#lang racket/base

(require gregor)
(require gregor/period)
(require racket/format)
(require racket/list)
(require racket/string)
(require racket/match)

(define (maybe-plural stem n)
  (if (= n 1) stem
      (~a stem
          (if (string-suffix? stem "s")
              "es"
              "s"))))

(define (non-empty p)
  (filter-not (λ (pair) (zero? (cdr pair)))
              (period->list p)))

;; Quizás usar una macro? En realidad lo único que necesito "matchear" es la
;; traducción.
(define/match (period-elem->string tup)
  [((cons 'years n)) (~a n " " (maybe-plural "año" n))]
  [((cons 'months n)) (~a n " " (maybe-plural "mes" n))])

(define (dates->period-string d1 d2)
  (let ([period (period-between d1 d2 '(years months))])
    (string-join
     (map period-elem->string (non-empty period))
     ", " #:before-last " y ")))

(define (fmt-dates d1 d2)
  (let ([d1str (~t d1 "yyyy")]
        [d2str (if (date=? d2 (today)) "Actualidad" (~t d2 "yyyy"))])
    (format "~a -- ~a (~a)" d1str d2str (dates->period-string d1 d2))))


;; Aquí definir tests
(module+ test
  (require rackunit)
  (check-equal? "meses" (maybe-plural "mes" 2)))

(provide fmt-dates)
