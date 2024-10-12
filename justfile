DATE := `LC_TIME=en_US.UTF-8 date "+%b%Y"`
JOBNAME := "AdrianBergesCV_" + DATE

all: makepdf
  mv ./cv.pdf ./{{JOBNAME}}.pdf

makepdf: processyml
  pandoc --defaults pdf_defaults.yaml

makeweb:
  pandoc --defaults html_defaults.yaml

processyml:
  # python3 src/python/process_yaml_data.py
  pdm run python3 -m src.python.process_yaml_data

get-fonts:
  sudo apt install fonts-vollkorn fonts-open-sans

pdm-init:
  pdm init
  pdm sync

# Local Variables:
# mode: makefile
# End:
