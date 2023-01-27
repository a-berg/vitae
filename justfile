DATE := `LC_TIME=en_US.UTF-8 date "+%b%Y"`
JOBNAME := "AdrianBergesCV_" + DATE

all: makepdf
  mv ./cv.pdf ./{{JOBNAME}}.pdf

makepdf: processyml
  pandoc --defaults pdf_defaults.yaml

makeweb:
  pandoc --defaults html_defaults.yaml

processyml:
  python src/python/process_yaml_data.py

get-fonts:
  sudo apt install fonts-vollkorn fonts-open-sans

# Local Variables:
# mode: makefile
# End:
