#lang racket

(require rackunit lang/posn
         2htdp/image 2htdp/universe)

; physical constants
(define SCENE-WIDTH 100)
(define SCENE-HEIGHT 100)

(define DOT-RADIUS 3)
(define DOT-COLOR "red")

; graphical constants
(define BACKGROUND
    (empty-scene SCENE-WIDTH SCENE-HEIGHT))

(define DOT
    (circle DOT-RADIUS "solid" DOT-COLOR))

; Posn -> Image
; adds a red dot to background at position
(define (scene+dot position)
    (place-image DOT
                (posn-x position)
                (posn-y position)
                BACKGROUND))

(check-equal? (scene+dot (make-posn 10 20))
    (place-image DOT 10 20 BACKGROUND))
(check-equal? (scene+dot (make-posn 88 73))
    (place-image DOT 88 73 BACKGROUND))


; Posn Number -> Posn
; replace x-coordinate of position for number
; such functions are called updaters or functional setters.
(define (posn-up-x position number)
    (make-posn number (posn-y position)))

(check-equal? (posn-up-x (make-posn 0 0) 20) (make-posn 20 0))
(check-equal? (posn-up-x (make-posn 12 20) 3) (make-posn 3 20))

; Posn -> Posn
; increase x coordinate of position by 3
(define (x+ position)
    (posn-up-x position (+ (posn-x position) 3)))

(check-equal? (x+ (make-posn 10 15)) (make-posn 13 15))
(check-equal? (x+ (make-posn 0 3)) (make-posn 3 3))


; Posn Number Number MouseEvent -> Posn
; for mouse clicks, (make-posn x y)
; otherwise p
(define (reset-dot position x y mouse-event)
    (cond
        [(string=? mouse-event "button-down") (make-posn x y)]
        [else position]))

(check-equal?
    (reset-dot (make-posn 10 20)
               29 31 "button-down")
    (make-posn 29 31))

(check-equal?
    (reset-dot (make-posn 10 20)
               29 31 "button-up")
    (make-posn 10 20))

; A Posn represents the state of the world

; Posn -> Posn
(define (main p0)
    (big-bang p0
        [on-tick x+]
        [on-mouse reset-dot]
        [to-draw scene+dot]))

(main (make-posn 0 50))