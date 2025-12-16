#import "../base.typ" as __
// if you write your own style, `#import "@preview/theoretic:.." as __` here instead.

#let show-theorem(it) = {
  let color = it.options.at("color", default: oklch(60%, 0.2, 20deg))
  block(
    stroke: (left: 3pt + color),
    inset: (left: 1em + 3pt, right: 0pt, y: 0.6em),
    outset: (left: -3pt),
    spacing: 1.2em,
    {
      block(
        above: 0em,
        below: 1.2em,
        sticky: true,
        {
          text(
            weight: "bold",
            fill: color,
            ..it.options.head-font,
            {
              if it.options.link != none {
                link(
                  it.options.link,
                  {
                    it.supplement
                    if it.number != none [ #it.number]
                  },
                )
              } else {
                it.supplement
                if it.number != none [ #it.number]
              }
              h(1fr)
              if it.title != none {
                it.title
              }
            },
          )
        },
      )
      it.body
    },
  )
}

#let theorem = __.theorem.with(
  show-theorem: show-theorem,
  options: (color: oklch(60%, 0.2, 20deg)),
  supplement: "Theorem",
  kind: "theorem",
)
#let proposition = theorem.with(
  options: (color: oklch(60%, 0.15, 265deg)),
  supplement: "Proposition",
  kind: "proposition",
)
#let lemma = theorem.with(options: (color: oklch(60%, 0.1, 175deg)), supplement: "Lemma", kind: "lemma")
#let corollary = theorem.with(options: (color: oklch(60%, 0.2, 323deg)), supplement: "Corollary", kind: "corollary")
#let definiton = theorem.with(options: (color: oklch(65%, 0.15, 52deg)), supplement: "Definition", kind: "definiton")
#let exercise = theorem.with(options: (color: oklch(65%, 0.15, 250deg)), supplement: "Exercise", kind: "exercise")
#let algorithm = theorem.with(options: (color: oklch(50%, 0.15, 310deg)), supplement: "Algorithm", kind: "algorithm")
#let axiom = theorem.with(options: (color: oklch(65%, 0.1, 235deg)), supplement: "Axiom", kind: "axiom")

#let example = theorem.with(
  options: (color: oklch(65%, 0.15, 131deg)),
  supplement: "Example",
  kind: "example",
  number: none,
)
#let counter-example = example.with(supplement: "Counter-Example")

#let remark = theorem.with(options: (color: oklch(65%, 0, 0deg)), supplement: "Remark", kind: "remark", number: none)
#let note = theorem.with(options: (color: oklch(60%, 0.1, 195deg)), supplement: "Note", kind: "note", number: none)
#let claim = theorem.with(options: (color: oklch(60%, 0.15, 145deg)), supplement: "Claim", kind: "claim", number: none)

#let QED = __.qed

#let proof = __.proof.with(
  options: (
    variant: "proof",
    head-punct: [:],
    head-sep: h(0.5em),
    block-args: (inset: (left: 1em + 3pt, right: 0pt, y: 0pt)),
  ),
  fmt-suffix: QED.with(force: false),
  supplement: "Proof",
  kind: "proof",
  number: none,
)
