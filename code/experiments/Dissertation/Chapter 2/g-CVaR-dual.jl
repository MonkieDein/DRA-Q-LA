include("../../../utils.jl")
include("../../../riskMeasure.jl")
using Plots
using Distributions

dist = MixtureModel([Normal(-3, 2),Normal(3, 2)], [0.5, 0.5])

α = 0.3
VaR_30 = quantile(dist, α)
CVaR_30 = mean(filter(x -> x <= VaR_30, rand(dist, 1_000_000)))  
x = range(-10, 15, length=200)


# Plot the PDF curve
plot(x, pdf.(dist, x), label="x̃₁ ∼ q", linewidth=2, color=:darkred,alpha=0.7)
plot!(x, pdf.(dist, x)/0.3, label="30% ⋅ ξ ≤ q", linewidth=2, color=:darkblue,alpha=0.7)
# Fill the area to the left of the 1% quantile
fill_x = x[x .<= VaR_30]  # Select x values on the left of the quantile
fill_y = pdf.(dist, fill_x)  # Corresponding PDF values
plot!(fill_x, fill_y/0.3, fill=(0, :aqua), label="x̃₂ ∼ ξ", lw=0, alpha=0.5)

vline!([VaR_30], linestyle=:dash, color =:magenta, linewidth=2, label="30% VaR")
vline!([CVaR_30], linestyle=:dash, color =:dodgerblue2, linewidth=2, label="30% CVaR[x̃₁] = E[x̃₂]")

xlabel!("x")
ylabel!("Density")
title!("CVaR Dual (α = 30%)")
annotate!(-5, 0.15, text("1.0", :steelblue4, :left, 12))

savefig(check_path("fig/Dissertation/Chapter2/CVaR/dual.pdf"))
