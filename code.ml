type regexp =
  | V  
  | E
  | C of char
  | U of regexp * regexp 
  | P of regexp * regexp 
  | S of regexp    
 (* simple pretty printing function *)
 let rec string_of_regexp s =
   match s with
   | V       -> "0"
   | E       -> "1"
   | C  c    -> String.make 1 c    
   | U (f,g) -> "("^(string_of_regexp f)^" + "^(string_of_regexp g)^")"
   | P (f,g) -> "("^(string_of_regexp f)^" . "^(string_of_regexp g)^")"
   | S s     -> (string_of_regexp s)^"*"

  let rec simplify (a:regexp) = 
    match a with 
    | U (r,s) ->
      let sr = simplify r in
      let ss = simplify s in
      if sr = V then ss
      else if ss = V then sr
      else if ss = sr then sr
      else U (sr,ss) 
    | P (r,s) ->
      let sr = simplify r in
      let ss = simplify s in
      if sr = V then V
      else if ss = V then V
      else if sr = E then ss
        else if ss = E then sr
      else P (sr,ss) 
    | S r -> let sr = simplify r in
      if sr = V || sr = E 
      then E else (
        match sr with
          U (E,rr) | U (rr,E) -> S rr       
          | _ -> S sr
        )
    |  _ -> a

(* --------------------------------------------Read Functions -----------------------------------------*)
let rec leitura_transicoes n lista =
  if n = 0 then
  lista
  else
  let a = Scanf.scanf "%d " (fun x -> x) in
  let b = Scanf.scanf "%c " (fun x -> x) in
  let c = Scanf.scanf "%d\n" (fun x -> x) in
  leitura_transicoes (n-1) ((a,b,c)::lista)

let ler_input() =
  let nr_elementos_S = Scanf.scanf "%d\n" (fun x -> x) in
  let estado_inicial = Scanf.scanf "%d\n" (fun x -> x) in 
  let nr_estados_finais = Scanf.scanf "%d\n" (fun x -> x) in  
  let estados_finais = read_line() in 
  let divisao = String.split_on_char ' ' estados_finais in 
  let final_states = (Array.make nr_estados_finais) 0 in 
  for i = 0 to ((Array.length final_states)- 1) do
    final_states.(i) <- (int_of_string(List.nth divisao i))
  done;
  let nr_transicoes = Scanf.scanf "%d\n" (fun x->x) in
  let transicoes = ref [] in
  transicoes := (leitura_transicoes nr_transicoes []); 
  (!transicoes,estado_inicial,final_states, nr_elementos_S, nr_transicoes, nr_estados_finais) 
(* ------------------------- Algoritmo de MacNaughton - Yamada --------------------------*)
let rec algoritmo lst matriz = 
   match lst with 
  | [] -> matriz 
  | (h1,h2,h3)::tl ->   if h1 != h3 then 
                          if matriz.(h1).(h3).(1) == V then 
                             matriz.(h1).(h3).(1) <- (C h2 ) 
                          else
                             matriz.(h1).(h3).(1) <- (U(C h2, matriz.(h1).(h3).(1))) 
                        else 
                        if matriz.(h1).(h3).(1) != V then 
                          match matriz.(h1).(h3).(1) with  
                          | U (h, m) -> matriz.(h1).(h3).(1) <- U (E, U (m, C h2)) 
                          | _ -> matriz.(h1).(h3).(1) <- (U(C h2, matriz.(h1).(h3).(1))) 
                        else
                        matriz.(h1).(h3).(1) <- U (E,C h2);
                      algoritmo tl matriz

let regras matriz nr_estados = 
  for k=2 to nr_estados+1 do
    for i=1 to nr_estados do
      for j=1 to nr_estados do
        matriz.(i).(j).(k) <- simplify (U(matriz.(i).(j).(k-1),P(matriz.(i).(k-1).(k-1),P(S matriz.(k-1).(k-1).(k-1),matriz.(k-1).(j).(k-1))))); 
      done
  done
done;
(matriz)        

(* --------------------------- Inicialização do código ----------------------------------*)
let trans,estado_inicial,final_states,nr_estados, nr_transicoes, nr_estados_finais = ler_input ()
let transicoes = List.rev trans
let maq = Array.init (nr_transicoes+1) (fun _ -> Array.init (nr_transicoes+1) (fun _ -> (Array.init (nr_transicoes+2) (fun _ -> V)))) 
let matrix = algoritmo transicoes maq
let matriz = regras matrix nr_estados 

let rec resultados aux contagem= 
  if(contagem < nr_estados_finais) then 
      (resultados (U (matriz.(estado_inicial).(final_states.(contagem)).(nr_estados+1), aux)) (contagem+1))
     else
  (aux)


let result = resultados V 0

let () = result |> simplify |> string_of_regexp |> print_endline
