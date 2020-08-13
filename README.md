- [TreeProof with Ocaml](#orge1c3318)
  - [Utilisation](#orgbcc761f)
  - [Compilation](#org3b30a7f)
  - [Execution en instantané](#orge1526a0)


<a id="orge1c3318"></a>

# TreeProof with Ocaml

La [méthode des arbres](https://fr.wikipedia.org/wiki/M%C3%A9thode_des_tableaux) permet de démontrer si une proposition logique est, ou non, un théoreme de la logique, c'est à dire si elle est toujours vrai. Ce programme codé un Ocaml recupère une proposition logique et l'analyse afin de générer trois choses, un booleen, indiquant si oui ou non la proposition est un théorme, la démonstration, et l'analyse de la proposition, les deux derniers sous la forme de fichiers graphiques générables avec graphiz


<a id="orgbcc761f"></a>

## Utilisation

executer le programme puis entrez une proposition logique respectant la synthaxe suivante

```
et          : & 
ou          : v 
implacation : > 
equivalence : = 
negation    : ! or ~
```

(le systeme peut prendre en charge des mots, mais faites attention aux parentheses, elles sont aussi reserver à l'analyse)


<a id="org3b30a7f"></a>

## Compilation

```
ocamlc tree.ml -o tree
```


<a id="orge1526a0"></a>

## Execution en instantané

```
rm value;rm tree.png;rm gtree.png;echo $your_formule | tree > value 2> errors;dot -Tpng tree.dot > tree.png;dot -Tpng gtree.dot > gtree.png
```

Demo : <https://marin.elie.org/tree/>