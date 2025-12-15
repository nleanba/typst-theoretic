#import "../base.typ" as tt

#let _fmt = (
  fmt-prefix: (supplement, number, title) => {
    strong({
      supplement
      if number != none [ #number]
      if title != none [ (#title)]
      [.~]
    })
  },
  fmt-body: tt.fmt-body,
  fmt-suffix: none,
  block-args: none,
)

#let theorem = tt.theorem.with(.._fmt, supplement: "Theorem", kind: "theorem")
#let proposition = tt.theorem.with(.._fmt, supplement: "Proposition", kind: "proposition")
#let lemma = tt.theorem.with(.._fmt, supplement: "Lemma", kind: "lemma")
#let corollary = tt.theorem.with(.._fmt, supplement: "Corollary", kind: "corollary")
#let definiton = tt.theorem.with(.._fmt, supplement: "Definition", kind: "definiton")
#let exercise = tt.theorem.with(.._fmt, supplement: "Exercise", kind: "exercise")
#let algorithm = tt.theorem.with(.._fmt, supplement: "Algorithm", kind: "algorithm")
#let axiom = tt.theorem.with(.._fmt, supplement: "Axiom", kind: "axiom")

#let example = tt.theorem.with(.._fmt, supplement: "Example", kind: "example", number: none)
#let counter-example = tt.theorem.with(.._fmt, supplement: "Counter-Example", kind: "example", number: none)
#let remark = tt.theorem.with(.._fmt, supplement: "Remark", kind: "remark", number: none)
#let note = tt.theorem.with(.._fmt, supplement: "Note", kind: "note", number: none)
#let claim = tt.theorem.with(.._fmt, supplement: "Claim", kind: "claim", number: none)

#let QED = tt.qed

#let proof = tt.proof.with(
  fmt-prefix: (supplement, number, title) => {
    emph({
      supplement
      if number != none [ #number]
      if title != none [ of #title]
      [.~]
    })
  },
  fmt-body: _fmt.fmt-body,
  fmt-suffix: QED.with(force: false),
  block-args: none,
  supplement: "Proof",
  kind: "proof",
  number: none,
)