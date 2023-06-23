run-build:
	@echo "running build..." && \
	dart run build_runner watch  --delete-conflicting-outputs

gen-logos-and-splash:
	dart run flutter_launcher_icons && \
	dart run flutter_native_splash:create

.PHONY: run-build gen-logos-and-splash