#= Read Input =#
input = readlines("22.txt", keep = false)

function parse_input(input)
    ix = findall(contains("Player"), input)
    p1 = parse.(Int, input[(ix[1] + 1):(ix[2] - 2)])
    p2 = parse.(Int, input[(ix[2] + 1):end])
    p1, p2
end

function each_round(p1, p2)
    draw1 = popfirst!(p1)
    draw2 = popfirst!(p2)
    if draw1 > draw2
        return vcat(p1, [draw1, draw2]), p2
    else
        return p1, vcat(p2, [draw2, draw1])
    end
end

function play_cards(p1, p2)
    while length(p1) > 0 && length(p2) > 0
        p1, p2 = each_round(p1, p2)
    end
    return p1, p2
end

function calc_score(p)
    sum(p[i] * (length(p) - i + 1) for i = 1:length(p))
end

p1, p2 = parse_input(input)
play_cards(p1, p2)
println("Part 1: ", length(p1) > 0 ? calc_score(p1) : calc_score(p2))

# Part 2

function play_recurse(n, p1, p2)
    seen = Set()
    while length(p1) > 0 && length(p2) > 0
        if [p1, p2] in seen
            return 1, p1, p2
        end
        push!(seen, [deepcopy(p1), deepcopy(p2)])
        # draw
        draw1 = popfirst!(p1)
        draw2 = popfirst!(p2)
        if length(p1) ≥ draw1 && length(p2) ≥ draw2
            n, r1, r2 = play_recurse(n, p1[1:draw1], p2[1:draw2])
        elseif draw1 > draw2
            n = 1
        else
            n = 2
        end

        if n == 1
            p1 = vcat(p1, [draw1, draw2])
        else
            p2 = vcat(p2, [draw2, draw1])
        end
    end
    return n, p1, p2
end

p1, p2 = parse_input(input)
n, p1, p2 = play_recurse(1, p1, p2)
println("Part 2: ", length(p1) > 0 ? calc_score(p1) : calc_score(p2))