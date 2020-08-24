#lang racket

(require rackunit)

; Last-Char is a String
; interpretation: represents the last character of a string

; String -> String
; Extract last character of a str
(define (string-last str)
    (substring str (- (string-length str) 1)
                   (string-length str)))

(check-equal? (string-last "Hello!") "!")
(check-equal? (string-last "meow") "w")