input = [[x[1], parse(Int, x[2:length(x)])] for x in readlines("12.txt")]

function motor(inst, pos, facing)
    dir = Dict('N' => [0, 1], 'S' => [0, -1], 'E' => [1, 0], 'W' => [-1, 0])
    lr = Dict('L' => [-1, -1], 'R' => [1, 1])
    if inst[1] ∈ keys(dir)
        pos += inst[2] * dir[inst[1]]
    elseif inst[1] ∈ keys(lr)
        deg = inst[2]/90
        for twist in 1:deg
            facing = [facing[2], -facing[1]] .* lr[inst[1]]
        end
    else
        pos += facing * inst[2]
    end
    return pos, facing
end

function waypoint(inst, pos, wp)
    dir = Dict('N' => [0, 1], 'S' => [0, -1], 'E' => [1, 0], 'W' => [-1, 0])
    lr = Dict('L' => [-1, -1], 'R' => [1, 1])
    if inst[1] ∈ keys(dir)
        wp += inst[2] * dir[inst[1]]
    elseif inst[1] ∈ keys(lr)
        deg = inst[2]/90
        for twist in 1:deg
            wp = [wp[2], -wp[1]]           
        end
    else
        pos += wp * inst[2]
    end
    return pos, wp
end

function move_ship(input, pos, wp, mover)
    for inst in input
        pos, wp = mover(inst, pos, wp)
    end
    return pos 
end

moved_ship = move_ship(input, [0, 0], [1, 0], motor)
println("Part 1: ", (abs(moved_ship[1]) + abs(moved_ship[2])))

moved_ship = move_ship(input, [0, 0], [10, 1], waypoint)
println("Part 2: ", abs(moved_ship[1]) + abs(moved_ship[2]))



