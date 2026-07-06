#import "../../lib.typ" as theoretic: theorem

#set heading(numbering: "1/1-1")

#theorem[Blah]
#theorem[Blah]

= Blah

#theorem[Blah]

Setting `numbering: "a"`
#theoretic.configure(
  numbering: "a",
)

#theorem[Blah]

== Blah

#theorem(numbering-depth: 3)[with `numbering-depth: 3`]
#theorem[Blah]

=== Blah

#theorem[Blah]

Setting `numbering-depth: 2`
#theoretic.configure(
  numbering-depth: 2,
)

#theorem[Blah]

= Blah

#theorem[Blah]

Setting `numbering: "1"`
#theoretic.configure(
  numbering: "1",
)

#theorem[Blah]
#theorem(numbering-depth: 3)[With `numbering-depth: 3`]

== Blah

#theorem[Blah]
#theorem(numbering: "*")[With `numbering: "*"`]

=== Blah

#theorem[Blah]

Setting `numbering-depth: 5`
#theoretic.configure(
  numbering-depth: 5,
)

#theorem[Blah]
