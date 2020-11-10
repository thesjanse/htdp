#lang racket

(require rackunit 2htdp/image 2htdp/universe)

; TODO key-handler, gauge render

(define-struct pet [position happiness] #:transparent)
; Pet is a structure
; (make-pet Number String Number), where position is the x
; coordinate of the pet; happiness is the happiness of a pet.

(define PET1 (make-pet 25 100))
(define PET2 (make-pet 175 100))

(define PET3 (make-pet 174 100))
(define PET4 (make-pet 173 100))
(define PET5 (make-pet 172 100))

(define PET6 (make-pet 50 1))
(define PET7 (make-pet 50 99))
(define PET8 (make-pet 50 50))

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


; Happiness -> Happiness
; decrease Happiness level by EFFORT-COST
(define (decrease-happiness h)
    (- h EFFORT-COST))

(check-equal? (decrease-happiness 100) (- 100 EFFORT-COST))
(check-equal? (decrease-happiness 49) (- 49 EFFORT-COST))
(check-equal? (decrease-happiness 1) 0)
(check-equal? (decrease-happiness 0) -1)


; Pet -> Pet
; move pet on a canvas with a STEP
; moving decreases happiness by EFFORT-COST
(define (move p)
    (define next-move
        (move-right (pet-position p)))
    (cond
        [(<= next-move (- WIDTH BODY-RADIUS))
            (make-pet next-move
            (decrease-happiness (pet-happiness p)))]
        [else (make-pet BODY-RADIUS (pet-happiness p))]))

(check-equal? (move PET1)
    (make-pet (move-right (pet-position PET1))
              (decrease-happiness (pet-happiness PET1))))

(check-equal? (move PET2)
    (make-pet BODY-RADIUS
              (pet-happiness PET2)))

(check-equal? (move PET3)
    (make-pet BODY-RADIUS
              (pet-happiness PET3)))

(check-equal? (move PET4)
    (make-pet BODY-RADIUS
              (pet-happiness PET4)))

(check-equal? (move PET5)
    (make-pet (move-right (pet-position PET5))
              (decrease-happiness (pet-happiness PET5))))


; Pet -> Boolean
; Returns True if happiness of pet reaches 0
(define (unhappy? p)
    (cond
        [(equal? (pet-happiness p) 0) #t]
        [else #f]))

(check-equal? (unhappy? (make-pet 50 100)) #f)
(check-equal? (unhappy? (make-pet 50 49)) #f)
(check-equal? (unhappy? (make-pet 50 1)) #f)
(check-equal? (unhappy? (make-pet 50 0)) #t)


; Pet KeyEvent -> Pet
; increase Happiness level by 33 points
; by pressing the up button
; increase Happiness level by 20 points
; by pressing the down button
;;; (define (key-handler p ke)
;;;     (define next
;;;         (+ 2 (pet-happiness p)))
;;;     (cond

;;;         [(> next 100) (make-pet (pet-position p)
;;;                                 (pet-direction p)
;;;                                 100)]
;;;         [else (make-pet (pet-position p)
;;;                         (pet-direction p)
;;;                         next)]))

;;; (check-equal? (key-handler PET6 "down")
;;;     (make-pet (pet-position PET6)
;;;               (+ 20 (pet-happiness PET6))))
;;; (check-equal? (key-handler PET7 "down")
;;;     (make-pet (pet-position PET7)
;;;               100))
;;; (check-equal? (key-handler PET8 "down")
;;;     (make-pet (pet-position PET8)
;;;               (+ 20 (pet-happiness PET8))))


(define (main p)
    (big-bang p
        [to-draw render-status]
        [on-tick move]
        [on-key key-handler]
        [stop-when unhappy?]))

(main PET1)