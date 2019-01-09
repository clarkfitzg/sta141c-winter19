%.pdf: %.md
	pandoc -s $< -o $@ -V geometry:margin=1in -V fontsize=12pt

%.md: %.R
	~/dev/teaching-notes/tools/clear_code.py md $< $@

