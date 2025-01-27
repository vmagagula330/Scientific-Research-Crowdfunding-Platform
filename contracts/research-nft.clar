;; Research NFT Contract

(define-non-fungible-token research-nft uint)

(define-map token-metadata
  { token-id: uint }
  {
    proposal-id: uint,
    title: (string-ascii 100),
    description: (string-utf8 500),
    researcher: principal
  }
)

(define-data-var nft-nonce uint u0)

(define-public (mint-research-nft (proposal-id uint) (title (string-ascii 100)) (description (string-utf8 500)))
  (let
    ((new-id (+ (var-get nft-nonce) u1)))
    (try! (nft-mint? research-nft new-id tx-sender))
    (map-set token-metadata
      { token-id: new-id }
      {
        proposal-id: proposal-id,
        title: title,
        description: description,
        researcher: tx-sender
      }
    )
    (var-set nft-nonce new-id)
    (ok new-id)
  )
)

(define-read-only (get-token-metadata (token-id uint))
  (map-get? token-metadata { token-id: token-id })
)

(define-read-only (get-last-token-id)
  (var-get nft-nonce)
)

