#import "../../lib.typ" as theoretic: proof, qed

#let proof = proof.with(options: (block-args: (inset: (left: 2em), stroke: 0.5pt)))

Basic:

#proof[#lorem(10)]
#proof(suffix: $square$)[
  This is a proof. A QED symbol is placed correctly even after block equations.
  $ norm(x) = sqrt( sum_(k = 1)^d x_k ) . $
]

Manually placed:

#proof[
  #lorem(10)
  #qed()
  #lorem(10)
]

#proof(suffix: $square$)[
  #lorem(10)
  #qed()
  $ norm(x) = sqrt( sum_(k = 1)^d x_k ) . $
]

Nested:

#proof(suffix: $square$)[
  #lorem(10)
  #proof[
    #lorem(10)
  ]
  #lorem(10)
]
#proof(suffix: $square$)[
  #lorem(10)
  #proof[
    #lorem(10)
    #qed()
    #lorem(10)
  ]
  #lorem(10)
]
#proof[
  #lorem(10)
  #qed()
  #lorem(10)
  #proof(suffix: $square$)[
    #lorem(10)
    #qed()
    #lorem(10)
  ]
  #lorem(10)
]

#proof(suffix: $square$)[
  #lorem(10)
  #proof[
    #lorem(10)
    #qed($triangle$)
    #lorem(5)
    #qed()
    #lorem(10)
    #qed($triangle$)
  ]
  #lorem(10)
]

Outside of proof:
#qed($triangle$)
