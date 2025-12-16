#import "../base.typ" as __
// if you write your own style, `#import "@preview/theoretic:.." as __` here instead.

#let _fmt(color: oklch(60%, 0.2, 20deg)) = (
  fmt-prefix: (supplement, number, title) => {
    block(
      above: 0em,
      below: 1.2em,
      sticky: true,
      {
        set text(weight: "bold", fill: color)
        supplement
        if number != none [ #number]
        h(1fr)
        if title != none [ #title]
      },
    )
  },
  block-args: (
    stroke: (left: 3pt + color),
    inset: (left: 1em + 3pt, right: 0pt, y: 0.6em),
    outset: (left: -3pt),
    spacing: 1.2em,
  ),
)


#let theorem = __.theorem.with(.._fmt(color: oklch(60%, 0.2, 20deg)), supplement: "Theorem", kind: "theorem")
#let proposition = __.theorem.with(
  .._fmt(color: oklch(60%, 0.15, 265deg)),
  supplement: "Proposition",
  kind: "proposition",
)
#let lemma = __.theorem.with(.._fmt(color: oklch(60%, 0.1, 175deg)), supplement: "Lemma", kind: "lemma")
#let corollary = __.theorem.with(.._fmt(color: oklch(60%, 0.2, 323deg)), supplement: "Corollary", kind: "corollary")
#let definiton = __.theorem.with(.._fmt(color: oklch(65%, 0.15, 52deg)), supplement: "Definition", kind: "definiton")
#let exercise = __.theorem.with(.._fmt(color: oklch(65%, 0.15, 250deg)), supplement: "Exercise", kind: "exercise")
#let algorithm = __.theorem.with(.._fmt(color: oklch(50%, 0.15, 310deg)), supplement: "Algorithm", kind: "algorithm")
#let axiom = __.theorem.with(.._fmt(color: oklch(65%, 0.1, 235deg)), supplement: "Axiom", kind: "axiom")

#let example = __.theorem.with(
  .._fmt(color: oklch(65%, 0.15, 131deg)),
  supplement: "Example",
  kind: "example",
  number: none,
)
#let counter-example = __.theorem.with(
  .._fmt(color: oklch(65%, 0.15, 131deg)),
  supplement: "Counter-Example",
  kind: "example",
  number: none,
)
#let remark = __.theorem.with(.._fmt(color: oklch(65%, 0, 0deg)), supplement: "Remark", kind: "remark", number: none)
#let note = __.theorem.with(.._fmt(color: oklch(60%, 0.1, 195deg)), supplement: "Note", kind: "note", number: none)
#let claim = __.theorem.with(.._fmt(color: oklch(60%, 0.15, 145deg)), supplement: "Claim", kind: "claim", number: none)

#let QED = __.qed

#let proof = __.proof.with(
  fmt-prefix: (supplement, number, title) => {
    emph(
      strong({
        supplement
        if number != none [ #number]
        if title != none [ of #title]
        [:]
        h(0.5em)
      }),
    )
  },
  fmt-suffix: QED.with(force: false),
  block-args: (
    inset: (left: 1em + 3pt, right: 0pt, y: 0pt),
  ),
  supplement: "Proof",
  kind: "proof",
  number: none,
)
