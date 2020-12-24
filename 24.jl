input = readlines("24.txt", keep = false)

#= Part 1 =#
function parse_dir(di)
    [di[x] for x in findall(r"((s|n)(e|w))|(e|w)", di)]
end

function dir_to_coord(d)
    d == "se" && return (1, -1)
    d == "sw" && return (-1, -1)
    d == "e"  && return (2, 0)
    d == "w"  && return (-2, 0)
    d == "ne" && return (1, 1)
    d == "nw" && return (-1, 1)
end

function parse_input(input)
    [reduce((l, r) -> l .+ r, [dir_to_coord(x) for x in parse_dir(di)]) for di in input]
end

flip = parse_input(input)

flippy = [f for f in flip if mod(length(findall(x -> x == f,flip)), 2) == 1]
println("Part 1: ", length(flippy))

#= Part 2 =#

function art(flippy)
    d = Dict(k => 1 for k in flippy)
    for day = 1:100
        d = flip_time(d)
    end
    sum(values(d))
end
    
function hexcoord(pos)
    [x .+ pos for x in [(2, 0), (-2, 0), (1, 1), (-1, 1), (1, -1), (-1, -1)]]
end

function flip_time(d)
    new = deepcopy(d)

    # Add neighbours
    for k in keys(d)
        neighbours = hexcoord(k)
        for n in neighbours
            new[n] = get(new, n, 0)
        end
    end
    flipped = deepcopy(new)
    
    # Flip tiles
    for k in keys(new)
        nbsum = sum(get(new, x, 0) for x in hexcoord(k))
        flipped[k] = (new[k] == 1 && (1 ≤ nbsum ≤ 2)) || (new[k] == 0 && nbsum == 2) ? 1 : 0
    end
    return flipped
end

println("Part 2: ", art(flippy))
