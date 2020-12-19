rules = replace.(readlines("19_rules.txt"), "\"" => "")
test = readlines("19_text.txt")

rules = ["0: 4 1 5", "1: 2 3 | 3 2", "2: 4 4 | 5 5", "3: 4 5 | 5 4", "4: a", "5: b"]
test = ["ababbb", "bababa", "abbbab", "aaabbb", "aaaabbb"]

function rules_d(rules)
    Dict(x[1] => split.(split(x[2], " | "), " ") for x in split.(rules, ": "))
end

function rules_d(rules)
    Dict(x[1] => "(( " * replace(x[2], " | " => " )|( ") * " ))" for x in split.(rules, ": "))
end


rd["0"]
start = "0"

function repl_num(find, repl, seg)
    #seg = replace(seg, Regex("\\($find ") => "(" * repl * " ")
    #seg = replace(seg, Regex(" $find\\)") => " " * repl * ")")
    replace(seg, Regex(" $find ") => " " * repl * " ")
end


function rev_d(rd, start = "0")
    end_keys = [k for k in keys(rd) if rd[k] == "(( a ))" || rd[k] == "(( b ))"]
    known_d = Dict(k => replace(replace(rd[k], "(" => ""), ")" => "") for k in end_keys)
    delete!(rd, end_keys[1])
    delete!(rd, end_keys[2])
    
    while "0" in keys(rd) && contains(rd[start], r"[0-9]")
        println("length known ", length(known_d), " rules ", length(rd))
        for k in keys(known_d)
            for r in keys(rd)
                rd[r] = repl_num(k, known_d[k], rd[r])
                if !contains(rd[r], r"[0-9]")
                    known_d[r] = rd[r]
                    delete!(rd, r)
                end
            end
        end
    end
    return known_d
end

function tidy_d(out)
    # remove extra space, then remove extra brackets
    for k in keys(out)
        out[k] = replace(out[k], " " => "")
    end
    return out
end

function match_exp(ru, te)
    replace(te, Regex("$ru") => "")
end

rd = rules_d(rules)
out = rev_d(rd, "0")
out = tidy_d(out)
println(sum(length(match_exp(out["0"], te)) == 0 for te in test))



#= Part 2
=#

function rules_d(rules)
    Dict(x[1] => ifelse(contains("|", x[2]), "( " * x[2] * " )", x[2]) for x in split.(rules, ": "))
end


function overwrite(rd)
    rd["8"] = "(( 42 )|( 42 8 ))"
    rd["11"] = "(( 42 31 )|( 42 11 31 ))"
end


function rev_d(rd)
    end_keys = [k for k in keys(rd) if rd[k] == "a" || rd[k] == "b"]
    known_d = Dict(k => replace(replace(rd[k], "(" => ""), ")" => "") for k in end_keys)
    delete!(rd, end_keys[1])
    delete!(rd, end_keys[2])
    
    while length(keys(rd)) > 3
        println("length known ", length(known_d), " rules ", length(rd))
        for k in keys(known_d)
            for r in keys(rd)
                rd[r] = repl_num(k, known_d[k], rd[r])
                if !contains(rd[r], r"[0-9]")
                    known_d[r] = rd[r]
                    delete!(rd, r)
                end
            end
        end
    end
    return known_d
end

rules = replace.(readlines("19_rules.txt"), "\"" => "")
test = readlines("19_text.txt")

rd = rules_d(rules)
overwrite(rd)
partial_d = tidy_d(rev_d(rd))
zero_rules = "811"
zero_rules = replace8(zero_rules, partial_d["42"])
#zero_rules = replace11(zero_rules, partial_d["42"], partial_d["31"])

println(sum(length(match_exp(zero_rules, te)) == 0 for te in test))

rd["8"]
rd["11"]
rd["0"]
partial_d["42"]
partial_d["31"]

function tidy_brackets(seg)
    nc = findfirst(r"\)[^|]", seg)
    if nc == nothing
        return seg
    else
        nc = nc[1]
    end
    fb = maximum(only.(findall(r"\(", seg[1:nc])))
    seg[1:(fb - 1)] * seg[(fb + 1):(nc - 1)] * seg[(nc + 1):end]
end

function keep_cleaning(seg)
    nch = length(seg)
    new_seg = tidy_brackets(seg)
    while length(new_seg) < nch
        nch = length(new_seg)
        new_seg = tidy_brackets(new_seg)
    end
    return new_seg
end



function replace8(seg, fortytwo)
    replace(seg, "8" => "(" * fortytwo * ")+")
end


function replace11(seg, fortytwo, thirtyone, x)
    fancified = "(" * fortytwo * "){" * string(x) * "}(" * thirtyone * "){" * string(x) * "}"
    replace(seg, "11" => fancified)
end

function loop11(partial_d, rd)
    zero_rules = "811"
    fortytwo = keep_cleaning(partial_d["42"])
    thirtyone = keep_cleaning(partial_d["31"])
    zero_rules = replace8(zero_rules, fortytwo)
    s = 0

    for te in test
        if any(length(match_exp(replace11(zero_rules, fortytwo, thirtyone, x), te)) == 0 for x in 1:44)
            s+= 1
        end
    end
    return s
end

println(loop11(partial_d, rd))




count_char("\\)", zero_rules)



