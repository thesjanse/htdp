#lang racket

; exercise12
(require rackunit)

; calculate the volume of the equalateral cube
; Number (cm) -> Number (cubic cm)
(define (cube-volume x)
    (if (< x 0)
        0
        (* x x x)))

(check-equal? (cube-volume 0) 0)
(check-equal? (cube-volume 2) 8)
(check-equal? (cube-volume -3) 0)
(check-equal? (cube-volume 3) 27)
