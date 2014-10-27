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

(define blinn-vertex-shader "
precision mediump float;
uniform vec3 LightPos;
varying vec3 N;
varying vec3 P;
varying vec3 V;
varying vec3 L;
varying vec3 T;
uniform mat4 ViewMatrix;
uniform mat4 CameraMatrix;
uniform mat4 LocalMatrix;
uniform mat4 NormalMatrix;
attribute vec3 p;
attribute vec3 n;
attribute vec3 t;
void main()
{
    mat4 ModelViewMatrix = ViewMatrix * CameraMatrix * LocalMatrix;
    N = vec3(NormalMatrix*normalize(vec4(n,1.0)));
    P = p.xyz;
    T = t;
    V = -vec3(ModelViewMatrix*vec4(p,1.0));
    L = vec3(ModelViewMatrix*vec4((LightPos-p),1));
    gl_Position = ModelViewMatrix * vec4(p,1);
}")

(define blinn-fragment-shader "
precision mediump float;
uniform vec3 AmbientColour;
uniform vec3 DiffuseColour;
uniform vec3 SpecularColour;
uniform float Roughness;
varying vec3 N;
varying vec3 P;
varying vec3 V;
varying vec3 L;
varying vec3 T;
uniform sampler2D texture;
void main()
{
    vec3 l = normalize(L);
    vec3 n = normalize(N);
    vec3 v = normalize(V);
    vec3 h = normalize(l+v);
    float diffuse = dot(l,n);
    float specular = pow(max(0.0,dot(n,h)),1.0/Roughness);
    gl_FragColor = vec4(AmbientColour +
                        texture2D(texture, vec2(T.s, T.t)).xyz *
                        DiffuseColour*diffuse +
                        SpecularColour*specular,1);
}")


(define playful-vertex-shader "
precision mediump float;
uniform vec3 LightPos;
varying vec3 N;
varying vec3 P;
varying vec3 V;
varying vec3 L;
varying vec3 T;
uniform mat4 ViewMatrix;
uniform mat4 CameraMatrix;
uniform mat4 LocalMatrix;
uniform mat4 NormalMatrix;
attribute vec3 p;
attribute vec3 n;
attribute vec3 t;
void main()
{
    mat4 ModelViewMatrix = ViewMatrix * CameraMatrix * LocalMatrix;
    N = vec3(NormalMatrix*normalize(vec4(n,1.0)));
    P = p.xyz;
    T = t;
    V = -vec3(ModelViewMatrix*vec4(p,1.0));
    L = vec3(ModelViewMatrix*vec4((LightPos-p),1));
    gl_Position = ModelViewMatrix * vec4(p,1);
}")



(define basic-fragment-shader
  "precision mediump float;
   varying vec3 colour;
   void main(void) {
       gl_FragColor = vec4(colour,1.0);
   }")

(define basic-vertex-shader
  "attribute vec3 p;
   attribute vec3 n;
   uniform mat4 ViewMatrix;
   uniform mat4 CameraMatrix;
   uniform mat4 LocalMatrix;
   uniform mat4 NormalMatrix;
   varying vec3 colour;
   void main(void) {
       gl_Position = (ViewMatrix * CameraMatrix * LocalMatrix) * vec4(p, 1.0);
       vec4 ln = vec4(n, 1.0);
       colour = vec3(0.5,0.5,1)*max(0.0,dot(vec4(0.85, 0.8, 0.75, 1.0),ln));
   }")


;; game shader...

(define vertex-shader
  "
precision mediump float;
varying vec3 P;
varying vec3 T;
uniform mat4 ViewMatrix;
uniform mat4 CameraMatrix;
uniform mat4 LocalMatrix;
attribute vec3 p;
attribute vec3 t;
void main()
{
    mat4 ModelViewMatrix = ViewMatrix * CameraMatrix * LocalMatrix;
    P = p.xyz;
    T = t;
    gl_Position = ModelViewMatrix * vec4(p,1);
}")

(define fragment-shader
  "
precision mediump float;
varying vec3 P;
varying vec3 T;
uniform sampler2D texture;
void main() {
 gl_FragColor = texture2D(texture,vec2(T.s,T.t));

}
")
