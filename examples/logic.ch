
T = \ x y . x
F = \ x y . y
if = \ b x y . b x y

if T t u
if F t u

and = \ x y . x y F
or = \ x y . x T y
not = \ x . x F T

T = and T T
F = and T F
F = and F T
F = and F F

T = or T F
T = or F T
F = or F F
T = or T T

T = not F
F = not T
T = not (and F F)

1 = if T 1 2
2 = if F 1 2
