#lang racket

(require rackunit)

; if sunny is False or friday is True -> True
; Boolean, Boolean -> Boolean
(define (implication sunny friday)
    (or (equal? sunny #f)
        (equal? friday #t)))

(check-equal? (implication #f #t) #t)
(check-equal? (implication #t #t) #t)
(check-equal? (implication #t #f) #f)
(check-equal? (implication #f #f) #t)
