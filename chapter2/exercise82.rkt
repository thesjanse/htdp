#lang racket

(require rackunit)

; Desing the function compare-word.
; Function consumes three-letter words.
; It produces a word that indicates
; where the given ones agree and disagree.
; The function retains the content of the
; structure fields if the two agree;
; otherwise it places #false in the field
; of the resulting word.

; Letter is one of the
; -- #false
; -- 1String [a, z]
; interpretation: #false represents missmatch between letters
; 1String denotes equal letter

(define-struct word [first second third] #:transparent)
; Word is a structure
; (make-word Letter Letter Letter)

(define W1 (make-word "h" "e" "n"))
(define W2 (make-word "h" "a" "m"))
(define W3 (make-word "h" "e" "r"))
(define W4 (make-word "h" #false #false))
(define W5 (make-word "h" "e" #false))

; Letter Letter -> Boolean
; compare letters, if they are equal then return letter
; if they are not, return #false
(define (compare-letter a b)
    (cond
        [(string=? a b) a]
        [else #false]))

(check-equal? (compare-letter "h" "h") "h")
(check-equal? (compare-letter "e" "a") #false)
(check-equal? (compare-letter "n" "m") #false)


; Word Word -> Word
; Compare two words letter by letter.
; Return a new word with equal letters or
; #false inplace of not equal letters.

(define (compare-word w1 w2)
    (make-word (compare-letter (word-first w1) (word-first w2))
               (compare-letter (word-second w1) (word-second w2))
               (compare-letter (word-third w1) (word-third w2))))

(check-equal? (compare-word W1 W2) W4)
(check-equal? (compare-word W1 W3) W5)
(check-equal? (compare-word W2 W3) W4)