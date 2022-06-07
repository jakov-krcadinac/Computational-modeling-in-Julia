import Pkg
Pkg.add("Plots")

using Plots

## POČETAK 1. ZADATKA

    # parametri i varijable koje znamo
    m=70
    cd=0.25
    t=1:2:14
    t=collect(t)

    println("vremena u kojima mjerimo brzinu i prijeđeni put: ", t)  #PROVJERA
    g=9.81

    # jednadžba brzine ovisne o vremenu - analitičko rješenje:
    v=sqrt((g*m)/cd).*tanh.(sqrt.((g*cd)/m).*t)
    println("postignute brzine za to vrijeme: ", v)  #PROVJERA

    # prikaz ovisnosti na grafu
    brzinaPlot = plot(t, v, label="Brzina ovisno o vremenu_ analitičko", color=:red, legend = :bottomright) # osnovna naredba za plot
    brzinaPlot = plot!(xlab="t [s]", ylab="v [m/s]") # dodajmo nazive osi

    # izračun terminalne brzine za infinite uže (dakle kao da beskonačno padamo)
    vt=sqrt((g*m)/cd).*tanh.(sqrt.((g*cd)/m).*Inf)
    vt=vt*ones(length(t)) # radimo listu da bi to mogli pokazati na slici
    brzinaPlot = plot!(t,vt, label="terminalna brzina", line=:dash) #prikaz na slici

    # računanje prijeđenog puta u ovisnosti o vremenu
    prijedeniPut=0
    brzine = sqrt((g*m)/cd).*tanh.(sqrt.((g*cd)/m).*t)
    putevi = zeros(0)   #lista u koju se spremaju vrijednosti prijeđenog puta ovisno o vremenu
    putPlot = plot(label="Put ovisno o vremenu_ analitičko",xlab="t [s]", ylab="s [m]", color=:blue, legend = :bottomright)
    for vrijeme in t
        local v=sqrt((g*m)/cd).*tanh.(sqrt.((g*cd)/m).*vrijeme) #računanje brzine koju je postigao u tom vremenu 
        # println(v) -> provjera
        
        interval = 2       #= vremenski interval tijekom kojeg pada tom brzinom 
                            (pretpostavka je da tijekom te 2 sekunde cijelo vrijeme pada istom brzinom, što naravno nije točno, 
                            ali ovo je gruba procjena). Kada bismo htjeli puno bolju procjenu mogli bismo staviti da se vremena
                            povećavaju za 0.1 sekundu umjesto za 2 sekunde pa bismo imali puno precizniju krivulju 
                        =#
        
        if (vrijeme == 1)
            global prijedeniPut = v * 1     # na početku pada od 0. do 1. sekunde, pa je interval 1 sekudna
        else 
            global prijedeniPut = prijedeniPut + v * interval   # sva druga vremena su udaljena za 2 sekunde
        end
        
        append!(putevi, prijedeniPut)   # dodavanje ukupnog prijeđenog puta u listu

    end

    println("povecavanje puta: ", putevi)  #PROVJERA

    putPlot = plot(t, putevi, label="Put ovisno o vremenu_ analitičko", xlab="t [s]", ylab="s [m]", color=:blue, legend = :topleft)

    maxBungeeSkok = 199     #svjetski rekord za najviši bungee skok je postavio A.J. Hackett 2006. godine kada je skočio s Macau Towera
    maxBungeeSkok=maxBungeeSkok*ones(length(t)) # radimo listu da bi to mogli pokazati na slici
    putPlot = plot!(t,maxBungeeSkok, label="maksimalni put", line=:dash, color = :blue) #prikaz na slici


    # Stavljam ograničenje prijeđenog puta na 199 metara
    prijedeniPut = 0
    putevi_s_ogranicenjem = zeros(0)   #lista u koju se spremaju vrijednosti prijeđenog puta ovisno o vremenu
    prijedenaVremena = zeros(0)  # lista u koju će se spremati sva vremena dok ne dosegne visinu od 199 metara
    precizniji_t=1:0.1:14
    precizniji_t=collect(precizniji_t)
    for vrijeme in precizniji_t
        local v=sqrt((g*m)/cd).*tanh.(sqrt.((g*cd)/m).*vrijeme) #računanje brzine koju je postigao u tom vremenu 
        # println(v) -> provjera
        
        interval = 0.1       #= vremenski interval tijekom kojeg pada tom brzinom, sada ga postavljam na 0.1 kako 
                                bismo dobili precizniju krivulju
                            =#
        
        if (vrijeme == 1)
            global prijedeniPut = v * 1     # na početku pada od 0. do 1. sekunde, pa je interval 1 sekudna
        else 
            global prijedeniPut = prijedeniPut + v * interval   # sva druga vremena su udaljena za 0.1 sekundu
        end

        if (prijedeniPut > 199)
            break
        end

        append!(putevi_s_ogranicenjem, prijedeniPut)   # dodavanje ukupnog prijeđenog puta u listu
        append!(prijedenaVremena, vrijeme)   # dodavanje trenutnog vremena u listu

    end

    #postavljanje svih prijeđenih puteva s ograničenjem u plot 
    putSOgranicenjemPlot = plot(prijedenaVremena, putevi_s_ogranicenjem, label="Put s ogranicenjem ovisno o vremenu_ analitičko", xlab="t [s]", ylab="s [m]", color=:green, legend = :topleft)

    plot(brzinaPlot, putPlot, putSOgranicenjemPlot, layout = (3, 1))  #želim prikazati sva 3 grafa


## KRAJ 1. ZADATKA



## POČETAK 2. ZADATKA -> put i brzina bez otpora zraka

    # m=70
    # cd=0.25   -> masa i otpor zraka više nisu potrebni

    g=9.81
    t=1:2:14
    t=collect(t)

    # jednadžba brzine ovisne o vremenu - analitičko rješenje:
    v=g*t
    println("postignute brzine za to vrijeme: ", v)  #PROVJERA

    # prikaz ovisnosti na grafu
    brzinaPlot1 = plot(t, v, label="Brzina ovisno o vremenu bez cd_ analitičko", color=:red, legend = :bottomright) # osnovna naredba za plot
    brzinaPlot1 = plot!(xlab="t [s]", ylab="v [m/s]") # dodajmo nazive osi

    s=[]    # polje u kojem će biti pohranjen izračunati prijeđeni put za neko vrijeme
    for i in 1:length(t)
        push!(s, ((g/2)*t[i]*t[i]) )    #dodavanje prijeđenih puteva u polje
    end
    println(s)

    # prikaz ovisnosti na grafu
    putPlot1 = plot(t, s, label="put ovisno o vremenu bez cd_ analitičko", color=:red, legend = :bottomright, xlab="s [m]", ylab="v [m/s]") # osnovna naredba za plot

## KRAJ 2. ZADATKA

## POČETAK 3. ZADATKA -> razlike između numeričkog i analitičkog rješenja

    # m=70
    # cd=0.25   -> masa i otpor zraka više nisu potrebni

    global m=70
    global cd=0.25
    global g=9.81
    # funkcije koje su nam potrebne za izračin brzine
    function deriva(v)
        dv=g-((cd/m)*v*v)
        return dv
    end

    function brzina(v0,dt,tp,tk) # v0-početna vrijednost brzine (ovisne varijable),dt-vremenski korak, tp-početno vrijeme, tk-konačno vrijeme
        n=(tk-tp)/dt
        vi=v0
        ti=tp
        for i=1:n
            dvdt= deriva(vi)
            vi=vi+dvdt*dt
            ti=ti+dt
        end
        return vi
    end

    ## pozivanje funkcija (npr, želimo sada izračunati brzinu nakon 14 s, početno krenemo iz nule, sa stepom 0.5)
    rez=brzina(0,0.5,0,14)


    #ANALITIČKI
    t=0:0.5:14
    t=collect(t)

    v=sqrt((g*m)/cd).*tanh.(sqrt.((g*cd)/m).*t)
    println(v, length(v))   #PROVJERA

    razlike=[]  #u ovo polje spremam razlike između analitički i numerički izračunate brzine za svaki 
    for i in 1:length(t)
        raz = abs(v[i] - brzina(0,0.5,0,t[i]))
        push!(razlike, raz)
    end
    println()
    println(razlike)

    ApsPog_barChart = bar(t, razlike, kind="bar", xlab="t [s]", ylab="v [m/s]")
## KRAJ 3. ZADATKA


## POČETAK 4. ZADATKA -> animirani plot prijeđenog puta i brzine u ovisnosti u vremenu 

m=70
cd=0.25
t=0:0.1:14  #računam vrijeme i prijeđeni put svakih 0.1s do 14.sekudne
t=collect(t)

g=9.81

# jednadžba brzine ovisne o vremenu - analitičko rješenje:
v=sqrt((g*m)/cd).*tanh.(sqrt.((g*cd)/m).*t)

# prikaz ovisnosti na grafu
brzinaPlot = plot(t, v, label="Brzina ovisno o vremenu_ analitičko", color=:red, legend = :bottomright) # osnovna naredba za plot
brzinaPlot = plot!(xlab="t [s]", ylab="v [m/s]") # dodajmo nazive osi

# računanje prijeđenog puta u ovisnosti o vremenu
prijedeniPut=0
brzine = sqrt((g*m)/cd).*tanh.(sqrt.((g*cd)/m).*t)
putevi = zeros(0)   #lista u koju se spremaju vrijednosti prijeđenog puta ovisno o vremenu
putPlot = plot(label="Put ovisno o vremenu_ analitičko",xlab="t [s]", ylab="s [m]", color=:blue, legend = :bottomright)
for vrijeme in t
    local v=sqrt((g*m)/cd).*tanh.(sqrt.((g*cd)/m).*vrijeme) #računanje brzine koju je postigao u tom vremenu 
    # println(v) -> provjera
    
    interval = 2       #= vremenski interval tijekom kojeg pada tom brzinom 
                        (pretpostavka je da tijekom te 2 sekunde cijelo vrijeme pada istom brzinom, što naravno nije točno, 
                        ali ovo je gruba procjena). Kada bismo htjeli puno bolju procjenu mogli bismo staviti da se vremena
                        povećavaju za 0.1 sekundu umjesto za 2 sekunde pa bismo imali puno precizniju krivulju 
                    =#
    
    if (vrijeme == 1)
        global prijedeniPut = v * 1     # na početku pada od 0. do 1. sekunde, pa je interval 1 sekudna
    else 
        global prijedeniPut = prijedeniPut + v * interval   # sva druga vremena su udaljena za 2 sekunde
    end
    
    append!(putevi, prijedeniPut)   # dodavanje ukupnog prijeđenog puta u listu

end

t = collect(0:0.1:14)
brzina(t) = sqrt((g*m)/cd).*tanh.(sqrt.((g*cd)/m).*t)
put(t) = sqrt((g*m)/cd).*tanh.(sqrt.((g*cd)/m).*t) * t


yposV = brzina.(t)
yposS = put.(t)

anim = @animate for i = 0:1:length(t)
    plot(t[1:i], yposV[1:i], labels="brzina",
    xaxis=("t [s]", (0, 15)), yaxis=("v [m/s]", (0, 60)))
    plot!(t[1:i], yposS[1:i], labels="put",
    xaxis=("t [s]", (0, 15)), yaxis=("v [m/s]", (0, 700)))
end
 
gif(anim, "put_i_vrijeme.gif", fps = 30)

## KRAJ 4. ZADATKA

## 5. ZADATAK


function deriva(v)
    dv=g-((cd/m)*v*abs(v))
    #dv=g-((cd/m)*v*v)
    return dv
end

function brzina_intervali(v0,bi,tp,tk) 
    # v0-početna vrijednost brzine (ovisne varijable)
    # bi-broj interala koji želimo između početnog i konačnog vremena
    # tp-početno vrijeme
    # tk-konačno vrijeme
    interval = (tk - tp) / bi      #vrijeme između intervala će ovisiti o broju intervala koji želimo
    vi=v0
    ti=tp
    s=interval # unosimo ovu varijablu da bi po potrebi negdje drugdje kasnije znali vrijednost dt
    br=zeros(0) # vektor za spremanje brzine svakog intervala
    vrijeme=zeros(0)    # vektor za spremanje gornje vremenske granice svakog vremenskog intervala 
                        # (recimo za interval 0s - 0.15s će se pohraniti 0.15 u vektor)
    
    # ovakvim računanjem nema potrebe za while petljom i breakom jer će konačno vrijeme nakon završetka
    # for petlje uvijek biti konačno vrijeme tk.
    for i=1:bi              
        dvdt= deriva(vi)
        vi=vi+dvdt*s
        ti=ti+s
        append!(br,vi) # da bi imali brzinu u svakom intervalu
        append!(vrijeme, ti)
    end
    return br, vrijeme
end

#što smo veći broj intervala odabrali krivulja će biti preciznija
brzine, vremena = brzina_intervali(0,10,0,14)

#println(brzine)  -> PROVJERA
#println(vremena)  -> PROVJERA
#println(length(vremena)) -> PROVJERA

plot(vremena, brzine, label="Brzina ovisno o vremenu", legend = :bottomright) # osnovna naredba za plot
plot!(xlab="t [s]", ylab="v [m/s]")

## KRAJ 5. ZADATKA