input = parse.(Int, readlines("09.txt"))

function find_match(numbs, N)
    for i = 1:length(numbs)
        if (N - numbs[i] in numbs)
            return true
        end
    end
    return false
end

function find_first_missing_match(numbs, N)
    for i = (N + 1):length(numbs)
        if !find_match(numbs[(i - N):(i - 1)], numbs[i])
            return numbs[i]
        end
    end
end

targ = find_first_missing_match(input, 25)

function moving_window(input, targ)
    for i= 2:length(input)
        for j = 1:(length(input) - i)
            if sum(input[j:(j + i)])  == targ
                return sum(extrema(input[j:(j + i)]))
            end
        end
    end
end

println("Part 1: ", targ)
println("Part 2: ", moving_window(input, targ))


