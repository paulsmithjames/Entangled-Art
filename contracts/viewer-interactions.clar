;; Viewer Interactions Contract

(define-data-var interaction-counter uint u0)

(define-map viewer-interactions uint {
    viewer: principal,
    artwork-id: uint,
    interaction-type: (string-ascii 50),
    timestamp: uint,
    quantum-influence: (string-utf8 500)
})

(define-public (record-interaction (artwork-id uint) (interaction-type (string-ascii 50)) (quantum-influence (string-utf8 500)))
    (let
        ((new-id (+ (var-get interaction-counter) u1)))
        (asserts! (is-some (contract-call? .artwork-management get-artwork artwork-id)) (err u404))
        (map-set viewer-interactions new-id {
            viewer: tx-sender,
            artwork-id: artwork-id,
            interaction-type: interaction-type,
            timestamp: block-height,
            quantum-influence: quantum-influence
        })
        (var-set interaction-counter new-id)
        (ok new-id)
    )
)

(define-read-only (get-interaction (interaction-id uint))
    (map-get? viewer-interactions interaction-id)
)

(define-read-only (get-interactions-for-artwork (artwork-id uint))
    (filter (lambda (interaction)
        (is-eq (get artwork-id interaction) artwork-id))
    (map-to-list viewer-interactions))
)

(define-read-only (get-interaction-count)
    (var-get interaction-counter)
)

