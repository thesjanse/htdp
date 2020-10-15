#lang racket

; create templates for functions that
; consume instances of the following
; structure types

(define-struct movie [title director year])

(define (movie-func mov)
    (... (movie-title mov)
     ... (movie-director mov)
     ... (movie-year mov) ...))

(define-struct pet [name number])

(define (pet-func p)
    (... (pet-name p)
     ... (pet-number) ...))

(define-struct cd [artist title price])

(define (cd-func c)
    (... (cd-artist c)
     ... (cd-title c)
     ... (cd-price c) ...))

(define-struct sweater [material size color])

(define (sweater-func sw)
    (... (sweater-material sw)
     ... (sweater-size sw)
     ... (sweater-color sw) ...))