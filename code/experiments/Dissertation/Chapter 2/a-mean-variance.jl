include("../../../utils.jl")
include("../../../riskMeasure.jl")
using Plots
using Distributions

dist1 = Normal(0, 2)
dist2 = MixtureModel([Normal(-4, 3),Normal(6, 3)], [0.5, 0.5])

x = range(-20, 20, length=200)
plot(x, pdf.(dist1, x), linestyle=:dot, label="x̃₁", linewidth=2, color =:red, xlabel="x", ylabel="Density", title="Two distributions")
plot!(x, pdf.(dist2, x), linestyle=:dot, label="x̃₂", linewidth=2, color =:blue)
savefig(check_path("fig/Dissertation/Chapter2/risk_measures/a-two_distributions.pdf"))


# Compute statistics
mean1, mean2 = mean(dist1), mean(dist2)  # Means
sd1, sd2 = std(dist1), std(dist2)  # Std Deviation
VaR_75_1, VaR_75_2 = quantile(dist1, 0.75), quantile(dist2, 0.75)  # 75% Value at Risk (VaR)
CVaR_50_1 = mean(filter(x -> x <= quantile(dist1, 0.50), rand(dist1, 100_000)))  # CVaR 50% (dist1)
CVaR_50_2 = mean(filter(x -> x <= quantile(dist2, 0.50), rand(dist2, 100_000)))  # CVaR 50% (dist2)
EVaR_25_1 = EVaR(distribution(rand(dist1, 100_000)),[0.25]) # EVaR 25% (dist1)
EVaR_25_2 = EVaR(distribution(rand(dist2, 100_000)),[0.25]) # EVaR 25% (dist2)
# Plot horizontal reference lines
plot(; xlims=(-20,20),ylims=(-1,5), legend=false, title="Risk measure of the distributions", 
xlabel="Value", yticks=(0:4, ["EVaR 25%", "CVaR 50%","VaR 75%","Mean","Std Dev"]))

# Add points for the distributions
scatter!([sd1], [4], markershape=:hexagon, markersize=6, color=:lightcoral)
scatter!([sd2], [4], markershape=:hexagon, markersize=6, color=:lightskyblue)
scatter!([mean1], [3], markershape=:circle, markersize=6, color=:lightcoral)
scatter!([mean2], [3], markershape=:circle, markersize=6, color=:lightskyblue)
scatter!([VaR_75_1], [2], markershape=:star, markersize=6, color=:lightcoral)
scatter!([VaR_75_2], [2], markershape=:star, markersize=6, color=:lightskyblue)
scatter!([CVaR_50_1], [1], markershape=:diamond, markersize=6, color=:lightcoral)
scatter!([CVaR_50_2], [1], markershape=:diamond, markersize=6, color=:lightskyblue)
scatter!([EVaR_25_1], [0], markershape=:square, markersize=6, color=:lightcoral)
scatter!([EVaR_25_2], [0], markershape=:square, markersize=6, color=:lightskyblue)

# Add horizontal lines
hline!([0, 1, 2, 3, 4], linestyle=:dot, color=:gray, linewidth=1)

# Manually add legend using annotations
annotate!(15, 4.8, text("x̃₁", :lightcoral, :left, 12))
annotate!(15, 4.5, text("x̃₂", :lightskyblue, :left, 12))
savefig(check_path("fig/Dissertation/Chapter2/risk_measures/a-two_distributions_measures.pdf"))










