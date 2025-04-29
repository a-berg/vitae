lang := "en"
name := "AdrianBergesCV"
DATE := `LC_TIME=en_US.UTF-8 date "+%b%Y"`
JOBNAME := name + "_" + DATE
DOCUMENTS := "~/Documents/cv/"

all: makepdf
  mv ./cv.pdf ./{{JOBNAME}}_{{lang}}.pdf

makepdf: 
  typst c cv.typ --input lang={{ lang }}

# makeweb: processyml
#   pandoc --defaults html_defaults.yaml -V lang_es={{ if lang == "es" { "true" } else { "" } }}

get-fonts:
   {{ if os() == 'linux' { "sudo apt update && sudo apt install fonts-vollkorn fonts-open-sans" } else if os() == 'macos' {  "brew install cask font-vollkorn font-open-sans" } else { error("Windows not supported!") } }}
