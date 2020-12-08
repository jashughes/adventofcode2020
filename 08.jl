instr_master = readlines("08.txt")

function find_repeat(instr)
    acc = 0
    seen = Set()
    keep_going = true
    i = 1
    corrected = false
    while keep_going
        action = instr[i][1:3]
        if action == "nop"
            i += 1
        elseif action == "acc"
            acc +=  parse(Int, replace(instr[i], r".* " => ""))
            i += 1
        else
            i += parse(Int, replace(instr[i], r".* " => ""))
        end
        corrected = (i == length(instr) + 1)
        keep_going = !(i in seen) && !corrected
        push!(seen, i)
    end
    return acc, corrected
end

function try_switching(instr_master)
    for i = 1:length(instr_master)
        action = instr_master[i][1:3]
        if action == "acc"
            continue
        end

        instr = deepcopy(instr_master)
        instr[i] = ifelse(action == "jmp", "nop ", "jmp ") *  replace(instr_master[i], r".* " => "")
        acc, corr = find_repeat(instr)

        if corr
            return acc
        end
    end
end

println("Part 1: ", find_repeat(instr_master)[1]) 
println("Part 2: ", try_switching(instr_master))