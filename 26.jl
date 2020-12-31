using DataFrames
using Gadfly

function time_to_int(seg)
    segspl = parse.(Int, split(seg, ":"))
    segspl[1] + segspl[2] / 60 + segspl[3] / 3600
end

# Load Data (copy/paste from website too messy for easy parsing as a CSV)
raw_scores = split.(replace.(readlines("26.txt")[3:end], r"^( )+" => ""), r"( )+")
df = DataFrame(Day = String[], Time1 = String[], Rank1 = String[], Score1 = String[], 
                               Time2 = String[], Rank2 = String[], Score2 = String[])

for rs in raw_scores
    push!(df, rs)
end

# Convert columns to more useful data types
select!(df, :Day, :Time1, :Rank1, :Time2, :Rank2)
transform!(df, [:Day, :Rank1, :Rank2] .=> i -> parse.(Int, i); renamecols = false)
df[!, :Time1] = [time_to_int(s) for s in df[!, :Time1]]
df[!, :Time2] = [time_to_int(s) for s in df[!, :Time2]]

# Reshape data
dflong = stack(df, 2:5)
dflong[!, :Star] = replace.(dflong[!, :variable], r"[^0-9.]" => "")
dflong[!, :variable] = replace.(dflong[!, :variable], r"[0-9.]" => "")
dfwide = unstack(dflong, :variable, :value)

# Plot
plot(dfwide, x=:Day, y=:Rank, color=:Star, Geom.point, 
    Scale.color_discrete_manual(colorant"grey", colorant"yellow"),
    Theme(major_label_color = colorant"white", minor_label_color = colorant"white", 
          key_label_color = colorant"white", key_title_color = colorant"white"))
plot(dfwide, x=:Day, y=:Time, color=:Star, Geom.point, 
    Scale.color_discrete_manual(colorant"grey", colorant"yellow"), Scale.y_log(),
    Theme(major_label_color = colorant"white", minor_label_color = colorant"white", 
          key_label_color = colorant"white", key_title_color = colorant"white"))

# Change in Rank
deltadf = df
deltadf[!, :dr] = (deltadf[!, :Rank1] .- deltadf[!, :Rank2]) ./ deltadf[!, :Rank2]
deltadf[!, :colorkey] = ifelse.(deltadf[!, :dr] .> 0, "1", "2")

plot(deltadf, x=:Day, y=:dr, color = :colorkey, Geom.point, 
    Guide.ylabel("Rank: Part 1 - Part 2"),
    Scale.color_discrete_manual(colorant"green", colorant"red"),
    Theme(major_label_color = colorant"white", minor_label_color = colorant"white", 
          key_label_color = colorant"white", key_title_color = colorant"white",
          key_position = :none))


sum((df[(df[!, :Day] .!=(23)) .& (df[!, :Day] .!=(7)), :])[!, :Time2])

