- [TreeProof with Ocaml](#org27ef58e)
  - [Option](#orgd548ac4)
  - [Help](#orga167a33)
  - [Compilation](#org6ebfcad)
  - [Exemple](#org7fe5412)
  - [Démonstration](#org376e2a0)


<a id="org27ef58e"></a>

# TreeProof with Ocaml

> In proof theory, [the semantic tableaux](https://en.wikipedia.org/wiki/Method_of_analytic_tableaux) (truth tree, *methode des arbres* in french) is a decision procedure. An analytic tableau is a tree structure computed for a logical formula, having at each node a subformula of the original formula to be proved or refuted. Computation constructs this tree and uses it to prove or refute the whole formula.

Forest is a prover, wrote in Ocaml.

It produces the graphviz dot file of the proof and the tree of formula (also in dot).


<a id="orgd548ac4"></a>

## Option

| Command | Description                                         | File's name |
|------- |--------------------------------------------------- |----------- |
| -t      | allow the generation of the tree formula dot's file | formula.dot |
| -g      | allow the generation of the proof dot's file        | proof.dot   |
| -h      | show a description of the different options         |             |


<a id="orga167a33"></a>

## Help

```
négation    : ! ~ -
conjonction : & .
disjonction : v | +
conditionel : > -> =>
équivalence : = <=> 
```

(the programme can take in charge world, but be carful of the parentheses)


<a id="org6ebfcad"></a>

## Compilation

```
ocamlc str.cma forest.ml -o forest
```


<a id="org7fe5412"></a>

## Exemple

![img](./gtree.png)


<a id="org376e2a0"></a>

## Démonstration

<https://marin.elie.org/tree/>