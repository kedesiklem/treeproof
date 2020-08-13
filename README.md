- [TreeProof with Ocaml](#org99ce217)
  - [Utilisation](#orgf290e6d)
  - [Compilation](#org0a3d34a)
  - [Exemple](#org378fb0f)
  - [Démonstration](#org4bb4348)


<a id="org99ce217"></a>

# TreeProof with Ocaml

La [méthode des arbres](https://fr.wikipedia.org/wiki/M%C3%A9thode_des_tableaux) permet de démontrer si une proposition logique est, ou non, un théorème de la logique, c'est à dire si elle est toujours vraie. Ce programme codé en Ocaml prend une proposition logique et l'analyse afin de générer trois choses :

1.  un booleen, indiquant si oui ou non la proposition est un théorème
2.  la démonstration (forma graphviz pour dot)
3.  l'analyse de la proposition (forma graphviz pour dot)


<a id="orgf290e6d"></a>

## Utilisation

Éxécuter le programme puis entrez une proposition logique respectant la synthaxe suivante

```
négation    : ! or ~
conjonction : & 
disjonction : v 
conditionel : > 
équivalence : = 
```

(le système peut prendre en charge des mots, mais faites attention aux parenthèses, elles sont aussi réservé à l'analyse)


<a id="org0a3d34a"></a>

## Compilation

```
ocamlc tree.ml -o tree
```


<a id="org378fb0f"></a>

## Exemple

![img](./gtree.png)


<a id="org4bb4348"></a>

## Démonstration

<https://marin.elie.org/tree/>