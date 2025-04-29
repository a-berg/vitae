#import "@preview/fontawesome:0.5.0": *

#let lang = sys.inputs.at("lang", default: "en")
#let i18n = (
  "en": (
    "exp": "Experience",
    "edu": "Education",
    "skills": "Skills",
    "projects": "Projects",
    "yr": (singular: "year", plural: "years"),
    "mo": (singular: "month", plural: "months"),
    "update": [Updated on #datetime.today().display("[month repr:long] [day], [year]")]
  ),
  "es": (
    "exp": "Experiencia",
    "edu": "Educación",
    "skills": "Habilidades",
    "projects": "Proyectos",
    "yr": (singular: "año", plural: "años"),
    "mo": (singular: "mes", plural: "meses"),
    "update": [Actualizado el #datetime.today().display("[day] de [month repr:long] de [year]")]
  )
).at(lang)

#show link: it => {text(fill:blue)[#it]}
#show heading.where(level: 1): it => {
  rect(width: 100%, stroke: (top: .5pt))[
    #set text(size: 10pt, weight: "regular", font: "Open Sans", tracking: 0.5pt) 
    #pad(left: -5pt)[ #upper(it.body) ]
  ]
}
#show "\Cpp": [C#text([++], baseline: -.75pt, tracking: -1.5pt)]

#set text(size: 11pt, lang: lang)
#set page(
  margin: 15mm,
  header: [
    #set text(8pt, font: "Open Sans")
    #h(1fr)
    #i18n.update
  ],
  numbering: "1",
)
#set par(leading: 5pt, spacing: 7pt, justify: true)
#set list(indent: 1em)
#set grid(row-gutter: 8pt)


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
#let personal = yaml("content/personal.yaml").personal

#grid(columns: (1fr, 2fr),
  rect(height: 2in, fill: luma(90%))[Placeholder for portrait.],
  box[
  #set text(font: "Open Sans")
  #text(upper(personal.name), weight: "bold", size: 18pt, tracking: 1pt, spacing: 300%)
  #v(12pt)
  #faicon("envelope")     #personal.mail\
  #v(4pt)
  #faicon("phone")        #personal.phone\ 
  #v(4pt)
  #faicon("location-dot") #personal.location\ 
  #v(4pt)
  #faicon("globe")        #link(personal.links.website.url,personal.links.website.display)\ 
  #v(4pt)
  #faicon("linkedin")     #link(personal.links.linkedin.url,personal.links.linkedin.display)\ 
  #v(4pt)
  #faicon("github")       #link(personal.links.github.url,personal.links.github.display)
])

= #i18n.exp

#let experience = yaml(("content", lang, "experience.yaml").join("/"))

#for it in experience {
  block(
    grid(align: (left, right), columns: (1fr, 1fr),
      text(it.jobtitle, weight: "bold", size: 12pt),
      [
      #set text(size: 10pt)
      #(it.start, it.end).map(parse_date).map(datetime.year).map(str).join(" - ")
       (#duration_calc(..(it.start, it.end).map(parse_date)))
      ],
      emph(it.company),
      it.location
    ),
    width: 100%,
    height: auto
  )
  list(tight: false,..it.highlights)
  v(16pt)
}

= #i18n.edu

#let education = yaml(("content", lang, "education.yaml").join("/")).r

#for it in education {
  block(
    grid(align: (left, right), columns: (1fr, 1fr),
      text([#it.type #it.title], weight: "bold", size: 12pt),
      [
      #set text(size: 10pt)
      #(it.start, it.end).map(str).join(" - ")
      ],
      emph(it.institution),
      it.location
    ),
    width: 100%,
    height: auto
  )
  v(10pt)
}

= #i18n.skills

#let skills = yaml(("content", lang, "skills.yaml").join("/"))

#for it in skills {
  [#text(it.header, size: 13pt, weight: "bold")]
  grid(columns: (1fr, 3fr), ..for x in it.table {x})
  v(12pt)
}
