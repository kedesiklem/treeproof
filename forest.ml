(*#load "str.cma";;*)
open Printf;;

(* | CONSTANTES | *)
let option:string array= [|"-t";"-g";"-h";"-e"|];;
let str_shape:string ref=ref "box";;

let sfrom:string array= [|" ";"<=>";"->";"=>";"\.";"+" ;"|" ;"-" ;"!"|] ;;
let sto:string array=   [|"" ;"="  ;">" ;">" ;"&" ;"v" ;"v" ;"~" ;"~"|];;

let ffrom:string array= [|"&"      ;"v"       ;"~"     ;">"      ;"="      ;"³"  ;"²"      ;"#10754;" |];;
let fto:string array=   [|"&#8743;";" &#8744;";"&#172;";"&#8835;";"&#8801;";"->" ;"[label=";"&#10754;"|]

let help_doc:string=
  "Syntaxe: forest [options]\n\nforest take a formula and return a boolean.\n\n-t: produces formula.dot\n-g: produces proof.dot\n-h: prompt help\n-e: disable boxes around nodes\n\nnegation:\t ~ - !\nconjonction:\t & .\ndisjonction:\t + v |\nconditionnal:\t -> => >\nequivalence:\t <=> =\n";;

(*REPLACE STRING START*)
let s_replace(sfrom,sto,src:string*string*string):string= (Str.global_replace (Str.regexp sto) sfrom src);;

let str_replace(sfrom,sto,src:string array*string array*string):string=
  let (a,b):int*int=Array.length sfrom,Array.length sto in
  if a<>b
  then failwith "Error: unmatched list (check it)"
  else
    let nsrc:string ref=ref src in
    for i=0 to a-1
    do nsrc:= (s_replace(sto.(i),sfrom.(i),!nsrc))
    done;
    !nsrc
;;

let finalstr(a:string):string=
  str_replace(ffrom,fto,a)
;;

let normalize(src:string):string=
  (str_replace(sfrom,sto,src))
;;

(*REPLACE STRING END*)

(*--- TYPE START ---*)

type operator = AND|OR|IMP|EQU|NOT;;

type t_tree = LEAF of string
            |BRANCH of operator*t_tree
            |BRANCHS of operator*t_tree*t_tree
;;

type t_gtree = S of string
             | C of string*t_gtree
             | G of string*t_gtree*t_gtree
             | X
;;

(*--- TYPE END ---*)

(*===--- START FOREST ---===*)


let save_str file string =
     let channel = open_out file in
     output_string channel string;
     close_out channel
;;

let rec find_op(a:string):int*int=
  let prof:int ref=ref 0 and operator:int ref=ref (-1) and prof_op:int ref=ref (-1) in
  for i=0 to (String.length a -1) 
  do match a.[i] with
       '&'|'v'|'>'|'=' -> if !prof_op= -1 || !prof_op >= !prof then (operator:= i;prof_op:=!prof);
       |'~' -> if !prof_op= -1 || !prof_op > !prof then (operator:= i;prof_op:=!prof);
       | '(' -> prof:= !prof +1
       | ')' -> prof:= !prof -1
       |  n  -> print_string("")
  done;
  !operator,!prof_op
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

let rec add_EQU(t,n,m:t_gtree*string*string):t_gtree=
  let (a,b):string*string=nettoy(n),nettoy(m) in
  match t with
    G(x,y,z) -> G(x,(add_EQU(y,a,b)),(add_EQU(z,a,b)))
  | C(x,y) -> C(x,add_EQU(y,a,b))
  | S(x) -> G(x,C(a,S(b)),C("~("^a^")",S("~("^b^")")))
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
  | S(x) -> C(x,S("#10754;"))
  | X -> X
;;

(*--- ADD END ---*)


let char_of_op(a:operator):string=
  match a with
    AND -> "&"
   |OR  -> "v"
   |IMP -> ">"
   |EQU -> "="
   |NOT -> "~"
;;

let op_of_char(a:string):operator=
  match a with
    "&"-> AND
   |"v"-> OR
   |">"-> IMP
   |"="-> EQU
   |"~"-> NOT
   |n -> failwith"Undefined"
;;

let rec split(b:string):string*string*string=
  let a:string=nettoy(b) in
  let (pos,prof):int*int=find_op(a) in
  if prof>0
  then split((String.sub a 1 (String.length a -2)))
  else
    if pos= -1
    then (a,"","")
    else ((String.make 1 a.[pos]),(String.sub a 0 pos),(String.sub a (pos+1) (String.length a -(pos+1))))
;;

let rec analyse(a:string):t_tree=
  let (pos,debut,fin):string*string*string=split(a) in
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
      LEAF(a) -> string_of_int(k)^" ²\""^a^"\"];\n",k
     |BRANCH(a,b) -> let (link,nom_b):string*int=sub_print(b,compteur()) in
                     (string_of_int(k)^" ²\""^char_of_op(a)^"\"];\n"
                      ^string_of_int(k)^"³"^string_of_int(nom_b)
                      ^";\n"^link)
                     ,k
     |BRANCHS(a,b,c) -> let (link_b,nom_b):string*int=sub_print(b,compteur()) in
                        let (link_c,nom_c):string*int=sub_print(c,compteur()) in
                        (string_of_int(k)^" ²\""^char_of_op(a)^"\"];\n"
                         ^string_of_int(k)^"³{"^string_of_int(nom_b)^";"^string_of_int(nom_c)
                         ^"};\n"^link_b^link_c)
                        ,k
  in
  
  let (riri,_):string*int=sub_print(a,compteur()) in
  let fifi:string=finalstr(riri) in
  "digraph t_tree{\nnode [shape="^ !str_shape^"]\n"^fifi^"}"
;;

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
      S(a) -> string_of_int(k)^" ²\""^(a)^"\"];\n",k
     |C(a,b) -> let (x,y,z):string*t_gtree*t_gtree=ssub_print(b)in
                let (link_y,nom_y):string*int=sub_print(y,compteur())
                and (link_z,nom_z):string*int=sub_print(z,compteur()) in
                (string_of_int(k)^" ²\""^a^"\n"^x^"\"];\n"^
                   (
                     if nom_y <> -1
                     then 
                       (string_of_int(k)^" ³ {"^string_of_int(nom_y)^";"
                        ^string_of_int(nom_z)^"};\n"^link_y^link_z)
                     else ""
                   )
                ,k)
     |G(a,b,c) -> let (link_b,nom_b):string*int=sub_print(b,compteur()) in
                  let (link_c,nom_c):string*int=sub_print(c,compteur()) in
                  (string_of_int(k)^" ²\""^a^"\"];\n"
                   ^string_of_int(k)^"³{"^string_of_int(nom_b)^";"^string_of_int(nom_c)
                   ^"};\n"^link_b^link_c)
                  ,k
     |X -> "",-1
  in
  let (riri,_):string*int=sub_print(a,compteur()) in
  let fifi:string=finalstr(riri) in
  "digraph t_tree{\nnode [shape="^ !str_shape^"]\n"^fifi^"}"
;;

let psl (a:string array):string=
  let b:string ref=ref "" in 
  for i=0 to Array.length a -1
  do b:= !b ^ a.(i) ^ " "
  done;
  !b
;;


let proof(t:string):t_gtree*bool=
  let ancetre:string array ref=ref [||] and ending:string ref=ref "" and answer:bool ref=ref true in
  let rec sub(gt,etage:t_gtree ref*int):t_gtree=
    let wstop:bool ref=ref false in
    let (op,debut,fin):string*string*string=
      match !gt with
        G(a,_,_) | C(a,_) | S(a) -> (if etage >= Array.length !ancetre 
                                     then ancetre := Array.append !ancetre [|a|]
                                     else (!ancetre).(etage) <- a);
                                    (*print_string("\n"^psl(!ancetre)^"\n");*)
                                    (*print_string(a^" : "^psl(!ancetre)^"\n");*)
                                    (if (List.exists (fun x -> x=("~"^a)||("~"^x=a)||x=("~("^a^")")||(("~("^x^")")=a)) (Array.to_list (Array.sub !ancetre 0 (etage+1))))
                                     then (wstop:= true;
                                          ending:= a));
                                      split(a)
        |X -> split("")
    in
    if !wstop
    then C(!ending,S("#10754;"))
    else (
      (match op with
         "&" -> gt:= add_AND(!gt,debut,fin)
       | "v" -> gt:= add_OR(!gt,debut,fin)
       | ">" -> gt:= add_OR(!gt,"~("^nettoy(debut)^")",fin)
       | "=" -> gt:= add_EQU(!gt,debut,fin)
       | "~" ->
          let (nop,ndebut,nfin):string*string*string=split(fin) in
          (match nop with
             "&" -> gt:=add_OR(!gt,"~"^ndebut,"~"^nfin)
           | "v" -> gt:=add_AND(!gt,"~"^ndebut,"~"^nfin)
           | ">" -> gt:=add_AND(!gt,ndebut,"~"^nfin)
           | "=" -> gt:=add_EQU(!gt,"~("^nettoy(ndebut)^")",nfin)
           | "~" -> gt:=add_NOT(!gt,nfin)
           |  _   -> print_string(""));
       | _ -> print_string(""));
      (match !gt with
         G(a,b,c) -> gt:=G(a,sub(ref b,etage+1),sub(ref c,etage+1)) 
        |C(a,b) -> gt:=C(a,sub(ref b,etage +1))
        |S(a) -> answer:=false ; gt:=S(a)
        |X -> gt:=X;);
           !gt)
  in
  let x:t_gtree= sub(ref (S("~("^t^")")),0) in
  x,!answer
;;

let main():unit=

  let isopt:bool array=Array.make (Array.length option) false in
  for i=0 to Array.length option -1
  do isopt.(i) <- (Array.exists (fun x->(x=option.(i))) Sys.argv)
  done;

  if isopt.(3) (*-e*)
  then (str_shape:="none";);   
  if isopt.(2) (*-h*)
  then (print_string(help_doc))
  else (
    
    print_string("formula: ");
    
    let input:string=normalize(read_line()) in
    let (tree,answer):t_gtree*bool= proof(input) in
    
    if isopt.(0) (*-t*)
    then(save_str "formula.dot" (print_t_tree(analyse(input))););
    
    if isopt.(1) (*-g*)
    then (save_str "proof.dot" (print_gtree(tree));); 
    
    print_string(string_of_bool(answer)^"\n"))
;;

main()
