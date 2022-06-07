using Pkg
Pkg.status()
Pkg.update()
Pkg.add("Plots")
using Plots


x = collect(0:0.1:30)
y = sin.(x)
y2 = cos.(x)
df = 2

 
anim = @animate for i = 0:df:length(x)
    plot(x[1:i], y[1:i], labels="sinus",
    xaxis=("x", (0, 32)), yaxis=("y", (-1.5, 1.5)))
    plot!(x[1:i], y2[1:i], labels="kosinus",
    xaxis=("x", (0, 32)), yaxis=("y", (-1.5, 1.5)))
end
 
gif(anim, "sinus_i_kosinus_anim_fps30.gif", fps = 30)
