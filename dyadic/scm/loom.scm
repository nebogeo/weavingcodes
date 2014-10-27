; thinking more like a loom

(define (dbg a)
  (console.log a)(newline) a)

(define (error msg) (console.log msg))

(define (repeat seq rep)
  (cond
    ((zero? rep) seq)
    (else (append seq (repeat seq (- rep 1))))))


(define (loom heddles lifts warp) (list heddles lifts warp))
(define (loom-heddles l) (list-ref l 0))
(define (loom-lifts l) (list-ref l 1))
(define (loom-warp l) (list-ref l 2))


; given a lift plan line, return the heddles raised
(define (loom-lifts-to-heddles l lift c)
  (cond
   ((null? lift) ())
   ((zero? (car lift))
    (loom-lifts-to-heddles l (cdr lift) (+ c 1)))
   (else
    (cons (list-ref (loom-heddles l) c)
          (loom-lifts-to-heddles l (cdr lift) (+ c 1))))))

(define (loom-heddles-raised l lift-counter)
  (let ((lift (list-ref (loom-lifts l) lift-counter)))
    (loom-lifts-to-heddles l lift 0)))

(define (list-or a b)
  (map2
   (lambda (a b)
     (if (or (not (zero? a)) (not (zero? b))) 1 0))
   a b))

(define (loom-shed l lift-counter)
  (foldl
   (lambda (a b)
     (list-or a b))
   (build-list (length (car (loom-heddles l))) (lambda (a) 0))
   (loom-heddles-raised l lift-counter)))

(define (loom-weave-yarn l weft-yarn lift-counter)
  (map2
   (lambda (lift warp-yarn)
     (if (eq? lift 1)
         (list (string-append "warp-" warp-yarn)
               (string-append "weft-" weft-yarn))
         (list (string-append "weft-" weft-yarn)
               (string-append "warp-" warp-yarn))))
   (loom-shed l lift-counter)
   (loom-warp l)))

(define (loom-weave l weft lift-counter)
  (cond
    ((null? weft) ())
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
  (console.log "testing loom")

  (let ((l (loom
            (list
             (list 1 0 0 0)
             (list 0 1 0 0)
             (list 0 0 1 0)
             (list 0 0 0 1))
            (list
             (list 1 0 1 0)
             (list 0 1 0 1))
            (repeat (list "O" ":") 1))))

  (when (not (list-equal? (loom-lifts l)
                     (list
                      (list 1 0 1 0)
                      (list 0 1 0 1))))
    (error "loom-lifts test failed"))

  (when (not (list-equal? (loom-heddles l)
                     (list (list 1 0 0 0)
                           (list 0 1 0 0)
                           (list 0 0 1 0)
                           (list 0 0 0 1))))
    (error "loom-heddles test failed"))

  (when (not (list-equal? (loom-lifts-to-heddles l (list 1 1 0 0) 0)
                     (list (list 1 0 0 0) (list 0 1 0 0))))
    (error "loom-lifts-to-heddles test failed"))

  (when (not (list-equal? (loom-heddles-raised l 0)
                     (list (list 1 0 0 0) (list 0 0 1 0))))
    (error "loom-heddles-raised test failed"))

  (when (not (list-equal? (loom-shed l 0) (list 1 0 1 0)))
    (error "loom-shed test1 failed"))

  (when (not (list-equal? (loom-shed l 1) (list 0 1 0 1)))
    (error "loom-shed test2 failed"))

  (when (not (list-equal? (loom-weave-yarn l "A" 0) (list "O" "A" "O" "A")))
        (error "loom-weave-yarn test failed"))

  ))

(test)
