input, suj = parse.(Int, readlines("25.txt", keep = false)), 7

function transform(inp, N)
    out = 1
    for i = 1:N
        out = inp * out
        out = mod(out, 20201227)
    end
    out
end

function find_loop(input, suj)
    found = Dict()
    i, out = 1, 1
    while length(input) > 0
        out = mod(out * suj, 20201227)
        if out in input
            found[out] = i
            input = input[input .!= out]
        end
        i += 1
    end
    transform(collect(keys(found))[1], collect(values(found))[2])
end

println("Part 1 and 2: ", find_loop(input, suj))


