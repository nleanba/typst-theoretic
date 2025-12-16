#import "../base.typ" as __
// if you write your own style, import "@preview/theoretic:.." here instead.

// Uses built-in defaults.

#let theorem = __.theorem.with()
#let proposition = theorem.with(supplement: "Proposition", kind: "proposition")
#let lemma = theorem.with(supplement: "Lemma", kind: "lemma")
#let corollary = theorem.with(supplement: "Corollary", kind: "corollary")
#let algorithm = theorem.with(supplement: "Algorithm", kind: "algorithm")
#let axiom = theorem.with(supplement: "Axiom", kind: "axiom")

#let definiton = theorem.with(options: (variant: "definition"), supplement: "Definition", kind: "definiton")
#let exercise = theorem.with(options: (variant: "definition"), supplement: "Exercise", kind: "exercise")

#let example = theorem.with(
  options: (variant: "definition"),
  supplement: "Example",
  kind: "example",
  number: none,
)
#let counter-example = example.with(supplement: "Counter-Example")

#let remark = theorem.with(options: (variant: "remark"), supplement: "Remark", kind: "remark", number: none)
#let note = theorem.with(options: (variant: "remark"), supplement: "Note", kind: "note", number: none)
#let claim = theorem.with(options: (variant: "remark"), supplement: "Claim", kind: "claim", number: none)

#let proof = __.proof
