T = \ x y . x
F = \ x y . y

0 = \ f x . x
1 = \ f x . f x
2 = \ f x . f (f x)
3 = \ f x . f (f (f x))
succ = \ n f x . n f (f x)

0 = 0
1 = succ 0
2 = succ 1
3 = succ 2

add = \ m n . m succ n
0 = add 0 0
1 = add 0 1
2 = add 1 1
3 = add 2 1

4 = succ 3
4 = add (add 1 1) (add 1 1)

mul = \ m n . m (add n) 0
exp = \ m n . n (mul m) 1

iszero = \ n x y . n (\ z . y) x
T = iszero 0
F = iszero 1
F = iszero 2

pred = \ n f x . n (\ g h . h (g f)) (\ y . x) (\ y . y)
0 = pred 1
1 = pred 2
2 = pred 3

sub = \ m n . n pred m
1 = sub 2 1
2 = sub 3 1
1 = sub 3 2

leq = \ m n . iszero (sub m n)
F = leq 2 1
F = leq 3 1
T = leq 1 2
