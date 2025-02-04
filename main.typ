#import "@preview/tidy:0.4.1"
#import "lib.typ" as theoretical

#let example = tidy.styles.default.show-example.with(scope: (theoretical: theoretical,), preamble: "#import theoretical: *\n", scale-preview: 100%)//, dir: ttb)

#set par(justify: true)
#set heading(numbering: "1.1")
#show heading.where(level: 3): set heading(numbering: none)
#show heading.where(level: 4): set heading(numbering: none)
#set table(inset: 7pt, stroke: (0.5pt + luma(90%)))
#show table: set align(left)
#show table.cell.where(y: 0): smallcaps
#set page(numbering: "1", columns: 1)

/// Balance columns
#let balance(content) = layout(size => {
  let count = content.at("count")
  let textheight = measure(content, width: size.width).height / count
  // block(height: textheight / count, fill: blue, content)
  let height = measure(content, height: textheight + 8pt, width: size.width).height
  block(height: height, content)
})

#show ref: theoretical.show-ref

#block(spacing: 30pt)[#text(size: 30pt)[Theoretical]]

#heading(outlined: false, numbering: none)[Contents]
#{
  set par(justify: false)
  show outline.entry.where(level: 1): it => {
    // if it.body.has("children") and it.body.children.first() == [A] { colbreak() }
    v(4pt)
    set text(weight: 700)
    link(it.element.location(), {
      let name = if it.body.has("children") { it.body.children.slice(2).join() } else { it }
      h(15pt)
      box(width: 1fr, {
        box(width: 15pt, if it.body.has("children") {
          h(-15pt)
          it.body.children.first()
        } else { none })
        h(-15pt)
        name
      })
      // h(1fr)
      box(width: 20pt, align(right, it.page))
    })
  }
  show outline.entry.where(level: 2): it => {
    h(15pt)
    link(it.element.location(), {
      let name = if it.body.has("children") { it.body.children.slice(2).join() } else { it }
      h(25pt)
      box(width: 1fr, {
        box(width: 25pt, if it.body.has("children") {
          h(-25pt)
          it.body.children.first()
        } else { none })
        h(-25pt)
        name
        box(width: 1fr, align(right, repeat(gap: 8pt, justify: false, text(size: 10pt, [.]))))
      })
      box(width: 20pt, align(right, it.page))
    })
  }
  show outline.entry.where(level: 4): it => {
    set text(fill: luma(40%))
    h(15pt)
    link(it.element.location(), {
      let name = if it.body.has("children") { it.body.children.slice(2).join() } else { it }
      h(25pt)
      box(width: 1fr, {
        // box(width: 25pt, if it.body.has("children") {
        //   h(-25pt)
        //   it.body.children.first()
        // } else { none })
        // h(-25pt)
        // name
        it.body
        box(width: 1fr, align(right, repeat(gap: 8pt, justify: false, text(size: 10pt, [.]))))
      })
      box(width: 20pt, align(right, it.page))
    })
  }
  show outline.entry.where(level: 4): it => {
    set text(size: 8pt, fill: luma(20%))
    h(37pt)
    link(it.element.location(), context {
      if it.body.has("children") {
        let supp = text(font: "Besley*", stretch: 85%, array(it.body.children).slice(0, 3).join())
        let width = measure(supp).width + 2.5pt
        if width <= 48pt { width = 48pt}
        h(48pt)
        box(width: 1fr, {
          box(width: width, {
            h(-48pt)
            supp
          })
          h(-48pt)
          text(font: "Besley*", array(it.body.children).slice(5, -1).join())
          // h(2pt)
          h(1fr)
        })
      } else {
        text(font: "Besley*", it.body)
      }
      box(width: 16pt, align(right, it.page))
    })
  }
  
  balance(columns(2, theoretical.toc()))
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
  #theorem[This is a theorem]
  #proof[This is a proof.]
  
  #theorem(title: "Foo", label: <thm:foo>)[
    This is a theorem
  ]
  #proof(title: [@thm:foo[-]])[
    This is a proof.
    - Ends with a list or enum?
      No problem.#qed()
  ]
  ```)

References can be controlled by passing some specific supplements, see #ref(label("theoretical-show-ref()")) for more details.

= Setup
Put the following at the top of your document:
```typ
  #import "@preview/theoretical:0.1.0" as theoretical: theorem, proof, qed

  // Otherwise, references won't work.
  #show ref: theoretical.show-ref

  // set up your needed presets
  #let corollary = theorem.with(kind: "corollary", supplement: "Corollary")
  #let example = theorem.with(kind: "example", supplement: "Example", number: none)
  // ..etc
  ```

See #ref(label("theoretical-theorem()")) for a detailed description of customization options.

Except for ```typ #show ref: theoretical.show-ref```, no "setup" is neccesary. All configuration is achieved via parameters on the #ref(label("theoretical-theorem()")) function, use ```typc theorem.with(..)``` for your preset needs.

The numbering of theorems is not configurable, but can be disabled (`number: none`) or temporarily overridden (`number: "X"` or `number: 2`).
If your headings are numbered, it will use top-level heading numbers as the first component, otherwise it will simply number your theorems starting with Theorem 1.

Use #link(label("theoretical-toc()"))[```typ #theoretical.toc()```] to get a list of theorems, list of definitions, a table of contents containg theorems, etc.

Put ```typ #theoretical.solutions()``` at the end of your document to get the solutions (every theorem environent accepts a second positional arguments, which gets used as the solution).
(Nothing will appear unless there are solutions to show.)
#theoretical.theorem(kind: "exercise", supplement: "Exercise")[
  Go look for the solution of this exercise at the end of this document.
][
  Yay! you found it!
]

// = Open TODOs
// - Ability to reference enumerations within theorem ("See Proposition 2.25 (a)")
// - Copy what #link("https://github.com/sahasatvik/typst-theorems/blob/ebaa938c8911cdd89bf9ba51eaf91b017302b010/theorems.typ#L254", "ctheorems") did for ```typ #qed-here```.
// - Re-stated theorems should automatically use same `theorem()` function.
// - Investigate why it takes more than 5 iterations for large documents, even tough there are no circular dependencies as far as I can tell?
//   We store the number in a metadata, which is context dependent (includes counters), but we never use the stored value to update the counter...


#pagebreak(weak: true)
= Examples
#theoretical.theorem(
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
    #let proof = proof.with(fmt-suffix: qed)

    #lorem(20)
    #theorem(label: <e.g>)[#lorem(9)]
    #proof(title: [@e.g])[#lorem(18)]
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

#set page(numbering: (.., i) => { smallcaps("a"); str(i) }, columns: 1)
#counter(page).update(1)
#set heading(numbering: "A.1")
#counter(heading).update(0)
= Detailed Documentation of all Exported Symbols

#let docs = tidy.parse-module(
  read("lib.typ"),
  name: "theoretical",
  scope: (theoretical: theoretical),
  preamble: "#import theoretical: *\n#set heading(outlined: false)\n",
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

#theoretical.solutions()
