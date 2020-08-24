#lang racket

(require rackunit)

; string-without-last
; String without last character

; String -> String [string-without-last]
; return String without the last character

(define (string-remove-last str)
    (substring str 0 (- (string-length str) 1)))


(check-equal? (string-remove-last "Hello") "Hell")
(check-equal? (string-remove-last "meow") "meo")