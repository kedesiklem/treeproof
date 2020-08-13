- [TreeProof with Ocaml](#orgff37378)
  - [Utilisation :](#org83c5119)
  - [Compilation :](#orgb4acdab)
  - [Execution en instantané](#orgafdd388)


<a id="orgff37378"></a>

# TreeProof with Ocaml

La methode des arbres permet de demontrer si une proposition logique est, ou non, un théoreme de la logique, c'est à dire si elle est toujours vrai. Ce programme codé un Ocaml recupère une proposition logique et l'analyse afin de générer trois chose, un booleen, indiquant si oui ou non la proposition est un théorme, la demonstration, et l'analyse de la proposition, les deux dernier sous la forme de fichiers graphiques generables avec graphiz


<a id="org83c5119"></a>

## Utilisation :

executer le programme puis entrez une proposition logique respectant la synthaxe suivante

```
et          : & 
ou          : v 
implacation : > 
equivalence : = 
negation    : ! or ~
```

(le systeme peux prendre en charge des mots, mais faites attention aux parentheses, elles sont aussi reserver à l'analyse)


<a id="orgb4acdab"></a>

## Compilation :

```
ocamlc tree.ml -o tree
```


<a id="orgafdd388"></a>

## Execution en instantané

```
rm value;rm tree.png;rm gtree.png;echo $your_formule | tree > value 2> errors;dot -Tpng tree.dot > tree.png;dot -Tpng gtree.dot > gtree.png
```

Demo : <https://marin.elie.org/tree/>