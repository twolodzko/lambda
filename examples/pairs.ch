
T = \ x y . x
F = \ x y . y

pair = \ x y f . f x y
fst = \ p . p T
snd = \ p . p F
nil = \ x . T
null =  \ p . p (\ x y . F)

1 = fst (pair 1 2)
2 = snd (pair 1 2)
T = null nil
F = null (pair 1 2)
F = null (pair nil nil)
