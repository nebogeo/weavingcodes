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

(define textures ())

(define (get-texture name)
  (foldl
   (lambda (t r)
     (if (and (not r) (eq? (car t) name))
         (cadr t) r))
   #f
   textures))

(define (load-texture-impl! gl name)
  (let ((texture (gl.createTexture)))
    (set! texture.image (js "new Image();"))
    (set! texture.image.onload
          (lambda ()
            (console.log "loaded")
            (gl.bindTexture gl.TEXTURE_2D texture)
            (gl.pixelStorei gl.UNPACK_FLIP_Y_WEBGL true)
            (gl.texImage2D gl.TEXTURE_2D 0 gl.RGBA gl.RGBA gl.UNSIGNED_BYTE texture.image)
            (gl.texParameteri gl.TEXTURE_2D gl.TEXTURE_MAG_FILTER gl.NEAREST)
            (gl.texParameteri gl.TEXTURE_2D gl.TEXTURE_MIN_FILTER gl.NEAREST)
            (gl.bindTexture gl.TEXTURE_2D null)
            (set! textures (cons (list name texture) textures))))
    (set! texture.image.src name)
    (console.log (+ "loading " name))
    name))

(define (bind-texture gl shader name)
  (let ((texture (get-texture name)))
    ;; may not have loaded yet
    (when texture
          (gl.activeTexture gl.TEXTURE0)
          (gl.bindTexture gl.TEXTURE_2D texture)
          (gl.uniform1i shader.texture 0))))
