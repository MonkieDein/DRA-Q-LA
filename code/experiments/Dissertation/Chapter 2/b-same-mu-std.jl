include("../../../utils.jl")
using Plots
using Distributions

dist1 = MixtureModel([Normal(-3, 1),Normal(3, 1)], [0.3, 0.7])
dist2 = MixtureModel([Normal(-0.6, 1),Normal(5.4, 1)], [0.7, 0.3])
x = range(-10, 10, length=200)

plot(x, pdf.(dist1, x), linestyle=:dot, label="x̃₁", linewidth=2, color =:red, xlabel="x", ylabel="Density", title="Two distributions")
plot!(x, pdf.(dist2, x), linestyle=:dot, label="x̃₂", linewidth=2, color =:blue)
savefig(check_path("fig/Dissertation/Chapter2/risk_measures/b-two_distributions.pdf"))


# Compute statistics
mean1, mean2 = mean(dist1), mean(dist2)  # Means
sd1, sd2 = std(dist1), std(dist2)  # Std Deviation
VaR_75_1, VaR_75_2 = quantile(dist1, 0.75), quantile(dist2, 0.75)  # 75% Value at Risk (VaR)
CVaR_40_1 = mean(filter(x -> x <= quantile(dist1, 0.40), rand(dist1, 100_000)))  # CVaR 40% (dist1)
CVaR_40_2 = mean(filter(x -> x <= quantile(dist2, 0.40), rand(dist2, 100_000)))  # CVaR 40% (dist2)
EVaR_25_1 = EVaR(distribution(rand(dist1, 100_000)),[0.25]) # EVaR 25% (dist1)
EVaR_25_2 = EVaR(distribution(rand(dist2, 100_000)),[0.25]) # EVaR 25% (dist2)
# Plot horizontal reference lines
plot(; xlims=(-10,10),ylims=(-1,5), legend=false, title="Risk measure of the distributions", 
xlabel="Value", yticks=(0:4, ["EVaR 25%", "CVaR 40%","VaR 75%","Mean","Std Dev"]))

# Add points for the distributions
scatter!([sd1], [4], markershape=:hexagon, markersize=6, color=:red, alpha=0.5)
scatter!([sd2], [4], markershape=:hexagon, markersize=6, color=:blue, alpha=0.5)
scatter!([mean1], [3], markershape=:circle, markersize=6, color=:red, alpha=0.5)
scatter!([mean2], [3], markershape=:circle, markersize=6, color=:blue, alpha=0.5)
scatter!([VaR_75_1], [2], markershape=:star, markersize=6, color=:red, alpha=0.5)
scatter!([VaR_75_2], [2], markershape=:star, markersize=6, color=:blue, alpha=0.5)
scatter!([CVaR_40_1], [1], markershape=:diamond, markersize=6, color=:red, alpha=0.5)
scatter!([CVaR_40_2], [1], markershape=:diamond, markersize=6, color=:blue, alpha=0.5)
scatter!([EVaR_25_1], [0], markershape=:square, markersize=6, color=:red, alpha=0.5)
scatter!([EVaR_25_2], [0], markershape=:square, markersize=6, color=:blue, alpha=0.5)

# Add horizontal lines
hline!([0, 1, 2, 3, 4], linestyle=:dot, color=:gray, linewidth=1)

# Manually add legend using annotations
annotate!(8, 4.8, text("x̃₁", :red, :left, 12))
annotate!(8, 4.5, text("x̃₂", :blue, :left, 12))
savefig(check_path("fig/Dissertation/Chapter2/risk_measures/b-two_distributions_measures.pdf"))










