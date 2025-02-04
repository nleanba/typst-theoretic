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
  
  balance(columns(2, theoretic.toc()))
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

References can be controlled by passing some specific supplements, see #ref(label("theoretic-show-ref()")) for more details.

= Setup
Put the following at the top of your document:
```typ
  #import "@preview/theoretic:0.1.0" as theoretic: theorem, proof, qed

  // Otherwise, references won't work.
  #show ref: theoretic.show-ref

  // set up your needed presets
  #let corollary = theorem.with(kind: "corollary", supplement: "Corollary")
  #let example = theorem.with(kind: "example", supplement: "Example", number: none)
  // ..etc
  ```

See #ref(label("theoretic-theorem()")) for a detailed description of customization options.

Except for ```typ #show ref: theoretic.show-ref```, no "setup" is neccesary. All configuration is achieved via parameters on the #ref(label("theoretic-theorem()")) function, use ```typc theorem.with(..)``` for your preset needs.

The numbering of theorems is not configurable, but can be disabled (`number: none`) or temporarily overridden (`number: "X"` or `number: 2`).
If your headings are numbered, it will use top-level heading numbers as the first component, otherwise it will simply number your theorems starting with Theorem 1.

Use #link(label("theoretic-toc()"))[```typ #theoretic.toc()```] to get a list of theorems, list of definitions, a table of contents containg theorems, etc.

Put ```typ #theoretic.solutions()``` at the end of your document to get the solutions (every theorem environent accepts a second positional arguments, which gets used as the solution).
(Nothing will appear unless there are solutions to show.)
#theoretic.theorem(kind: "exercise", supplement: "Exercise")[
  Go look for the solution of this exercise at the end of this document.
][
  Yay! you found it!
]

= Proofs / QED
If a proof ends with text, nothing needs to be done.
#example(```typ
  #proof[#lorem(5)]
  ```)
If a proof ends with a list or some other full-width block, simply put a ```typc qed()``` at the end of it.
#example(```typ
  // Bad
  #proof[- #lorem(5)]

  // Good
  #proof[- #lorem(5)#qed()]
  ```)

However, if it ends with a displayed (block) equation, things get tricky.

It does not seem possible to place the qed from within the equation directly. However, we can use it as the "number" of the equation instead. (This breaks, of course, if you want the equation itself numbered also -- but in that case the wed has to go someplace else anyway)
// I have not yet been able to figure out a way to elegantly place a QED in this situation from within the equation. Here are a couple of possible workarounds:
#[#set par(justify: false)
#example(```typ
  #proof[
    #lorem(5)
    #set math.equation(numbering: (..) => {qed()}, number-align: bottom)
    $ x &= y \ &= sqrt(sum_(4/a_k)^oo a_n). $
  ]
  ```)]

// (Using a grid or stack des not allow proper alignment)

(Note: use ```typc qed()``` instead of ```typc $square$``` so the proof environment knows that _it_ doesn't need to place one.)

  // Bad
  // #proof[
  //   #lorem(5)
  //   $ x = y . $
  // ]

  // // Using inline math
  // #proof[
  //   #lorem(5)
  //   #v(0.5em)#hide(qed())$display( x = sqrt( sum^(oo) a_n ) . )$#qed()
  // ]
  // // But this doesn't work for multiline equations
  // #proof[
  //   #lorem(5)
  //   #v(0.5em)#hide(qed())$display( x &= y \ &= sqrt( sum^(oo) a_n ) . )$#qed()
  // ]
  // // But this doesn't work for multiline equations
  // #proof[
  //   #lorem(5)
  //   #v(0.5em)#box(width: 1fr, $display( #hide(qed()) x &= y \ &= sqrt( sum^(oo) a_n ) .#h(1fr)#qed() )$)
  // ]
  // // ?

//   // For perfect alignment, repeat the last line of the equation invisibly.
//   #proof[
//     #lorem(5)
//     #v(0.5em)#hide(qed())$ x &= y \ &= sqrt( sum^(oo) a_n ) .$..$display( sqrt( sum^(oo) a_n ) . )$#qed()
//   ]

//   // Using grid
//   #proof[
//     #lorem(5)
//     #grid(
//       align: horizon,
//       columns: (1fr, auto, 1fr),
//       [], $ x = sqrt( sum^(oo) a_n ) . $, qed()
//     )
//   ]
//   // But this doesn't work for multiline equations
//   #proof[
//     #lorem(5)
//     #grid(
//       align: horizon,
//       columns: (1fr, auto, 1fr),
//       [], $ x &= y \ &= sqrt( sum^(oo) a_n ) . $, qed()
//     )
//   ]
//   ```)

// Broken: I consider it a typs bug that the text edges do affetc the visual sizes of the box, but not the measure ones.
// #context {
//   let eq = $display( x = sqrt( sum_(n_(n_(n_(n_k))))^(oo) a_n )^7 . ) $
//   let eq-h = measure(eq).height
//   eq
//   box(fill: yellow, eq)
//   box(width: 4pt, height: eq-h, fill: red)
//   [#eq-h \ ]

//   // let eq3a = rect(box(fill: green, clip: true, eq), fill: blue, inset: 10pt)
//   // let eq3a-h = measure(eq3a).height
//   // box(eq3a)
//   // box(width: 4pt, height: eq3a-h, fill: red)

//   // set text(bottom-edge: "bounds", top-edge: "bounds")
//   let eq3 = text(bottom-edge: "bounds", top-edge: "bounds", eq) // pad(stack(dir: ttb, box(fill: green, clip: true, eq)))
//   let eq3-h = measure(eq3).height
//   [.]
//   box(eq3, fill: gray)
//   [.]
//   box(width: 4pt, height: eq3-h, fill: red)
//   [ #eq3-h ]
//   // set text(top-edge: "cap-height", bottom-edge: "baseline") // default

//   // set text(bottom-edge: "bounds", top-edge: "bounds")
//   let eq3c = text(top-edge: "bounds", eq) // pad(stack(dir: ttb, box(fill: green, clip: true, eq)))
//   let eq3c-h = measure(eq3c).height
//   [.]
//   box(eq3c, fill: gray)
//   [.]
//   box(width: 4pt, height: eq3c-h, fill: red)
//   [ #eq3c-h ]
//   // set text(top-edge: "cap-height", bottom-edge: "baseline") // default
  

//   let eq2 = rect(stroke: none, inset: 0pt, fill: aqua, eq)
//   let eq2-h = measure(eq2).height
//   box(eq2)
//   [.]
//   box(width: 4pt, height: eq3-h - eq2-h, fill: red)
//   [.]
//   box(width: 4pt, height: eq2-h, fill: red)
//   [.$x$]
//   box(eq, baseline: eq3-h - eq2-h)
//   [.]
//   eq
//   [. #eq2-h ]

//   theoretic.proof[
//     #grid(
//       align: bottom,
//       columns: (1fr, auto, 1fr),
//       [], eq, {theoretic.qed(); v(eq3-h - eq2-h)}
//     )
//   ]
// }

// = Open TODOs
// - Ability to reference enumerations within theorem ("See Proposition 2.25 (a)")
// - Copy what #link("https://github.com/sahasatvik/typst-theorems/blob/ebaa938c8911cdd89bf9ba51eaf91b017302b010/theorems.typ#L254", "ctheorems") did for ```typ #qed-here```.
// - Re-stated theorems should automatically use same `theorem()` function.
// - Investigate why it takes more than 5 iterations for large documents, even tough there are no circular dependencies as far as I can tell?
//   We store the number in a metadata, which is context dependent (includes counters), but we never use the stored value to update the counter...


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
