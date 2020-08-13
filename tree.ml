let save_str file string =
     let channel = open_out file in
     output_string channel string;
     close_out channel
;;

let str_shape:string="none";;

let rec find_op(a:string):int*int=
  let prof:int ref=ref 0 and operator:int ref=ref (-1) and prof_op:int ref=ref (-1) in
  for i=0 to (String.length a -1) 
  do match a.[i] with
       '&'|'v'|'>'|'='|'~'|'!' -> if !prof_op= -1 || !prof_op > !prof then (operator:= i;prof_op:=!prof);
       | '(' -> prof:= !prof +1
       | ')' -> prof:= !prof -1
       |  n  -> print_string("")
  done;
  !operator,!prof_op
;;

type operator = AND|OR|IMP|EQU|NOT;;
type t_tree = LEAF of char
          |BRANCH of operator*t_tree
          |BRANCHS of operator*t_tree*t_tree
;;

let classop(a:operator):string=
  match a with
    AND -> "&"
   |OR  -> "v"
   |IMP -> ">"
   |EQU -> "="
   |NOT -> "~"
;;

let op_of_char(a:char):operator=
  match a with
    '&'-> AND
   |'v'-> OR
   |'>'-> IMP
   |'='-> EQU
   |'~'|'!'-> NOT
   |n -> failwith"Undefined"
;;

let rec split(a:string):char*string*string=
  let (pos,prof):int*int=find_op(a) in
  if prof>0
  then split((String.sub a 1 (String.length a -2)))
  else
    if pos= -1
    then
      if a.[0]='('
      then split((String.sub a 1 (String.length a -2)))
      else (a.[0],"","")
    else (a.[pos],(String.sub a 0 pos),(String.sub a (pos+1) (String.length a -(pos+1))))
;;

let nettoy(a:string):string=
  let thend:bool ref=ref false
  and b:string ref=ref a in
  while not(!thend)
  do let (op,prof):int*int=find_op(!b) in
     if prof>0
     then b:=(String.sub !b 1 (String.length !b -2))
     else thend:= true
  done;
  !b
;;

let rec analyse(a:string):t_tree=
  let (pos,debut,fin):char*string*string=split(a) in
  if debut=""
  then
    if fin=""
    then LEAF(pos)
    else BRANCH(op_of_char(pos),analyse(fin))
  else BRANCHS(op_of_char(pos),analyse(debut),analyse(fin))
;;

let print_t_tree(a:t_tree):string=
  let k:int ref=ref 0 in
  let compteur():int=
    k:= !k+1;
    !k
  in
  let rec sub_print(a,k:t_tree*int):string*int=
    match a with  
      LEAF(a) -> string_of_int(k)^" [label=\""^(String.make 1 a)^"\"];\n",k
     |BRANCH(a,b) -> let (link,nom_b):string*int=sub_print(b,compteur()) in
                     (string_of_int(k)^" [label=\""^classop(a)^"\"];\n"
                      ^string_of_int(k)^"->"^string_of_int(nom_b)
                      ^";\n"^link)
                     ,k
     |BRANCHS(a,b,c) -> let (link_b,nom_b):string*int=sub_print(b,compteur()) in
                        let (link_c,nom_c):string*int=sub_print(c,compteur()) in
                        (string_of_int(k)^" [label=\""^classop(a)^"\"];\n"
                         ^string_of_int(k)^"->{"^string_of_int(nom_b)^";"^string_of_int(nom_c)
                         ^"};\n"^link_b^link_c)
                        ,k
  in
  
  let (truc,_):string*int=sub_print(a,compteur()) in
  "digraph t_tree{\nnode [shape="^str_shape^"]\n"^truc^"}"
;;

let polop(a:operator):string=
  match a with
    AND -> "K"
   |OR -> "A"
   |EQU -> "E"
   |IMP -> "C"
   |NOT -> "N"
;;

let rec polt_tree(t:t_tree):string=
  match t with
    LEAF(a) -> String.make 1 a
  | BRANCH(a,b) -> polop(a)^polt_tree(b)
  | BRANCHS(a,b,c) -> polop(a)^polt_tree(b)^polt_tree(c)
;;
let classt_tree(t:t_tree):string=
  let rec sub_classt_tree(t:t_tree):string=
    match t with
      LEAF(a) -> String.make 1 a
    | BRANCH(a,b) -> classop(a)^sub_classt_tree(b)
    | BRANCHS(a,b,c) -> "("^sub_classt_tree(b)^classop(a)^sub_classt_tree(c)^")"
  in
  let p:string=sub_classt_tree(t) in
  if p.[0]='('
  then String.sub p 1 (String.length p -2)
  else p
;;

type t_gtree = S of string
             | C of string*t_gtree
             | G of string*t_gtree*t_gtree
             | X
;;

(*--- ADD START ---*)

let rec add_AND(t,n,m:t_gtree*string*string):t_gtree=
  let (a,b):string*string=nettoy(n),nettoy(m) in
  match t with
    G(x,y,z) -> G(x,(add_AND(y,a,b)),(add_AND(z,a,b)))
  | C(x,y) -> C(x,add_AND(y,a,b))
  | S(x) -> C(x,C(a,S(b)))
  | X -> X
;;

let rec add_OR(t,n,m:t_gtree*string*string):t_gtree=
  let (a,b):string*string=nettoy(n),nettoy(m) in
  match t with
    G(x,y,z) -> G(x,(add_OR(y,a,b)),(add_OR(z,a,b)))
  | C(x,y) -> C(x,add_OR(y,a,b))
  | S(x) -> G(x,S(a),S(b))
  | X -> X
;;

let rec add_NOT(t,n:t_gtree*string):t_gtree=
  let a:string=nettoy(n)in
  match t with
    G(x,y,z) -> G(x,(add_NOT(y,a)),(add_NOT(z,a)))
  | C(x,y) -> C(x,add_NOT(y,a))
  | S(x) -> C(x,S(a))
  | X -> X
;;

let rec add_CLOSE(t:t_gtree):t_gtree=
  match t with
    G(x,y,z) -> G(x,(add_CLOSE(y)),(add_CLOSE(z)))
  | C(x,y) -> C(x,add_CLOSE(y))
  | S(x) -> C(x,S("&#10754;"))
  | X -> X
;;

(*TODO : checker les noeuds avec d'ajouter un element identique*)
(*--- ADD END ---*)

let print_gtree(a:t_gtree):string=
  let k:int ref=ref 0 in
  let compteur():int=
    k:= !k+1;
    !k
  in
  let rec ssub_print(a:t_gtree):string*t_gtree*t_gtree=
    match a with
      G(x,y,z) -> x,y,z
    | C(x,y) -> let (m,n,o):string*t_gtree*t_gtree=ssub_print(y) in (x^"\n"^m),n,o
    | S(x) -> x,X,X
    | X -> "",X,X
  in
  let rec sub_print(a,k:t_gtree*int):string*int=
    match a with  
      S(a) -> string_of_int(k)^" [label=\""^(a)^"\"];\n",k
     |C(a,b) -> let (x,y,z):string*t_gtree*t_gtree=ssub_print(b)in
                let (link_y,nom_y):string*int=sub_print(y,compteur())
                and (link_z,nom_z):string*int=sub_print(z,compteur()) in
                (string_of_int(k)^" [label=\""^a^"\n"^x^"\"];\n"^
                   (
                     if nom_y <> -1
                     then 
                       (string_of_int(k)^" -> {"^string_of_int(nom_y)^";"
                        ^string_of_int(nom_z)^"};\n"^link_y^link_z)
                     else ""
                   )
                ,k)
     |G(a,b,c) -> let (link_b,nom_b):string*int=sub_print(b,compteur()) in
                  let (link_c,nom_c):string*int=sub_print(c,compteur()) in
                  (string_of_int(k)^" [label=\""^a^"\"];\n"
                   ^string_of_int(k)^"->{"^string_of_int(nom_b)^";"^string_of_int(nom_c)
                   ^"};\n"^link_b^link_c)
                  ,k
     |X -> "",-1
  in
  let (truc,_):string*int=sub_print(a,compteur()) in
  "digraph t_tree{\nnode [shape="^str_shape^"]\n"^truc^"}"
;;

let proof(t:string):t_gtree=
  let rec sub(gt:t_gtree ref):t_gtree=
    let (op,debut,fin):char*string*string=
      match !gt with
        G(a,b,c) -> split(a)
       |C(a,b) -> split(a)
       |S(a) -> split(a)
       |X -> split("")
    in
    (match op with
       '&' -> gt:= add_AND(!gt,debut,fin)
     | 'v' -> gt:= add_OR(!gt,debut,fin)
     | '>' -> gt:= add_OR(!gt,"~"^debut,fin)
     | '=' -> gt:= add_AND(!gt,debut^">"^fin,fin^">"^debut)
     | '!' | '~' ->
        let (nop,ndebut,nfin):char*string*string=split(fin) in
        (match nop with
          '&' -> gt:=add_OR(!gt,"~"^ndebut,"~"^nfin)
         | 'v' -> gt:=add_AND(!gt,"~"^ndebut,"~"^nfin)
         | '>' -> gt:=add_AND(!gt,ndebut,"~"^nfin)
         | '=' -> gt:=add_OR(!gt,"~("^ndebut^">"^nfin^")","~("^nfin^">"^ndebut^")")
         | '!' | '~' -> gt:=add_NOT(!gt,nfin)
         |  _   -> print_string(""));
     | _ -> print_string(""));
    gt:=
      (match !gt with
         G(a,b,c) -> G(a,sub(ref b),sub(ref c))
        |C(a,b) -> C(a,sub(ref b))
        |S(a) -> S(a)
        |X -> X;);
    !gt
  in
  let gt:t_gtree ref=ref (S("~("^t^")")) in
  gt:=sub(gt);
  !gt
;;

let rec scheck(l:string list):bool=
(*  let la:string array=Array.of_list l in
  let s:string ref=ref la.(0) in
  for i=1 to Array.length la -1
  do s:= !s^";"^la.(i)
  done;
  print_string("["^(!s)^"]\n");*)
  match l with
    []|_::[] -> false
    |hd::tl -> (List.exists (fun x -> x=("~"^hd)||("~"^x=hd)) tl)||scheck(tl)
;;

let rec subcheck(t,l:t_gtree*string list):t_gtree*bool=
  match t with
    G(a,b,c) -> let ((td,debut),(tf,fin)):(t_gtree*bool)*(t_gtree*bool)=
                  subcheck(b,[a]@l),subcheck(c,[a]@l)
                in
                (G(a,td,tf),(debut&&fin))
   |C(a,b) -> let (tt,tb):t_gtree*bool=subcheck(b,[a]@l) in
              (C(a,tt),tb)
   |S(a) -> if scheck(a::l) then (add_CLOSE(t),true) else t,false
   |X -> print_string("wtf");(t,false)
;;

let check(t:t_gtree):t_gtree*bool=
  subcheck(t,[])  
;;

let th_transitivite_implication:string="((a>b)&(b>c))>(a>c)"
and th_conversion:string="((a&b)>c)=(((~c)&a)>(~b))"
and th_identite:string="a=a"
and th_contrapose:string="(a>b)=((~b)>(~a))"
;;

let main():unit=
  let input:string=read_line() in
  let gt:t_gtree ref=ref (proof(input)) in
  let (ngt,bgt):t_gtree*bool= check(!gt) in
  gt:=ngt;
  save_str "tree.dot" (print_t_tree(analyse(input)));
  save_str "gtree.dot" (print_gtree(!gt));
  print_string(string_of_bool(bgt))
;;

main();;
