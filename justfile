DATE := `date "+%b%Y"`
JOBNAME := "AdrianBergesCV_" + DATE

all: makepdf pythontex makepdf
  mv ./aux/cv.pdf ./{{JOBNAME}}.pdf

makepdf:
  xelatex \
    -output-directory="./aux" \
    -interaction=nonstopmode \
    src/cv.tex

pythontex:
  pythontex aux/cv.pytxcode

get-fonts:
  sudo apt install fonts-vollkorn fonts-open-sans
