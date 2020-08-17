- [TreeProof with Ocaml](#org0fc0061)
  - [Option](#orgdd045de)
  - [Help](#org1492263)
  - [Compilation](#org0291f8e)
  - [Exemple](#org1c4b727)
  - [Démonstration](#org3ec6b61)


<a id="org0fc0061"></a>

# TreeProof with Ocaml

> In proof theory, [the semantic tableaux](https://en.wikipedia.org/wiki/Method_of_analytic_tableaux) (truth tree, *methode des arbres* in french) is a decision procedure. An analytic tableau is a tree structure computed for a logical formula, having at each node a subformula of the original formula to be proved or refuted. Computation constructs this tree and uses it to prove or refute the whole formula.

Forest is a prover, wrote in Ocaml.

It produces the graphviz dot file of the proof and the tree of formula (also in dot).


<a id="orgdd045de"></a>

## Option

| Command | Description                                         | File's name |
|------- |--------------------------------------------------- |----------- |
| -t      | allow the generation of the tree formula dot's file | formula.dot |
| -g      | allow the generation of the proof dot's file        | proof.dot   |
| -h      | show a description of the different options         |             |
| -e      | disable boxes around the nodes                      |             |


<a id="org1492263"></a>

## Help

```
négation    : ! ~ -
conjonction : & . 
disjonction : v | +
conditionel : > -> =>
équivalence : = <=> 
```

(the programme can take in charge variable<sup><a id="fnr.1" class="footref" href="#fn.1">1</a></sup> longer than one character, but be careful of the parentheses)


<a id="org0291f8e"></a>

## Compilation

```
ocamlc str.cma forest.ml -o forest
```


<a id="org1c4b727"></a>

## Exemple

![img](./proof.png)


<a id="org3ec6b61"></a>

## Démonstration

<https://marin.elie.org/tree/>

## Footnotes

<sup><a id="fn.1" class="footnum" href="#fnr.1">1</a></sup> v is an operator&#x2026; have fun