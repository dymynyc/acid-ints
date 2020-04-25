(module
  (def strings (import "acid-strings"))

  (def incr (mac (x) &(set $x (add 1 $x)) ))
  (def minus 45)
  (def zero 48)


  (def encode (fun (i)
    (if (eq 0 i) "0" {block
      (def l 0)
      (def i2 (def i3 (if (lt i 0) (mul i -1) i)))

      ;; need to calculate the length first
      (if (eq i 0) (set l 1)
        [loop (neq 0 i2) {block (set i2 (div i2 10)) (incr l)} ])

      (def L (add l {if (lt i 0) 1 0} ))

      (def s (strings.create L))
      (def j 0)
      (if (lt i 0) (strings.set_at s 0 minus))

      (loop (lt j l)
        (block
          (def n (mod i3 10))
          (set i3 (div i3 10))
          (strings.set_at s (sub L (add j 1)) (add zero n))
          (incr j)
        )
      )
      s
    })))

  (def minus_char 45)
  (def decode (fun (string start end) (block
    {if (eq (strings.at string start) minus_char)
      (block (incr start) (def sign -1))
      (def sign 1)
    }
    (def r 0)
    (loop (lt start end) {block
      (set r [add (mul r 10) (sub (strings.at string start) 48) ])
      (incr start)
    })
    (mul r sign)
  )))

  (export int_to_string encode)
  (export encode encode)
  (export decode decode)
)
