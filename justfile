lang := "en"
name := "AdrianBergesCV"
DATE := `LC_TIME=en_US.UTF-8 date "+%b%Y"`
JOBNAME := name + "_" + DATE
DOCUMENTS := "~/Documents/cv/"

all: makepdf
  mv ./cv.pdf ./{{JOBNAME}}_{{lang}}.pdf
  -cp ./{{JOBNAME}}_{{lang}}.pdf {{DOCUMENTS}}

makepdf: processyml
  pandoc --defaults pdf_defaults.yaml -V lang_es={{ if lang == "es" { "true" } else { "" } }}

makeweb: processyml
  pandoc --defaults html_defaults.yaml -V lang_es={{ if lang == "es" { "true" } else { "" } }}

processyml:
  pdm run python3 -m src.python.process_yaml_data -L {{lang}}

get-fonts:
  sudo apt update
  sudo apt install fonts-vollkorn fonts-open-sans

pdm-init:
  pdm init
  pdm sync
