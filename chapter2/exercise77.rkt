#lang racket

(define-struct time [hours minutes seconds])
; Time is a (make-time Number Number Number)
; interpretation: time is numerical representation
;                 of time since midnight
; -- "hours" Number Interval [0, 24) representing hours
; -- "minutes" Number Interval [0, 59] representing minutes
; -- "seconds" Number Interval [0, 59] representing seconds