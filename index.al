(module
  (def strings (import "acid-strings"))

  (def minus 45)
  (def zero 48)

  ;;iterates util initial is reduced to zero, then returns the counter
  (def until (fun (initial start reduce)
    ((fun R (acc i)
      (if (gt acc 0) (R (reduce acc i) (add 1 i)) i)
    ) initial start)
  ))

  ;;iterates from start to end
  (def range (fun (st end initial reduce)
    ((fun R (acc i)
      (if (lt i end) (R (reduce acc i) (add 1 i)) acc)
    ) initial st)
  ))

  (def encode (fun (i)
    (if (eq 0 i) "0" {block
      (def abs_i (if (lt i 0) (mul i -1) i))

      ;; need to calculate the length first
      (def l [(fun R (l2 i2)
        (if (gt i2 0) (R (add 1 l2) (div i2 10)) l2) ) 0 abs_i])
      ;; okay my inlining isn't hygenic that's why this doesn't work.
;;      [def l (until (fun (i2 l2) (div i2 10)) abs_i 0)]

      (def s (strings.create (add l (lt i 0))))
      (if (lt i 0) (strings.set_at s 0 minus))

      ;;set digits from the end, working backwards
      ;;must also leave a space for the - if it's negative
      (until abs_i (gte i 0) (fun (i3 j) {block
        (strings.set_at s (sub l j) (add (mod i3 10) zero))
        (div i3 10)
      }))

      s
    })))

  (def decode (fun (string start end) (block
    (def neg (eq (strings.at string start) minus))
    (mul (if neg -1 1)
      (range (add neg start) end 0 [fun (acc i)
        (add (mul acc 10) (sub (strings.at string i) zero))])
    )
  )))

  (export int_to_string encode)
  (export encode encode)
  (export decode decode)
)
