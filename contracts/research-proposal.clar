;; Research Proposal Contract

(define-map proposals
  { proposal-id: uint }
  {
    title: (string-ascii 100),
    description: (string-utf8 1000),
    researcher: principal,
    funding-goal: uint,
    status: (string-ascii 20)
  }
)

(define-data-var proposal-nonce uint u0)

(define-public (submit-proposal (title (string-ascii 100)) (description (string-utf8 1000)) (funding-goal uint))
  (let
    ((new-id (+ (var-get proposal-nonce) u1)))
    (map-set proposals
      { proposal-id: new-id }
      {
        title: title,
        description: description,
        researcher: tx-sender,
        funding-goal: funding-goal,
        status: "pending"
      }
    )
    (var-set proposal-nonce new-id)
    (ok new-id)
  )
)

(define-read-only (get-proposal (proposal-id uint))
  (map-get? proposals { proposal-id: proposal-id })
)

(define-public (update-proposal-status (proposal-id uint) (new-status (string-ascii 20)))
  (let
    ((proposal (unwrap! (map-get? proposals { proposal-id: proposal-id }) (err u404))))
    (asserts! (is-eq tx-sender (get researcher proposal)) (err u403))
    (ok (map-set proposals
      { proposal-id: proposal-id }
      (merge proposal { status: new-status })
    ))
  )
)

(define-read-only (get-proposal-count)
  (var-get proposal-nonce)
)

