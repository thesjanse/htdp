#lang racket

(require rackunit)

; Extract 1String from non-empty string
; String -> String
(define (string-first str)
    (substring str 0 1))


(check-equal? (string-first "Hello") "H")
(check-equal? (string-first "maybe") "m")
(check-equal? (string-first "run, Forest!") "r")
