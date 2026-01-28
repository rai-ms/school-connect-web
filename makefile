.PHONY: build_runner gen_l10n asset_gen all

# Run code generation using build_runner
build_runner:
	dart run build_runner build --delete-conflicting-outputs

# Generate localization files
gen_l10n:
	flutter gen-l10n --arb-dir=lib/l10n --output-dir=lib/generated/l10n --template-arb-file=intl_en.arb --output-localization-file=s.dart --output-class=S

# Generate asset references (Flutter gen command)
asset_gen:
	dart run asset_generator:generate --delete-conflicting-outputs

# Language and injector runner
injector_and_lang: build_runner gen_l10n

# Run all code generation steps
all: build_runner gen_l10n asset_gen

# Run commands (defaults to dev)
run:
	flutter run --flavor dev

# Flavor-specific run commands
run-dev:
	flutter run --flavor dev

run-prod:
	flutter run --flavor prod

icon_gen:
	dart run flutter_launcher_icons

splash_gen:
	flutter pub run flutter_native_splash:create

# Legacy build
build_apk:
	flutter clean && flutter pub get && flutter build apk --release --no-tree-shake-icons --split-per-abi

# Flavor-specific APK builds
build-dev-apk:
	flutter build apk --flavor dev --split-per-abi

build-prod-apk:
	flutter build apk --flavor prod --release --split-per-abi

# Flavor-specific App Bundle builds
build-dev-appbundle:
	flutter build appbundle --flavor dev

build-prod-appbundle:
	flutter build appbundle --flavor prod --release

# Flavor-specific iOS builds
build-dev-ios:
	flutter build ios --flavor dev

build-prod-ios:
	flutter build ios --flavor prod --release

build-dev-ipa:
	flutter build ipa --flavor dev

build-prod-ipa:
	flutter build ipa --flavor prod --release


run_tunnel:
	cloudflared tunnel --url http://localhost:8080
run_spring:
	mvn spring-boot:run

clean:
	rm -rf pubspec.lock
