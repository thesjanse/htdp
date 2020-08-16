#lang racket

(require rackunit)

; concatenate 2 strings with _ in between
; String String -> String
(define (string-join a b)
    (string-append a "_" b))

(check-equal? (string-join "" "") "_")
(check-equal? (string-join "" "hello") "_hello")
(check-equal? (string-join "hey" "buddy") "hey_buddy")
(check-equal? (string-join "." "hey") "._hey")