#lang racket
; thinking more like a loom

(define (dbg a)
  (display a)(newline) a)

(define (repeat seq rep)
  (cond 
    ((zero? rep) seq)
    (else (append seq (repeat seq (- rep 1))))))

(define heddles list)
(define lifts list)
(define heddle list)
(define lift list)
(define warp list)

(define (loom heddles lifts warp) (list heddles lifts warp))
(define (loom-heddles l) (list-ref l 0))
(define (loom-lifts l) (list-ref l 1))
(define (loom-warp l) (list-ref l 2))

; given a lift plan line, return the heddles raised
(define (loom-lifts->heddles l lift c)
  (cond
    ((null? lift) '())
    ((zero? (car lift))
     (loom-lifts->heddles l (cdr lift) (+ c 1)))
    (else
     (cons (list-ref (loom-heddles l) c) 
           (loom-lifts->heddles l (cdr lift) (+ c 1))))))

(define (loom-heddles-raised l lift-counter)
  (let ((lift (list-ref (loom-lifts l) lift-counter)))
    (loom-lifts->heddles l lift 0)))

(define (list-or a b)
  (map
   (lambda (a b)
     (if (or (not (zero? a)) (not (zero? b))) 1 0))
   a b))

(define (loom-shed l lift-counter)
  (foldl list-or          
         (build-list (length (car (loom-heddles l))) (lambda (_) 0))
         (loom-heddles-raised l lift-counter)))

(define (loom-weave-yarn l weft-yarn lift-counter)
  (map
   (lambda (lift warp-yarn)
     (if (eq? lift 1) warp-yarn weft-yarn))
   (loom-shed l lift-counter)
   (loom-warp l)))

(define (loom-weave l weft lift-counter)
  (cond
    ((null? weft) '())
    (else
     (cons (loom-weave-yarn 
            l (car weft) 
            (modulo lift-counter (length (loom-lifts l)))) 
           (loom-weave 
            l (cdr weft) 
            (+ lift-counter 1))))))

(define (display-weave l)
  (for-each
   (lambda (weft)
     (for-each
      (lambda (warp)
        (display (string-append warp " ")))
      weft)
     (newline))
   l))

(define (test)
  (define l (loom 
             (heddles
              (heddle 1 0 0 0)
              (heddle 0 1 0 0)
              (heddle 0 0 1 0)
              (heddle 0 0 0 1))
             (lifts
              (lift 1 0 1 0)
              (lift 0 1 0 1))
             (repeat (list "O" ":") 1)))
  
  (when (not (equal? (loom-lifts l) 
                     (list
                      (lift 1 0 1 0)
                      (lift 0 1 0 1))))
    (error "loom-lifts test failed"))
  
  (when (not (equal? (loom-heddles l) 
                     (list (heddle 1 0 0 0)
                           (heddle 0 1 0 0)
                           (heddle 0 0 1 0)
                           (heddle 0 0 0 1))))
    (error "loom-heddles test failed"))
  
  (when (not (equal? (loom-lifts->heddles l (list 1 1 0 0) 0)
                     (list (list 1 0 0 0) (list 0 1 0 0))))
    (error "loom-lifts->heddles test failed"))
  
  (when (not (equal? (loom-heddles-raised l 0)
                     (list (list 1 0 0 0) (list 0 0 1 0))))
    (error "loom-heddles-raised test failed"))
      
  (when (not (equal? (loom-shed l 0) (list 1 0 1 0)))
    (error "loom-shed test1 failed"))
  
  (when (not (equal? (loom-shed l 1) (list 0 1 0 1)))
    (error "loom-shed test2 failed"))
  
  (when (not (equal? (loom-weave-yarn l "A" 0) (list "O" "A" "O" "A")))
    (error "loom-weave-yarn test failed"))

  )

(test)

(define l (loom 
           (heddles
            (repeat (heddle 1 0 0 0 1 1 0 0 0 0 0 0 0 0) 1)
            (repeat (heddle 0 1 0 0 0 0 1 1 0 0 0 0 0 1) 1)
            (repeat (heddle 0 0 1 0 0 0 0 0 1 1 0 0 1 0) 1)
            (repeat (heddle 0 0 0 1 0 0 0 0 0 0 1 1 0 0) 1))
           (lifts
            (lift 0 0 0 1)
            (lift 0 0 1 0)
            (lift 0 0 1 1)
            (lift 0 1 0 0)
            (lift 0 1 0 1)
            (lift 0 1 1 0)
            (lift 0 1 1 1)
            (lift 1 0 0 0)
            (lift 1 0 0 1)
            (lift 1 0 1 0)
            (lift 1 0 1 1)
            (lift 1 1 0 0)
            (lift 1 1 0 1)
            (lift 1 1 1 0)
            )
           (repeat (list "O") 27)))

(display-weave (loom-weave l (repeat (list ":" ":" ":" ":" ":" ":") 2) 0))
