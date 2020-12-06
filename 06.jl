#= Part 1 =# 
forms = replace.(split(read("06.txt", String), "\r\n\r\n"), "\r\n" => "")
println("Part 1: ", sum([length(Set(split(x, ""))) for x in forms]))

#= Part 2 =#
forms2 = split.(split(read("06.txt", String), "\r\n\r\n"), "\r\n")

function count_family(fam)
    sum(all(occursin.(a, fam)) for a in Set(reduce(vcat, (split.(fam, "")))))
end

println("Part 2: ", sum(count_family(fam) for fam in forms2))

        


