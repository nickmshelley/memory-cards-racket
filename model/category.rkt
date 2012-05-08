#lang racket
(require db)

(provide add-category
         get-categories)

(define (add-category conn name)
  (query-exec conn
              "INSERT INTO category VALUES(?)"
              name))

(define (get-categories conn)
  (query-list conn
              "SELECT name FROM category"))