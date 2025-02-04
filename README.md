# Theoretic

> Opinionated tool to typeset theorems, lemmas and such

Example Usage:
```typ
  #import "@preview/theoretic:0.1.0": *

  // Otherwise, references won't work.
  #show ref: theoretic.show-ref

  // set up your needed presets
  #let corollary = theorem.with(kind: "corollary", supplement: "Corollary")
  #let example = theorem.with(kind: "example", supplement: "Example", number: none)
  // ..etc

  // use
  #corollary[]
```

[Full manual: ![first page of the documentation](https://github.com/nleanba/typst-theoretic/raw/refs/heads/main/preview.svg)](https://github.com/nleanba/typst-theoretic/blob/main/main.pdf)