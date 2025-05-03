#import "@preview/fontawesome:0.5.0": *

#let lang = sys.inputs.at("lang", default: "en")
#let i18n = (
  en: (
    exp: "Experience",
    edu: "Education",
    skills: "Skills",
    projects: "Projects",
    yr: (singular: "year", plural: "years"),
    mo: (singular: "month", plural: "months"),
    update: [Updated on #datetime.today().display("[month repr:long] [day], [year]")]
  ),
  es: (
    exp: "Experiencia",
    edu: "Educación",
    skills: "Habilidades",
    projects: "Proyectos",
    yr: (singular: "año", plural: "años"),
    mo: (singular: "mes", plural: "meses"),
    update: [Actualizado el #datetime.today().display("[day] de [month repr:long] de [year]")]
  )
).at(lang)

#let parse_date(d) = {
  return if d == "now" {
    datetime.today()
  } else {
    datetime(..d.split("-").map(int).zip(("year", "month", "day")).map(array.rev).to-dict())
  }
}
#let duration_calc(s, e) = {
  let dur = (e - s).weeks()
  let yrs = int(dur / 52)
  let mnt = int(calc.rem(dur, 52)/4.33)
  (
    if yrs > 1 { str(yrs) + " " + i18n.yr.plural } else if yrs == 1 { str(yrs) + " " + i18n.yr.singular  } else { none },
    if mnt > 1 { str(mnt) + " " + i18n.mo.plural } else if mnt == 1 { str(mnt) + " " + i18n.mo.singular  } else { none }
  ).join(if yrs > 0 and mnt > 0 {" & "} else {""})
}
#let faicon(s) = {
  box(align(center, fa-icon(s, solid: true)), width: 15pt)
}
