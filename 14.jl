input =split.(readlines("14.txt"), " = ")


function overwrite(to_write, mask)
    [mask[x] == 'X' ? to_write[x] : parse(Int, mask[x], base = 2) for x in 1:length(mask)]
end

function perms(nf)
    Iterators.product([(0, 1) for i = 1:nf]...) 
end

function overfloat!(addr, mask, out, to_write)
    intmed = [mask[x] == '0' ? addr[x] : ifelse(mask[x] == 'X', "F", 1) for x in 1:length(mask)]
    nf = sum([x == "F" for x in intmed])
    allperms = perms(nf)

    for a in allperms
        tmp = deepcopy(intmed)
        tmp[tmp .== "F"] .= collect(a)
        out[bin_to_n(tmp)] = to_write
    end
end

function bin_to_n(bin)
    parse(Int, join(bin), base = 2)
end

function n_to_bin(n::Int)
    reverse(digits(n, base = 2, pad = 36))
end

function n_to_bin(cha::SubString)
    reverse(digits(parse(Int, cha), base = 2, pad = 36))
end


function parse_input(input)
    out = Dict()
    mask = input[1][2]
    for i = 1:length(input)
        if input[i][1] == "mask"
            mask = input[i][2]
        else
            ind = parse(Int, input[i][1][5:length(input[i][1]) - 1])
            to_write = n_to_bin(input[i][2])
            out[ind] = overwrite(to_write, mask)
        end
    end
    return out
end

function parse_float(input)
    out = Dict()
    mask = input[1][2]
    for i = 1:length(input)
        if input[i][1] == "mask"
            mask = input[i][2]
        else
            ind = parse(Int, input[i][1][5:length(input[i][1]) - 1])
            to_write = parse(Int, input[i][2])
            addr = n_to_bin(ind)
            overfloat!(addr, mask, out, to_write)
        end
    end
    return out
end

function sum_dict(out)
    sum([bin_to_n(out[k]) for k in keys(out)])
end

function sum_dict2(out)
    sum([out[k] for k in keys(out)])
end

println("Part 1: ", sum_dict(parse_input(input)))
println("Part 2: ", sum_dict2(parse_float(input)))


