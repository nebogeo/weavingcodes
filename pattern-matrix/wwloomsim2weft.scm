;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; weavecoding raspberry pi installation

(clear-colour (vector 1 1 1))

;(rotate (vector 0 -45 0))
(define weft (build-jellyfish 4096))
(define weft2 (build-jellyfish 4096))
(define warp (build-jellyfish 4096))
(define weave-scale (vector 0.2 -0.2 0.2))

(define yarn-a (vector 1 1 1))
(define yarn-b (vector 0.5 0.3 0.1))

(define warp-yarn-a yarn-a)
(define warp-yarn-b yarn-a)
(define weft-yarn-a yarn-b)
(define weft-yarn-b yarn-b)

(define weft-program
    '(let ((vertex positions-start)
         (t 0)
         (v 0)
         (weft-direction (vector 2 0 0))
         (weft-position (vector -20 0 0))
         (weft-t 0)
         (draft-pos 0)
         (draft-start 0)
         (draft 0) (d-b 0) (d-c 0) (d-d 0) (d-e 1)
         (d-f 0) (d-g 0) (d-h 0) (d-i 1) (d-j 0)
         (d-k 0) (d-l 0) (d-m 1) (d-n 0) (d-o 0)
         (d-p 0) (d-q 1) (d-r 0) (d-s 0) (d-t 0)
         (d-u 1) (d-v 0) (d-w 0) (d-x 0) (d-y 0)
         (weft-z (vector 0 0 0))
         (weft-count 0)
         (weft-total 21)
         (draft-size 5))

;    (trace (addr draft-size))

     (define read-draft
       (lambda ()
         (read
          (+ (addr draft)
             (+ (* draft-pos draft-size)
                (if (> weft-direction 0)
                    (modulo weft-count (+ draft-size (vector 0 1 1)) )
                    (modulo (- (- weft-total 1) weft-count) (+ draft-size (vector 0 1 1)) )))))))

     (define calc-weft-z
       (lambda ()
         (set! weft-count (+ weft-count 1))
         (set! weft-z
               (if (> (read-draft) 0.5)
                   (vector 0 0 0.01)
                   (vector 0 0 -0.01)))))


     (define right-selvedge
       (lambda (gap)
         ;; top corner
         (write! vertex
                 (- (+ weft-position (vector 2 0 0)) gap)
                 (- (+ weft-position (vector 3 1 0)) gap)
                 (- (+ weft-position (vector 2 1 0)) gap))
         (set! vertex (+ vertex 3))
         ;; vertical connection
         (write! vertex
                 (- (+ weft-position (vector 3 1 0)) gap)
                 (- (+ weft-position (vector 2 1 0)) gap)
                 (+ weft-position (vector 2 0 0))
                 (- (+ weft-position (vector 3 1 0)) gap)
                 (+ weft-position (vector 2 0 0))
                 (+ weft-position (vector 3 0 0)))
         (set! vertex (+ vertex 6))
         ;; bottom corner
         (write! vertex
                 (+ weft-position (vector 2 0 0))
                 (+ weft-position (vector 3 0 0))
                 (+ weft-position (vector 2 1 0)))
         (set! vertex (+ vertex 3))
         ))

     (define left-selvedge
       (lambda (gap)
         ;; top corner
         (write! vertex
                 (- (+ weft-position (vector 0 0 0)) gap)
                 (- (+ weft-position (vector -1 1 0)) gap)
                 (- (+ weft-position (vector 0 1 0)) gap))
         (set! vertex (+ vertex 3))
         ;; vertical connection
         (write! vertex
                 (- (+ weft-position (vector -1 1 0)) gap)
                 (- (+ weft-position (vector 0 1 0)) gap)
                 (+ weft-position (vector 0 0 0))
                 (- (+ weft-position (vector -1 1 0)) gap)
                 (+ weft-position (vector 0 0 0))
                 (+ weft-position (vector -1 0 0)))
         (set! vertex (+ vertex 6))
         ;; bottom corner
         (write! vertex
                 (+ weft-position (vector 0 0 0))
                 (+ weft-position (vector -1 0 0))
                 (+ weft-position (vector 0 1 0)))
         (set! vertex (+ vertex 3))
         ))

     (forever
      (set! vertex positions-start)
      (loop (< vertex positions-end)
            (calc-weft-z)
            (set! weft-position (+ weft-position weft-direction))
            ;; selvedge time?
            (when (> weft-count weft-total)
                  (set! weft-count 0)
                  ;;(trace draft-pos)
                  (set! draft-pos (+ draft-pos 1))
                  (when (> draft-pos draft-size)
                        (set! draft-pos draft-start))
                  (set! weft-position (- (+ weft-position (vector 0 1.5 0))
                                         weft-direction))
                  (set! weft-direction (* weft-direction -1))
                  (if (> 0 weft-direction)
                      (right-selvedge (vector 0 1.5 0))
                      (left-selvedge (vector 0 1.5 0))))

            (set! weft-t (/ weft-count 21))

            (write! vertex
                    (+ weft-z weft-position)
                    (+ weft-position (+ weft-z (vector 2 1.3 0)))
                    (+ weft-position (+ weft-z (vector 2 0 0)))
                    (+ weft-z weft-position)
                    (+ weft-position (+ weft-z (vector 2 1.3 0)))
                    (+ weft-position (+ weft-z (vector 0 1.3 0))))
            (set! vertex (+ vertex 6)))
      ;;(set! t (+ t 0.01))
      )))

(with-primitive
 weft
 (program-jelly 30 prim-triangles weft-program)
 (hint-unlit)
 (hint-wire)
 (texture (load-texture "thread.png"))
 (scale weave-scale)
 (translate (vector 0.4 0 0))
 (pdata-index-map! (lambda (i t)
                     (cond
                      ((eqv? (modulo i 6) 0) (vector 0 0 0))
                      ((eqv? (modulo i 6) 1) (vector 1 1 0))
                      ((eqv? (modulo i 6) 2) (vector 1 0 0))
                      ((eqv? (modulo i 6) 3) (vector 0 0 0))
                      ((eqv? (modulo i 6) 4) (vector 1 1 0))
                      ((eqv? (modulo i 6) 5) (vector 0 1 0))
                      )) "t")
 (pdata-map! (lambda (c) weft-yarn-a) "c")
 (pdata-map! (lambda (n) (vector 0 0 0)) "n"))

;; (with-primitive
;;  weft2
;;  (parent weft)
;;  (program-jelly 30 prim-triangles weft-program)
;;  (hint-unlit)
;;  (hint-wire)
;;  (texture (load-texture "thread.png"))
;;  (translate (vector 0 1.5 0))
;;  (pdata-index-map! (lambda (i t)
;;                      (cond
;;                       ((eqv? (modulo i 6) 0) (vector 0 0 0))
;;                       ((eqv? (modulo i 6) 1) (vector 1 1 0))
;;                       ((eqv? (modulo i 6) 2) (vector 1 0 0))
;;                       ((eqv? (modulo i 6) 3) (vector 0 0 0))
;;                       ((eqv? (modulo i 6) 4) (vector 1 1 0))
;;                       ((eqv? (modulo i 6) 5) (vector 0 1 0))
;;                       )) "t")
;;  (pdata-map! (lambda (c) weft-yarn-b) "c")
;;  (pdata-map! (lambda (n) (vector 0 0 0)) "n"))


;;  weave section
;;  top shed
;;  bottom shed
;;  back section

(with-primitive
 warp
  (program-jelly
   800 prim-triangles
   '(let ((vertex positions-start)
          (warp-end 0)
          (warp-position (vector 0 0 0))
          (v 0)
          (weft-t 0)
          (draft-pos 0)
          (draft-size 5)
         (draft 0) (d-b 0) (d-c 0) (d-d 0) (d-e 1)
         (d-f 0) (d-g 0) (d-h 0) (d-i 1) (d-j 0)
         (d-k 0) (d-l 0) (d-m 1) (d-n 0) (d-o 0)
         (d-p 0) (d-q 1) (d-r 0) (d-s 0) (d-t 0)
         (d-u 1) (d-v 0) (d-w 0) (d-x 0) (d-y 0)
          (last-t 0))

      ;;(trace (addr draft-size))

      (define build-quad
        (lambda (tl size)
          (write! vertex
                  tl (+ tl size)
                  (+ tl (*v size (vector 1 0 0)))
                  tl (+ tl size)
                  (+ tl (*v size (vector 0 1 0))))
          (set! vertex (+ vertex 6))))

      ;; like weft but don't need to take account of direction
      (define read-draft
        (lambda ()
          (read (+ (addr draft)
                   (+ (* draft-pos draft-size)
                      (modulo warp-end (+ draft-size (vector 0 1 1)) ))))))

      (define animate-shed
        (lambda (i)
          (set! v (if (< weft-t 0.2)
                      (vector 0 0 2)
                      (if (> weft-t 0.8)
                          (vector 0 0 -1.3)
                          (vector 0 0 0))))
          (set! warp-end 0)
          (loop (< warp-end 20)
                (when (< (read-draft) 0.5)
                      (write-add! (- i 6) 0 v 0 0 v v
                                  v 0 v v))
                (set! i (+ i 24))
                (set! warp-end (+ warp-end 1)))))

      (define build-warp
        (lambda ()
          (set! vertex positions-start)
          ;; build 4 segments X warp-ends
          (set! warp-end 0)
          (loop (< warp-end 20)
                (set! warp-position (+ (vector -19 -35.5 0)
                                       (* (vector 2 0 0) warp-end)))
                (build-quad warp-position (vector 1.3 35 0))
                (build-quad (+ warp-position (vector 0 35 0)) (vector 1.3 10 0))
                (build-quad (+ warp-position (vector 0 45 0)) (vector 1.3 15 0))
                (build-quad (+ warp-position (vector 0 60 0)) (vector 1.3 25 0))
                (set! warp-end (+ warp-end 1)))))

      (build-warp)
      (forever
       (set! vertex (+ positions-start 12))
       (animate-shed vertex)

       (when (> (- last-t weft-t) 0.1)
             (set! draft-pos (+ draft-pos 1))
             (when (> draft-pos draft-size) (set! draft-pos 0))
             (build-warp))

       (set! last-t weft-t)
       )))

 (hint-unlit)
 (texture (load-texture "thread.png"))
 (scale weave-scale)
 (pdata-index-map! (lambda (i t)
                     (cond
                      ((eqv? (modulo i 6) 0) (vector 0 0 0))
                      ((eqv? (modulo i 6) 1) (vector 10 1 0))
                      ((eqv? (modulo i 6) 2) (vector 0 1 0))
                      ((eqv? (modulo i 6) 3) (vector 0 0 0))
                      ((eqv? (modulo i 6) 4) (vector 10 1 0))
                      ((eqv? (modulo i 6) 5) (vector 10 0 0))
                      )) "t")
 (pdata-index-map! (lambda (i c) (if (< (modulo i 48) 24)
                                     warp-yarn-a warp-yarn-b)) "c")
 (pdata-map! (lambda (n) (vector 0 0 0)) "n")
  )

(define (jellyfish-dma sprim src dprim dst)
  (with-primitive
   dprim
   (pdata-set!
    "x" dst (with-primitive
             sprim
             (pdata-ref "x" src)))))


(define weft-draft-start 15)
(define warp-draft-start 14)

(define (set-draft! start data)
  (when (not (null? data))
	(pdata-set! "x" start
		    (if (zero? (car data))
			(vector 0 0 0) (vector 1 0 0)))
	(set-draft! (+ start 1) (cdr data))))

(define (set-draft-all! data)
  (with-primitive warp (set-draft! warp-draft-start data))
  (with-primitive weft (set-draft! weft-draft-start data))
  (with-primitive weft2 (set-draft! weft-draft-start data)))

(define old-data
  (list 0 0 0 0 0
        0 0 0 0 0
        0 0 0 0 0
        0 0 0 0 0))

(synth-init 20 44100)

(define (sound-from-changes data)
  (for-each
   (lambda (a b)
     (if (not (eqv? a b))
         (if (zero? a)
             (play-now (mul (adsr 0 0.3 0 0)
                            (sine (mul (adsr 0.1 0 0 0) 400))) 0)
             (play-now (mul (adsr 0 0.3 0 0)
                            (sine (mul (adsr 0 0.2 0 0) 400))) 0)
             )))
   old-data data))

(define (update! data)
  (sound-from-changes data)

  ;; draft pos offset
  (with-primitive weft2 (pdata-set! "x" 14 (vector 1 0 0)))

  ;; if right/bottom border zero treat as 4X4 matrix
  (cond
   ((and (zero? (list-ref data 4))
         (zero? (list-ref data 9))
         (zero? (list-ref data 14))
         (zero? (list-ref data 19))
         (zero? (list-ref data 20))
         (zero? (list-ref data 21))
         (zero? (list-ref data 22))
         (zero? (list-ref data 23))
         (zero? (list-ref data 24)))

    ;; draft size
    (with-primitive weft (pdata-set! "x" 43 (vector 4 0 0)))
    (with-primitive weft2 (pdata-set! "x" 43 (vector 4 0 0)))
    (with-primitive warp (pdata-set! "x" 13 (vector 4 0 0)))
    (msg "4x4")
    (set-draft-all!
     (list (list-ref data 0) (list-ref data 1) (list-ref data 2) (list-ref data 3)
           (list-ref data 5) (list-ref data 6) (list-ref data 7) (list-ref data 8)
           (list-ref data 10) (list-ref data 11) (list-ref data 12) (list-ref data 13)
           (list-ref data 15) (list-ref data 16) (list-ref data 17) (list-ref data 18))))
   (else
    (msg "5x5")
    ;; draft size 5x5
    (with-primitive weft (pdata-set! "x" 43 (vector 5 0 0)))
    (with-primitive weft2 (pdata-set! "x" 43 (vector 5 0 0)))
    (with-primitive warp (pdata-set! "x" 13 (vector 5 0 0)))
    (set-draft-all! data))))

(define count-down 50)

(every-frame
 (jellyfish-dma weft 12 warp 11)
 (jellyfish-dma weft 13 warp 12)

 (set! count-down (- count-down 1))

 (when (zero? count-down)
       (update! (list
                 0 0 0 1 1
                 0 0 1 1 0
                 0 1 1 0 0
                 1 1 0 0 0
                 1 0 0 0 1)))

 (with-primitive
  weft
  (when
   (< (vy (vtransform  (pdata-ref "x" 11) (get-transform))) 0)
   (translate (vector 0 -0.1 0))
   ;; (with-primitive
   ;;  warp
   ;;  (pdata-map!
   ;;   (lambda (t) (vadd t (vector 0.03 0 0))) "t"))

   )))
