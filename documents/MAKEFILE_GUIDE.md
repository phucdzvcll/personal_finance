# Makefile Guide

This project includes a Makefile to simplify common Flutter development tasks.

## Quick Start

View all available commands:
```bash
make help
```

## Common Commands

### Setup & Installation
```bash
make install          # Install dependencies
make setup           # Complete setup (install + generate code)
make upgrade         # Upgrade dependencies
```

### Code Generation
```bash
make gen             # Generate code (freezed, injectable, auto_route)
make gen-watch       # Watch for changes and auto-generate
make gen-clean       # Clean generated files
```

### Running the App
```bash
make run-dev         # Run dev flavor
make run-stg         # Run staging flavor
make run-prod        # Run production flavor
make quick-dev       # Generate code + run dev (most common)
```

### Building
```bash
# Android APK
make build-apk-dev   # Build dev APK
make build-apk-stg   # Build staging APK
make build-apk-prod  # Build production APK

# Android App Bundle
make build-appbundle-dev
make build-appbundle-stg
make build-appbundle-prod

# iOS
make build-ios-dev
make build-ios-stg
make build-ios-prod
```

### Code Quality
```bash
make format          # Format code
make format-check    # Check formatting without changing files
make lint            # Run linter
```

### Testing
```bash
make test            # Run tests
make test-coverage   # Run tests with coverage
make test-watch      # Run tests in watch mode
```

### Cleaning
```bash
make clean           # Clean build files
make clean-all       # Clean everything including generated files
```

### Development Workflow
```bash
make dev             # Full dev workflow: install + generate + run dev
```

## CI/CD Commands

These commands are designed for CI/CD pipelines:

```bash
make ci-install      # Install dependencies
make ci-gen          # Generate code
make ci-lint         # Run linting checks
make ci-test         # Run tests
make ci-build-dev    # Build dev APK
make ci-build-prod   # Build production APK
```

## Examples

### Daily Development
```bash
# First time setup
make setup

# Daily workflow
make quick-dev       # Generate code and run dev flavor
```

### Before Committing
```bash
make format          # Format code
make lint            # Check for issues
make test            # Run tests
```

### Building for Release
```bash
# Android
make build-apk-prod
make build-appbundle-prod

# iOS
make build-ios-prod
```

### Troubleshooting
```bash
make clean-all       # Clean everything
make install         # Reinstall dependencies
make gen             # Regenerate code
```

## Tips

1. **Use `make quick-dev`** for the most common workflow (generate + run)
2. **Use `make help`** to see all available commands
3. **Use `make gen-watch`** when actively developing models/DI to auto-generate
4. **Use `make clean-all`** if you encounter strange build issues

## Command Reference

| Command | Description |
|---------|-------------|
| `make help` | Show all available commands |
| `make install` | Install Flutter dependencies |
| `make gen` | Generate code (freezed, injectable, auto_route) |
| `make run-dev` | Run app with dev flavor |
| `make run-stg` | Run app with staging flavor |
| `make run-prod` | Run app with production flavor |
| `make build-apk-prod` | Build production APK |
| `make format` | Format code |
| `make lint` | Run linter |
| `make test` | Run tests |
| `make clean` | Clean build files |
