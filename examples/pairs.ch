
T = \ x y . x
F = \ x y . y

pair = \ x y f . f x y
fst = \ p . p T
snd = \ p . p F
nil = \ x . T
null =  \ p . p (\ x y . F)
