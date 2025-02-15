include("../../../utils.jl")
include("../../../riskMeasure.jl")
using Plots

dist = [1,2,2,3,3,3]


quantile_50 = quant(distribution(dist),[0.5])[1]
# Split the data into two parts: left (≤ quantile) and right (> quantile)
dist_left = filter(x -> x <= quantile_50, dist)
dist_right = filter(x -> x > quantile_50, dist)

# Plot histogram of values ≤ quantile (left side)
histogram(dist_left, xlabel="x", ylabel="Frequency", title="Quantile of Discrete Distribution", ylims=(0,4), xlims=(0,4),bins=0.5:1:3.5, color=:lightblue, edgecolor=:black, label="Left of 50% Quantile")
xticks!(1:3)

annotate!(1.8, 0.5, text("50%", :blue, :left, 12))
annotate!(3, 0.5, text("50%", :red, :left, 12))
annotate!(2.3, 2.55, text("{", 70, :black))  # Upper brace
# Overlay histogram of values > quantile (right side)
histogram!(dist_right, bins=0.5:1:3.5, color=:lightcoral, edgecolor=:black, label="Right of 50% Quantile")
vline!([quantile_50+.5], linestyle=:dash, color =:purple, linewidth=3, label="50% Quantile")
savefig(check_path("fig/Dissertation/Chapter2/VaR/discrete.pdf"))
