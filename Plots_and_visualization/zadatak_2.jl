using Pkg
Pkg.status()
Pkg.update()
Pkg.add("Plots")
using Plots
Pkg.add("PlotThemes")
Pkg.add("GR")
Pkg.add("PlotlyJS")
Pkg.add("PyPlot")

a=1:20; b = rand(20, 5)
c=1:5; d=rand(5,2)
g=1:25; h=1:25

# backend je po defaultu GR
theme(:sand)
p1 = plot(a, b, title = "This is Plotted using GR") # vizualizacija linijom

x = range(1, 20)
y= rand(20, 5)

plotlyjs() # Postavljanje backenda u Plotly
p1plotly = plot(x, y, title = "This is Plotted using Plotly")

pyplot() # Postavljanje backenda u PyPlot
p1pyplot = plot(x,y,label="Base Plot", title = "This is Plotted using PyPlot")

#ne mogu porikazati pyplot plot kao subplot. Zbog toga se prikaze samo plyplot umjesto sva 3 plota.
#plot(p1, p1plotly, p1pyplot,layout = (3, 1),legend=false)
