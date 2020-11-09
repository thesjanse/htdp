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

(define PET11 (make-pet 50 "right" 1))
(define PET12 (make-pet 50 "left" 99))
(define PET13 (make-pet 50 "right" 50))

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


; Happiness -> Happiness
; decrease Happiness level by EFFORT-COST
(define (decrease-happiness h)
    (define next-h
        (- h EFFORT-COST))
    (cond
        [(<= next-h 0) h]
        [else next-h]))

(check-equal? (decrease-happiness 100) (- 100 EFFORT-COST))
(check-equal? (decrease-happiness 49) (- 49 EFFORT-COST))
(check-equal? (decrease-happiness 1) 1)

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
                        (decrease-happiness (pet-happiness p)))]))


(check-equal? (move PET1)
    (make-pet (move-right (pet-position PET1)) "right"
              (decrease-happiness (pet-happiness PET1))))

(check-equal? (move PET2)
    (make-pet (move-left (pet-position PET2)) "left"
              (decrease-happiness (pet-happiness PET2))))

(check-equal? (move PET3)
    (make-pet 25 "right" 100))

(check-equal? (move PET4)
    (make-pet 26 "right" 100))

(check-equal? (move PET5)
    (make-pet 27 "right" 100))

(check-equal? (move PET6)
    (make-pet (move-left (pet-position PET6)) "left"
              (decrease-happiness (pet-happiness PET6))))

(check-equal? (move PET7)
    (make-pet 175 "left" 100))

(check-equal? (move PET8)
    (make-pet 174 "left" 100))

(check-equal? (move PET9)
    (make-pet 173 "left" 100))

(check-equal? (move PET10)
    (make-pet (move-right (pet-position PET10)) "right"
              (decrease-happiness (pet-happiness PET10))))


; Pet KeyEvent -> Pet
; increase Happiness level by 33 points
; by pressing the up button
; increase Happiness level by 20 points
; by pressing the down button
(define (key-handler p ke)
    (define next
        (cond
            [(equal? ke "up") (+ 33 (pet-happiness p))]
            [(equal? ke "down") (+ 20 (pet-happiness p))]))
    (cond
        [(> next 100) (make-pet (pet-position p)
                                (pet-direction p)
                                100)]
        [else (make-pet (pet-position p)
                        (pet-direction p)
                        next)]))

(check-equal? (key-handler PET11 "up")
    (make-pet (pet-position PET11)
              (pet-direction PET11)
              (+ 33 (pet-happiness PET11))))
(check-equal? (key-handler PET12 "up")
    (make-pet (pet-position PET12)
              (pet-direction PET12)
              100))
(check-equal? (key-handler PET13 "up")
    (make-pet (pet-position PET13)
              (pet-direction PET13)
              (+ 33 (pet-happiness PET13))))
(check-equal? (key-handler PET11 "down")
    (make-pet (pet-position PET11)
              (pet-direction PET11)
              (+ 20 (pet-happiness PET11))))
(check-equal? (key-handler PET12 "down")
    (make-pet (pet-position PET12)
              (pet-direction PET12)
              100))
(check-equal? (key-handler PET13 "down")
    (make-pet (pet-position PET13)
              (pet-direction PET13)
              (+ 20 (pet-happiness PET13))))


(define (main p)
    (big-bang p
        [to-draw render-status]
        [on-tick move]
        [on-key key-handler]))

(main PET1)