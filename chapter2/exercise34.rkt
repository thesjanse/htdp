#lang racket
(require rackunit)

; first-char is a String
; interpretation: represents the first character of a string

; String -> String
; extract the first character from the str string

(define (string-first str)
    (substring str 0 1))

(check-equal? (string-first "Hello") "H")
(check-equal? (string-first "meow") "m")