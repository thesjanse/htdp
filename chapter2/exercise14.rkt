#lang racket

(require rackunit)

; Extract last char from non-empty string
; String -> String
(define (string-last str)
    (substring str (- (string-length str) 1)))

(check-equal? (string-last "Hello!") "!")
(check-equal? (string-last "meow") "w")
(check-equal? (string-last "hello ") " ")