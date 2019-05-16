(* Copyright (C) 2014 Florent Monnier
 
 This software is provided "AS-IS", without any express or implied warranty.
 In no event will the authors be held liable for any damages arising from
 the use of this software.
 
 Permission is granted to anyone to use this software for any purpose,
 including commercial applications, and to alter it and redistribute it freely.
*)
(* Timeline *)

(* timeline types *)

type time = int

type ('a, 'b) animated = [
  | `From of time * 'a
  | `Evol of time * time * (time -> time -> time -> 'b -> 'a) * 'b
  ]

type ('a, 'b) timed = [
  | `Static of 'a
  | `Animated of ('a, 'b) animated list
  ]

(* timeline functions *)

let rec val_at t = function
  | `From(t1, v) :: `From(t2,_) :: _
  | `From(t1, v) :: `Evol(t2,_,_,_) :: _
    when t1 <= t && t < t2 -> v
  
  | `From(t, v) :: [] -> v
  
  | `Evol(t1, t2, f, v) :: []
    when t >= t2 -> f t1 t2 t2 v
  
  | `Evol(t1, t2, f, v) :: _
    when t1 <= t && t <= t2 -> f t1 t2 t v
  
  | _ :: tl -> val_at t tl
  
  | [] -> invalid_arg "val_at"


let get_val t = function
  | `Static v -> v
  | `Animated anim -> val_at t anim


let finished t = function
  | `From _ :: [] -> true
  | `Evol(_, t2, _, _) :: [] -> t > t2
  | _ -> false


module Labels = struct

  let val_at ~t ~anim = val_at t anim
  let get_val ~t ~tv = get_val t tv

end
