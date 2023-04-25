#!/opt/homebrew/bin/zsh

# Called by .travis.yml. Compiles bookdown in HTML and pdf form.
# All R packages needed to be listed in the separate DESCRIPTION file to be installed.

#set -ev
set -v

Rscript -e "bookdown::render_book(output_format='bookdown::gitbook')"
#Rscript -e "bookdown::render_book('rmd_files', 'bookdown::pdf_book')"
#Rscript -e "bookdown::render_book('rmd_files', 'bookdown::epub_book')"

# copy .nojekyll into docs directory
#cp .nojekyll docs/

# remove temp .rds and .log files
#rm -rf *.rds *.log
