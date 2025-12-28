#import "lib.typ" as theoretic

#set par(justify: true, linebreaks: "optimized")
#set text(fill: luma(30), size: 10pt)
#show raw: set text(font: ("Iosevka Term", "IBM Plex Mono", "DejaVu Sans Mono"), size: 1.25 * 0.8em)
#let balance(content) = layout(size => {
  let count = content.at("count")
  let textheight = measure(content, width: size.width).height / count
  // block(height: textheight / count, fill: blue, content)
  let height = measure(content, height: textheight + 8pt, width: size.width).height
  block(height: height, content)
})
#set page(
  numbering: "1",
  columns: 1,
  margin: (
    x: 2cm,
  ),
  footer: align(center)[#context counter(page).display(page.numbering)], // why is this necessary? idk???
  height: auto,
) if "onepage" in sys.inputs

== Preset Styles <presets>
All preset styles define the following environments:
#(
  ..for (name, env) in dictionary(theoretic.presets.basic).pairs().sorted() {
    if type(env) == function and not "qed" in name and not name.starts-with("_") and not "show" in name {
      (raw(lang: "typ", "#" + name + "[...]"),)
    }
  }
).join(", ", last: [, and ]);.

#for (style-name, style) in dictionary(theoretic.presets) {
  v(2em, weak: true)
  block(
    breakable: false,
    {
      grid(columns: (
          1fr,
          auto,
        ))[=== Preset "#raw(style-name)"][Use with: #raw(lang: "typ", "#import theoretic.presets." + style-name + ": *")]

      // set text(size: 9pt)
      set text(font: "Besley", size: 8pt) if style-name == "fancy"
      show raw: set text(font: "Iosevka", size: 8pt) if style-name == "fancy"

      [
        #style._meta.description
      ]

      balance(
        columns(
          2,
          {
            [
              This style supports the variants
              #style._meta.variants.map(o => raw(lang: "typc", "\"" + o + "\"")).join([, ], last: [, and ]);;
              and the options
              #style._meta.options.map(o => raw(o)).join([, ], last: [, and ]);.
            ]
            style.theorem(
              toctitle: none,
            )[Title][This is an example theorem created using ```typ #theorem(toctitle: none)[Title][...]```.]
            style.proof[Using ```typ #proof[...]```.]
            style.proof[Title][Using ```typ #proof[...][...]```.]
            if style-name == "fancy" {
              style.lemma(variant: "plain")[Using ```typ #lemma(variant: "plain")[...]```.]
            }
            if "important" in style._meta.variants {
              style.lemma(variant: "important")[Using ```typ #lemma(variant: "important")[...]```.]
            }
            if "color" in style._meta.options {
              style.theorem(
                options: (color: red),
                toctitle: none,
                [Title],
              )[Using ```typ #theorem(options: (color: red), ..)```.]
            }
            style.definition[Using ```typ #definition[...]```.]
            style.remark[Using ```typ #remark[...]```.]
            style.example[Using ```typ #example[...]```.]
          },
        ),
      )
    },
  )
}
