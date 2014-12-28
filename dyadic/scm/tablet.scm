#lang racket

;;     loom setup
;;  warp        weave
;;       ___
;; /----|o o|---####\
;; \----|o o|---####/
;;       ---
;;
;; forward rotation
;; a b > d a > d c > b d 
;; d c > c b > b a > a c
;;
;; backwards
;; a b > b c
;; d c > a d
;;
;; sideways rotation
;; a b > b a
;; d c > c d
;;
;; weaving (this took a while to figure out)
;;
;; turn   f    f    f     b    f     b     b
;; top->  a[b] d[a] c[d] [d]a  c[d] [d]a [a]b  
;; bot-> [d]c [c]b [b]a   c[b][b]a   c[b] d[c]

(define (flip a)
  (if (equal? a "s") "z" "s"))

(define (card angle a b d c) (list angle a b d c "f"))
(define (card-angle c) (list-ref c 0))
(define (card-a c) (list-ref c 1))
(define (card-b c) (list-ref c 2))
(define (card-d c) (list-ref c 3))
(define (card-c c) (list-ref c 4))
(define (card-memory c) (list-ref c 5))
(define (card-print c)
  (display (card-a c))(display " ")(display (card-b c))(newline)
  (display (card-d c))(display " ")(display (card-c c))(newline))

(define (card-forward c) 
  (list
   (card-angle c)
   (card-d c) (card-a c) 
   (card-c c) (card-b c)
   "f"))

(define (card-back c)
  (list 
   (card-angle c)
   (card-b c) (card-c c)
   (card-a c) (card-d c)
   "b"))

(define (card-flip c)
  (list 
   (flip (card-angle c))
   (card-b c) (card-a c)
   (card-c c) (card-d c)
   (card-memory c)))

(define (card-weave c)
  (if (equal? (card-memory c) "f")
      (list (card-b c) (card-d c))
      (list (card-a c) (card-c c))))

(define (card-loom cards) (list cards))
(define (card-loom-cards c) (list-ref c 0))

(define (card-loom-all-forward c)
  (card-loom
   (map 
    (lambda (card)
      (card-forward card))
    (card-loom-cards c))))

(define (card-loom-all-back c)
  (card-loom
   (map 
    (lambda (card)
      (card-back card))
    (card-loom-cards c))))

(define (in-list? l c)
  (cond
    ((null? l) #f)
    ((equal? (car l) c) #t)
    (else (in-list? (cdr l) c))))

(define (card-loom-flip loom c)
  (define pos -1)
  (card-loom
   (map
    (lambda (card)
      (set! pos (+ pos 1))
      (if (in-list? c pos)
          (card-flip card) card))
    (card-loom-cards loom))))

(define (card-loom-ind-forward loom c)
  (define pos -1)
  (card-loom
   (map
    (lambda (card)
      (set! pos (+ pos 1))
      (if (in-list? c pos)
          (card-forward card) card))
    (card-loom-cards loom))))

(define (card-loom-ind-back loom c)
  (define pos -1)
  (card-loom
   (map
    (lambda (card)
      (set! pos (+ pos 1))
      (if (in-list? c pos)
          (card-back card) card))
    (card-loom-cards loom))))

(define (card-loom-weave-top c)
  (for-each
   (lambda (card)
     (display (car (card-weave card)))
     (display 
      (if (equal? (card-angle card) "s") #\\ #\/)))
   (card-loom-cards c))
  (newline) c)

(define (card-loom-multi loom fn c)
  (cond
    ((zero? c) loom)
    (else 
     (card-loom-multi
      (card-loom-weave-top (fn loom)) fn (- c 1)))))

(define (card-loom-interpret loom command)
  (cond
    ((list? command)
     (cond
       ((equal? (car command) 'weave-forward)
        (card-loom-multi loom card-loom-all-forward (cadr command)))
       ((equal? (car command) 'weave-back) 
        (card-loom-multi loom card-loom-all-back (cadr command)))
       ((equal? (car command) 'twist)
        (card-loom-flip loom (cdr command)))
       ((equal? (car command) 'rotate-forward)
        (card-loom-ind-forward loom (cdr command)))
       ((equal? (car command) 'rotate-back)
        (card-loom-ind-back loom (cdr command)))       
       (else 
        (display "unknown function ")
        (display (car command))(newline) loom)))
    (else (display "unknown command ")(display command)(newline) loom)))

(define (card-loom-run loom code)
  (cond
    ((null? code) loom)
    (else 
     (card-loom-run
      (card-loom-weave-top       
       (card-loom-interpret loom (car code)))
      (cdr code)))))

         


(define (assert q)
  (if (not q) (error "test failed...")
      (display "test passed..."))
  (newline))

(define (test)
  (assert (equal? (card-forward 
                   (card "s"
                         "#" "."
                         "." "."))
                  (list "s"
                        "." "#"
                        "." "." "f")))
  (card-print 
   (card "s" 
         "#" "."
         "." "#"))
  (assert (equal? (card-forward 
                   (card "s" 
                         "#" "."
                         "." "#"))
                  (list "s"
                        "." "#"
                        "#" "." "f")))
  (assert (equal? (card-back 
                   (card "z" 
                         "#" "#"
                         "." "."))
                  (list "z"
                        "#" "."
                        "#" "." "b")))
  (assert (equal? (card-back 
                   (card-back 
                    (card "z"
                          "#" "."
                          "#" ".")))
                  (list "z"
                        "." "#"
                        "." "#" "b")))
  (assert (equal? (card-forward
                   (card-forward
                    (card-forward
                     (card-forward
                      (card "s" 
                            "1" "4"
                            "2" "3")))))
                  (list "s"
                        "1" "4"
                        "2" "3" "f")))
  
  (assert (equal? (card-flip (card "s" 
                                   "1" "2"
                                   "3" "4"))
                  (card "z" 
                        "2" "1"
                        "4" "3")))
  
  (assert (equal? (card-weave 
                   (card "z" 
                         "1" "2"
                         "4" "3")) (list "2" "4")))

  (assert (equal? (card-weave                    
                   (card-back
                    (card "z" 
                          "1" "2"
                          "4" "3"))) (list "2" "4")))

  (assert (equal? (card-weave                    
                   (card-back
                    (card-back
                     (card "z" 
                           "1" "2"
                           "4" "3")))) (list "3" "1")))
    
  )

(test)

(define loom
  (card-loom
   (list
    (card "z"
          "#" "#"
          "." ".")
    (card "z"
          "#" "#"
          "." ".")
    (card "z"
          "#" "#"
          "." ".")
    (card "z"
          "#" "#"
          "." ".")
    (card "z"
          "#" "#"
          "." ".")
    (card "z"
          "#" "#"
          "." ".")
    (card "z"
          "#" "#"
          "." ".")
    (card "z"
          "#" "#"
          "." ".")    
    )))

(card-loom-run 
 loom 
 '((weave-forward 8)
   (rotate-forward 1 2 3 4 5 6)
   (rotate-forward 2 3 4 5)
   (rotate-forward 3 4)
   (weave-forward 8)
   (weave-back 8)
   (twist 0 1 2 3)
   (weave-forward 8)
   (weave-back 8)
   
   ))
