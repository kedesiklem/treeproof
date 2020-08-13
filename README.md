- [TreeProof with Ocaml](#org08693c7)
  - [Utilisation](#orgedb0bfe)
  - [Compilation](#org2e11cc1)
  - [Exemple](#orgb5846df)
  - [Demonstration](#orgffbf2f4)


<a id="org08693c7"></a>

# TreeProof with Ocaml

La [méthode des arbres](https://fr.wikipedia.org/wiki/M%C3%A9thode_des_tableaux) permet de démontrer si une proposition logique est, ou non, un théorème de la logique, c'est à dire si elle est toujours vraie. Ce programme codé en Ocaml prend une proposition logique et l'analyse afin de générer trois choses :

1.  un booleen, indiquant si oui ou non la proposition est un théorème
2.  la démonstration (forma graphiz pour dot)
3.  l'analyse de la proposition (forma graphiz pour dot)


<a id="orgedb0bfe"></a>

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


<a id="org2e11cc1"></a>

## Compilation

```
ocamlc tree.ml -o tree
```


<a id="orgb5846df"></a>

## Exemple

![img](./gtree.png)


<a id="orgffbf2f4"></a>

## Demonstration

<https://marin.elie.org/tree/>