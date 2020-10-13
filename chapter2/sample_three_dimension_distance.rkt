#lang racket

(require rackunit)

; Desing a function that computes the distance
; of objects in 3-dimensional space to origin

(define-struct r3 [x y z])
; R3 is a structure:
; (make-r3 Number Number Number)
; -- "x" is the x coordinate of a point
; -- "y" is the y coordinate of a point
; -- "z" is the z coordinate of a point

(define ex1 (make-r3 1 2 13))
(define ex2 (make-r3 -1 0 3))


; Number -> Number
; Compute square of a given number
(define (square x)
    (* x x))

(check-equal? (square 5) 25)
(check-equal? (square -2) 4)
(check-equal? (square 0) 0)


; R3 -> Number
; Compute distance from the R3 to
; the origin in 3-dimensional space
(define (3-distance point)
    (sqrt (+ (square (r3-x point))
             (square (r3-y point))
             (square (r3-z point)))))

(check-equal? (3-distance ex1)
    (sqrt (+ (square 1)
             (square 2)
             (square 13))))

(check-equal? (3-distance ex2)
    (sqrt (+ (square -1)
             (square 0)
             (square 3))))