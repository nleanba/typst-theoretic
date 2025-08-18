#import "lib.typ" as theoretic

#import "@preview/tidy:0.4.2"
#import "tidy-style.typ"

#let example = tidy.styles.default.show-example.with(scope: (theoretic: theoretic,), preamble: "#import theoretic: *\n", scale-preview: 100%)//, dir: ttb)

#set par(justify: true, linebreaks: "optimized")
#set text(fill: luma(30), size: 10pt)
#show raw: set text(font: ("Iosevka Term", "IBM Plex Mono", "DejaVu Sans Mono"), size: 1.25 * 0.85em)

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

#let fn-link(fn) = {
  link(label("theoretic-" + fn +"()"), raw(lang: "typ", "#theoretic." + fn + "()"))
}

= Summary

This package provides opinionated functions to create theorems and similar environments.
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

== Setup
Put the following at the top of your document:
```typ
  #import "@preview/theoretic:0.2.0" as theoretic: theorem, proof, qed
  #show ref: theoretic.show-ref // Otherwise, references won't work.

  // set up your needed presets
  #let corollary = theorem.with(kind: "corollary", supplement: "Corollary")
  #let example = theorem.with(kind: "example", supplement: "Example", number: none)
  // ..etc
  ```

See #fn-link("theorem") (#ref(label("theoretic-theorem()"))) for a detailed description of customization options.

= Features

- Except for ```typ #show ref: theoretic.show-ref```, no "setup" is necessary.
  All configuration is achieved via parameters on the #fn-link("theorem") function.
  Use ```typc theorem.with(..)``` for your preset needs.
  #h(1fr)#box[→ #fn-link("theorem")]

- Automatic numbering.
  If your headings are numbered, it will use top-level heading numbers as the first component, otherwise it will simply number your theorems starting with Theorem 1.
  #example(```typ
    #theorem(number: "!!")[
      Number can be overridden per-theorem.
    ]
    #theorem(number: 400)[
      If a `number` is passed (as opposed to a string or content),
    ]
    #theorem[
      ...subsequent theorems will pick it up.
    ]
    ```)

- Flexible References via specific supplements.
  #h(1fr)#box[ → #fn-link("show-ref")]
  #example(```typ
    @thm:foo vs @thm:foo[-] vs @thm:foo[--] vs @thm:foo[!] vs @thm:foo[!!] vs @thm:foo[!!!] vs @thm:foo[?] vs @thm:foo[Statement]
    ```)

- Custom outlines: Outline for headings _and/or_ theorems.
  #h(1fr)#box[ → #fn-link("toc")]
  - Filter for specific kinds of theorem to create e.g. a list of definitions.
  - Optionally sorted alphabetically!
  - Theorems can have a different title for outlines (#link(label("theoretic-theorem.toctitle"), raw(lang: "typ", "theorem(toctitle: ..)"))) and can even have multiple entries in a sorted outline.
  - Highly customizable! #h(1fr)#box[ → #fn-link("toc-entry")]
    - (And this customization can be reused for regular outlines)#h(1fr)#box[→ #fn-link("show-entry-as")]

- Exercise solutions:
  #h(1fr)#box[ → #fn-link("solutions")]
  - Every theorem environment accepts a second positional argument, which gets used as the solution.
  - Solutions section automatically hides itself if there are no solutions to show.
  #example(```typ
    #theorem(kind: "exercise", supplement: "Exercise")[
      Go look for the solution of this exercise at the end of this document.
    ][
      // no cheating! //
    >>>  Yay! you found it!
    ]
    ```)

- Automatic QED placement!
  #h(1fr)#box[ → #fn-link("proof") & #fn-link("qed")]

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
  ```)
  #example(```typ
  #proof[
    This is a proof.
    - #lorem(3)
  ]
  #proof[
    This is a proof.
    - #lorem(3) $ x = y $
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

- Any theorem can be restated.
  #h(1fr)#box[ → #fn-link("restate")]
  #example(```typc
  theoretic.restate(<thm:foo>)
  // the prefix links to the original
  ```)



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
  scope: (
    theoretic: theoretic,
    type: tidy-style.show-type.with(style-args: (colors: tidy.styles.default.colors)),
  ),
  preamble: "#import theoretic: *\n#set heading(outlined: false)\n",
)

#tidy.show-module(
  docs,
  style: tidy-style,
  // enable-cross-references: auto,
  first-heading-level: 1,
  show-outline: false,
  omit-private-definitions: true,
  // omit-private-parameters: false,
  show-module-name: false,
  // omit-empty-param-descriptions: true,
  // sort-functions: false,
  break-param-descriptions: true,
)

#theoretic.solutions()
