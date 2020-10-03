#lang racket

; Take a look at the following structure type definitions
; Write down the names of the functions
; (constructors, selectors, and predicates)
; that each introduces.

; constructor: make-movie
; selectors: movie-title, movie-producer, movie-year
; predicate: movie?
(define-struct movie [title producer year])

(define MOVIE
    (make-movie "Walker, Texas Ranger"
                "Paul Haggis"
                1993))
(movie-title MOVIE)
(movie-producer MOVIE)
(movie-year MOVIE)
(movie? MOVIE)

; constructor: make-person
; selectors: person-name, person-hair,
;            person-eyes, person-phone
; predicate: person?
(define-struct person [name hair eyes phone])
(define PERSON
    (make-person "John" "White"
                 "Blue" "20-40-50"))
(person-name PERSON)
(person-hair PERSON)
(person-eyes PERSON)
(person-phone PERSON)
(person? PERSON)

; constructor: make-pet
; selectors: pet-name, pet-number
; predicate: pet?
(define-struct pet [name number])
(define PET
    (make-pet "Rex" "12345532"))
(pet-name PET)
(pet-number PET)
(pet? PET)

; constructor: make-cd
; selectors: cd-artist, cd-title, cd-price
; predicate cd?
(define-struct cd [artist title price])
(define CD (make-cd "Mitch Murder" "Burning Chrome" 10))
(cd-artist CD)
(cd-title CD)
(cd-price CD)
(cd? CD)

; constructor: make-sweater
; selectors: sweater-material, sweater-size, sweater-producer
; predicate: sweater?
(define-struct sweater [material size producer])
(define SWEATER
    (make-sweater "Wool" "L" "India"))
(sweater-material SWEATER)
(sweater-size SWEATER)
(sweater-producer SWEATER)
(sweater? SWEATER)