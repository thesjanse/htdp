#lang racket

; exercise 11
(require rackunit)

(define (distance-to-origin x y)
    (sqrt (+ (square x)
             (square y))))

(define (square x)
    (* x x))

(check-equal? (distance-to-origin 6 6) (sqrt (+ (square 6) (square 6))))
(check-equal? (distance-to-origin 6 6) (sqrt (+ (square 6) (square -6))))
(check-equal? (distance-to-origin 1 2) (sqrt (+ (square 1) (square 2))))
(check-equal? (distance-to-origin 0 0) 0)
