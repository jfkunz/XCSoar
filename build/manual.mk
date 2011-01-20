MANUAL_OUTPUT_DIR = $(OUT)/all/manual
TEX_INCLUDES = $(wildcard $(DOC)/manual/*.sty)
FIGURES = $(DOC)/manual/figures/*.png
SVG_ICON_LIST = \
	alt2_landable_airport \
	alt2_landable_field \
	alt_landable_airport \
	alt_landable_field \
	alt_reachable_airport \
	alt_reachable_field \
	winpilot_landable \
	winpilot_marginal \
	winpilot_reachable \
	map_turnpoint
SVG_ICONS = $(patsubst %,$(DOC)/manual/generated/icons/%.png,$(SVG_ICON_LIST))

TEX_FLAGS = -halt-on-error -interaction=nonstopmode

.PHONY: manual
manual: $(MANUAL_OUTPUT_DIR)/XCSoar-manual.pdf

$(MANUAL_OUTPUT_DIR)/XCSoar-manual.pdf: $(DOC)/manual/XCSoar-manual.tex $(TEX_INCLUDES) \
	$(FIGURES) $(SVG_ICONS) | $(MANUAL_OUTPUT_DIR)/dirstamp
	# run TeX twice to make sure that all references are resolved
	cd $(<D) && pdflatex $(TEX_FLAGS) -output-directory $(abspath $(@D)) $(<F)
	cd $(<D) && pdflatex $(TEX_FLAGS) -output-directory $(abspath $(@D)) $(<F)

$(SVG_ICONS): $(DOC)/manual/generated/icons/%.png: $(topdir)/Data/icons/%.svg | $(DOC)/manual/generated/icons/dirstamp
	rsvg-convert -a -w 32 $< -o $@
