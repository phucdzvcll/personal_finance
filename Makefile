.PHONY: help install clean build run test gen format lint

# Default target
.DEFAULT_GOAL := help

# Colors for output
BLUE := \033[0;34m
GREEN := \033[0;32m
YELLOW := \033[1;33m
NC := \033[0m # No Color

help: ## Show this help message
	@echo "$(BLUE)Personal Finance - Flutter Project Makefile$(NC)"
	@echo ""
	@echo "$(GREEN)Available commands:$(NC)"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "  $(YELLOW)%-20s$(NC) %s\n", $$1, $$2}'

# Installation & Setup
install: ## Install Flutter dependencies
	@echo "$(BLUE)Installing dependencies...$(NC)"
	flutter pub get

upgrade: ## Upgrade Flutter dependencies
	@echo "$(BLUE)Upgrading dependencies...$(NC)"
	flutter pub upgrade

# Code Generation
gen: ## Generate code (freezed, injectable, auto_route)
	@echo "$(BLUE)Generating code...$(NC)"
	dart run build_runner build --delete-conflicting-outputs

gen-watch: ## Watch for changes and generate code automatically
	@echo "$(BLUE)Watching for changes...$(NC)"
	dart run build_runner watch --delete-conflicting-outputs

gen-clean: ## Clean generated files
	@echo "$(BLUE)Cleaning generated files...$(NC)"
	dart run build_runner clean

# Code Quality
format: ## Format code
	@echo "$(BLUE)Formatting code...$(NC)"
	dart format lib test

format-check: ## Check code formatting without changing files
	@echo "$(BLUE)Checking code format...$(NC)"
	dart format --set-exit-if-changed lib test

lint: ## Run linter
	@echo "$(BLUE)Running linter...$(NC)"
	flutter analyze

# Cleaning
clean: ## Clean build files
	@echo "$(BLUE)Cleaning build files...$(NC)"
	flutter clean
	flutter pub get

clean-all: clean gen-clean ## Clean everything including generated files
	@echo "$(BLUE)Cleaning everything...$(NC)"
	rm -rf .dart_tool
	rm -rf build

# Running
run-dev: ## Run app with dev flavor (Android) or default (iOS)
	@echo "$(GREEN)Running dev flavor...$(NC)"
	@if flutter devices | grep -q "ios"; then \
		echo "$(YELLOW)Note: iOS detected. Running without flavor (schemes not configured).$(NC)"; \
		echo "$(YELLOW)To use flavors on iOS, set up Xcode schemes first.$(NC)"; \
		flutter run -t lib/main.dart; \
	else \
		flutter run --flavor dev -t lib/main.dart; \
	fi

run-stg: ## Run app with staging flavor (Android) or default (iOS)
	@echo "$(GREEN)Running staging flavor...$(NC)"
	@if flutter devices | grep -q "ios"; then \
		echo "$(YELLOW)Note: iOS detected. Running without flavor (schemes not configured).$(NC)"; \
		echo "$(YELLOW)To use flavors on iOS, set up Xcode schemes first.$(NC)"; \
		flutter run -t lib/main.dart; \
	else \
		flutter run --flavor stg -t lib/main.dart; \
	fi

run-prod: ## Run app with production flavor (Android) or default (iOS)
	@echo "$(GREEN)Running production flavor...$(NC)"
	@if flutter devices | grep -q "ios"; then \
		echo "$(YELLOW)Note: iOS detected. Running without flavor (schemes not configured).$(NC)"; \
		echo "$(YELLOW)To use flavors on iOS, set up Xcode schemes first.$(NC)"; \
		flutter run -t lib/main.dart --release; \
	else \
		flutter run --flavor prod -t lib/main.dart; \
	fi

run-dev-release: ## Run app with dev flavor in release mode
	@echo "$(GREEN)Running dev flavor (release)...$(NC)"
	@if flutter devices | grep -q "ios"; then \
		flutter run -t lib/main.dart --release; \
	else \
		flutter run --flavor dev -t lib/main.dart --release; \
	fi

# iOS-specific commands (without flavors)
run-ios: ## Run on iOS device without flavor
	@echo "$(GREEN)Running on iOS device...$(NC)"
	flutter run -t lib/main.dart

run-ios-release: ## Run on iOS device in release mode
	@echo "$(GREEN)Running on iOS device (release)...$(NC)"
	flutter run -t lib/main.dart --release

# Building Android
build-apk-dev: ## Build Android APK for dev
	@echo "$(BLUE)Building dev APK...$(NC)"
	flutter build apk --flavor dev -t lib/main.dart

build-apk-stg: ## Build Android APK for staging
	@echo "$(BLUE)Building staging APK...$(NC)"
	flutter build apk --flavor stg -t lib/main.dart

build-apk-prod: ## Build Android APK for production
	@echo "$(BLUE)Building production APK...$(NC)"
	flutter build apk --flavor prod -t lib/main.dart --release

build-appbundle-dev: ## Build Android App Bundle for dev
	@echo "$(BLUE)Building dev App Bundle...$(NC)"
	flutter build appbundle --flavor dev -t lib/main.dart

build-appbundle-stg: ## Build Android App Bundle for staging
	@echo "$(BLUE)Building staging App Bundle...$(NC)"
	flutter build appbundle --flavor stg -t lib/main.dart

build-appbundle-prod: ## Build Android App Bundle for production
	@echo "$(BLUE)Building production App Bundle...$(NC)"
	flutter build appbundle --flavor prod -t lib/main.dart --release

# Building iOS
build-ios-dev: ## Build iOS app for dev
	@echo "$(BLUE)Building dev iOS app...$(NC)"
	flutter build ios --flavor dev -t lib/main.dart

build-ios-stg: ## Build iOS app for staging
	@echo "$(BLUE)Building staging iOS app...$(NC)"
	flutter build ios --flavor stg -t lib/main.dart

build-ios-prod: ## Build iOS app for production
	@echo "$(BLUE)Building production iOS app...$(NC)"
	flutter build ios --flavor prod -t lib/main.dart --release

# Testing
test: ## Run tests
	@echo "$(BLUE)Running tests...$(NC)"
	flutter test

test-coverage: ## Run tests with coverage
	@echo "$(BLUE)Running tests with coverage...$(NC)"
	flutter test --coverage

test-watch: ## Run tests in watch mode
	@echo "$(BLUE)Running tests in watch mode...$(NC)"
	flutter test --watch

# Device Management
devices: ## List connected devices
	@echo "$(BLUE)Connected devices:$(NC)"
	flutter devices

doctor: ## Run Flutter doctor
	@echo "$(BLUE)Running Flutter doctor...$(NC)"
	flutter doctor -v

# Quick Setup (for new developers)
setup: install gen ## Complete setup: install dependencies and generate code
	@echo "$(GREEN)Setup complete!$(NC)"

# Development workflow
dev: install gen run-dev ## Full dev workflow: install, generate, and run dev

# CI/CD helpers
ci-install: install ## Install dependencies for CI
	@echo "$(GREEN)Dependencies installed$(NC)"

ci-gen: gen ## Generate code for CI
	@echo "$(GREEN)Code generated$(NC)"

ci-lint: format-check lint ## Run linting checks for CI
	@echo "$(GREEN)Linting complete$(NC)"

ci-test: test ## Run tests for CI
	@echo "$(GREEN)Tests complete$(NC)"

ci-build-dev: build-apk-dev ## Build dev APK for CI
	@echo "$(GREEN)Dev build complete$(NC)"

ci-build-prod: build-apk-prod ## Build production APK for CI
	@echo "$(GREEN)Production build complete$(NC)"

# iOS Setup
setup-ios-flavors: ## Open Xcode and show iOS flavors setup instructions
	@./scripts/setup_ios_flavors.sh

# Quick commands (most common shortcuts)
quick-dev: gen run-dev ## Quick dev: generate and run dev flavor
quick-stg: gen run-stg ## Quick staging: generate and run staging flavor
quick-prod: gen run-prod ## Quick prod: generate and run production flavor
quick-ios: gen run-ios ## Quick iOS: generate and run on iOS device

# Ultra-short aliases (for daily use)
g: gen ## Shortcut: Generate code
i: install ## Shortcut: Install dependencies
r: run-dev ## Shortcut: Run dev flavor
c: clean ## Shortcut: Clean build files
f: format ## Shortcut: Format code
l: lint ## Shortcut: Run linter
t: test ## Shortcut: Run tests
d: devices ## Shortcut: List devices

# Combined workflows
fresh: clean install gen ## Fresh start: clean, install, and generate
rebuild: clean install gen run-dev ## Rebuild: clean, install, generate, and run
check: format-check lint test ## Check all: format, lint, and test
build-all: build-apk-dev build-apk-stg build-apk-prod ## Build all Android flavors

# Development shortcuts
watch: gen-watch ## Watch mode: auto-generate on file changes
run: run-dev ## Default run: dev flavor
build: build-apk-dev ## Default build: dev APK