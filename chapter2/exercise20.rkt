#lang racket

(require rackunit)

; delete the char from string at index
; String -> String
(define (string-delete str index)
    (cond ((= index 0)
                (substring str 1))
          ((= index (- (string-length str) 1))
                (substring str 0 index))
          ((< index (string-length str))
                (string-append (substring str 0 index)
                               (substring str (+ index 1))))))

(check-equal? (string-delete "Hello" 1) "Hllo")
(check-equal? (string-delete "Hello" 0) "ello")
(check-equal? (string-delete "Hello" 4) "Hell")
(check-equal? (string-delete "h" 0) "")
