all: dualangle.asy helicoid.pdf line.pdf nontrivial_line.pdf plucker_conoid.pdf clean

dualangle.pdf: dualangle.asy
	asy -noV -v $<

helicoid.pdf: helicoid.asy
	asy -noV -v $<

line.pdf: line.asy
	asy -noV -v $<

nontrivial_line.pdf: nontrivial_line.asy
	asy -noV -v $<

plucker_conoid.pdf: plucker_conoid.asy
	asy -noV -v $<


.PHONY: clean cleanall
clean:
	rm -fv *.tex *.ps *.aux *.log

cleanall: clean
	rm -fv *.pdf

