input = [parse.(Int, x) for x in split.(replace.(replace.(readlines("17.txt"), "." => "0"), "#" => "1"), "")]

function create_d(input, ND)
    d = Dict()
    dND = ND - 2
    for i = 1:length(input[1]), j = 1:length(input)
        d[vcat([i, j], zeros(Int, dND))] = input[j][i]
    end
    return d
end

function sum_around(R, d, ND)
    dND = length(R) - ND
    coords = [collect(a) for a in Iterators.product([(-1, 0, 1) for i = 1:ND]...) if sum(abs.(collect(a))) != 0]
    sum(get(d, R .+ c, 0) for c in coords)
end

function key_extrema(d, dimen)
    extrema(k[dimen] for k in keys(d)) .+ (-1, 1)
end

function cycle_d(d, ND)
    next_cycle = Dict()
    for a in Iterators.product([collect(x[1]:x[2]) for x in [key_extrema(d, dimen) for dimen = 1:ND]]...)
        loc = collect(a)
        if get(d, loc, 0) == 1 && (2 ≤ sum_around(loc, d, ND) ≤ 3)
            next_cycle[loc] = 1
        elseif get(d, loc, 0) == 0 && (sum_around(loc, d, ND) == 3)
            next_cycle[loc] = 1
        end
    end
    return next_cycle
end 

function scan_d(d, N, ND)
    cycled = d
    for cyc = 1:N
        println("Cycle: ", cyc)
        cycled = cycle_d(cycled, ND)
    end
    return cycled
end

d3 = create_d(input, 3)
d4 = create_d(input, 4)
cycled1 = scan_d(d3, 6, 3)
cycled2 = scan_d(d4, 6, 4)
println("Part 1: ", length(cycled1))
println("Part 2: ", length(cycled2))

d5 = create_d(input, 5)
cycled5 = scan_d(d5, 6, 5)
println("Part Bonus: ", length(cycled5))
