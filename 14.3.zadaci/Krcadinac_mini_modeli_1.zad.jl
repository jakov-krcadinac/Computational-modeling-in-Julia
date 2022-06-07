## 1. zadatak 

#Očitavanje user inputa
println("Unesite temperaturu u Celzijevim stupnjevima")
temp = readline()
temp = parse(Int64, temp)
println("Upisite \"Farenheit\" ako temperaturu zelite pretvoriti u Farenheite, ili \"Kelvin\" ako temperaturu zelite u Kelvinima.")
jedinica = readline()
println(jedinica)

#funkcija koja pretvara u F ili K 
function pretvorba(t, j)
    if (j=="Farenheit")
        return t*1.8 + 32
    elseif (j=="Kelvin")
        return t+273.15
    else 
        println("Ne podrzavamo zadanu temperaturu")
        return false
    end
end

#ispis rezultata
pretvorena=pretvorba(temp, jedinica)
if (pretvorena != false)
    if (jedinica=="Kelvin")
        println(temp, "°C = ", pretvorena, " K")
    elseif (jedinica=="Farenheit")
        println(temp, "°C = ", pretvorena, "°F")
    end
end


##