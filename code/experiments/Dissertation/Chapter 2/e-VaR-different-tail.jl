include("../../../utils.jl")
include("../../../riskMeasure.jl")
using Plots
using Distributions

dist = MixtureModel([Normal(-15, 0.1),Normal(5, 1)], [0.03999, 0.96001])
dist2 = MixtureModel([Normal(-5, 0.1),Normal(5, 1)], [0.03999, 0.96001])
x = range(-20, 10, length=1000)

α = 0.05

VaR_05_1 = quantile(dist, α)
VaR_05_2 = quantile(dist2, α)
CVaR_05_1 = mean(filter(x -> x <= VaR_05_1, rand(dist, 1_000_000)))  
CVaR_05_2 = mean(filter(x -> x <= VaR_05_2, rand(dist2, 1_000_000)))  
EVaR_05_1 = EVaR(distribution(rand(dist, 100_000)),[α])
EVaR_05_2 = EVaR(distribution(rand(dist2, 100_000)),[α])
# Plot the PDF curve
plot(x, pdf.(dist, x), label="x̃₁", linewidth=2, color=:darkred,alpha=0.7)
# Fill the area to the left of the 01% quantile
fill_x = x[x .<= VaR_05_1]  # Select x values on the left of the quantile
fill_y = pdf.(dist, fill_x)  # Corresponding PDF values
plot!(fill_x, fill_y, fill=(0, :red), label="", lw=0, alpha=0.7)
vline!([VaR_05_1], linestyle=:dash, color=:red, linewidth=2, label="5% VaR")
vline!([CVaR_05_1], linestyle=:dashdot, color=:tomato2, linewidth=2, label="5% CVaR")
vline!([EVaR_05_1], linestyle=:dashdot, color=:salmon1, linewidth=2, label="5% EVaR")
xlabel!("x")
ylabel!("Density")
title!("VaR, CVaR and EVaR of Distribution 1")
savefig(check_path("fig/Dissertation/Chapter2/VaR/e-tail_1.pdf"))

plot(x, pdf.(dist2, x), label="x̃₂", linewidth=2, color=:blue,alpha=0.7)
fill_x = x[x .<= VaR_05_2]  # Select x values on the left of the quantile
fill_y = pdf.(dist2, fill_x)  # Corresponding PDF values
plot!(fill_x, fill_y, fill=(0, :deepskyblue2), label="", lw=0, alpha=0.5)
vline!([VaR_05_2], linestyle=:dash, color=:deepskyblue2, linewidth=2, label="5% VaR")
vline!([CVaR_05_2], linestyle=:dashdot, color=:cyan, linewidth=2, label="5% CVaR")
vline!([EVaR_05_2], linestyle=:dashdot, color=:lime, linewidth=2, label="5% EVaR")
xlabel!("x")
ylabel!("Density")
title!("VaR, CVaR and EVaR of Distribution 2")
savefig(check_path("fig/Dissertation/Chapter2/VaR/e-tail_2.pdf"))

# Plot horizontal reference lines
plot(; xlims=(-20,10),ylims=(-1,4), legend=false, title="Risk Measure of the Distributions", 
xlabel="Value", yticks=(0:3, ["5% EVaR", "5% CVaR","5% VaR","Mean"]))

# Add points for the distributions
scatter!([mean(dist)], [3], markershape=:circle, markersize=6, color=:red, alpha=0.5)
scatter!([mean(dist2)], [3], markershape=:circle, markersize=6, color=:blue, alpha=0.5)
scatter!([VaR_05_1], [2], markershape=:star, markersize=6, color=:red, alpha=0.5)
scatter!([VaR_05_2], [2], markershape=:star, markersize=6, color=:blue, alpha=0.5)
scatter!([CVaR_05_1], [1], markershape=:diamond, markersize=6, color=:red, alpha=0.5)
scatter!([CVaR_05_2], [1], markershape=:diamond, markersize=6, color=:blue, alpha=0.5)
scatter!([EVaR_05_1], [0], markershape=:square, markersize=6, color=:red, alpha=0.5)
scatter!([EVaR_05_2], [0], markershape=:square, markersize=6, color=:blue, alpha=0.5)

# Add horizontal lines
hline!([0, 1, 2, 3], linestyle=:dot, color=:gray, linewidth=1)

# Manually add legend using annotations
annotate!(6, 3.8, text("x̃₁", :red, :left, 15))
annotate!(6, 3.4, text("x̃₂", :blue, :left, 15))
savefig(check_path("fig/Dissertation/Chapter2/VaR/e-two_distributions_measures.pdf"))
