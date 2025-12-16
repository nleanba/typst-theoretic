#import "../base.typ" as __
// if you write your own style, `#import "@preview/theoretic:.." as __` here instead.

#let _badge(title, hue: 142.5deg) = {
  box(
    fill: oklch(70%, if hue == 0deg { 0 } else { 0.17 }, hue, 20%),
    outset: (y: 4.25pt),
    inset: (x: 2pt),
    radius: 2pt,
    text(fill: oklch(44.67%, if hue == 0deg { 0 } else { 0.15 }, hue), weight: "semibold", title),
  )
}

#let _fmt_strong(hue: 142.5deg) = (
  fmt-prefix: (supplement, number, title) => {
    box(
      stroke: (top: 0.5pt + oklch(44.67%, if hue == 0deg { 0 } else { 0.15 }, hue)),
      outset: (left: 4pt, right: if title != none { 1pt } else { 4pt }, y: 3.75pt),
      {
        set text(stretch: 85%, weight: "semibold")
        supplement
        if number != none [ #number]
      },
    )
    if title != none {
      h(2pt)
      _badge(title, hue: hue)
      h(-2pt)
    }
    h(1em)
  },
  block-args: (
    stroke: (left: 0.5pt + oklch(44.67%, if hue == 0deg { 0 } else { 0.15 }, hue)),
    outset: (left: 4pt, right: 0pt, y: 4pt),
  ),
)

#let _fmt(hue: 142.5deg) = (
  .._fmt_strong(hue: hue),
  fmt-prefix: (supplement, number, title) => {
    box({
      set text(stretch: 85%, weight: "regular")
      supplement
      if number != none [ #number]
    })
    if title != none {
      h(2pt)
      _badge(title, hue: hue)
      h(-2pt)
    }
    h(1em)
  },
)

#let theorem = __.theorem.with(.._fmt_strong(hue: 307.4deg), supplement: "Theorem", kind: "theorem")
#let proposition = __.theorem.with(.._fmt_strong(hue: 255.8deg), supplement: "Proposition", kind: "proposition")
#let lemma = __.theorem.with(.._fmt_strong(hue: 255.8deg), supplement: "Lemma", kind: "lemma")
#let corollary = __.theorem.with(.._fmt_strong(hue: 255.8deg), supplement: "Corollary", kind: "corollary")
#let definiton = __.theorem.with(.._fmt_strong(hue: 142.5deg), supplement: "Definition", kind: "definiton")
#let exercise = __.theorem.with(.._fmt_strong(hue: 1deg), supplement: "Exercise", kind: "exercise")
#let algorithm = __.theorem.with(.._fmt_strong(hue: 142.5deg), supplement: "Algorithm", kind: "algorithm")
#let axiom = __.theorem.with(.._fmt_strong(hue: 142.5deg), supplement: "Axiom", kind: "axiom")

#let example = __.theorem.with(
  .._fmt(hue: 0deg),
  fmt-body: (b, s) => {
    set text(fill: oklch(44.67%, 0, 0deg))
    __.fmt-body(b, s)
  },
  supplement: "Example",
  kind: "example",
)
#let counter-example = example.with(supplement: "Counter-Example")
#let remark = __.theorem.with(.._fmt(hue: 0deg), supplement: "Remark", kind: "remark")
#let note = __.theorem.with(.._fmt(hue: 0deg), supplement: "Note", kind: "note")
#let claim = __.theorem.with(.._fmt(hue: 0deg), supplement: "Claim", kind: "claim")

#let QED = __.qed.with(
  suffix: {
    h(1em)
    $square$
  },
)
#let QED-BOLT = __.qed.with(
  suffix: {
    h(1em)
    [$limits(square)^arrow.zigzag$]
  },
)

#let proof = __.proof.with(
  fmt-prefix: (supplement, number, title) => {
    emph({
      supplement
      if number != none [ #number]
      if title != none [ of #title]
      [.]
      h(1em)
    })
  },
  fmt-suffix: QED.with(force: false),
  block-args: (
    inset: (left: 1em, right: 0pt, y: 0pt),
  ),
  supplement: "Proof",
  kind: "proof",
  number: none,
)
