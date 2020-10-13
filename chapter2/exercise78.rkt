#lang racket

; Provide a structure type and data
; definition for representing three-letter words.

(define-struct word [first second third flag])
; Word is a (make-word 1String 1String 1String Boolean)
; three-letter word represented by
; lower-case 1Strings [a-z] and
; a boolean flag