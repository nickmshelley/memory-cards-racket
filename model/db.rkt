#lang racket
(require db)

(provide db-connection)

(define (init-db conn)
  (query-exec conn
              (string-append
               "CREATE TABLE category"
               "(name TEXT PRIMARY KEY)"))
  (query-exec conn 
              (string-append
               "CREATE TABLE card"
               "(cardid INTEGER PRIMARY KEY,"
               "category TEXT"
               "question TEXT,"
               "answer TEXT,"
               "review_level INTEGER,"
               "last_review_date DATE,"
               "status TEXT,"
               "FOREIGN KEY(category) REFERENCES category(name))")))

(define db-connection
  (if (file-exists? "database.db")
      (sqlite3-connect #:database "database.db")
      (begin
        (let ([c (sqlite3-connect #:database "database.db" #:mode 'create)])
          (init-db c)
          c))))
