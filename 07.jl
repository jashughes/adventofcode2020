rules = readlines("07.txt")

function holding_dict(rules)
    # keys are bag colours, their values are another dictionary, containing bags that THEY HOLD, 
    # and how many they hold 
    d = Dict()
    for i = 1:length(rules)
        node_name = replace(rules[i], r" bags contain.*"=> "")
        dest = split(replace(rules[i], r"(.*bags contain )|( bags)|( bag)|\."=> ""), ", ")
        if occursin(r"no other", dest[1])
            push!(d, node_name => 0)
        else
            sd = Dict()
            for j in dest
                merge!(sd, Dict(replace(j, r"^([0-9])* " => "") =>  parse(Int, replace(j, r" .*" => ""))))
            end
            push!(d, node_name => sd)
        end    
    end
    return d
end

function held_by_dict(rules)
    # keys are bag colours, their values are another dictionary, containing bags that HOLD THEM, 
    # and how many they hold 
    d = Dict()
    for i = 1:length(rules)
        held_by = replace(rules[i], r" bags contain.*"=> "")
        holds = split(replace(rules[i], r"(.*bags contain )|( bags)|( bag)|\."=> ""), ", ")
        if !occursin(r"no other", holds[1])
            for j in holds
                new_hold_key = replace(j, r"^([0-9])* " => "")
                new_hold_value = parse(Int, replace(j, r" .*" => ""))
                if new_hold_key in keys(d)
                    push!(d[new_hold_key], held_by => new_hold_value)
                else
                    #create a dictionary
                    push!(d, new_hold_key => Dict(held_by => new_hold_value))
                end
            end
        end    
    end
    return d
end



function count_outer(pr)
    seen = Set()
    bags_to_check = ["shiny gold"]
    while length(bags_to_check) > 0
        new_bags = []
        for b in bags_to_check
            if !(b in seen) && b in keys(pr)
                new_bags = vcat(new_bags, collect(keys(pr[b])))
            end
            push!(seen, b)
        end
        bags_to_check = new_bags
    end
    delete!(seen, "shiny gold")
    return length(seen)
end

function count_inner(pr)
    seen = []
    bags_to_check = [("shiny gold", 1)]
    while length(bags_to_check) > 0
        new_bags = []
        for b in bags_to_check
            mult = b[2]
            for nb in keys(pr[b[1]])
                if pr[b[1]][nb] > 0
                    push!(seen, (nb, pr[b[1]][nb] * mult))
                    push!(new_bags, (nb, pr[b[1]][nb] * mult))
                end
            end
        end
        bags_to_check = new_bags
    end
    return sum(x[2] for x in seen)
end


reverse_rules = held_by_dict(rules)
println("Part 1: ", count_outer(reverse_rules))


forward_rules = holding_dict(rules)
println("Part 2: ", count_inner(forward_rules))



