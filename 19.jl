#= Read Input =#
rules = replace.(readlines("19_rules.txt"), "\"" => "")
test = readlines("19_text.txt")

#= Useful Functions =#
function rules_d(rules)
    Dict(x[1] => ifelse(contains(x[2], r"\|"), "( " * x[2] * " )", " " * x[2] * " ") for x in split.(rules, ": "))
end

function repl_num(find, repl, seg)
    replace(seg, Regex(" $find ") => " " * repl * " ")
end

function match_exp(ru, te)
    replace(te, Regex("$ru") => "")
end

function rev_d(rd, part2 = false)
    end_keys = [k for k in keys(rd) if rd[k] == " a " || rd[k] == " b "]
    known = Dict(k => replace(rd[k], "(|)" => "") for k in end_keys)
    delete!(rd, end_keys[1])
    delete!(rd, end_keys[2])
    
    while length(keys(rd)) > (part2 ? 3 : 0)
        for k in keys(known), r in keys(rd)
            rd[r] = repl_num(k, known[k], rd[r])
            if !contains(rd[r], r"[0-9]")
                known[r] = rd[r]
                delete!(rd, r)
            end
        end
    end
    return Dict(k => replace(known[k], " " => "") for k in keys(known))
end

function rule8(seg, fortytwo)
    replace(seg, "8" => "(" * fortytwo * ")+")
end


function rule11(seg, fortytwo, thirtyone, x)
    fancified = "(" * fortytwo * "){" * string(x) * "}(" * thirtyone * "){" * string(x) * "}"
    replace(seg, "11" => fancified)
end

function rule0(d)
    #=  This function hardcodes in the new specifications for Rule 0 ("8 11")
        Then, we replace the regex for Rule 8 and Rule 11:
            Rule 8: r"(42)+"
            Rule 11: r"(42){N}(31){N}"
        The theoretical maximum value for N is [(max N char) - 1]/2, but that hits the max regex
        length in julia. Empirically, increasing N beyond 4 does not impact the number of matches,
        so for this solution, testing N = 1:4 is enough! =#
    zero_rules = rule8("811", d["42"])
    sum(any(length(match_exp(rule11(zero_rules, d["42"], d["31"], N), te)) == 0 for N = 1:4) for te in test)
end

#= Part 1 =#
rd = rules_d(rules)
out = rev_d(rd, false)
println("Part 1: ", sum(length(match_exp(out["0"], te)) == 0 for te in test))

#= Part 2 =#
println("Part 2: ", rule0(out))


