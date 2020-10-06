#lang racket

; Formulate data definition for the
; phone structure type definition that
; accomodates given examples.

; A Centry is a structure:
;   (make-centry String Phone Phone Phone)
; interpretation: (make-centry name home office cell) means
; a name of the phone numbers owner
; home phone number,
; office phone number and
; cell phone number
(define-struct centry [name home office cell])

; A Phone is a structure:
;   (make-phone Number Number)
; interpretation: (make-phone area number) means
; an area code
; a phone number
(define-struct phone [area number])

; Formulate data definition for phone
; numbers using the structure type definition

; A Phone# is a structure:
;   (make-phone# Number Number Number)
; interpretation: (make-phone# area switch num) means
; a three digit area code,
; a three digit switch code
; a four digit number for the neighborhood
(define-struct phone# [area switch num])
