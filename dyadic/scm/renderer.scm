;; Planet Fluxus Copyright (C) 2013 Dave Griffiths
;;
;; This program is free software: you can redistribute it and/or modify
;; it under the terms of the GNU Affero General Public License as
;; published by the Free Software Foundation, either version 3 of the
;; License, or (at your option) any later version.
;;
;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU Affero General Public License for more details.
;;
;; You should have received a copy of the GNU Affero General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

(console.log "hello")

(define renderer
  (lambda (gl)
    (list
     gl
     ()
     (mat4.identity (mat4.create))
     (mat4.identity (mat4.create))
     (mat4.identity (mat4.create))
     (list (state gl))
     ()
     #f
     ())))

(define renderer-gl (lambda (r) (list-ref r 0)))
(define renderer-list (lambda (r) (list-ref r 1)))
(define renderer-modify-list (lambda (r v) (list-replace r 1 v)))
(define renderer-view (lambda (r) (list-ref r 2)))
(define renderer-camera (lambda (r) (list-ref r 3)))
(define renderer-world-to-screen (lambda (r) (list-ref r 4)))
(define renderer-stack (lambda (r) (list-ref r 5)))
(define renderer-modify-stack (lambda (r v) (list-replace r 5 v)))
(define renderer-immediate-prims (lambda (r) (list-ref r 6)))
(define renderer-modify-immediate-prims (lambda (r v) (list-replace r 6 v)))
(define renderer-hook (lambda (r) (list-ref r 7)))
(define renderer-modify-hook (lambda (r v) (list-replace r 7 v)))
(define renderer-prefab (lambda (r) (list-ref r 8)))
(define renderer-modify-prefab (lambda (r v) (list-replace r 8 v)))

(define renderer-add
  (lambda (r p)
    (renderer-modify-list r (cons p (renderer-list r)))))

(define renderer-stack-dup
  (lambda (r)
    (renderer-modify-stack
     r (cons (state-clone (car (renderer-stack r)))
            (renderer-stack r)))))

(define renderer-stack-pop
  (lambda (r)
    (renderer-modify-stack
     r (cdr (renderer-stack r)))))

(define renderer-stack-top
  (lambda (r)
    (car (renderer-stack r))))

(define renderer-top-tx
  (lambda (r)
    (state-tx (renderer-stack-top r))))

(define (renderer-modify-stack-top r fn)
  (renderer-modify-stack
   r (cons (fn (car (renderer-stack r)))
           (cdr (renderer-stack r)))))

(define renderer-immediate-add
  (lambda (r p)
    (renderer-modify-immediate-prims
     r (cons
        ;; state, and a primitive to render in
        (list (state-clone (renderer-stack-top r)) p)
        (renderer-immediate-prims r)))))))

(define renderer-immediate-clear
  (lambda (r)
    (renderer-modify-immediate-prims r ())))

(define renderer-render
  (lambda (r t)
    (let ((gl (renderer-gl r))
          (hook (renderer-hook r)))
      (gl.viewport 0 0 gl.viewportWidth gl.viewportHeight)
      (gl.clearColor 0 0 0 1)
      (gl.clear (js "gl.COLOR_BUFFER_BIT | gl.DEPTH_BUFFER_BIT"))
      (mat4.perspective 45 (/ gl.viewportWidth gl.viewportHeight) 0.1 1000.0
                        (renderer-view r))
      ;; for inspection purposes...
      (mat4.multiply (renderer-view r) (renderer-camera r) (renderer-world-to-screen r))
      (mat4.identity (renderer-top-tx r))

      (when hook (js "try{") (hook) (js "} catch(e) { ") (display e) (js "}"))

      ;; immediate mode
      (for-each
       (lambda (p)
         (let ((state (car p))
               (prim (cadr p)))
           (primitive-render prim gl
                             (renderer-view r)
                             (renderer-camera r)
                             state)))
       (renderer-immediate-prims r))
      (renderer-immediate-clear r))))


      ;; retained mode
                                        ;      (for-each
                                        ;       (lambda (p)
                                        ;         (primitive-render
                                        ;          p gl (renderer-camera r) (renderer-view r)))
                                        ;       (renderer-list r))


(define renderer-build-prefab
  (lambda (r)
    (let ((gl (renderer-gl r)))
      (renderer-modify-prefab
       r
       (list
        (build-primitive
         gl
         (length unit-cube-vertices)
         (list
          (buffer gl "p" unit-cube-vertices 3)
          (buffer gl "n" unit-cube-normals 3)
          (buffer gl "t" unit-cube-texcoords 3)
          ))
        (build-primitive
         gl
         (length sphere-vertices)
         (list
          (buffer gl "p" sphere-vertices 3)
          (buffer gl "n" sphere-normals 3)
          (buffer gl "t" sphere-texcoords 3)
          ))
        (build-primitive
         gl
         (length torus-vertices)
         (list
          (buffer gl "p" torus-vertices 3)
          (buffer gl "n" torus-normals 3)
          (buffer gl "t" torus-texcoords 3)
          ))
        (build-primitive
         gl
         (length wing-vertices)
         (list
          (buffer gl "p" wing-vertices 3)
          (buffer gl "n" wing-normals 3)
          (buffer gl "t" wing-texcoords 3)
          ))
        (build-primitive
         gl
         (length body-vertices)
         (list
          (buffer gl "p" body-vertices 3)
          (buffer gl "n" body-normals 3)
          (buffer gl "t" body-texcoords 3)
          ))
        )))))
