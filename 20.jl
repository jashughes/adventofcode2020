#= Read Input =#
input = readlines("20.txt")
monster = [[2, 1], [3, 2], [3, 5], [2, 6], [2, 7],
[3, 8], [3, 11], [2, 12], [2, 13], [3, 14],
[3, 17], [2, 18], [1, 19], [2, 19], [2, 20]]

function process_input(input)
    ims = Dict(parse(Int, replace(replace(input[i], "Tile " => ""), ":" => "")) => input[(i + 1):(i + 10)] for i = 1:12:length(input))
end

function get_edges(im)
    [[i for i in im[1]], [i for i in im[10]], [i[1] for i in im], [i[10] for i in im]] 
end    

function extract_all_edges(ims) 
    edges = Dict()
    edge_count = Dict()
    for k in keys(ims)
        edges[k] = get_edges(ims[k])
        for curr in edges[k]
            if reverse(curr) in keys(edge_count)
                edge_count[reverse(curr)] += 1
            else
                edge_count[curr] = get(edge_count, curr, 0) + 1
            end
        end
    end
    edges, edge_count
end

function find_outside(edges, edge_count)
    outside_edges = Set([k for k in keys(edge_count) if edge_count[k] == 1])
    outside_tiles = [(k, length(intersect(edges[k], outside_edges))) for k in keys(edges) if length(intersect(edges[k], outside_edges)) > 0]
    unique_outside = [x[1] for x in outside_tiles]
    corners = [x[1] for x in outside_tiles if x[2] > 1]
    return unique_outside, corners
end

ims = process_input(input) # a 12x12 image
edges, edge_count = extract_all_edges(ims)
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

function check_monster(arr, monster)
    unique(arr[m...] for m in monster) == ["#"]
end

function monster_size(monster)
    maximum(m[1] for m in monster), maximum(m[2] for m in monster)
end

function find_monster(out, monster)
    mw, ml = monster_size(monster)
    imax, jmax = (size(out)[1], size(out)[2]) .- (ml, mw)
    found = false
    for i = 1:imax, j = 1:jmax
        if check_monster(out[j:(j + mw - 1), i:(i + ml -1)], monster)
            found = true
        end
    end
    return found
end

function scan_photo(out, monster, d = 96)
    if find_monster(out, monster)
        return out
    end
    # Rotate
    new = rotl90(out)
    for i = 1:3
        if find_monster(new, monster)
            return new
        else
            new = rotl90(new)
        end
    end
    # flip
    new = new[1:d, d:-1:1]
    return scan_photo(new, monster, d)
end

function replace_monster(oriented,offsets)
    mw, ml = monster_size(monster)
    imax, jmax = (size(out)[1], size(out)[2]) .- (ml, mw)
    
    for i = 1:imax, j = 1:jmax
        if check_monster(oriented[j:(j + mw -1), i:(i + + ml -1)], offsets)
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
oriented = scan_photo(out, monster)
oriented = replace_monster(oriented, monster)

println("Part 2: ", length(oriented[oriented .== "#"]))


