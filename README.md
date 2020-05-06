# Frekvence společného výskytu klíčových slov v bibliografgických záznamech

    Usage: bigram [-t <threshold>] [-d] [-i <ignore>] [-h] [<input>]
    
    Tiskne bigram klíčových slov s jejich frekvencí
    
    Arguments:
       input                 Vstupní RIS soubor (použije se standardní vstup při jeho absenci)
    
    Options:
                -t <threshold>,
       --threshold <threshold>
                             Práh pro výpis frekvence
       -d, --dot             Vypsat graf pro GraphViz
             -i <ignore>,    Ignorované klíčové slovo
       --ignore <ignore>
       -h, --help            Show this help message and exit.
    
## Generování grafu

Je dobré ignorovat ústření klíčové slovo, aby ten graf nějak vypadal. Navíc
souvislost s ním mají všechny záznamy, tak nám toho zase tolik neříká.

    texlua bigram.lua -t 15 -i "klima školy" -d zaznamyCZ_NPMK.ris > npmk-cz.dot 

Je třeba určit hodnotu thresholdu podle zdrojových dat

Graf vytvoříme:

    dot -T pdf npmk-cz.dot -o npmp-cz.pdf
