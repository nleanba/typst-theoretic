# Theoretic

> Opinionated tool to typeset theorems, lemmas and such

Example Usage:
```typ
  #import "@preview/theoretic:0.2.0" as theoretic: theorem, proof, qed

  // Otherwise, references won't work.
  #show ref: theoretic.show-ref

  // set up your needed presets
  #let corollary = theorem.with(kind: "corollary", supplement: "Corollary")
  #let example = theorem.with(kind: "example", supplement: "Example", number: none)
  // ..etc

  // use
  #theorem(title: [Important Theorem])[#lorem(5)]
  #corollary[#lorem(5)]
  #example[#lorem(5)]
  // ..etc
```

[![first page of the documentation](https://github.com/nleanba/typst-theoretic/raw/refs/heads/main/preview.svg)](https://github.com/nleanba/typst-theoretic/blob/main/main.pdf)
[Full Manual →](https://github.com/nleanba/typst-theoretic/blob/main/main.pdf)

<!-- [Full manual: ![first page of the documentation](https://github.com/nleanba/typst-theoretic/raw/refs/tags/v0.1.1/preview.svg)](https://github.com/nleanba/typst-theoretic/blob/v0.1.1/main.pdf) -->

-----

- Have you encountered a bug? [Please report it as an issue in my github repository.](https://github.com/nleanba/typst-theoretic/issues)
- Has this package been useful to you? [Let me know by giving my repository a star ⭐](https://github.com/nleanba/typst-theoretic)
