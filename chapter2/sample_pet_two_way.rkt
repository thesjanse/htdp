#lang racket

(require rackunit 2htdp/image 2htdp/universe)

; TODO move: add boundary examples

(define-struct pet [position direction happiness] #:transparent)
; Pet is a structure
; (make-pet Number String Number), where position is the x
; coordinate of the pet; direction is the current movement direction
; of a pet; happiness is the happiness of a pet.

(define PET1 (make-pet 25 "right" 100))
(define PET2 (make-pet 175 "left" 100))

(define PET3 (make-pet 25 "left" 100))
(define PET4 (make-pet 26 "left" 100))
(define PET5 (make-pet 27 "left" 100))
(define PET6 (make-pet 28 "left" 100))

(define PET7 (make-pet 175 "right" 100))
(define PET8 (make-pet 174 "right" 100))
(define PET9 (make-pet 173 "right" 100))
(define PET10 (make-pet 172 "right" 100))

; Direction is an enumeration:
; -- "right" side direction or
; -- "left" side direction

; Happiness is an interval [1, 100]
; interpretation: happiness level of the pet

; Physical Constants
(define WIDTH 200)
(define HEIGHT 100)
(define STEP 3)
(define EFFORT-COST 1)
(define BODY-RADIUS 25)
(define PET-Y (- HEIGHT BODY-RADIUS))
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
(define HAPPINESS-COLOR "Black")


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
    (place-image PET-IMAGE (pet-position p) PET-Y BACKGROUND))

(check-equal? (render PET1)
    (place-image PET-IMAGE (pet-position PET1)
                 PET-Y BACKGROUND))

(check-equal? (render PET2)
    (place-image PET-IMAGE (pet-position PET2)
                 PET-Y BACKGROUND))


; Pet -> Image
; render the happiness level of the pet
; in top right corner of the canvas
(define (render-status p)
    (define text-img
        (text (number->string (pet-happiness p))
              12 HAPPINESS-COLOR))
    (place-image text-img
                 (- WIDTH (image-width text-img))
                 (image-height text-img)
                 (render p)))

(check-equal? (render-status PET1)
    (place-image (text (number->string (pet-happiness PET1))
                       12 HAPPINESS-COLOR)
                 (- WIDTH (image-width (text (number->string (pet-happiness PET1))
                                        12 HAPPINESS-COLOR)))
                 (image-height (text (number->string (pet-happiness PET1))
                                     12 HAPPINESS-COLOR))
                 (render PET1)))

; Number -> Number
; move right by STEP pixels
(define (move-right x)
    (+ x STEP))

(check-equal? (move-right 5) (+ 5 STEP))
(check-equal? (move-right 1) (+ 1 STEP))
(check-equal? (move-right 0) (+ 0 STEP))


; Number -> Number
; move left STEP pixels
(define (move-left x)
    (- x STEP))

(check-equal? (move-left 5) (- 5 STEP))
(check-equal? (move-left STEP) (- STEP STEP))

; Pet -> Pet
; move pet on a canvas with a STEP
; moving decreases happiness by EFFORT-COST
(define (move p)
    (define next-pos
        (cond
            [(equal? (pet-direction p) "left")
                (move-left (pet-position p))]
            [(equal? (pet-direction p) "right")
                (move-right (pet-position p))]))
    (cond
        [(> next-pos (- WIDTH BODY-RADIUS))
            (make-pet (pet-position p) "left"
                      (pet-happiness p))]
        [(< next-pos BODY-RADIUS)
            (make-pet (pet-position p) "right"
                      (pet-happiness p))]
        [else (make-pet next-pos (pet-direction p)
                        (- (pet-happiness p) 1))]))


(check-equal? (move PET1)
    (make-pet (move-right (pet-position PET1)) "right"
              (- (pet-happiness PET1) EFFORT-COST)))

(check-equal? (move PET2)
    (make-pet (move-left (pet-position PET2)) "left"
              (- (pet-happiness PET2) EFFORT-COST)))

(check-equal? (move PET3)
    (make-pet 25 "right" 100))

(check-equal? (move PET4)
    (make-pet 26 "right" 100))

(check-equal? (move PET5)
    (make-pet 27 "right" 100))

(check-equal? (move PET6)
    (make-pet (move-left (pet-position PET6)) "left"
              (- (pet-happiness PET6) EFFORT-COST)))

(check-equal? (move PET7)
    (make-pet 175 "left" 100))

(check-equal? (move PET8)
    (make-pet 174 "left" 100))

(check-equal? (move PET9)
    (make-pet 173 "left" 100))

(check-equal? (move PET10)
    (make-pet (move-right (pet-position PET10)) "right"
              (- (pet-happiness PET10) 1)))

(define (main p)
    (big-bang p
        [to-draw render-status]
        [on-tick move]))

(main PET1)