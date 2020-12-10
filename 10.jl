input = parse.(Int, readlines("10.txt"))

function prep_input(input)
    push!(input, 0)
    push!(input, maximum(input) + 3) 
end  

function part1(input)
    diffs = diff(sort(input))
    sum(x == 1 for x in diffs) * sum(x == 3 for x in diffs)
end

prep_input(input)
println("Part 1:", part1(input))



#=
Part 2 is a little trickier, and it requires knowing the number of delta-1s in a row.
- If there is only one delta-1, there's no flexibility. Ex: ([0], 1, [4]) => only ([0], 1, [4]) is possible
- If there are two delta-1s in a row, you could remove the first (leaving a gap of 2), so that 
  doubles our possibilities. I.e., ([0], 1, 2, [5]) allows for: ([0], 2, [5]) or ([0], 1, 2, [5])  
- If there are three delta-1s in a row, there are 4 possible permutations. Given, for example, ([0], 1, 2, 3, [6]):
     ([0], 1, 2, 3 [6])
     ([0], 2, 3 [6])
     ([0], 1, 3 [6])
     ([0], 3 [6])
- If there are four delta-1s in a row, there are 7 possible permutations. Given ([0], 1, 2, 3, 4, [7]):
    ([0], 1, 2, 3, 4, [7])
    ([0], 1, 2, 4, [7])
    ([0], 1, 3, 4, [7])
    ([0], 3, 4, [7])
    ([0], 2, 3, 4, [7])
    ([0], 1, 4, [7])
    ([0], 3, 4, [7])

- Checking the input confirms that there are no deltas other than (1, 3) in our sorted input
- Luckily for us, there are never more than 4 deltas in a row either!

=#

function count_runs(input)
    diffs = diff(sort(input))
    rp, current_run = 1, 0
    prod_map = Dict(0 => 1, 1 => 1, 2 => 2, 3 => 4, 4 => 7)

    for i =1:length(diffs)
        if diffs[i] == 1
            current_run += 1
        else
            rp *= prod_map[current_run]
            current_run = 0
        end
    end
    return rp
end

println("Part 2: ", count_runs(input))


