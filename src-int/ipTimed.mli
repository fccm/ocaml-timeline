(* Copyright (C) 2014 Florent Monnier
 
 This software is provided "AS-IS", without any express or implied warranty.
 In no event will the authors be held liable for any damages arising from
 the use of this software.
 
 Permission is granted to anyone to use this software for any purpose,
 including commercial applications, and to alter it and redistribute it freely.
*)
(** Timeline *)

(** {3 Timeline types} *)

type time = int

(** The type ['a] is the output.
    
    The type ['b] is a parameter for the function [f] that
    make the evolution over the input time.
*)
type ('a, 'b) animated = [
  | `From of time * 'a
    (** [From (t, v)] after time [t] is reach (and before next timeline chunk)
        the returned value will be [v] *)
  | `Evol of time * time * (time -> time -> time -> 'b -> 'a) * 'b
    (** [Evol (t1, t2, f, d)] when [t] is between [t1] and [t2] the value is the result of
        [f t1 t2 t d] *)
  ]

type ('a, 'b) timed = [
  | `Static of 'a
    (** with [Static v] the returned value will always be [v] *)
  | `Animated of ('a, 'b) animated list
    (** [Animated anim_chunks] the animation chunks have to be correctly sorted *)
  ]

(** {3 Timeline functions} *)

val val_at :
  time -> ('a, 'b) animated list -> 'a

val get_val :
  time -> ('a, 'b) timed -> 'a

val finished :
  time -> ('a, 'b) animated list -> bool


(** {3 Labeled functions} *)

module Labels : sig

  (** {3 Timeline functions with labels} *)

  val val_at :
    t:time -> anim:('a, 'b) animated list -> 'a

  val get_val :
    t:time -> tv:('a, 'b) timed -> 'a

end
