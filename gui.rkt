#lang racket/gui
(require rackunit
         db)

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
      (begin
        (printf "~nexists~n")
        (sqlite3-connect #:database "database.db"))
      (begin
        (printf "~ndoesn't exist~n")
        (let ([c (sqlite3-connect #:database "database.db" #:mode 'create)])
          (init-db c)
          c))))

(struct category (name cards) #:transparent)
(struct card (question answer review-level
                       last-review-date status) #:transparent)

(define (generate-test-data num-categories cards-per-category)
  (for/list ([i (in-range num-categories)])
    (category (format "Category ~a" i)
              (for/list ([j (in-range cards-per-category)])
                (card (format "Question ~a" j)
                      (format "Answer ~a" j)
                      j
                      (today-minus j)
                      'ready)))))

(define (today-minus num-days)
  (define seconds-in-day
    (* 60 60 24))
  (seconds->date
   (- (current-seconds)
       (* num-days seconds-in-day))))

(define test-categories (generate-test-data 4 50))

(define frame 
  (new frame%
       [label "Memory Cards"]
       [width 500]
       [height 500]))

(define title-font (send the-font-list find-or-create-font
                         20 'default 'normal 'bold))

(define main-panel
  (new horizontal-panel%
       [parent frame]))

(define categories-panel
  (new vertical-panel% 
       [parent main-panel]
       [style '(border auto-vscroll)]
       [alignment '(left top)]
       [stretchable-width #f]))

(define categories-title
  (new message%
       [parent categories-panel]
       [label "Categories"]
       [font title-font]))

(define no-category-panel
  (new horizontal-panel%
       [parent main-panel]
       [style '(border)]
       [alignment '(center center)]))

(for ([cat test-categories])
  (new button%
       [parent categories-panel]
       [label (category-name cat)]
       [callback
        (lambda (b e)
          (send main-panel delete-child no-category-panel)
          (display-category cat))]))

(define no-category-title
  (new message%
       [parent no-category-panel]
       [label "Choose a category on the left"]
       [font title-font]))

(define (display-category cat)
  (define pan
    (new vertical-panel%
         [parent main-panel]
         [style '(border auto-vscroll)]))
  (new message%
       [parent pan]
       [label (category-name cat)]
       [font title-font])
  (display-stats cat pan)
  pan)

(define (display-stats cat parent)
  (define pan (new vertical-panel%
                   [parent parent]
                   [alignment '(left top)]))
  (define levels (review-levels (category-cards cat)))
  (new message%
       [parent pan]
       [label "Review Level\t\tTotal\tNeeds Review\tFuture Review"])
  (for ([i (in-range (add1 (apply max levels)))])
    (define num (count (lambda (v)
                         (= v i))
                       levels))
    (new message%
         [parent pan]
         [label (format "~a:\t\t~a" i num)])))

(define (review-levels cards)
  (map card-review-level cards))
       

(send frame show #t)
