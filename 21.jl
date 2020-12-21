# Part 1
function parse_input(input)
    als, ings = Set(), Set()
    for i in input
        als = union(als, split(replace(replace(i, r".*contains " => ""), ")" => ""), ", "))
        ings = union(ings, split(replace(i, r" \(.*" => "")))
    end
    [a for a in als], [i for i in ings]
end

function parse_examples(input)
    examples =  []
    for i in input
        ags = split(replace(replace(i, r".*contains " => ""), ")" => ""), ", ")
        ingreds = split(replace(i, r" \(.*" => ""))
        for a in ags
            push!(examples, [a, ingreds])
        end
    end
    examples
end

function narrow_down(als, ings, examples)
    opts = Dict(k => ings for k in als)
    for ex in examples
        opts[ex[1]] = intersect(ex[2], opts[ex[1]])
    end
    opts
end

function count_cant_possiblies(cant_possiblies, examples)
    sm = 0
    unique_examples = unique(ex[2] for ex in examples)
    for ex in unique_examples
        sm += length([i for i in ex if i in cant_possiblies])
    end
    sm
end

input = readlines("21.txt")
examples = parse_examples(input)
als, ings = parse_input(input)
opts = narrow_down(als, ings, examples)
cant_possiblies = setdiff(ings, unique(vcat([v for v in values(opts)]...)))
println("Part 1: ", count_cant_possiblies(cant_possiblies, examples))

# Part 2
function solve_opts(opts)
    goal = length(opts)
    known = Dict()
    while length(known) < goal
        for k in keys(opts)
            if length(opts[k]) == 1
                known[k] = opts[k][1]
                delete!(opts, k)
            else
                opts[k] = setdiff(opts[k], collect(values(known)))
            end
        end
    end
    known
end

known = solve_opts(opts)
kt = [(k, v) for (k, v) in known]
println("Part 2: ", join([t[2] for t in sort(kt)], ","))
