;; Access Point Management Contract
;; Monitors network coverage and performance

;; Constants
(define-constant CONTRACT-OWNER tx-sender)
(define-constant ERR-NOT-AUTHORIZED (err u100))
(define-constant ERR-ACCESS-POINT-EXISTS (err u101))
(define-constant ERR-ACCESS-POINT-NOT-FOUND (err u102))
(define-constant ERR-INVALID-STATUS (err u103))
(define-constant ERR-INVALID-CAPACITY (err u104))

;; Data Variables
(define-data-var next-access-point-id uint u1)

;; Data Maps
(define-map access-points
  { access-point-id: uint }
  {
    operator: principal,
    location: { latitude: int, longitude: int },
    capacity: uint,
    status: (string-ascii 20),
    performance-score: uint,
    last-updated: uint
  }
)

(define-map access-point-by-name
  { name: (string-ascii 50) }
  { access-point-id: uint }
)

(define-map operator-access-points
  { operator: principal }
  { access-point-ids: (list 100 uint) }
)

;; Public Functions

;; Register a new access point
(define-public (register-access-point (name (string-ascii 50)) (location { latitude: int, longitude: int }) (capacity uint))
  (let
    (
      (access-point-id (var-get next-access-point-id))
      (operator tx-sender)
    )
    (asserts! (> capacity u0) ERR-INVALID-CAPACITY)
    (asserts! (is-none (map-get? access-point-by-name { name: name })) ERR-ACCESS-POINT-EXISTS)

    ;; Store access point data
    (map-set access-points
      { access-point-id: access-point-id }
      {
        operator: operator,
        location: location,
        capacity: capacity,
        status: "active",
        performance-score: u100,
        last-updated: block-height
      }
    )

    ;; Map name to ID
    (map-set access-point-by-name
      { name: name }
      { access-point-id: access-point-id }
    )

    ;; Update operator's access point list
    (let
      (
        (current-list (default-to (list) (get access-point-ids (map-get? operator-access-points { operator: operator }))))
      )
      (map-set operator-access-points
        { operator: operator }
        { access-point-ids: (unwrap! (as-max-len? (append current-list access-point-id) u100) ERR-INVALID-CAPACITY) }
      )
    )

    ;; Increment next ID
    (var-set next-access-point-id (+ access-point-id u1))

    (ok access-point-id)
  )
)

;; Update access point status
(define-public (update-access-point-status (access-point-id uint) (new-status (string-ascii 20)))
  (let
    (
      (access-point (unwrap! (map-get? access-points { access-point-id: access-point-id }) ERR-ACCESS-POINT-NOT-FOUND))
    )
    (asserts! (is-eq tx-sender (get operator access-point)) ERR-NOT-AUTHORIZED)
    (asserts! (or (is-eq new-status "active") (is-eq new-status "inactive") (is-eq new-status "maintenance")) ERR-INVALID-STATUS)

    (map-set access-points
      { access-point-id: access-point-id }
      (merge access-point { status: new-status, last-updated: block-height })
    )

    (ok true)
  )
)

;; Update performance score
(define-public (update-performance-score (access-point-id uint) (score uint))
  (let
    (
      (access-point (unwrap! (map-get? access-points { access-point-id: access-point-id }) ERR-ACCESS-POINT-NOT-FOUND))
    )
    (asserts! (is-eq tx-sender (get operator access-point)) ERR-NOT-AUTHORIZED)
    (asserts! (<= score u100) ERR-INVALID-STATUS)

    (map-set access-points
      { access-point-id: access-point-id }
      (merge access-point { performance-score: score, last-updated: block-height })
    )

    (ok true)
  )
)

;; Read-only Functions

;; Get access point details
(define-read-only (get-access-point (access-point-id uint))
  (map-get? access-points { access-point-id: access-point-id })
)

;; Get access point ID by name
(define-read-only (get-access-point-id-by-name (name (string-ascii 50)))
  (map-get? access-point-by-name { name: name })
)

;; Get operator's access points
(define-read-only (get-operator-access-points (operator principal))
  (map-get? operator-access-points { operator: operator })
)

;; Get total access points count
(define-read-only (get-total-access-points)
  (- (var-get next-access-point-id) u1)
)
