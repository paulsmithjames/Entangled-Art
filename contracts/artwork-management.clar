;; Artwork Management Contract

(define-data-var artwork-counter uint u0)

(define-map artworks uint {
    creator: principal,
    title: (string-ascii 100),
    description: (string-utf8 1000),
    creation-date: uint,
    last-updated: uint,
    quantum-state: (string-ascii 50)
})

(define-public (create-artwork (title (string-ascii 100)) (description (string-utf8 1000)) (quantum-state (string-ascii 50)))
    (let
        ((new-id (+ (var-get artwork-counter) u1)))
        (map-set artworks new-id {
            creator: tx-sender,
            title: title,
            description: description,
            creation-date: block-height,
            last-updated: block-height,
            quantum-state: quantum-state
        })
        (var-set artwork-counter new-id)
        (ok new-id)
    )
)

(define-public (update-artwork (artwork-id uint) (new-title (string-ascii 100)) (new-description (string-utf8 1000)) (new-quantum-state (string-ascii 50)))
    (let
        ((artwork (unwrap! (map-get? artworks artwork-id) (err u404))))
        (asserts! (is-eq tx-sender (get creator artwork)) (err u403))
        (ok (map-set artworks artwork-id
            (merge artwork {
                title: new-title,
                description: new-description,
                quantum-state: new-quantum-state,
                last-updated: block-height
            })))
    )
)

(define-read-only (get-artwork (artwork-id uint))
    (map-get? artworks artwork-id)
)

(define-read-only (get-artwork-count)
    (var-get artwork-counter)
)

