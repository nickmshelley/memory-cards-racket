#lang racket
(require db)

(provide add-category
         get-categories
         delete-category)

(define (add-category conn name)
  (query-exec conn
              "INSERT INTO category VALUES(?)"
              name))

(define (delete-category conn name)
  (query-exec conn
              "DELETE FROM category WHERE name=?"
              name))

(define (get-categories conn)
  (query-list conn
              "SELECT name FROM category"))
