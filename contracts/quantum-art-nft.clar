;; Quantum Art NFT Contract

(define-non-fungible-token quantum-art-nft uint)

(define-data-var token-id-counter uint u0)

(define-map token-metadata uint {
    creator: principal,
    artwork1-id: uint,
    artwork2-id: uint,
    entanglement-type: (string-ascii 50),
    quantum-signature: (string-utf8 500),
    creation-date: uint
})

(define-public (mint-entangled-artwork-nft (artwork1-id uint) (artwork2-id uint) (entanglement-type (string-ascii 50)) (quantum-signature (string-utf8 500)))
    (let
        ((new-id (+ (var-get token-id-counter) u1)))
        (asserts! (is-some (contract-call? .artwork-management get-artwork artwork1-id)) (err u404))
        (asserts! (is-some (contract-call? .artwork-management get-artwork artwork2-id)) (err u404))
        (try! (nft-mint? quantum-art-nft new-id tx-sender))
        (map-set token-metadata new-id {
            creator: tx-sender,
            artwork1-id: artwork1-id,
            artwork2-id: artwork2-id,
            entanglement-type: entanglement-type,
            quantum-signature: quantum-signature,
            creation-date: block-height
        })
        (var-set token-id-counter new-id)
        (ok new-id)
    )
)

(define-public (transfer (token-id uint) (sender principal) (recipient principal))
    (begin
        (asserts! (is-eq tx-sender sender) (err u403))
        (nft-transfer? quantum-art-nft token-id sender recipient)
    )
)

(define-read-only (get-token-metadata (token-id uint))
    (map-get? token-metadata token-id)
)

(define-read-only (get-last-token-id)
    (var-get token-id-counter)
)

