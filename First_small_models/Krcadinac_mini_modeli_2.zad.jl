##poznate duljine kateta
function dvijeKat(a, b)
    return a*b/2
end
##

##poznata duljina 1 katete i duljina hipotenuze
function katIhip(a, c)
    b=sqrt(c^2 - a^2)
    return a*b/2
end
##

##poznata duljina hipotenuze i njena visina
function katIhip(c, vc)     
    return c*vc/2           # radi istu stvar kao funkcija dvijeKat
end
##

##poznata duljina hipotenuze i kut alfa između nasuprotne i hipotenuze (zadan u radijanima)
function hipIalfa(c, alfa)     
    a = sin(alfa) * c
    pov=katIhip(a, c)   #sada nam je poznata duljina jedne katete pa možemo koristiti već postojeću formulu za računanje povrišne
    return pov
end

hipIalfa(2, pi/6)
##

##poznata duljina nasuprotne i kut alfa između nasuprotne i hipotenuze (zadan u radijanima)
function nasupIalfa(a, alfa)     
    c = a / sin(alfa)
    pov=katIhip(a, c)   
    return pov
end

nasupIalfa(1, pi/6)
##

##poznata duljina hipotenuze i kut beta između priležeće i hipotenuze (zadan u radijanima)
function hipIbeta(c, beta)     
    b = cos(beta) * c
    pov=katIhip(b, c)   
    return pov
end

hipIbeta(2, pi/3)
##

##poznata duljina priležeće i kut beta između priležeće i hipotenuze (zadan u radijanima)
function prilIbeta(b, beta)     
    c = b / cos(beta)
    pov=katIhip(b, c)   
    return pov
end

prilIbeta(1, pi/3)
##

