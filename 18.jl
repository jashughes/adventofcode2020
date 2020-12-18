input = readlines("18.txt")

function parse_op(seg)
    eval(Meta.parse(seg))
end

function parse_phrase(seg)
    while length(findall(r"\+|\*", seg)) > 0
        s = seg[findfirst(r"[0-9]+ ((\+)|(\*)) [0-9]+", seg)]
        seg = string(parse_op(s)) * seg[(length(s) + 1):end]
    end
    return seg
end

function clean_brackets(seg)
    nc = only(findfirst(r"\)", seg))
    fb = maximum(only.(findall(r"\(", seg[1:nc])))
    seg[1:(fb - 1)] * parse_phrase(seg[(fb + 1):(nc - 1)]) * seg[(nc + 1):end]
end

function tidy_line(seg)
    # clean up brackets
    while length(findall(r"\(", seg)) > 0
        seg = clean_brackets(seg)
    end
    # calculate the rest
    parse_phrase(seg)
end

function process_input(input)
    sum(parse(Int, tidy_line(i)) for i in input)
end

# Part 1
function parse_phrase(seg)
    while length(findall(r"\+|\*", seg)) > 0
        s = seg[findfirst(r"[0-9]+ ((\+)|(\*)) [0-9]+", seg)]
        seg = string(parse_op(s)) * seg[(length(s) + 1):end]
    end
    return seg
end

println("Part 1: ", process_input(input))


# Part 2

function parse_phrase(seg)
    while length(findall(r"\+", seg)) > 0
        si = findfirst(r"[0-9]+ \+ [0-9]+", seg)
        s = seg[si]
        seg = seg[1:(si[1] - 1)] * string(parse_op(s)) * seg[(si[end] + 1):end]
    end
    return string(parse_op(seg))
end

println("Part 2: ", process_input(input))



