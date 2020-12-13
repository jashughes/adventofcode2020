input = readlines("13.txt")

#= Part 1 =#
ts = parse(Int, input[1])
buses = [parse(Int, x) for x in split(input[2], ",") if x != "x"]
min_i = findmin([b - mod(ts, b) for b in buses])
println("Part 1: ", min_i[1] * buses[min_i[2]])


#= Part 2 =#
#=
Approach:
  - Start with the first two numbers: n1, n2. Find the *first* time the offset
    criteria is satisfied, t1. The solution will be equal to (t1 + X * lcm(n1, n2)) 
    for some value of X (here lcm stands for the least common multiple). 
  - For example, if the first number is 5 and the second number is 3 with an offset of 1, 
    the first time the offset criteria is satisfied is at t1 == 5 since mod(5 + 1, 3) == 0. 
    This offset criteria will be true every lcm(5, 3) = 15 numbers. 
       mod(5 + 1, 3) = 0      -> t1
       mod(10 + 1, 3) = 2     -> t1 + 5
       mod(15 + 1, 3) = 1     -> t1 + 10
       mod(20 + 1, 3) = 0     -> t1 + 15  ** the offset criteria is met.


  - Now we repeat this same calculation for the third bus. We are looking for the *first* time 
    (t2) that the offset criteria is satisfied for the third number, which we know has to satisfy
    (t1 + X * lcm(n1, n2)). Like before, we know that the final answer will be equal to
    (t2 + Y * lcm(lcm(n1, n2), n2)) for some value of Y.
  - We repeat this until we get to the end of our 'bus schedule' and have found t(number_of_buses -1)
  - This problem is apparently known as the Chinese Remainder Theorem.
=#
busx = split(readlines("13.txt")[2], ",")

function loop_lcm(n1, n2, off, increment)
    i = n1
    while mod(i + off, n2) != 0
        i += increment
    end
    return i, lcm(increment, n2)
end

function loop_pairs(busx)
    offset = [i - 1 for i in 1:length(busx) if busx[i] != "x"]
    bus = [parse(Int, x) for x in split(input[2], ",") if x != "x"]

    n1 = bus[1]
    incr = n1

    for i = 2:length(bus)
        n1, incr = loop_lcm(n1, bus[i], offset[i], incr)
    end
    return n1
end

println("Part 2: ", loop_pairs(busx))





