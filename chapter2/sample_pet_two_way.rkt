#lang racket

(require rackunit 2htdp/image 2htdp/universe)


(define-struct pet [position direction happiness] #:transparent)
; Pet is a structure
; (make-pet Number String Number), where position is the x
; coordinate of the pet; direction is the current movement direction
; of a pet; happiness is the happiness of a pet.

(define PET1 (make-pet 25 "right" 100))
(define PET2 (make-pet 175 "left" 100))

; Direction is an enumeration:
; -- "right" side direction or
; -- "left" side direction

; Happiness is an interval [1, 100]
; interpretation: happiness level of the pet

; Physical Constants
(define WIDTH 200)
(define HEIGHT 100)
(define SPEED 3)
(define EFFORT-COST 1)
(define BODY-RADIUS 25)
(define LEG-WIDTH 16)
(define LEG-HEIGHT 10)
(define NOSE-WIDTH (/ LEG-WIDTH 2))
(define NOSE-HEIGHT (/ LEG-HEIGHT 2))
(define EYE-WIDTH (/ LEG-WIDTH 4))
(define EYE-HEIGHT LEG-HEIGHT)
(define BODY-COLOR "Orange")
(define LEG-COLOR "DarkOrange")
(define NOSE-COLOR "Black")
(define EYE-COLOR "CadetBlue")


; Graphical Constants
(define BACKGROUND (empty-scene WIDTH HEIGHT))
(define PET-BODY (circle BODY-RADIUS "solid" BODY-COLOR))
(define PET-LEG
    (ellipse LEG-WIDTH LEG-HEIGHT "solid" LEG-COLOR))
(define PET-NOSE
    (ellipse NOSE-WIDTH NOSE-HEIGHT "solid" NOSE-COLOR))
(define PET-EYE
    (ellipse EYE-WIDTH EYE-HEIGHT "solid" EYE-COLOR))

(define PET-IMAGE
  (underlay/align/offset "center" "center"
    (underlay/align/offset "center" "center"
      (underlay/align/offset "center" "center"
        (underlay/align/offset "center" "center"
          (underlay/align/offset "center" "center" PET-BODY LEG-WIDTH 20 PET-LEG)
          (- LEG-WIDTH) 20 PET-LEG)
        0 0 PET-NOSE)
      NOSE-WIDTH (- EYE-HEIGHT) PET-EYE)
      (- NOSE-WIDTH) (- EYE-HEIGHT) PET-EYE))


; Pet -> Image
; render the pet image on a canvas based on its position
(define (render p)
    BACKGROUND)


; Pet -> Pet
; move pet on a canvas with a SPEED
; moving decreases happiness by EFFORT-COST
(define (move p)
    p)


;;; (define (main p)
;;;     (big-bang p
;;;         [to-draw render]
;;;         [on-tick move]))