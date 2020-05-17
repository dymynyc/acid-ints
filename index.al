(module
  (def strings (import "acid-strings"))

  (def minus 45)
  (def zero 48)

  (def encode (fun (i)
    (if (eq 0 i) "0" {block
      (def abs_i (if (lt i 0) (mul i -1) i))

      ;; need to calculate the length first
      (def l [(fun R (l2 i2)
        (if (gt i2 0) (R (add 1 l2) (div i2 10)) l2) ) 0 abs_i])

      (def s (strings.create (add l (lt i 0))))
      (if (lt i 0) (strings.set_at s 0 minus))

      ;;set digits from the end, working backwards
      ;;must also leave a space for the - if it's negative
      ((fun R (i3 j)
        (if (gt i3 0)
          [R
            {block
              ;;put everything in a block because I know acidlisp
              ;;won't loopify the recursion currently, otherwise
              (strings.set_at s (sub l j) (add (mod i3 10) zero))
              (div i3 10) }
            (add 1 j) ]
          0)
      ) abs_i {if (lt i 0) 0 1})
      abs_i
      s
    })))

  (def decode (fun (string start end) (block
    (def neg (eq (strings.at string start) minus))
    (mul (if neg -1 1) ((fun R (acc i)
      (if (lt i end)
        (R (add (mul acc 10) (sub (strings.at string i) zero)) (add 1 i))
        acc
      )) 0 (add neg start)))
  )))

  (export int_to_string encode)
  (export encode encode)
  (export decode decode)
)
