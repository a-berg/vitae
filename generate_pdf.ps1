xelatex src/cv.tex `
    -include-directory=".\src\" `
    -output-directory=".\output\" `
    -job-name="AdrianBergesCV_$(get-date -f MMMyyyy)"