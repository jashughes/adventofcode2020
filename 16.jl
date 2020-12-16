rules = split.(readlines("16_sched.txt"), ": ")
r = Dict([x[1] => split(x[2], " or ") for x in rules])
mine = parse.(Int, split(readlines("16_mine.txt")[1], ","))
nearby1 = parse.(Int, split(replace(read("16_nearby.txt", String), "\r\n" => ","), ","))
nearby2 = [parse.(Int, x) for x in split.(readlines("16_nearby.txt"), ",")]

function check_range(b, ranges)
    (ranges[1][1] ≤ b ≤ ranges[1][2]) || (ranges[2][1] ≤ b ≤ ranges[2][2])
end

function check_req(r, tidy)
    final = deepcopy(tidy)
    for t in 1:length(tidy)
        keep = false
        for k in keys(r)
            ranges = [parse.(Int, split(x, "-")) for x in r[k]]
            keep = check_range(tidy[t], ranges) ? true : keep
        end
        if keep
            filter!(x -> x != tidy[t], final)
        end
    end
    return sum(final)
end

function return_valid(r, tidy)
    final = deepcopy(tidy)
    for t in 1:length(tidy)
        keep = false
        for k in keys(r)
            ranges = [parse.(Int, split(x, "-")) for x in r[k]]
            keep = all([check_range(b, ranges) for b in tidy[t]]) ? true : keep
        end
        if !keep
            filter!(x -> x != tidy[t], final)
        end
    end
    return final
end

function pos_check(r, valid)
    could_be = Dict([k => collect(1:length(valid[1])) for k in keys(r)])
    for k in keys(r)
        ranges = [parse.(Int, split(x, "-")) for x in r[k]]
        for t in 1:length(valid)
            could_be[k] = [i for i in could_be[k] if check_range(valid[t][i], ranges)]
        end
    end
    return could_be
end

function unique_pos(could_be)
    tidy_d = Dict()
    unknown = Set(1:maximum([maximum(could_be[i]) for i in keys(could_be)]))
    
    while length(unknown) > 0
        for k in keys(could_be)
            could_be[k] = [x for x in could_be[k] if x in unknown]
            if length(could_be[k]) == 1
                tidy_d[k] = could_be[k][1]
                delete!(unknown, could_be[k][1])
                delete!(could_be, k)
            end
        end
    end
    return tidy_d
end

function departures(tidied, mine)
    prod([mine[tidied[x]] for x in keys(tidied) if occursin(r"^departure", x)])
end

println("Part 1: ", check_req(r, nearby1))

valid = return_valid(r, nearby2)
could_be = pos_check(r, valid)
tidied = unique_pos(could_be)
println("Part 2: ", departures(tidied, mine))


