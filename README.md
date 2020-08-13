- [TreeProof with Ocaml](#orgef2f30e)


<a id="orgef2f30e"></a>

# TreeProof with Ocaml

La methode des arbres permet de demontrer si une proposition logique est, ou non, un théoreme de la logique, c'est à dire si elle est toujours vrai. Ce programme codé un Ocaml recupère une proposition logique et l'analyse afin de générer trois chose, un booleen, indiquant si oui ou non la proposition est un théorme, la demonstration, et l'analyse de la proposition, les deux dernier sous la forme de fichiers graphiques generables avec graphiz

Utilisation : executer le programme puis entrez une proposition logique respectant la synthaxe suivante

```
et          : & 
ou          : v 
implacation : > 
equivalence : = 
negation    : ! or ~
```

(le systeme peux prendre en charge des mots, mais faites attention aux parentheses, elles sont aussi reserver à l'analyse)

Demo : <https://marin.elie.org/tree/>