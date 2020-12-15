input = [1,20,11,6,12,0]
input = [0, 3, 6]

function counting_game(input)
    i = length(input) - 1
    turns = input[1:i]
    ns = Set(turns)
    i += 1
    ln = input[i]
    while length(turns) < 300
        if !(ln in turns)
            push!(ns, ln)
            push!(turns, ln)
            ln = 0
            i += 1
        else
            push!(turns, ln)
            all_turns = findall(isequal(ln), turns)
            ln = diff(all_turns[(length(all_turns) -1):end])[1]
            push!(ns, ln)
            i += 1
        end
    end
    return turns[2020]
end

counting_game(input)


function counting_game(input, N)
    i = length(input) - 1 
    turns = zeros(Int, N)
    turns[1:i] .= input[1:i]
    ns = Set(input[1:i])
    i += 1
    ln = input[i]
    while i < N
        println(i)
        if !(ln in ns)
            turns[i] = ln
            push!(ns, ln)
            ln = 0
            i += 1
        else
            turns[i] = ln
            all_turns = findall(isequal(ln), view(turns, 1:i))
            #println("ln ", ln, " i ", i)
            #println(ns)
            #println(all_turns)
            ln = diff(all_turns[(length(all_turns) -1):end])[1]
            i += 1
            #push!(ns, ln)
        end
        #println(turns[1:(i-1)])
    end
    return turns[N]
end

counting_game(input, 2020)

function counting_game(input)
    i = length(input) - 1
    turns = input[1:i]
    ns = Set(turns)
    i += 1
    ln = input[i]
    while length(turns) < 300
        if !(ln in turns)
            push!(ns, ln)
            push!(turns, ln)
            ln = 0
            i += 1
        else
            push!(turns, ln)
            all_turns = findall(isequal(ln), turns[])
            ln = diff(all_turns[(length(all_turns) -1):end])[1]
            push!(ns, ln)
            i += 1
        end
    end
    return turns[2020]
end


function counting_game(input, N)
    d = Dict(input[i] => i for i = 1:length(input))






        
