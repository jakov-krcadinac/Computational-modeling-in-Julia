
## učitavanje igrača iz datoteke
println("###############################################################################################################")

dat = open("match.txt", "r")  # treba paziti da se datoteka match.txt nalazi u radnom direktoriju u Julia terminalu. U suprotnom Error. 

mec = readlines(dat)

#učitavanje imena igrača i vjerojatnosti da osvoje point kad serviraju iz datoteke u vektore
igraci = Vector{String}()
pPointNaServisu = Vector{Float64}()
for i in mec
    pom = split(i, " = ")
    println(pom)
    push!(igraci, pom[1])
    push!(pPointNaServisu, round(parse(Float64, pom[2])/100, digits=3))
end

#ispis igrača i njihovih vjerojatnosti da osvoje point kad serviraju
println(igraci)
println(pPointNaServisu)

##

## računanje vjerojatnosti da igrač A dobije game 
function Pgame(p)
    # p je vjerojatnost da igrač A osvoji point kada on servira. Taj je podatak lako dostupan za svakog igrača i jedna je od najbitnijih statistika u tenisu.
    # q je vjerojatnost da A ne osvoji point kada servira.
    q = 1 - p

    #= vjerojatnost da igrač A dobije game u kojem servira je zbroj vjerojatnosti:
        - da rezultat bude (game-0) 
        - da rezultat bude (game-15) 
        - da rezultat bude (game-30) 
        - da rezultat bude (40-40) i nakon toga  
    =#
    Pg = (p^4) + (4 * p^4 * q) + (10 * p^4 * q^2) + (20 * p^3 * q^3 * p^2 / (p^2 + q^2)) 
    return Pg
end
##

println("\nVjerojatnost da " * igraci[1] * " kojem je p=", pPointNaServisu[1], " osvoji game je: ", Pgame(pPointNaServisu[1]))
println()

## računanje vjerojatnosti da igrač A pobijedi u Tiebreak gameu

matricaTiebreakGame = zeros(9,9)
# rekurzivna funkcija za računanje vjerojatnosti svih ishoda u Tiebreak gameu ako A prvi servira. 
# str. 39 i 40 u knjizi (normalna stranica, ne pdf stranica) 
function rekurzivnaTiebreakFunkcija(g, h, pa, pb)
    qa = 1 - pa
    qb = 1 - pb
    rez1 = [(1, 0), (4, 0), (5, 0), (7, 1), (7, 2), (7, 5)]
    rez2 = [(2, 0), (3, 0), (6, 0), (7, 0), (7, 3), (7, 4)]
    rez3 = [(0, 1), (0, 4), (0, 5), (1, 7), (2, 7), (5, 7)]
    rez4 = [(0, 2), (0, 3), (0, 6), (0, 7), (3, 7), (4, 7)]
    rez5 = [(1, 1), (2, 1), (5, 1), (6, 1), (1, 2), (4, 2), (5, 2), (3, 3), (4, 3), (2, 4), (3, 4), (6, 4), 
            (1, 5), (2, 5), (5, 5), (6, 5), (1, 6), (4, 6), (5, 6)]
    rez6 = [(3, 1), (4, 1), (2, 2), (3, 2), (6, 2), (1, 3), (2, 3), (5, 3), (6, 3), (1, 4), (4, 4), (5, 4),
            (3, 5), (4, 5), (2, 6), (3, 6), (6, 6)]
    
    if (g == 0 && h==0)
        return 1

    elseif ((g, h) in rez1)
        return pa * rekurzivnaTiebreakFunkcija(g-1, h, pa, pb)

    elseif ((g, h) in rez2)
        return qb * rekurzivnaTiebreakFunkcija(g-1, h, pa, pb)

    elseif ((g, h) in rez3)
        return qa * rekurzivnaTiebreakFunkcija(g, h-1, pa, pb)

    elseif ((g, h) in rez4)
        return pb * rekurzivnaTiebreakFunkcija(g, h-1, pa, pb) 

    elseif ((g, h) in rez5)
        return qb * rekurzivnaTiebreakFunkcija(g-1, h, pa, pb) + pb * rekurzivnaTiebreakFunkcija(g, h-1, pa, pb) 

    elseif ((g, h) in rez6)
        return pa * rekurzivnaTiebreakFunkcija(g-1, h, pa, pb) + qa * rekurzivnaTiebreakFunkcija(g, h-1, pa, pb) 
    end

end




# računanje vjerojatnosti da igrač A pobijedi ako se igra u beskonačnost dok jedan od igrača ne vodi za 2 pointa razlike i igrač A servira cijelo vrijeme
function beskonacnaAdvantageIgra(pa)
    qa = 1 - pa 
    return pa^2 / (pa^2 + qa^2)
end

# računanje vjerojatnosti da igrač A pobijedi ako se igra Tiebreak game u beskonačnost dok jedan od igrača ne vodi za 2 pointa razlike. A je imao prvi servis.
function beskonacniTiebreakGame(pa, pb)
    qa = 1 - pa 
    qb = 1 - pb
    return pa*qa / (pa*qb+ qa*pb)
end

#punjenje stupca i retka koji prikazuju mogući broj pointova od A i B
for i in 1:9
    for j in 1:9
        if (i==1 && j!=1)
            matricaTiebreakGame[i, j] = j-2
        end
        if (j==1 && i!=1)
            matricaTiebreakGame[i, j] = i-2
        end
    end 
end

#punjenje vjerojatnosti svih ishoda
for i in 2:9
    for j in 2:9
        if (i==2 && j==2)
            matricaTiebreakGame[2, 2] = 1  # vjerojatnost da se u Tiebreak Gameu dostigne rezultat (0-0) je 100% 
        end
        if ( ((i-2, j-2) != (7, 6))  && ((i-2, j-2) != (7, 7)) && ((i-2, j-2) != (6, 7)))
            matricaTiebreakGame[i, j] = rekurzivnaTiebreakFunkcija(i-2, j-2, pPointNaServisu[1], pPointNaServisu[2])
        end
    end 
end

#uredni ispis matrice za Tiebreak game (broj osvojenih pointova igrača A je u 1. stupcu, od B su u 1. retku)
for i in 1:9
    for j in 1:9
        if (i==1 && j==1)
            print("          ")
        elseif (i==1 && j!=1 || j==1 && i!=1)
            print(string(Int64(matricaTiebreakGame[i, j])) * "        ")
        else
            ispis = string( round(matricaTiebreakGame[i, j], digits=3) ) 
            for i in 1:(9 - length(ispis))
                ispis = ispis * " "
            end
            print(ispis)
        end 
    end 
    println()
end

# racunanje vjerojatnosti da A pobijedi u Tiebreak gameu
PaTiebreaker = matricaTiebreakGame[9, 2] + matricaTiebreakGame[9, 3] + matricaTiebreakGame[9, 4] + matricaTiebreakGame[9, 5] +
                matricaTiebreakGame[9, 6] + matricaTiebreakGame[9, 7] + matricaTiebreakGame[8, 8] * beskonacniTiebreakGame(0.62, 0.6)
println("\nVjerojatnost da " * igraci[1] * " kojem je p=", pPointNaServisu[1], " osvoji Tiebreaker game kad igra protiv " * igraci[2] *
         " kojem je p=", pPointNaServisu[2], " je  ", PaTiebreaker)

##




## računanje vjerojatnosti da igrač A pobjedi u Tiebreak setu (to je set u kojem ako dođe do rezultata (6-6) u gameovima 
## igra se Tiebreak game da se odluči tko će osvojiti set s rezultatom (7-6)) 
println("\nSet matrica:\n")
setMatrica = zeros(9,9)

# rekurzivna funkcija za računanje vjerojatnosti svih ishoda u setu kada igraju A i B. 
# str. 42 i 43 i  u knjizi (normalna stranica, ne pdf stranica) 
function rekurzivnaSetFunkcija(g, h, pga, pgb, pTiebreakGame)
    qga = 1 - pga   #pga je vjerojatnost da A pobijedi game u kojem on servira kad igra s B, qga je onda logično vjerojatnost da izgubi taj game
    qgb = 1 - pgb   #pgb je vjerojatnost da B pobijedi game u kojem on servira kad igra s A, qga je vjerojatnost da B izgubi taj game
    rez1 = [(1, 0), (3, 0), (5, 0), (6, 1), (6, 3), (6, 5)]
    rez2 = [(2, 0), (4, 0), (6, 0), (6, 2), (6, 4), (7, 5)]
    rez3 = [(0, 1), (0, 3), (0, 5), (1, 6), (3, 6), (5, 6)]
    rez4 = [(0, 2), (0, 4), (0, 6), (2, 6), (4, 6), (5, 7)]
    rez5 = [(2, 1), (4, 1), (1, 2), (3, 2), (5, 2), (2, 3), (4, 3), (1, 4), (3, 4), (5, 4), (2, 5), (4, 5)]
    rez6 = [(1, 1), (3, 1), (5, 1), (2, 2), (4, 2), (1, 3), (3, 3), (5, 3), (2, 4), (4, 4), (1, 5), (3, 5),
            (5, 5), (6, 6)]

    if (g == 0 && h==0)
        return 1
        
    elseif ((g, h) in rez1)
        return pga * rekurzivnaSetFunkcija(g-1, h, pga, pgb, pTiebreakGame)
        
    elseif ((g, h) in rez2)
        return qgb * rekurzivnaSetFunkcija(g-1, h, pga, pgb, pTiebreakGame)
        
    elseif ((g, h) in rez3)
        return qga * rekurzivnaSetFunkcija(g, h-1, pga, pgb, pTiebreakGame)
        
    elseif ((g, h) in rez4)
        return pgb * rekurzivnaSetFunkcija(g, h-1, pga, pgb, pTiebreakGame) 
        
    elseif ((g, h) in rez5)
        return pga * rekurzivnaSetFunkcija(g-1, h, pga, pgb, pTiebreakGame) + qga * rekurzivnaSetFunkcija(g, h-1, pga, pgb, pTiebreakGame) 
        
    elseif ((g, h) in rez6)
        return qgb * rekurzivnaSetFunkcija(g-1, h, pga, pgb, pTiebreakGame) + pgb * rekurzivnaSetFunkcija(g, h-1, pga, pgb, pTiebreakGame) 
    elseif ((g, h) == (7, 6)) 
        return pTiebreakGame * rekurzivnaSetFunkcija(g-1, h, pga, pgb, pTiebreakGame)
    
    elseif ((g, h) == (6, 7)) 
        return (1-pTiebreakGame) * rekurzivnaSetFunkcija(g, h-1, pga, pgb, pTiebreakGame)
    
    end
end

#punjenje 1. stupca i 1. retka koji prikazuju mogući broj rezultat u gameovima između igrača A i B
for i in 1:9
    for j in 1:9
        if (i==1 && j!=1)
            setMatrica[i, j] = j-2
        end
        if (j==1 && i!=1)
            setMatrica[i, j] = i-2
        end
    end 
end

#punjenje vjerojatnosti svih ishoda
PgA = Pgame(pPointNaServisu[1])
PgB = Pgame(pPointNaServisu[2])
for i in 2:9
    for j in 2:9
        if (i==2 && j==2)
            setMatrica[2, 2] = 1  # vjerojatnost da se u setu dostigne rezultat gameova (0-0) je 100% 
        end

        if ( !( (i-2 == 7 && j-2 <= 4) || (j-2 == 7 && i-2 <= 4) || (j-2 == 7 && i-2 == 7) ) )
            setMatrica[i, j] = rekurzivnaSetFunkcija(i-2, j-2, PgA, PgB, PaTiebreaker)
        end
    end 
end

#uredan ispis matrice za vjerojatnosti svih ishoda u setu između A i B (broj osvojenih gameova igrača A je u 1. stupcu, od B su u 1. retku)
for i in 1:9
    for j in 1:9
        if (i==1 && j==1)
            print("          ")
        elseif (i==1 && j!=1 || j==1 && i!=1)
            print(string(Int64(setMatrica[i, j])) * "        ")
        else
            ispis = string( round(setMatrica[i, j], digits=3) ) 
            for i in 1:(9 - length(ispis))
                ispis = ispis * " "
            end
            print(ispis)
        end 
    end 
    println()
end


PaSet = setMatrica[8, 2] + setMatrica[8, 3] + setMatrica[8, 4] + setMatrica[8, 5] +
        setMatrica[8, 6] + setMatrica[9, 7] + setMatrica[9, 8] 

println("\nVjerojatnost da " * igraci[1] * " kojem je p=", pPointNaServisu[1], " osvoji set protiv " * igraci[2] *
         " kojem je p=", pPointNaServisu[2], " je  ", PaSet)
##


## računanje vjerojatnosti da igrač A pobjedi cijeli match (first-to-5 meč, dakle men's singles i men's doubles)

println("\nMatch matrica:\n")
matchMatrica = zeros(5,5)

# rekurzivna funkcija za računanje vjerojatnosti svih ishoda u matchu između A i B. 
# str. 47 u knjizi (normalna stranica, ne pdf stranica) 
function rekurzivnaMatchFunkcija(k, l, psa)
    qsa = 1 - psa

    if (k == 0 && l==0)
        return 1
        
    elseif ((k ==3 && l >= 0 && l <= 2) || (l==0 && k>=1 && k<=3))
        return psa * rekurzivnaMatchFunkcija(k-1, l, psa)
        
    elseif (l ==3 && k >= 0 && k <= 2 || (k==0 && l>=1 && l<=3))
        return qsa * rekurzivnaMatchFunkcija(k, l-1, psa)
        
    elseif (k >= 1 && k <= 2 && l >= 1 && l <= 2)
        return psa * rekurzivnaMatchFunkcija(k-1, l, psa) + qsa * rekurzivnaMatchFunkcija(k, l-1, psa)
    
    end
end

#punjenje 1. stupca i 1. retka koji prikazuju mogući broj rezultat u setovima između igrača A i B
for i in 1:5
    for j in 1:5
        if (i==1 && j!=1)
            matchMatrica[i, j] = j-2
        end
        if (j==1 && i!=1)
            matchMatrica[i, j] = i-2
        end
    end 
end

# punjenje vjerojatnosti svih ishoda
# varijabla PaSet predstavlja vjerojatnost da igrač A osvoji set i već je izračunata
for i in 2:5
    for j in 2:5

        if ( !(i==5 && j==5) )
            matchMatrica[i, j] = rekurzivnaMatchFunkcija(i-2, j-2, PaSet)
        
        end
    end 
end

#uredan ispis matrice za vjerojatnosti svih ishoda meča između A i B (broj osvojenih setova igrača A je u 1. stupcu, od B su u 1. retku)
for i in 1:5
    for j in 1:5
        if (i==1 && j==1)
            print("          ")
        elseif (i==1 && j!=1 || j==1 && i!=1)
            print(string(Int64(matchMatrica[i, j])) * "        ")
        else
            ispis = string( round(matchMatrica[i, j], digits=3) ) 
            for i in 1:(9 - length(ispis))
                ispis = ispis * " "
            end
            print(ispis)
        end 
    end 
    println()
end

# vjerojatnost da A dobije cijeli match protiv B
PaMatch = matchMatrica[5, 2] + matchMatrica[5, 3] + matchMatrica[5, 4]

println("\nVjerojatnost da " * igraci[1] * " kojem je p=", pPointNaServisu[1], " osvoji pobijedi igrača " * igraci[2] *
         " kojem je p=", pPointNaServisu[2], " je  ", PaMatch)
println()
##


