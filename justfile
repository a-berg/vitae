DATE := `LC_TIME=es_ES.UTF-8 date "+%b%Y"`
JOBNAME := "AdrianBergesCV_" + DATE

all: pptex makepdf
  mv ./cv.pdf ./{{JOBNAME}}.pdf

makepdf:
  tectonic src/cv.tex --outdir .

pptex:
  racket src/zxp.scrbl > src/zxp.tex

get-fonts:
  sudo apt install fonts-vollkorn fonts-open-sans
