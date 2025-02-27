#import "lib.typ": *

/// Creates a colorful badge
///
/// -> content
#let badge(
  /// oklch-hue (color) of the badge.
  ///
  /// `none` for gray.
  /// -> angle | none
  hue: 300deg,
  // Font to use
  // -> list | string
  // font: ("Besley* Semi", "Besley*"),
  /// -> content
  content,
) = {
  box(
    fill: if hue != none { oklch(70%, 0.17, hue, 20%) } else { oklch(70%, 0, 0deg, 20%) },
    outset: (y: 4pt),
    inset: (x: 2pt),
    radius: 2pt,
    text(fill: if hue != none { oklch(44.67%, 0.15, hue) } else { oklch(44.67%, 0, 0deg) }, font: "Besley* Semi", weight: "semibold", content),
  )
}

/// Create a theorem-function with some presets.
/// -> function
#let badged(
  /// oklch-hue (color)
  ///
  /// `none` for gray.
  /// -> degree | none
  hue: 300deg,
  /// Use bolded title or not
  /// -> boolean
  bold: true,
  /// other args for theorem
  ..args,
) = {
  theorem.with(
    fmt-prefix: (s, n, t) => {
      box({
        text(
          font: if bold { "Besley* Narrow Semi" } else { "Besley*" },
          weight: if bold { "semibold" } else { "regular" },
          stretch: 85%,
        )[#s #n]
        if t != none {
          [ ]
          badge(hue: hue, t)
        }
      })
      h(1em)
    },
    block-args: (
      stroke: (left: 0.5pt + if hue != none { oklch(44.67%, 0.15, hue) } else { oklch(44.67%, 0, 0deg) }),
      outset: (left: 4pt, right: 0pt, y: 4pt),
    ),
    ..args,
  )
}
