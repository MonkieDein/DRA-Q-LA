include("../../../utils.jl")
using Plots
using Distributions

dist = MixtureModel([Normal(-0.6, 1),Normal(5.4, 1)], [0.7, 0.3])
x = range(-10, 10, length=200)

VaR_10 = quantile(dist, 0.1)

# Plot the PDF curve
plot(x, pdf.(dist, x), label="PDF", linewidth=2, color=:black)
# Fill the area to the left of the 10% quantile
fill_x = x[x .<= VaR_10]  # Select x values on the left of the quantile
fill_y = pdf.(dist, fill_x)  # Corresponding PDF values
plot!(fill_x, fill_y, fill=(0, :deepskyblue2), label="", lw=0, alpha=0.5)

# Add vertical dashed line at the 10% quantile
vline!([VaR_10], linestyle=:dash, color=:deepskyblue2, linewidth=2, label="10% Quantile")
annotate!(-3.5, 0.02, text("10%", :blue, :left, 12))
annotate!(0, 0.02, text("90%", :black, :left, 12))

# Labels and title
xlabel!("x")
ylabel!("Density")
title!("Quantile of Absolutely Continuous Distribution")
savefig(check_path("fig/Dissertation/Chapter2/VaR/continuous.pdf"))
