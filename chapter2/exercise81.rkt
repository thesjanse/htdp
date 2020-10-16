#lang racket

(require rackunit)

; Define the function time->seconds, which
; consumes instances of time structures and
; produces the number of seconds that have passed
; since midnight.

(define-struct time [hours minutes seconds])
; Time is a structure:
; (make-time Number Number Number)
; -- "hours" number of hours [0, 23]
; -- "minutes" number of minutes [0,59]
; -- "seconds" number of seconds [0, 59]

(define T1 (make-time 12 30 2))
(define T2 (make-time 0 0 0))
(define T3 (make-time 23 59 59))
(define T4 (make-time 10 10 10))


; Time -> Number
; Count number of seconds that have passed
; since midnight
(define (time->seconds t)
    (+ (* (time-hours t) 60 60)
       (* (time-minutes t) 60)
       (time-seconds t)))

(check-equal? (time->seconds T1)
    (+ (* (time-hours T1) 60 60)
       (* (time-minutes T1) 60)
       (time-seconds T1)))

(check-equal? (time->seconds T2)
    (+ (* (time-hours T2) 60 60)
       (* (time-minutes T2) 60)
       (time-seconds T2)))

(check-equal? (time->seconds T3)
    (+ (* (time-hours T3) 60 60)
       (* (time-minutes T3) 60)
       (time-seconds T3)))

(check-equal? (time->seconds T4)
    (+ (* (time-hours T4) 60 60)
       (* (time-minutes T4) 60)
       (time-seconds T4)))