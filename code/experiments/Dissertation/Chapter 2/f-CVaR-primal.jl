include("../../../utils.jl")
include("../../../riskMeasure.jl")
using Plots
using Distributions

dist = MixtureModel([Normal(-3, 2),Normal(3, 2)], [0.5, 0.5])

α = 0.3
VaR_30 = quantile(dist, α)
CVaR_30 = mean(filter(x -> x <= VaR_30, rand(dist, 1_000_000)))  
left_tail_dist = Truncated(dist, -Inf, VaR_30)
x = range(-10, 15, length=200)


# Plot the PDF curve
plot(x, pdf.(dist, x), label="x̃₁", linewidth=2, color=:darkred,alpha=0.7)
vline!([VaR_30], linestyle=:dash, color =:magenta, linewidth=2, label="z* = 30% VaR")
plot!([VaR_30,CVaR_30], [.15,.15], arrow=:left, linewidth=2, label="-E[z*-x̃₁]₊", color =:plum2)
plot!(x, pdf.(left_tail_dist, x), label="x̃₂ = Tail Distribution of x̃₁", linewidth=3, color=:darkblue,alpha=0.7)
vline!([CVaR_30], linestyle=:dash, color =:dodgerblue2, linewidth=2, label="30% CVaR[x̃₁] = z*-E[z*-x̃₁]₊ = E[x̃₂]")
# Fill the area to the left of the 01% quantile
fill_x = x[x .<= VaR_30]  # Select x values on the left of the quantile
fill_y = pdf.(dist, fill_x)  # Corresponding PDF values
plot!(fill_x, fill_y, fill=(0, :red), label="", lw=0, alpha=0.5)
xlabel!("x")
ylabel!("Density")
title!("CVaR Primal (α = 30%)")


annotate!(-5, 0.025, text("30%", :red, :left, 12))
annotate!(3, 0.025, text("70%", :black, :left, 12))

savefig(check_path("fig/Dissertation/Chapter2/CVaR/primal.pdf"))
