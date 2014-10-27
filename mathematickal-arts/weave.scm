;-------------------------------------------------------
; a plain weave "kernel" looks like this, with different
; colour threads in the warp and weft:
;
;   R   G
;   ||  ||
;B =||======
;   ||  ||
;Y =====||==
;   ||  ||
;
; resulting topmost colours would look like this:
;
;    R   B
;
;    Y   G

;---------------------------------------------------------
; this function prints plain weave given warp and weft
; lists where characters represent colours.
; eg: (weave '(O O O O O O O) '(: : : : : : : : :))
; =>
; O : O : O : O
; : O : O : O :
; O : O : O : O
; : O : O : O :
; O : O : O : O
; : O : O : O :
; O : O : O : O
; : O : O : O :
; O : O : O : O
;
; or: (weave '(O O : : O O : : O O) '(O : : O O : : O O :))
; =>
; : O : : : O : : : O
; O : : : O : : : O :
; O O O : O O O : O O
; O O : O O O : O O O
; : O : : : O : : : O
; O : : : O : : : O :
; O O O : O O O : O O
; O O : O O O : O O O
; : O : : : O : : : O

; return warp or weft, dependant on the position
(define (stitch x y warp weft)
  (if (eq? (modulo x 2)
           (modulo y 2))
      warp weft))

; prints out a weaving
(define (weave warp weft)
  (for ((x (in-range 0 (length weft))))
       (for ((y (in-range 0 (length warp))))
            (display (stitch x y
                             (list-ref warp y)
                             (list-ref weft x))))
       (newline)))

;------------------------------------------------------------
; what happens if we generate the warp and weft colours
; via formal grammar replacement?
;
; * works on lists not strings
; * given axiom and rules where a rule a=>ab is '(a (a b))
;
; eg: (replace '(x) '((x (h e l l o)))) => '(h e l l o)

(define (replace pattern rules)
  (foldl
   (lambda (item r)
     (append
      r
      (foldl
       (lambda (rule r)
         (if (eq? item (car rule))
             (cadr rule)
             r))
       (list item)
       rules)))
   '()
   pattern))

;--------------------------------------------------------
; repeat replace multiple times:
; eg: (recurse '(a) '((a (a b)) (b (a a))) 3)
; =>
; (a b a a a b a b)

(define (recurse pattern rules n)
  (cond
    ((zero? n) pattern)
    (else
     (recurse
      (replace pattern rules) rules (- n 1)))))

;--------------------------------------------------------
; plug formal grammars into weave:

(let ((p (recurse '(O)
                  '(

;                    (O (O : O :))
;                    (: (: O :))

                    (O (: O O :))

; 1                   (O (O : O))
;                    (: (: O))
                    )
                  3))
      (q (recurse '(O)
                  '(
;                    (O (O : O))
                    (: (: O : O : O))

;                    (O (O O : : O :))
                    )
                  3)))

  (display "warp:")(display p)(newline)
  (display "weft:")(display q)(newline)
  (weave p p))

; :::O:O:O::O:O:O::O:O:O

;;    4         3        3        3           3
; O:O:O:OO:O:O:O:OO:O:O:O:OO:O:O:O:OO:OO:O:O:O:OO:O

;: : : : O O : : O O : : : : O O : : O O : : : : : : O O : : O
; O : : : : O O : : O O : : : :


; O : O : : O : O : O : : O : : O : O : O : : O : O : O : : O :
; O : O : : O : : O : O : O : : O :

; some notes:

; one rule cross
; ((O (: O : O)))

;'((O (O : O))
; (: (: O : O : O)))

; complex
; '((O (: O :))
; (: (O O O)))

; wavy
; '((O (: O O :))) 4))
; '((O (O : : O))) 4))

; lozenge
; (O (: O : O :)) 3))
; (O (O : : : O)) 4)

; hyper lozenge
; '((O (: O : O :) 4))
;   (O (O : : O O)) 4)

;star
;                    (O (O : :))
;                    (: (O))

; boxes
;                    (O (O : O))
;                    (: (: O))
