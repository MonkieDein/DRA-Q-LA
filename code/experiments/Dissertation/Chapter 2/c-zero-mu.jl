include("../../../utils.jl")
using Plots
using Distributions

dist1 = Normal(0, 2)
dist2 = MixtureModel([Normal(-6, 2),Normal(6, 2)], [0.5, 0.5])
x = range(-20, 20, length=200)

plot(x, pdf.(dist1, x), linestyle=:dot, label="x̃₁", linewidth=2, color =:red, xlabel="x", ylabel="Density", title="")
vline!([mean(dist1)], linestyle=:dash, color =:red, linewidth=2, label="Mean (μ₁)",alpha=0.5)
vline!([quantile(dist1,0.1)], linestyle=:dashdotdot, color =:red, linewidth=2, label="VaR 10% ̃x₁",alpha=0.5)
plot!([mean(dist1), mean(dist1) + std(dist1)], [pdf(dist1, quantile(dist1,0.841)),pdf(dist1, quantile(dist1,0.841))], color =:red, arrow=:both, linewidth=1, label="Std Dev (σ₁)")

plot!(x, pdf.(dist2, x), linestyle=:dot, label="x̃₂", linewidth=2, color =:blue)
vline!([mean(dist2)], linestyle=:dash, color =:blue, linewidth=2, label="Mean (μ₂)",alpha=0.5)
vline!([quantile(dist2,0.1)], linestyle=:dashdotdot, color =:blue, linewidth=2, label="VaR 10% ̃x₂",alpha=0.5)
plot!([mean(dist2), mean(dist2) + std(dist2)], [pdf(dist2, quantile(dist2,0.841)), pdf(dist2, quantile(dist2,0.841))], color =:blue, arrow=:both, linewidth=1, label="Std Dev (σ₂)")

savefig(check_path("fig/Dissertation/Chapter2/risk_measures/two_zero_mean_distributions.pdf"))
