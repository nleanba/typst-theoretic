#import "@preview/tidy:0.4.1"
#import "lib.typ" as theoretic

#let example = tidy.styles.default.show-example.with(scope: (theoretic: theoretic,), preamble: "#import theoretic: *\n", scale-preview: 100%)//, dir: ttb)

#set par(justify: true)
#set heading(numbering: "1.1")
#show heading.where(level: 3): set heading(numbering: none)
#show heading.where(level: 4): set heading(numbering: none)
#set table(inset: 7pt, stroke: (0.5pt + luma(90%)))
#show table: set align(left)
#show table.cell.where(y: 0): smallcaps
#set page(
  numbering: "1",
  columns: 1,
  footer: align(center)[#context counter(page).display(page.numbering)], // why is this neccesary? idk???
)
#set text(fill: luma(20%))

/// Balance columns
#let balance(content) = layout(size => {
  let count = content.at("count")
  let textheight = measure(content, width: size.width).height / count
  // block(height: textheight / count, fill: blue, content)
  let height = measure(content, height: textheight + 8pt, width: size.width).height
  block(height: height, content)
})

#show ref: theoretic.show-ref

#block(spacing: 30pt)[#text(size: 30pt)[Theoretic]]

#heading(outlined: false, numbering: none)[Contents]
#{
  set par(justify: false)
  let indents = (0pt, 15pt, 37pt)
  let hang-indents = (15pt, 22pt, 54pt)
  let text-styles = ((weight: 700), (size: 10pt), (size: 9pt, weight: 500), (size: 9pt, fill: luma(20%)), )
  
  let outline-entry = theoretic.toc-entry.with(
    indent: (level) => { indents.at(level - 1) },
    hanging-indent: (level) => { hang-indents.at(level - 1) },
    fmt-prefix: (prefix, level, _s) => {
      set text(..text-styles.at(level - 1), number-width: "tabular")
      prefix
      h(4pt)
    },
    fmt-body: (body, level, _s) => {
      set text(..text-styles.at(level - 1))
      body
    },
    fmt-fill: (level, _s) => {
      if level == 2 {
        set text(..text-styles.at(2))
        box(width: 1fr, align(right, repeat(gap: 9pt, justify: false, [.])))
      }
    },
    fmt-page: (page, level, _s) => {
      set text(..text-styles.at(level - 1), number-width: "tabular")
      box(width: 18pt, align(right, [#page]))
    },
    above: (level) => {
      if level == 1 {
        auto // 12pt
      } else {
        7pt
      }
    },
    below: auto,
  )
  balance(columns(2, theoretic.toc(toc-entry: outline-entry)))
}

#show link: it => {
  underline(
    stroke: 3pt + oklch(70%, 0, 0deg, 20%),
    background: true,
    offset: 0.5pt,
    extent: 1pt,
    evade: false,
    it
  )
}


= Summary

This package provides opinionated functions to create theorems and similar environments.

Default theorem environment and provided presets:
#example(```typ
  #theorem[This is a theorem.]
  #proof[
    Ends with Equation? No Problem:
    $ norm(x) = sqrt( sum_(k = 1)^d x_k ) . $
  ]
  #theorem(title: "Foo", label: <thm:foo>)[
    This is a named theorem.
  ]
  #proof(title: [@thm:foo[-]])[
    - Ends with a list or enum? Easy.
  ]
  ```)

References can be controlled by passing some specific supplements, see #ref(label("theoretic-show-ref()")) for more details.

= Setup
Put the following at the top of your document:
```typ
  #import "@preview/theoretic:0.1.1" as theoretic: theorem, proof, qed
  #show ref: theoretic.show-ref // Otherwise, references won't work.

  // set up your needed presets
  #let corollary = theorem.with(kind: "corollary", supplement: "Corollary")
  #let example = theorem.with(kind: "example", supplement: "Example", number: none)
  // ..etc
  ```

See #ref(label("theoretic-theorem()")) for a detailed description of customization options.

Except for ```typ #show ref: theoretic.show-ref```, no "setup" is necessary. All configuration is achieved via parameters on the #ref(label("theoretic-theorem()")) function, use ```typc theorem.with(..)``` for your preset needs.

The numbering of theorems is not configurable, but can be disabled (`number: none`) or temporarily overridden (`number: "X"` or `number: 2`).
If your headings are numbered, it will use top-level heading numbers as the first component, otherwise it will simply number your theorems starting with Theorem 1.

Use #link(label("theoretic-toc()"))[```typ #theoretic.toc()```] to get a list of theorems, list of definitions, a table of contents containing theorems, etc.

Put ```typ #theoretic.solutions()``` at the end of your document to get the solutions (every theorem environment accepts a second positional arguments, which gets used as the solution).
(Nothing will appear unless there are solutions to show.)
#theoretic.theorem(kind: "exercise", supplement: "Exercise")[
  Go look for the solution of this exercise at the end of this document.
][
  Yay! you found it!
]

= Proofs / QED
In most cases, it should place the QED symbol appropriately automatically:
#example(```typ
#proof[This is a proof. $x=y$]
#proof[
  This is a proof.
  $ x = y $
]
#proof[
  #set math.equation(numbering: "(1)")
  This is a proof.
  $ x = y $
]
#proof[
  This is a proof.
  - #lorem(3) $ x = y $
]
#proof[
  This is a proof.
  - #lorem(3)
]
#proof[
  This is a proof.
  + #lorem(3)
    + #lorem(3)
      + #lorem(3)
        + #lorem(3)
]
```)

Specifically, it works for lists, enums, and unnumbered block equations, which may be nested.
If your proof ends wit some other block, you should might want to place a ```typ #qed()``` manually.
For proper alignment with a block equation, use
```typ
#set math.equation(numbering: (..) => {qed()}, number-align: bottom)
```
placed directly in front of the equation.


// = Open TODOs
// - Ability to reference enumerations within theorem ("See Proposition 2.25 (a)")
// - Re-stated theorems should automatically use same `theorem()` function.


#pagebreak(weak: true)
= Examples
#theoretic.theorem(
  kind: "example", supplement: "Example",
  title: "A complicated example showing some configuration possibilities"
)[
  #example(
    dir: btt,
    ```typ
    >>> #counter("_thm").update(0)
    >>> #set heading(numbering: none)
    >>> #pad(x: 6pt, y: 4pt)[
    #set text(font: "Besley*", size: 9pt)
    #let theorem = theorem.with(
      fmt-prefix: (s, n, t) => {
        text(font: "Besley* Narrow Semi")[#s #n]
        if t!= none {
          h(2pt)
          box(fill: oklch(70%, 0.17, 307.4deg, 20%), outset: (y: 4pt), inset: (x: 2pt), radius: 2pt, text(fill: oklch(44.67%, 0.15, 307.4deg), font: "Besley* Semi", t))
        }
        h(1em)
      },
      block-args: (
        stroke: (left: 0.5pt + oklch(44.67%, 0.15, 307.4deg)),
        outset: (left: 4pt, right: 0pt, y: 4pt),
      ),
    )
    #let ex = theorem.with(
      kind: "example",
      supplement: "Example",
      fmt-prefix: (s, n, t) => {
        text(font: "Besley*", stretch: 85%)[#s #n]
        if t!= none [ (#t)]
        h(1em)
      },
      fmt-body: (b, _) => { emph(b) },
    )
    #let qed = qed.with(suffix: smallcaps[#h(1fr)_qed._])
    #let proof = proof.with(fmt-suffix: qed.with(force: false))

    #lorem(20)
    #theorem(label: <e.g>)[#lorem(9)]
    #proof(title: [@e.g])[+ #lorem(18)]
    #theorem(title: "Name")[#lorem(6)]
    #ex[#lorem(10)]
    #ex(title: "Named Example")[
      To avoid having examples and such show up in the toc, use the `toc.exclude` parameter.
    ]
    #lorem(20)
    >>> ]
    ```
  )
]

#set page(numbering: (.., i) => { smallcaps("a"); str(i); }, columns: 1)
#counter(page).update(1)
#set heading(numbering: "A.1")
#counter(heading).update(0)
= Detailed Documentation of all Exported Symbols

#let docs = tidy.parse-module(
  read("lib.typ"),
  name: "theoretic",
  scope: (theoretic: theoretic),
  preamble: "#import theoretic: *\n#set heading(outlined: false)\n",
)

#tidy.show-module(
  docs,
  // style: tidy.styles.help,
  // enable-cross-references: auto,
  first-heading-level: 1,
  show-outline: false,
  omit-private-definitions: true,
  omit-private-parameters: false,
  show-module-name: false,
  omit-empty-param-descriptions: true,
  // sort-functions: false,
)

#theoretic.solutions()
