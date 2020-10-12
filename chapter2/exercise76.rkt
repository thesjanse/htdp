#lang racket
(require lang/posn)

; seems like posn is just a container
; you can add strings to it
(make-posn "junk" "posn")

; Formulate data definitions for the next structure type definitions.

(define-struct movie [title producer year])
; Movie is a (make-movie String String Number)
; interpretation: movie is represented by the metadata
; -- "title" String - name of the movie
; -- "producer" String - name of the movie producer
; -- "year" Number - year of movie creation

(define-struct person [name hair eyes phone])
; Person is a (make-person String String String String)
; interpretation: person description, where
; "name" String is a name of the person
; "hair" String is a color of hair
; "eyes" String is a color of eyes
; "phone" String is a phone number with '-'

; or
; Person is a (make-person String String String Number)
; Person is a (make-person String String String String)
; interpretation: person description, where
; "name" String is a name of the person
; "hair" String is a color of hair
; "eyes" String is a color of eyes
; "phone" Number is a phone number with '-'


(define-struct pet [name number])
; Pet is a (make-pet String String)
; interpretation: is a pet with
; -- "name" String is a pet name
; -- "phone" String representation of a
;            phone number of the owner
; or
; Pet is a (make-pet String Number)
; interpretation: is a pet with
; "name" String is a a pet name
; "phone" Number is a phone number of the owner


(define-struct CD [artist title price])
; CD is a (make-cd String String Number)
; interpretation: cd is a catalog entry
;                 of musical cd drive in a shop
; -- "artist" String is an artist name
; -- "title" String is a cd album title
; -- "price" Number is a cost of an album


(define-struct sweater [material size producer])
; Sweater is a (make-sweater String String String)
; interpretation: sweater catalog entry in a shop
; -- "material" String is a material of a sweater
; -- "size" String is 1-2 character representation of the
;           sweater size
; -- "producer" String is a name of a producer company