#= Load data =# 
seats = readlines("05.txt")

function parse_binary(ch, to_zero, to_one)
    binary_ch = replace(replace(ch, Regex("$to_zero") => "0"), Regex("$to_one") => "1")
    parse(Int, binary_ch, base = 2)
end

function get_seat_id(bsp)
    parse_binary(bsp[1:7], "F", "B") * 8 + parse_binary(bsp[8:10], "L", "R")
end

function fill_seats(seats)
    plane = fill(0, (128, 8))
    for s in seats
        plane[parse_binary(s[1:7], "F", "B") + 1,  parse_binary(s[8:10], "L", "R") + 1]  = 1
    end
    return plane
end

function find_seat(plane)
    for i in 1:128
        if sum(plane[i, 1:8]) == 7
            return (i - 1) * 8 + argmin(plane[i, 1:8]) - 1
        end
    end
end

println(maximum(get_seat_id(x) for x in seats))
println(find_seat(fill_seats(seats)))