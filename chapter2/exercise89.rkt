#lang racket

; TODO make pet walk right and left (direction variable)

(require rackunit 2htdp/image 2htdp/universe)

; define a structure type that keeps track
; of the cat's x-coordinate and its happiness.
; formulate data definition for cats dubbed VCat,
; including its interpretation.

; design happy-cat program, which manages a walking
; cat and its happiness level. Cat starts out with
; perfect happiness.

(define-struct VCat [x h] #:transparent)
; VCat is a structure:
; (make-VCat Number Number),
; where x represents the x-coordinate of the cat
; and h stores the happiness level of the cat
(define CAT1 (make-VCat 35 100))


; Happiness is a Number [0, 100]
; interpretation: represents the happiness level


; Physical Constants
(define WIDTH 200)
(define HEIGHT 200)
(define RADIUS 25)
(define SPEED 3)
(define DETERIORATION-SPEED 1)
(define COLOR "yellow")

; Graphical Constants
(define BACKGROUND (empty-scene WIDTH HEIGHT))
(define CAT (circle RADIUS "solid" COLOR))

; Additional definitions
(define CAT2 (make-VCat (- (+ WIDTH RADIUS) DETERIORATION-SPEED) 100))
(define CAT3 (make-VCat (+ WIDTH RADIUS) 100))


; VCat -> Image
; render the VCat structure into image
(define (render vc)
    (place-image CAT (VCat-x vc)
                 (- HEIGHT RADIUS) BACKGROUND))

(check-equal? (render CAT1)
    (place-image CAT (VCat-x CAT1)
                 (- HEIGHT RADIUS) BACKGROUND))


; Number -> Number
; add 3 pixels to the initial number
(define (move-right n)
    (+ n 3))

(check-equal? (move-right 5) (+ SPEED 5))
(check-equal? (move-right 0) (+ SPEED 0))
(check-equal? (move-right 100) (+ SPEED 100))


; Number -> Number
; decrease happiness with each step
(define (decrease-happiness n)
    (cond
        [(<= n 1) n]
        [else (- n 1)]))

(check-equal? (decrease-happiness 100) (- 100 DETERIORATION-SPEED))
(check-equal? (decrease-happiness 48) (- 48 DETERIORATION-SPEED))
(check-equal? (decrease-happiness 0) 0)
(check-equal? (decrease-happiness 1) 1)


; VCat -> VCat
; Move VCat depending on the direction
(define (move vc)
    (define next-step (move-right (VCat-x vc)))
    (make-VCat
        (cond
            [(<= (+ WIDTH RADIUS) next-step) (- next-step WIDTH (* RADIUS 2))]
            [else next-step])
        (decrease-happiness (VCat-h vc))))

(check-equal? (move CAT1)
    (make-VCat (move-right (VCat-x CAT1))
               (decrease-happiness (VCat-h CAT1))))

(check-equal? (move CAT2)
    (make-VCat (move-right (- (+ RADIUS DETERIORATION-SPEED)))
               (decrease-happiness (VCat-h CAT2))))

(check-equal? (move CAT3)
    (make-VCat (move-right (- RADIUS))
               (decrease-happiness (VCat-h CAT3))))

(define (main vc)
    (big-bang vc
        [to-draw render]
        [on-tick move]))

(main CAT1)
