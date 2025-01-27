;; Peer Review Contract

(define-map reviews
  { proposal-id: uint, reviewer: principal }
  {
    score: uint,
    comment: (string-utf8 500)
  }
)

(define-public (submit-review (proposal-id uint) (score uint) (comment (string-utf8 500)))
  (ok (map-set reviews
    { proposal-id: proposal-id, reviewer: tx-sender }
    {
      score: score,
      comment: comment
    }
  ))
)

(define-read-only (get-review (proposal-id uint) (reviewer principal))
  (map-get? reviews { proposal-id: proposal-id, reviewer: reviewer })
)

(define-read-only (get-review-score (proposal-id uint) (reviewer principal))
  (get score (default-to { score: u0, comment: u"" }
    (map-get? reviews { proposal-id: proposal-id, reviewer: reviewer })))
)

