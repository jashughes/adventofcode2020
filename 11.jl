input = split.(readlines("11.txt"), "")

function seatval(input, x, y)
    0 < x ≤ length(input[1]) && 0 < y ≤ length(input) ? input[y][x] : 0
end

function neighbours(input, x, dx, y, dy)
    seatval(input, x + dx, y + dy) == "#"
end

function sight_line(input, x, dx, y, dy)
    sighted = seatval(input, x + dx, y + dy)
    sighted == "." ? sight_line(input, x + dx, dx, y + dy, dy) : sighted == "#"
end

function check_seat(input, x, y, decision_maker)
    coords = [(1, 1), (1, 0), (1, -1), (0, 1), (0, -1), (-1, 1), (-1, 0), (-1, -1)]
    sum([decision_maker(input, x, i[1], y, i[2]) for i in coords])
end

function fill_seats(input, seat_thresh, decision_maker)
    new_seats = deepcopy(input)
    for i = 1:length(input[1]), j = 1:length(input)
        if input[j][i] == "#" && check_seat(input, i, j, decision_maker) ≥ seat_thresh
            new_seats[j][i] = "L"
        elseif input[j][i] == "L" && check_seat(input, i, j, decision_maker) == 0
            new_seats[j][i] = "#"
        end
    end
    return new_seats
end

function count_filled(outseats)
    sum([outseats[j][i] == "#" for j in 1:length(outseats), i in 1:length(outseats[1])])
end

function loop_seats(input, seat_thresh, decision_maker)
    last_seats = deepcopy(input)
    filled_seats = fill_seats(input, seat_thresh, decision_maker)
    while last_seats != filled_seats
        last_seats = deepcopy(filled_seats)
        filled_seats = fill_seats(filled_seats, seat_thresh, decision_maker)
    end
    return count_filled(filled_seats)
end

println("Part 1: ", loop_seats(input, 4, neighbours))
println("Part 2: ", loop_seats(input, 5, sight_line))