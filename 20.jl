#= Read Input =#
input = readlines("20.txt")

function process_input(input)
    ims = Dict()
    i = 1
    while i < length(input)
        k = parse(Int, replace(replace(input[i], "Tile " => ""), ":" => ""))
        v = input[(i + 1):(i + 10)]
        ims[k] = v
        i += 12
    end
    return ims
end

ims = process_input(input) # a 12x12 image?

function get_edges(im)
    Dict("top" => [i for i in im[1]],
         "bottom" => [i for i in im[10]],
         "left" => [i[1] for i in im],
         "right" => [i[10] for i in im])  
end    

function extract_all_edges(ims) 
    edges = Dict()
    edge_count = Dict()
    for k in keys(ims)
        edges[k] = get_edges(ims[k])
        for ed in keys(edges[k])
            curr = edges[k][ed]
            if curr in keys(edge_count)
                edge_count[curr] += 1
            elseif reverse(curr) in keys(edge_count)
                edge_count[reverse(curr)] += 1
            else
                edge_count[curr] = 1
            end
        end
    end
    edges, edge_count
end

edges, edge_count = extract_all_edges(ims)

function find_outside(edges, edge_count)
    outside_edges = Set([k for k in keys(edge_count) if edge_count[k] == 1])
    outside_tiles = []

    for k in keys(edges)
        for ks in keys(edges[k])
            if edges[k][ks] in outside_edges
                push!(outside_tiles, k)
            end
        end
    end

    unique_outside = Set(outside_tiles)
    corners = [i for i in unique_outside if length(findall(x -> x == i, outside_tiles)) > 1]
    return unique(outside_tiles), corners
end

outside_tiles, corners = find_outside(edges, edge_count)
println("Part 1:", prod(corners))


# Part 2

function find_matches(outsides, tile)
    look_for = vcat(collect(values(outsides[tile])), reverse.(collect(values(outsides[tile]))))
    found = []
    for k in keys(outsides)
        if length(intersect(collect(values(outsides[k])), look_for)) > 0 && k != tile
            push!(found, k)
        end
    end
    return found
end

function matched_edge(t1, t2, edges)
    intersect(vcat(collect(values(edges[t1])), reverse.(values(edges[t1]))), vcat(collect(values(edges[t2])), reverse.(values(edges[t2]))))
end

function image_borders(corners, edges, outside_tiles, compiled = zeros(Int, 12, 12))
    outsides = Dict(k => edges[k] for k in outside_tiles)
    compiled[1, 1] = corners[1]
    # top
    for i = 2:12
        matches = find_matches(outsides, compiled[1, i - 1])[1]
        compiled[1, i] = matches
        delete!(outsides, compiled[1, i - 1])
    end
    # right
    for i = 2:12
        matches = find_matches(outsides, compiled[i - 1, 12])[1]
        compiled[i, 12] = matches
        delete!(outsides, compiled[i - 1, 12])
    end
    # bottom
    for i = 11:-1:1
        matches = find_matches(outsides, compiled[12, i + 1])[1]
        compiled[12, i] = matches
        delete!(outsides, compiled[12, i + 1])
    end
    # left
    for i = 11:-1:2
        matches = find_matches(outsides, compiled[i + 1, 1])[1]
        compiled[i, 1] = matches
        delete!(outsides, compiled[i + 1, 1])
    end
    return compiled
end

function fill_in_borders!(edges, compiled)
    for i = 2:11, j = 2:11
        up = find_matches(edges, compiled[i - 1, j])
        left = find_matches(edges, compiled[i, j - 1])
        exclude = compiled[i - 1, j - 1]
        compiled[i, j] = setdiff(intersect(up, left), exclude)[1]
    end
end

function render_image(compiled, ims)
    out = reshape(repeat([""], 120, 120), 120, :)
    # initialize corner, first square needs to be reflected across vertical line
    img = [reverse(x) for x in ims[compiled[1, 1]]]
    insert_im!(out, img, 1, 1)

    # Left Row
    for i = 2:12
        to_find = out[(i - 1) * 10, 1:10]
        to_print = rotate_img(ims[compiled[i, 1]], to_find)
        insert_im!(out, to_print, i, 1)
    end

    # The rest, reading left to right
    for i = 2:12, j = 1:12
        to_find = out[(j * 10 - 9):(j * 10), (i - 1) * 10]
        pre_print = rotate_img(ims[compiled[j, i]], to_find)
        to_print = [join([pre_print[x][y] for x = 1:10]) for y = 1:10]
        insert_im!(out, to_print, j, i)
    end
    rm_borders(out)
end

function insert_im!(out, img, i, j)
    for x = 1:10, y = 1:10
        out[(i * 10 - 10 + y), (j * 10 - 10 + x)] = string(img[y][x])
    end
end

function rotate_img(img, to_find)
    # return img with _to_find as top row, in fwd order
    if join(to_find) == img[1]
        return img
    elseif join(to_find) == img[10]
        return [img[i] for i = 10:-1:1]
    elseif join(to_find) == reverse(img[1])
        return [reverse(img[i]) for i = 1:10]
    elseif join(to_find) == reverse(img[10])
        return [reverse(img[i]) for i = 10:-1:1]
    else
        return rotate_img([reverse(join([img[i][j] for i = 1:10])) for j = 1:10], to_find)
    end
end

function rm_borders(out)
    idx = [x for x = 1:120 if mod(x, 10) != 0 && mod(x, 10) != 1]
    out[idx, idx]
end

function check_monster(arr)
    unique([arr[2, 1], arr[3, 2], arr[3, 5], arr[2, 6], arr[2, 7],
         arr[3, 8], arr[3, 11], arr[2, 12], arr[2, 13], arr[3, 14],
         arr[3, 17], arr[2, 18], arr[1, 19], arr[2, 19], arr[2, 20],]) == ["#"]
end

compiled = image_borders(corners, edges, outside_tiles)
fill_in_borders!(edges, compiled)
out = render_image(compiled, ims)

function find_monster(out)
    imax = size(out)[1] - 20
    jmax = size(out)[2] - 3
    found = false
    for i = 1:imax, j = 1:jmax
        if check_monster(out[j:(j + 2), i:(i + 19)])
            found = true
        end
    end
    return found
end

function scan_photo(out, d = 96)
    if find_monster(out)
        return out
    end
    # Rotate
    new = rotl90(out)
    for i = 1:3
        if find_monster(new)
            println("success")
            return new
        else
            new = rotl90(new)
        end
    end
    # flip
    new = new[1:d, d:-1:1]
    if find_monster(new)
        println("success")
        return new
    end
    # Rotate again
    new = rotl90(new)
    for i = 1:3
        if find_monster(new)
            println("success")
            return new
        else
            new = rotl90(new)
        end
    end
end

function get_test(test)
    t2 = reshape(repeat([""], 24, 24), 24, :)
    for i = 1:24, j = 1:24
        t2[j, i] = test[j][i]
    end
    t2
end



function replace_monster(oriented)
    imax = size(out)[1] - 20
    jmax = size(out)[2] - 3
    offsets =[[2, 1], [3, 2], [3, 5], [2, 6], [2, 7],
    [3, 8], [3, 11], [2, 12], [2, 13], [3, 14],
    [3, 17], [2, 18], [1, 19], [2, 19], [2, 20]]
    
    for i = 1:imax, j = 1:jmax
        if check_monster(oriented[j:(j + 2), i:(i + 19)])
            for o in offsets
                oriented[j + o[1] - 1, i + o[2] - 1] = "O"
            end
        end
    end
    return oriented
end

compiled = image_borders(corners, edges, outside_tiles)
fill_in_borders!(edges, compiled)
out = render_image(compiled, ims)
oriented = scan_photo(out)
find_monster(oriented)
oriented = replace_monster(oriented)

println("Part 2: ", length(oriented[oriented .== "#"]))


