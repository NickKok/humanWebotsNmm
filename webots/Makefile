all: controller plugin

CONTROLLER ?= with_lib

controller:
	@echo "Making controller..."; \
	$(MAKE) -C controllers/$(CONTROLLER) >/dev/null

plugin:
	@echo "Making plugin..."; \
	$(MAKE) -C plugins/physics/no_lift >/dev/null
