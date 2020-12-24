#= Solver Function =#
function play_big_game(input, n_rep, n_cup)
    cups = vcat(deepcopy(input), collect((maximum(input) + 1):n_cup))
    d = Dict(cups[i] => (cups[i - 1], cups[i + 1]) for i = 2:(n_cup - 1))
    d[cups[1]] = (n_cup, cups[2])
    d[cups[n_cup]] = (n_cup - 1, cups[1])
    i = 1
    val = cups[1]
    while i <= n_rep 
        ex1 = d[val][2]
        ex2 = d[ex1][2]
        ex3 = d[ex2][2]

        # find destination
        look_for = maximum(setdiff([val - 1, val - 2, val - 3, val - 4], [ex1, ex2, ex3]))
        if look_for < 1 
            look_for = maximum(setdiff([n_cup, n_cup - 1, n_cup - 2, n_cup - 3], [ex1, ex2, ex3])) 
        end
        
        # Update lists
        after_dest = d[look_for][2]
        d[look_for] = d[look_for][1] == ex3 ? (val, ex1) : (d[look_for][1], ex1)
        d[val] = d[val][1] == look_for ? (ex3, d[ex3][2]) : (d[val][1], d[ex3][2]) 
        d[ex1] = (look_for, ex2)
        d[ex3] = (ex2, after_dest)

        # prep for next iteration
        val = d[val][2]
        i += 1
    end 
    d
end

#= Useful function for debugging =#
function print_d(d, start = 1)
    arr = []
    nx = d[start][2]
    while length(arr) < length(keys(d))
        push!(arr, nx)
        nx = d[nx][2]
    end
    arr
end

# Read Input
input = parse.(Int, split(readlines("23.txt")[1], ""))
d = play_big_game(input, 100, 9)
println("Part 1: ", join(print_d(d, 1)[1:8], ""))

d = play_big_game(input, 10000000, 1000000)
one_over = d[1][2]
two_over = d[one_over][2]
println("Part 2: ", one_over * two_over)




