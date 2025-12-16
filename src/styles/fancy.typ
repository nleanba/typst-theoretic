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

/// This style ignores most `options`, except for
/// - variant: "muted", "remark", "plain", "important"
/// - hue: (angle)
#let show-theorem(it) = {
  let hue = it.options.at("hue", default: 0deg)
  let stroke = if it.variant == "muted" or it.variant == "remark" {
    0.5pt + oklch(44.67%, 0, 0deg)
  } else {
    0.5pt + oklch(44.67%, 0.15, hue)
  }
  block(
    width: 100%,
    stroke: (left: stroke),
    outset: (left: 4pt, right: 0pt, y: 4pt),
    {
      box(
        stroke: (top: if it.variant == "important" { stroke }),
        outset: (left: 4pt, right: if it.title != none { 1pt } else { 4pt }, y: 3.9pt),
        {
          set text(stretch: 85%, weight: "semibold")
          set text(weight: "regular") if it.variant == "remark"
          set text(weight: "regular", fill: luma(40%)) if it.variant == "muted"
          it.supplement
          if it.number != none [ #it.number]
        },
      )
      if it.title != none {
        h(2pt)
        _badge(it.title, hue: hue)
        h(-2pt)
      }
      h(1em)
      set text(style: "normal", weight: "regular")
      set text(style: "italic") if it.variant == "remark"
      set text(fill: luma(40%)) if it.variant == "muted"
      it.body
    },
  )
}

#let theorem = __.theorem.with(show-theorem: show-theorem, variant: "important", options: (hue: 307.4deg))
#let proposition = theorem.with(
  variant: "important",
  options: (hue: 255.8deg),
  supplement: "Proposition",
  kind: "proposition",
)
#let lemma = theorem.with(variant: "important", options: (hue: 255.8deg), supplement: "Lemma", kind: "lemma")
#let corollary = theorem.with(
  variant: "important",
  options: (hue: 255.8deg),
  supplement: "Corollary",
  kind: "corollary",
)
#let algorithm = theorem.with(
  variant: "important",
  options: (hue: 142.5deg),
  supplement: "Algorithm",
  kind: "algorithm",
)
#let axiom = theorem.with(variant: "important", options: (hue: 142.5deg), supplement: "Axiom", kind: "axiom")

#let definiton = theorem.with(
  variant: "important",
  options: (hue: 142.5deg),
  supplement: "Definition",
  kind: "definiton",
)
#let exercise = theorem.with(variant: "plain", options: (hue: 1deg), supplement: "Exercise", kind: "exercise")

#let example = theorem.with(
  variant: "muted",
  supplement: "Example",
  kind: "example",
)
#let counter-example = example.with(supplement: "Counter-Example")

#let remark = theorem.with(variant: "remark", supplement: "Remark", kind: "remark", number: none)
#let note = theorem.with(variant: "remark", supplement: "Note", kind: "note", number: none)
#let claim = theorem.with(variant: "plain", options: (hue: 50deg), supplement: "Claim", kind: "claim", number: none)

#let proof = __.proof

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
  options: (
    variant: "proof",
    head-punct: [.],
    head-sep: h(1em),
    block-args: (inset: (left: 1em, right: 0pt, y: 0pt)),
  ),
  fmt-suffix: QED.with(force: false),
  supplement: "Proof",
  kind: "proof",
  number: none,
)
