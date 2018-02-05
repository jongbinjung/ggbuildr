## Resubmission
This is a resubmission. In this version I have:

* Written package names and software names in single quotes (e.g. 'ggplot') in 
  title and description.

* Double checked that functions, examples, and tests do not write to user's home 
  filespace by default. All functions and examples will print(), unless a file 
  path is explicitly specified, and tests use tempfile() to generate
  temporary files for testing.
  
## Test environments
* local fedora 27, R 3.4.2
* ubuntu 14.04 (on travis-ci), R 3.4.2
* win-builder (devel and release)

## R CMD check results
There were no ERRORs or WARNINGs.

There was 1 NOTE:

* checking CRAN incoming feasibility ... NOTE
Maintainer: 'Jongbin Jung <me@jongbin.com>'

New submission

## Downstream dependencies
There are currently no downstream dependencies for this package.
