#import "@preview/tidy:0.4.2": styles

#let show-outline(module-doc, style-args: (:)) = {
  styles.default.show-outline(module-doc, style-args: style-args)
}
#let show-type(type, style-args: (:)) = {
  styles.default.show-type(type, style-args: style-args)
}
#let show-function(fn, style-args) = {
  // codeblock(
  styles.default.show-function(fn, style-args)
  // )
}
#let show-variable(var, style-args) = {
  // codeblock(
  styles.default.show-variable(var, style-args)
  // )
}
#let show-parameter-list(fn, style-args: (:)) = {
  pad(
    left: 10pt,
    {
      set text(font: ("Iosevka Term", "IBM Plex Mono", "DejaVu Sans Mono"), size: 0.85em)
      let items = ()
      let args = fn.args
      for (name, info) in fn.args {
        if style-args.omit-private-parameters and name.starts-with("_") {
          continue
        }
        let types
        if "types" in info {
          types = ": " + info.types.map(x => show-type(x, style-args: style-args)).join(" ")
        }
        if (
          style-args.enable-cross-references
            and not (info.at("description", default: "") == "" and style-args.omit-empty-param-descriptions)
        ) {
          name = link(label(style-args.label-prefix + fn.name + "." + name.trim(".")), name)
        }
        let display-name = if "default" in info { name } else { sym.chevron.l + name + sym.chevron.r }
        items.push(display-name + types)
      }

      layout(size => {
        let name = text(fn.name, fill: style-args.colors.at("signature-func-name", default: rgb("#4b69c6")))
        let params = items.join(", ")
        let return-types = if "return-types" in fn and fn.return-types != none {
          " → "
          fn.return-types.map(x => show-type(x, style-args: style-args)).join(" ")
        }
        let x = measure({
          name
          "("
          params
          ")"
          return-types
        }).width
        if x > size.width {
          name
          "(\n  "
          items.join(",\n  ")
          "\n)"
          return-types
        } else {
          name
          "("
          params
          ")"
          return-types
        }
      })

      // items.join(if inline-args { ", " } else { ",\n  " })
      // if not inline-args { "\n" } + ")"
      // if "return-types" in fn and fn.return-types != none {
      //   " → "
      //   fn.return-types.map(x => show-type(x, style-args: style-args)).join(" ")
      // }
    },
  )
}
#let show-parameter-block(
  function-name: none,
  name,
  types,
  content,
  style-args,
  show-default: false,
  default: none,
) = block(
  inset: (top: 10pt),
  // stroke: (top: 1pt + luma(90%)),
  width: 100%,
  breakable: style-args.break-param-descriptions,
  layout(size => {
    let title = {
      let display-name = if show-default { name } else { sym.chevron.l + name + sym.chevron.r }
      [#box(heading(level: style-args.first-heading-level + 3, raw(display-name)))#if (
          function-name != none and style-args.enable-cross-references
        ) { label(function-name + "." + name.trim(".")) }]
      if show-default {
        raw(": ")
        raw(lang: "typc", default)
      }
      h(1.2em)
      types.map(x => (style-args.style.show-type)(x, style-args: style-args)).join([ #text("or", size: .8em) ])
      // #if show-default {
      //   h(1.2em)
      //   // text(size: .8em)[#style-args.local-names.default:]
      //   // [ ]
      //   "("
      //   raw(lang: "typc", default)
      //   ")"
      // }
      if not show-default {
        h(1.2em)
        text("Positional", size: .8em)
      }
      h(1.8em)
    }
    let t = measure(title).width
    let c = measure(content).width
    if size.width >= t + c {
      title
      content
    } else {
      title
      parbreak()
      content
    }
  }),
)
#let show-reference(label, name, style-args: (:)) = {
  styles.default.show-reference(label, name, style-args: style-args)
}
