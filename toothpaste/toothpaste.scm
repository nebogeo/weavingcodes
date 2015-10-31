;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(set! prim-size 8000)

(scale (vector 0.2 0.2 0.2))
(translate (vector -25 -10 20))
(rotate (vector 45 0 0))
(define squeeze (build-jellyfish prim-size))

(define addr-profile-size 26)
(define addr-seq-size 21)

(define (write-profile size)
  (define (_ n addr)
    (when (<= n size) ;; overflow one at the end
          (pdata-set!
           "x" addr
           (vmul
            (vector 0
                    (sin (* 2 3.141 (/ n size)))
                    (cos (* 2 3.141 (/ n size))))
            1))
          (_ (+ n 1) (+ addr 1))))
  (pdata-set! "x" addr-profile-size (vector size 0 0))
  (_ 0 (+ addr-profile-size 1)))

(define (write-seq seq)
  (define addr 0)
  (pdata-set! "x" addr-seq-size (vector (length seq) 0 0))
  (for-each
   (lambda (v)
     (msg v)
     (pdata-set! "t" addr (vector v 0 0))
     (set! addr (+ addr 1)))
   seq))


(with-primitive
 squeeze
 (program-jelly
  1000 prim-triangles 3
  '(let ((vertex positions-start)
         (pos (vector 0 0 0))
         (last-pos (vector 0 0 0))
         (dir (vector 0 0 0))
         (tx-a (vector 1 0 0))
         (tx-b (vector 0 1 0))
         (tx-c (vector 0 0 1))
         (cur-tx-a (vector 1 0 0))
         (cur-tx-b (vector 0 1 0))
         (cur-tx-c (vector 0 0 1))
         (last-tx-a (vector 1 0 0))
         (last-tx-b (vector 0 1 0))
         (last-tx-c (vector 0 0 1))
         (t 0)
         (seq-size 14)
         (seq-pos 0)
         (seq-cur 0)
         (segments 4)
         (profile-pos 0)

         (profile-size 3)
         (profile-start (vector 0 0 1))
         (profile-b (vector 0 1 0))
         (profile-c (vector 0 0 -1))
         (profile-d (vector 0 -1 0))
         (profile-loop (vector 0 0 1))
         (space-0 0)
         (space-1 0)
         (space-2 0)
         (space-3 0)
         (space-4 0)
         (space-5 0)
         (space-6 0)
         (space-7 0)
         (space-8 0)
         (space-9 0)
         (space-10 0)
         (space-12 0)

         )


     (trace (addr profile-size))
     (trace (addr seq-size))


     (define init-mat
        (lambda ()
          (set! tx-a (vector 1 0 0))
          (set! tx-b (vector 0 1 0))
          (set! tx-c (vector 0 0 1))))

      (define rotate-mat-y
        (lambda (a)
          (set! tx-a (*v (swizzle yzx (sincos a)) (vector 1 1 -1)))
          (set! tx-b (vector 0 1 0))
          (set! tx-c (swizzle xzy (sincos a)))))

      (define rotate-mat-z
        (lambda (a)
          (set! tx-a (swizzle yxz (sincos a)))
          (set! tx-b (*v (sincos a) (vector -1 1 1)))
          (set! tx-c (vector 0 0 1))))

      ;; project vector by a matrix
      (define tx-proj
        (lambda (tx-addr v)
          (+
           (+ (dot v (read tx-addr))
              (swizzle yxy (dot v (read (+ tx-addr 1)))))
           (swizzle yyx (dot v (read (+ tx-addr 2)))))))

     (forever
      (set! vertex positions-start)
      (loop (< vertex positions-end)

            ;; new segment
            (set! last-pos pos)
            (set! last-tx-a cur-tx-a)
            (set! last-tx-b cur-tx-b)
            (set! last-tx-c cur-tx-c)
            (set! pos (+ pos dir))
            (set! dir (tx-proj (addr cur-tx-a) (vector 1 0 0)))

            (set! seq-cur (read (+ seq-pos texture-start)))
            (cond
             ((eq? seq-cur 0)
              (init-mat)
              (trace dir)
              (set! pos (+ pos (* dir (- segments 1))))
              (set! t segments)
              )
             ((eq? seq-cur 1) (rotate-mat-y (/ 90 segments)))
             ((eq? seq-cur 2) (rotate-mat-y (/ -90 segments)))
             ((eq? seq-cur 3)
              (set! pos
                    (+ pos (*v (sincos (* (/ t (- segments 1)) 180))
                               (vector 0 1 0)))))
             ((eq? seq-cur 4)
              (set! pos
                    (+ pos (*v (sincos (* (/ t (- segments 1)) 180))
                               (vector 0 -1 0)))))
              )

            ;; apply to current
            (*m (addr tx-a) (addr cur-tx-a) (addr cur-tx-a))

            ;;(rotate-mat-z (* (sincos t) 10000)))
            ;;(trace dir)


            (set! profile-pos (addr profile-start))
            (loop (< profile-pos (+ (addr profile-start) profile-size))
                  (write! vertex
                          (+ pos (tx-proj (addr cur-tx-a) (read (+ profile-pos 1))))
                          (+ pos (tx-proj (addr cur-tx-a) (read profile-pos)))
                          (+ last-pos (tx-proj (addr last-tx-a) (read profile-pos)))

                          (+ last-pos (tx-proj (addr last-tx-a) (read profile-pos)))
                          (+ last-pos (tx-proj (addr last-tx-a) (read (+ profile-pos 1))))
                          (+ pos (tx-proj (addr cur-tx-a) (read (+ profile-pos 1))))

                          )
                  ;; normals
                  (write! (+ vertex prim-size)
                          (tx-proj (addr cur-tx-a) (read (+ profile-pos 1)))
                          (tx-proj (addr cur-tx-a) (read profile-pos))
                          (tx-proj (addr last-tx-a) (read profile-pos))

                          (tx-proj (addr last-tx-a) (read profile-pos))
                          (tx-proj (addr last-tx-a) (read (+ profile-pos 1)))
                          (tx-proj (addr cur-tx-a) (read (+ profile-pos 1)))

                          )


                  (set! vertex (+ vertex 6))
                  (set! profile-pos (+ profile-pos 1)))


            (set! t (+ t 1))
            (when (> t segments)
                  (set! t 0)
                  ;; sort out fixed point rounding errors
                  ;; by snapping the matrix to 90 degrees
                  (set! cur-tx-a (round cur-tx-a))
                  (set! cur-tx-b (round cur-tx-b))
                  (set! cur-tx-c (round cur-tx-c))

                  (set! seq-pos (+ seq-pos 1))
                  (when (> seq-pos seq-size)
                        (set! seq-pos 0)))

            )


      ;;(set! t (+ t 0.01))
      )))
; (hint-unlit)
 (hint-wire)
 ;(pdata-map! (lambda (p) (srndvec)) "p")
 (pdata-map! (lambda (c) (vector 1 0.7 0.3)) "c")
 (pdata-map! (lambda (n) (vector 0 0 0)) "n")

 )


(define frame 0)

(every-frame
 (with-primitive
  squeeze
  (when (eqv? frame 10)
        (write-profile 8)
        (write-seq (list 1 1 0 3 4 3 4 0 0 0 0 2 2 0 0 0 0 0 0 0 0 0)))
  (set! frame (+ frame 1))
 ; (rotate (vector 0 0.5 0))
  ))
