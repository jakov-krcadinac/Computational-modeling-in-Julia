
## 1. zadatak
println("1. zadatak")   #kako bi ispisani rezultati u terminalu bili organizirani 
x=y=1
println(x)
println(y)
##

## 2. zadatak
# 15=a  ->  dobije se syntax error
##

## 3. zadatak

# xy je nedefinirana varijabla, tako da ako pokušamo nešto raditi s xy prije nego što 
# inicijaliziramo varijablu xy dobivamo UndefVarError
println("\n3. zadatak")  
println(x*y)    # dobijemo umnožak varijabli x i y 
a=b="String"
println(a*b)    # da su x i y stringovi dobili bi novi string sastavljen od x i y 

##

## 4. zadatak
function volumen(a, oznaka)
    if (oznaka=="kocka")
        println("Volumen zadane kocke je ", a*a*a)
    
    elseif (oznaka == "sfera")
        println("Volumen zadane sfere je ", (4/3)*a*a*a*pi)
    else
        println("Nije moguće izračunati volumen.")
    end
end

#volumen(3, "kocka")
#volumen(3, "sfera")
#volumen(3, "piramida")

##

## 5. zadatak
println("\n5. zadatak")  

function apsolutna(a)
    return abs(a)
end

println(apsolutna(5))
println(apsolutna(-5))

##

## 6. zadatak
function udaljenostTocaka(x1, y1, x2, y2)
    d = sqrt((x1+x2)^2 + (y1+y2)^2)
    return d
end

#println(udaljenostTocaka(1,2,1,3))
##

## 7. zadatak
println("\n7. zadatak")  
for i in 1:30
    if (!(i%3==0))
        print(i, " ")
    end
end
println()
##

## 8. zadatak
println("\n8. zadatak")  
function kolikoA(str)
    brojac=0
    for i in str
        if (i=='a')
            brojac+=1
        end
    end
    return brojac
end

println("U zadanoj recenici ima ", kolikoA("Volim studirati u Zagrebu."), " slova \"a\"")
##