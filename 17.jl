input = [parse.(Int, x) for x in split.(replace.(replace.(readlines("17.txt"), "." => "0"), "#" => "1"), "")]

function create_d(input)
    d = Dict()
    for i = 1:length(input[1]), j = 1:length(input)
        d[[i, j, 0, 0]] = input[j][i]
    end
    return d
end

function sum_around(R, d, ND)
    dND = length(R) - ND
    coords = [vcat(collect(a), zeros(Int, dND)) for a in Iterators.product([(-1, 0, 1) for i = 1:ND]...) if sum(abs.(collect(a))) != 0]
    sum(get(d, R .+ c, 0) for c in coords)
end

function key_extrema(d, dimen)
    extrema(k[dimen] for k in keys(d)) .+ (-1, 1)
end

function cycle_d(d, ND)
    next_cycle = Dict()

    di, dj, dk, dm = [key_extrema(d, dimen) for dimen = 1:4]

    for i = di[1]:di[2], j = dj[1]:dj[2], k = dk[1]:dk[2], m = dm[1]:dm[2]
        if get(d, [i, j, k, m], 0) == 1 && (2 ≤ sum_around([i, j, k, m], d, ND) ≤ 3)
            next_cycle[[i, j, k, m]] = 1
        elseif get(d, [i, j, k, m], 0) == 0 && (sum_around([i, j, k, m], d, ND) == 3)
            next_cycle[[i, j, k, m]] = 1
        end
    end
    return next_cycle
end 

function scan_d(d, N, ND)
    cycled = d
    for cyc = 1:N
        cycled = cycle_d(cycled, ND)
    end
    return cycled
end

d = create_d(input)
cycled1 = scan_d(d, 6, 3)
cycled2 = scan_d(d, 6, 4)
println("Part 1: ", length(cycled1))
println("Part 2: ", length(cycled2))
