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

(define t 0)

(define crank
  (lambda ()
    (set! t (+ t 0.1))
    (requestAnimFrame crank)
    (set! r (renderer-render r t))))

(define startup
  (lambda ()
    (let ((canvas (document.getElementById "webgl-canvas")))
      (let ((gl (canvas.getContext "experimental-webgl")))
        (msg "starting up webgl")
        (msg canvas.width)
        (set! gl.viewportWidth canvas.width)
        (set! gl.viewportHeight canvas.height)
        (set! r (renderer gl))
        ;; set up camera transform
        (mat4.translate (renderer-camera r) (list 0 0 -20))
        (set! r (renderer-build-prefab r))
        (gl.clearColor 0.0 0.0 0.0 1.0)
        (gl.enable gl.DEPTH_TEST)
        ;; make sure the default texture is loaded
        (load-texture "white.png")
        (crank)
        ))))

(startup)
