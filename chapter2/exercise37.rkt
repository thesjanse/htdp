#lang racket

(require rackunit)

; String-minus-first-char is a String
; interpretation: represents the string without first character

; String -> String [String-minus-first-char]
; return a String without first character

(define (string-rest str)
    (substring str 1))


(check-equal? (string-rest "!Hello!") "Hello!")
(check-equal? (string-rest "meow") "eow")