DATE := `date "+%b%Y"`

all:
	xelatex src/cv.tex \
		-include-directory="./src/" \
		-output-directory="./output/" \
		-job-name="AdrianBergesCV_{{DATE}}"
