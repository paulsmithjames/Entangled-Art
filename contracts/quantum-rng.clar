;; Quantum Random Number Generator Contract

(define-data-var last-random-number uint u0)
(define-data-var update-frequency uint u10) ;; Update every 10 blocks

(define-public (request-random-number)
    (let
        ((current-block (unwrap-panic (get-block-info? height u0))))
        (if (>= (- current-block (var-get last-random-number)) (var-get update-frequency))
            (let
                ((new-random (get-random)))
                (var-set last-random-number current-block)
                (ok new-random))
            (ok (var-get last-random-number))
        )
    )
)

(define-private (get-random)
    (mod (+ (char-to-uint (unwrap-panic (element-at? (unwrap-panic (get-block-info? id u0)) u0))) block-height) u1000000)
)

(define-read-only (get-last-random)
    (ok (var-get last-random-number))
)

(define-public (set-update-frequency (new-frequency uint))
    (begin
        (asserts! (is-eq tx-sender (contract-call? .artwork-management get-contract-owner)) (err u403))
        (ok (var-set update-frequency new-frequency))
    )
)

