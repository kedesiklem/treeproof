- [TreeProof with Ocaml](#org803271e)
  - [Utilisation](#org1de8f1b)
  - [Compilation](#org8e6f4c7)
  - [Exemple](#org938225e)
  - [Démonstration](#org91d1133)


<a id="org803271e"></a>

# TreeProof with Ocaml

La [méthode des arbres](https://fr.wikipedia.org/wiki/M%C3%A9thode_des_tableaux) permet de démontrer si une proposition logique est, ou non, un théorème de la logique, c'est à dire si elle est toujours vraie. Ce programme codé en Ocaml prend une proposition logique et l'analyse afin de générer trois choses :

1.  un booleen, indiquant si oui ou non la proposition est un théorème
2.  la démonstration (forma graphiz pour dot)
3.  l'analyse de la proposition (forma graphiz pour dot)


<a id="org1de8f1b"></a>

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


<a id="org8e6f4c7"></a>

## Compilation

```
ocamlc tree.ml -o tree
```


<a id="org938225e"></a>

## Exemple

![img](./gtree.png)


<a id="org91d1133"></a>

## Démonstration

<https://marin.elie.org/tree/>