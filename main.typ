#import "lib.typ" as theoretic

#import "@preview/tidy:0.4.3"
#import "tidy-style.typ"

#set par(justify: true, linebreaks: "optimized")
#set text(fill: luma(30), size: 10pt)
#show raw: set text(font: ("Iosevka Term", "IBM Plex Mono", "DejaVu Sans Mono"), size: 1.25 * 0.8em)

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

#import theoretic.presets.basic: *
#show ref: theoretic.show-ref

#let code-example = tidy.styles.default.show-example.with(
  scope: (theoretic: theoretic),
  // preamble: "#import theoretic.presets.basic: *\n",
  scale-preview: 100%,
)//, dir: ttb)
#let code-example-basic = code-example.with(preamble: "#import theoretic.presets.basic: *\n")

#let VERSION = "0.3.0"
#set document(
  author: "nleanba",
  title: "Theoretic 0.3.0",
)

#v(2em)
#title[#text(size: 30pt, weight: "regular")[Theoretic #text(fill: luma(50%), VERSION)]]
#v(2em)

#heading(outlined: false, numbering: none)[Contents]
#{
  set par(justify: false)
  let indents = (0pt, 15pt, 37pt)
  let hang-indents = (15pt, 22pt, 54pt)
  let text-styles = ((weight: 700), (size: 10pt), (size: 9pt, weight: 500), (size: 9pt, fill: luma(20%)))

  let outline-entry = theoretic.toc-entry.with(
    indent: level => { indents.at(level - 1) },
    hanging-indent: level => { hang-indents.at(level - 1) },
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
    above: level => {
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
    it,
  )
}
#show ref: it => {
  if it.has("element") and it.element != none and it.element.func() == heading {
    underline(
      stroke: 3pt + oklch(70%, 0, 0deg, 20%),
      background: true,
      offset: 0.5pt,
      extent: 1pt,
      evade: false,
      it,
    )
  } else { it }
}

#let fn-link(fn) = {
  link(label("theoretic-" + fn + "()"), raw(lang: "typ", "#theoretic." + fn + "()"))
}

= Summary
This package provides opinionated functions to create theorems and similar environments.

#code-example(
  raw(
    lang: "typ",
    "<<<#import \"@preview/theoretic:"
      + VERSION
      + "\"
#import theoretic.presets.basic: *
#show ref: theoretic.show-ref

#theorem[This is a theorem.]
#proof[
  This is a proof. A QED symbol is placed correctly even after block equations.
  $ norm(x) = sqrt( sum_(k = 1)^d x_k ) . $
]
#proposition(<thm:foo>)[Foo][This is a named theorem.]
#proof[@thm:foo[-]][
  Proof with a list or enum?
  - No problem for QED.
]
",
  ),
)

= Features <features>

- Except for ```typ #show ref: theoretic.show-ref```, no "setup" is strictly necessary.

  Customisation of the environments is acheived via parameters on the #fn-link("theorem") function.
  You can use e.g. ```typ #let lemma = theoretic.theorem.with(kind: "lemma", supplement: "Lemmma", /* ... */)```.
  #h(1fr)#box[→ See @styling]

  For convenience, the ```typc theoretic.presets``` module contains predefined styled environments.
  #h(1fr)#box[→ See @presets]

- Flexible References via specific supplements.
  #h(1fr)#box[ → #fn-link("show-ref")]
  #code-example(```typ
  @thm:foo vs @thm:foo[-] vs @thm:foo[--] vs @thm:foo[!] vs @thm:foo[!!] vs @thm:foo[!!!] vs @thm:foo[?] vs @thm:foo[Statement]
  ```)

- Any theorem can be restated.
  #h(1fr)#box[ → #fn-link("restate")]
  #code-example(```typc
  theoretic.restate(<thm:foo>)
  // the head links to the original
  ```)

- Automatic numbering.
  If your headings are numbered, it will use top-level heading numbers as the first component, otherwise it will simply number your theorems starting with Theorem 1.
  #code-example-basic(```typ
  #theorem(number: "!!")[
    Number can be overridden for individual theorems.
  ]
  #theorem(number: 40)[
    If a `number` is passed (as opposed to a string or content),
  ]
  #theorem[
    ...subsequent theorems will pick it up.
  ]
  ```)

- Custom outlines: Outline for headings _and/or_ theorems.
  #h(1fr)#box[ → #fn-link("toc")]
  - Filter for specific kinds of theorem to create e.g. a list of definitions.
  - Optionally sorted alphabetically!
  - Theorems can have a different title for outlines (#link(label("theoretic-theorem.toctitle"), raw(lang: "typ", "theorem(toctitle: ..)"))) and can even have multiple entries in a sorted outline.
  - Highly customizable! #h(1fr)#box[ → #fn-link("toc-entry")]
    - (And this customization can be reused for regular outlines)#h(1fr)#box[→ #fn-link("show-entry-as")]

- Automatic QED placement!
  #h(1fr)#box[ → #link(label("theoretic-theorem.suffix"), raw(lang: "typ", "#theorem(suffix: ..)")) & #fn-link("qed")]
  // TODO: QED stuff

  In most cases, it should place the QED symbol appropriately automatically:
  #code-example-basic(```typ
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
  #code-example-basic(```typ
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

- Exercise solutions:
  #h(1fr)#box[ → #fn-link("solutions")]
  - Every theorem environment can have a solution, which is shown in a separate section.
  - Solutions section automatically hides itself if there are no solutions to show.
  #code-example-basic(```typ
  >>> #exercise(solution: [Yay! you found the solutions!])[
  <<< #exercise(solution: [/***************************/])[
    Go look for the solution of this exercise at the end of
    this document.
  ]
  ```)

// = Open TODOs
// - Ability to reference enumerations within theorem ("See Proposition 2.25 (a)")

= Styling / Customization <styling>

For basic customization, you can override the `supplement`, `kind`, and `options` parameters of #fn-link("theorem").

You can start completely fresh:
#code-example(
  dir: ttb,
  raw(
    lang: "typ",
    "<<<#import \"@preview/theoretic:"
      + VERSION
      + "\"\n"
      + ```typ
      #show ref: theoretic.show-ref

      // simply setting `variant` to one of "plain", "remark", "definition" or "important" changes the style:
      #let theorem = theoretic.theorem.with(supplement: "Theorem", kind: "theorem", variant: "important")
      // you can also set the other style options directly:
      #let lemma = theoretic.theorem.with(
        supplement: "Lemma", kind: "lemma",
        options: (
          head-font: (style: "normal", weight: "bold"),
          title-font: (style: "italic", weight: "regular", fill: oklch(40%, 0.2, 12deg)),
          body-font: (style: "normal", weight: "regular"),
          block-args: (outset: 4pt, fill: oklch(95%, 0.06, 12deg)),
          head-punct: none,
          head-sep: h(1em),
        ),
      )

      #lorem(5)
      #theorem[#lorem(5)]
      #lemma[Title][#lorem(5)]
      ```.text,
  ),
)

See #link(label("theoretic-theorem.options"))[the documentation in the appendix] for more details on the `options` parameter.

Alternatively, you can also build upon a preset style:
#code-example(
  raw(
    lang: "typ",
    "<<<#import \"@preview/theoretic:"
      + VERSION
      + "\"\n"
      + ```typ
      #import theoretic.presets.fancy: *
      #show ref: theoretic.show-ref

      // this is immediately useful for translations:
      #let satz = theorem.with(supplement: "Satz")
      #satz[Eine deutsche Aussage.]
      #theorem[An English theorem.]

      // or to add new kinds:
      #let lession = theorem.with(supplement: "Lession", kind: "lession", options: (hue: 12deg), variant: "plain")
      #lession[Foo][Bar]
      <<<#lession(variant: "important")[Important Lesson][...]
      >>>#lession(variant: "important")[Important Lesson][
      >>>  The `variant` parameter is also intended to be called for single theorems.
      >>>  E.g. in this `fancy` preset, `"important"` adds a line above the supplement.
      >>>]
      ```.text,
  ),
)

Note that not all preset styles respect the same options. More details are given in the examples in @presets.


If you want to go in a completely new direction, you can also provide your own #link(label("theoretic-theorem.show-theorem"))[`show-theorem`] function to fully control styling.
For how this can look, I reccomend looking at how the predefined styles are made: #link("https://github.com/nleanba/typst-theoretic/tree/v0.3.0/src/styles")[See the code on GitHub].

== Preset Styles <presets>

#for (style-name, style) in dictionary(theoretic.presets) {
  [=== Preset "#raw(style-name)"]
  set text(size: 9pt)
  set text(font: "Besley", size: 8pt) if style-name == "fancy"
  show raw: set text(font: "Iosevka", size: 8pt) if style-name == "fancy"

  [Use with: #raw(lang: "typ", "#import theoretic.presets." + style-name + ": *")]
  parbreak()

  if style-name == "basic" [
    This style uses the built-in #fn-link("show-theorem") and accepts all its `options`.
  ] else if style-name == "fancy" [
    This style is intended#footnote[It still looks okay in other fonts, but it does not reach full potential. Compare: #h(8pt) #box(width: 6cm, style.lemma(toctitle: none)[Lorem][ipsum.])] for use with a font that supports `stretch: 85%` and `weight: "semibold"`. It is here shown using the font "Besley\*", #link("https://github.com/indestructible-type/Besley/tree/master/fonts/ttf")[which you can download on GitHub].

    This style ignores most `options`, except for a new `hue` option to set the `oklch` hue.
    The `variant` can be "muted", "remark", "plain", or "important".
  ] else if style-name == "bar" [
    This style ignores most `options`, except for `head-font`, and it adds a `color` option.
    The `variant` can be "plain" or "important".
    (Not all environments shown.)
  ] else if style-name == "corners" [
    This style is almost identical to the `basic` one, it just wraps the environments in a block with corners. It adds a `color` option.
    (Not all environments shown.)
  ] else if style-name == "columns" [
    This adds the following options: `number-font` and `grid-args`, and it ignores `head-sep`.
    (Not all environments shown.)
  ]
  if style-name in ("basic", "fancy") {
    columns(
      2,
      {
        for (name, env) in dictionary(style) {
          if name == "theorem" {
            env[This is an example theorem created using #raw(lang: "typ", "#" + name + "[...]").]
          } else if (
            type(env) == function and not "qed" in name and not name.starts-with("_") and not "show" in name
          ) {
            env[Using #raw(lang: "typ", "#" + name + "[...]").]
          }
        }
        colbreak()
        for (name, env) in dictionary(style) {
          if name == "theorem" {
            env(
              toctitle: none,
            )[Title][This is an example theorem created using #raw(lang: "typ", "#" + name + "(toctitle: none)[Title][...]").]
          } else if (
            type(env) == function and not "qed" in name and not name.starts-with("_") and not "show" in name
          ) {
            env(toctitle: none)[Title][#lorem(3)]
          }
        }
      },
    )
  } else {
    columns(
      2,
      {
        style.theorem[This is an example theorem created using ```typ #theorem[...]```.]
        style.lemma[Using ```typ #lemma[...]```.]
        style.example(options: (color: red))[Using ```typ #example(options: (color: red))[...]```.]
        colbreak()
        style.proposition(toctitle: none)[Title][This is an example theorem created using ```typ #proposition(toctitle: none)[Title][...]```.]
        style.lemma(variant: "important")[Using ```typ #lemma(variant: "important")[...]```.]
        style.proof[Title][Using ```typ #proof[...][...]```.]
      },
    )
  }
}

#set page(
  numbering: (.., i) => {
    smallcaps("a")
    str(i)
  },
  columns: 1,
)
#counter(page).update(1)
#set heading(numbering: "A.1")
#show heading.where(level: 3): set heading(numbering: none)
#show heading.where(level: 4): set heading(numbering: none)
#show heading.where(level: 5): set heading(numbering: none)
#counter(heading).update(0)
= Detailed Documentation of all Exported Symbols

#let docs = tidy.parse-module(
  read("src/base.typ"),
  name: "theoretic",
  scope: (
    theoretic: theoretic,
    type: tidy-style.show-type.with(style-args: (colors: tidy.styles.default.colors)),
  ),
  preamble: "#import theoretic: *\n#set heading(outlined: false)\n",
  enable-curried-functions: false,
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
  sort-functions: auto,
  break-param-descriptions: true,
  local-names: (parameters: [Parameters], default: [Default], variables: [Variables]),
)

#v(3em)

#theoretic.solutions()
