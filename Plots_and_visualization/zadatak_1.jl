using Pkg
Pkg.status()
Pkg.update()
Pkg.add("Plots")
using Plots
Pkg.add("PlotThemes")



a=1:20; b = rand(20, 5)
c=1:5; d=rand(5,2)
g=1:25; h=1:25

theme(:sand)
p1 = plot(a, b) # vizualizacija linijom

theme(:dark)
p2 = scatter(g, h) # scatter plot

theme(:lime)
p3 = plot(a, b, xlabel = "a", lw = 0.5, title = "Naziv slike")

theme(:wong)
p4 = histogram(c, d)


plot(p1, p2, p3, p4, layout = (2, 2),legend=false)