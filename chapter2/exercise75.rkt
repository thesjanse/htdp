#lang racket

(require rackunit lang/posn
         2htdp/image 2htdp/universe)

(define-struct ufo [loc vel] #:transparent)
; A UFO is a structure:
; (make-ufo Posn Vel)
; interpretation: (make-ufo position velocity)
; is at Position moving at Velocity

; A Vel is a structure:
; (make-vel deltax deltay)
; interpretation: (make-vel deltax deltay)
; is change in x and y directions
(define-struct vel [deltax deltay])

; definitions
(define v1 (make-vel 8 -3))
(define v2 (make-vel -5 -3))

(define p1 (make-posn 22 80))
(define p2 (make-posn 30 77))
(define p3 (make-posn 17 77))

(define u1 (make-ufo p1 v1))
(define u2 (make-ufo p1 v2))
(define u3 (make-ufo p2 v1))
(define u4 (make-ufo p2 v2))

(define u5 (make-ufo p3 v2))

; Posn Vel -> Posn
; adds velocity to position
(define (posn+ position velocity)
    (make-posn (+ (posn-x position) (vel-deltax velocity))
               (+ (posn-y position) (vel-deltay velocity))))

(check-equal? (posn+ p1 v1) p2)
(check-equal? (posn+ p1 v2) p3)

; UFO -> UFO
; determines where ufo moves in one clock tick
; leaves the velocity as is
(define (ufo-move-1 ufo)
    (make-ufo (posn+ (ufo-loc ufo)
                     (ufo-vel ufo))
              (ufo-vel ufo)))

(check-equal? (ufo-move-1 u1) u3)
(check-equal? (ufo-move-1 u2) u5)