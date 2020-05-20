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
  (def range (fun (start end initial reduce)
    ((fun R (acc i)
      (if (lt i end) (R (reduce acc i) (add 1 i)) acc)
    ) initial start)
  ))

  (def encode (fun (i)
    (if (eq 0 i) "0" {block
      (def abs_i (if (lt i 0) (mul i -1) i))

      [def l (until abs_i 0 (fun (i l) (div i 10)))]

      (def s (strings.create (add l (lt i 0))))
      (if (lt i 0) (strings.set_at s 0 minus))

      ;;set digits from the end, working backwards
      ;;must also leave a space for the - if it's negative
      (until abs_i (gte i 0) (fun (i j) {block
        (strings.set_at s (sub l j) (add (mod i 10) zero))
        (div i 10)
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
