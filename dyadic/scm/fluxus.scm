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

(define r 0)

(define time
  (lambda ()
    (js "new Date().getTime()/1000;")))

 (define push
  (lambda ()
    (set! r (renderer-stack-dup r))))

(define pop
  (lambda ()
    (set! r (renderer-stack-pop r))))

(define translate
  (lambda (v)
    (mat4.translate (renderer-top-tx r) v)))

(define rotate
  (lambda (v)
    (mat4.rotate (renderer-top-tx r) (* (vx v) 0.0174532925) (list 1 0 0))
    (mat4.rotate (renderer-top-tx r) (* (vy v) 0.0174532925) (list 0 1 0))
    (mat4.rotate (renderer-top-tx r) (* (vz v) 0.0174532925) (list 0 0 1))))

(define aim-matrix (mat4.create))

(define (maim a u)
  (let ((c (vector 0 0 0)))
    (vec3.cross a u c)
;;    (vec3.normalize c)

    (js "aim_matrix[0]=vx(a);")
    (js "aim_matrix[1]=vy(a);")
    (js "aim_matrix[2]=vz(a);")
    (js "aim_matrix[3]=0;")

    (js "aim_matrix[4]=vx(u);")
    (js "aim_matrix[5]=vy(u);")
    (js "aim_matrix[6]=vz(u);")
    (js "aim_matrix[7]=0;")

    (js "aim_matrix[8]=vx(c);")
    (js "aim_matrix[9]=vy(c);")
    (js "aim_matrix[10]=vz(c);")
    (js "aim_matrix[11]=0;")

    (js "aim_matrix[12]=0;")
    (js "aim_matrix[13]=0;")
    (js "aim_matrix[14]=0;")
    (js "aim_matrix[15]=1;")

    (mat4.multiply (renderer-top-tx r) aim-matrix)))

(define (camera-transform)
  (renderer-camera r))

(define (view-transform)
  (renderer-view r))

;; fudged to match canvas...
(define (project-point p)
  (let ((ret (list (vx p) (vy p) (vz p) 1))
        (gl (renderer-gl r)))
    (mat4.multiplyVec4 (renderer-world-to-screen r) ret)
    (vec3.create (list (* (+ (/ (vx ret) (list-ref ret 3)) 1) gl.viewportWidth 0.6)
                       (* (+ (/ (- 0 (vy ret)) (list-ref ret 3)) 0.95) gl.viewportHeight 0.55)

                       0))))

(define scale
  (lambda (v)
    (mat4.scale (renderer-top-tx r) v)))

(define (load-texture name)
  (load-texture-impl!
   (renderer-gl r)
   (+ "textures/" name)))

(define (texture name)
  (set! r (renderer-modify-stack-top
           r
           (lambda (state)
             (state-modify-texture state name)))))

(define (shader vert frag)
  (set! r (renderer-modify-stack-top
           r
           (lambda (state)
             (state-modify-shader
              state
              (build-shader (renderer-gl r) vert frag))))))

(define (colour col)
  (set! r (renderer-modify-stack-top
           r
           (lambda (state)
             (state-modify-colour state col)))))

(define every-frame-impl
  (lambda (hook)
    (set! r (renderer-modify-hook r hook))))

(define draw-cube
  (lambda ()
    (set! r (renderer-immediate-add
             r (list-ref (renderer-prefab r) 0)))))

(define draw-sphere
  (lambda ()
    (set! r (renderer-immediate-add
             r (list-ref (renderer-prefab r) 1)))))

(define draw-torus
  (lambda ()
    (set! r (renderer-immediate-add
             r (list-ref (renderer-prefab r) 2)))))

(define draw-obj
  (lambda (obj)
    (set! r (renderer-immediate-add
             r (list-ref (renderer-prefab r) obj)))))

(define build-polygons
  (lambda (type count)
    (let ((gl (renderer-gl r)))
    (set! r
          (renderer-add
           r
           (build-primitive
            gl
            (length unit-cube-vertices)
            (list
             (buffer gl "p" unit-cube-vertices 3)
             (buffer gl "n" unit-cube-normals 3)
             )))))))
