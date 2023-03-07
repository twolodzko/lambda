# Lambda calculus

[Lambda calculus] is defined using three _terms_:

* _variable_ $x$ that represents the parameter,
* _application_ $t  u$ which applies function $t$ to argument $u$,
* _abstraction_ $\lambda x . t$ is a function with parameter $x$ and term $t$ being the body of the function,
  $\lambda x y . x y$ reads like $\lambda x . \lambda y . x y$.

Where the application is associative to the left, $a b c d$ is the same as $(((a b) c) d)$, while abstraction expands to the right, so 
$\lambda x . a b c d$ reads as $\lambda x . (a b c d)$. 

The function is evaluated by applying $\beta$-reductions that substitute the free variables with provided arguments, e.g.

$$
(\lambda x y . x y) (\lambda x . x) a \underset{\beta}{\to}
(\lambda y . (\lambda x . x) y) a \underset{\beta}{\to}
(\lambda x . x) a \underset{\beta}{\to}
a
$$

Additionally, while it is not a part of lambda calculus, we can use aliases to simplify the notation, for example,
define the identity function as $I$ using the notation

$$
I = \lambda x . x
$$

so then

$$
I x \equiv (\lambda x . x) x \underset{\beta}{\to} x
$$

## Lambda calculus as a programming language

The above can be implemented as a programming language that has only a few reserved symbols: `\` (or `λ`), `.`, `(`, `)`, `=`, 
and `#`. In the implementation, `\` translates to $\lambda$. The words are separated
with white spaces, so $\lambda xy.xy$ will be written as `\ x y . x y`. Additionally, the round brackets can be used
for grouping terms, e.g. `(\x.x)y`. 



`#` marks the start of the comment that continues till the end of the line. It can also 
be used to split the expression between multiple lines, e.g.

```
(\x. # 
x    #
) y 
# ↪ y
```

`lhs = rhs` can be used to assign the result of `rhs` to the `lhs` name. 

```
I = \x.x
# ↪ λ x . x

I y
# ↪ y
```

The assignments are into immutable variables, so after binding something to a name, no further bindings to this name are possible. This way, it can serve also as an assertion

```
x = T
# ↪ T

x = T 
# ↪ T 

x = F 
# ↪ F
Error: T and F are not the same
```

When the `lhs` is *not* a variable name, `=` can be used for regular assertions, e.g.

```
(\x.x) = (\y.y)(\z.z)
```

## Usage

* To build the `lambda` binary run the [`just` command]. Call it as `./lambda [filename]...` or `./lambda` to launch REPL.
* `just repl` starts the REPL.


 [Lambda calculus]: https://en.wikipedia.org/wiki/Lambda_calculus
 [`just` command]: https://github.com/casey/just
