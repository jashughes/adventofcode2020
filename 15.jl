input = [1,20,11,6,12,0]


function counting_game(input, N) 
    d = Dict(input[i] => i for i = 1:length(input)) 
    consider = 0 
    for i = (length(input) + 1):(N - 1) 
        if consider in keys(d) 
            last_turn = d[consider] 
            d[consider] = i 
            consider = i - last_turn 
        else 
            d[consider] = i 
            consider = 0 
        end 
    end 
    return consider 
end

println("Part 1: ", counting_game(input, 2020))
println("Part 2: ", counting_game(input, 30000000))