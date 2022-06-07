println("Upisite duljine stranica a, b i c odvojene razmakom")
duljine = readline()
stranice = split(duljine, " ")
a = parse(Float64, stranice[1])
b = parse(Float64, stranice[2])
c = parse(Float64, stranice[3])

function Heron(a, b, c)
    s = (a+b+c) / 2
    pov = sqrt(s * (s-a) * (s-b) * (s-c))
    return pov
end

println("Povrsina zadanog trokuta je ", Heron(a, b, c))
