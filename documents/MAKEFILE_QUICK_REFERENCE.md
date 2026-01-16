# Makefile Quick Reference

## 🚀 Most Common Commands (Ultra-Short)

| Command | Description |
|---------|-------------|
| `make g` | Generate code (freezed, injectable, auto_route) |
| `make i` | Install dependencies |
| `make r` | Run dev flavor |
| `make c` | Clean build files |
| `make f` | Format code |
| `make l` | Lint code |
| `make t` | Run tests |
| `make d` | List connected devices |

## 📦 Installation & Setup

| Command | Description |
|---------|-------------|
| `make install` | Install Flutter dependencies |
| `make upgrade` | Upgrade Flutter dependencies |
| `make setup` | Complete setup: install + generate code |
| `make fresh` | Fresh start: clean + install + generate |

## 🔧 Code Generation

| Command | Description |
|---------|-------------|
| `make gen` or `make g` | Generate code (freezed, injectable, auto_route) |
| `make gen-watch` or `make watch` | Watch for changes and auto-generate |
| `make gen-clean` | Clean generated files |

## 🏃 Running the App

| Command | Description |
|---------|-------------|
| `make run-dev` or `make r` | Run dev flavor |
| `make run-stg` | Run staging flavor |
| `make run-prod` | Run production flavor |
| `make run-ios` | Run on iOS device |
| `make quick-dev` | Generate + run dev (most common) |
| `make quick-stg` | Generate + run staging |
| `make quick-prod` | Generate + run production |
| `make quick-ios` | Generate + run iOS |

## 🏗️ Building

### Android
| Command | Description |
|---------|-------------|
| `make build-apk-dev` | Build dev APK |
| `make build-apk-stg` | Build staging APK |
| `make build-apk-prod` | Build production APK |
| `make build-appbundle-dev` | Build dev App Bundle |
| `make build-appbundle-stg` | Build staging App Bundle |
| `make build-appbundle-prod` | Build production App Bundle |
| `make build` | Default: build dev APK |

### iOS
| Command | Description |
|---------|-------------|
| `make build-ios-dev` | Build dev iOS app |
| `make build-ios-stg` | Build staging iOS app |
| `make build-ios-prod` | Build production iOS app |

## 🧹 Cleaning

| Command | Description |
|---------|-------------|
| `make clean` or `make c` | Clean build files |
| `make clean-all` | Clean everything including generated files |
| `make gen-clean` | Clean only generated files |

## ✨ Code Quality

| Command | Description |
|---------|-------------|
| `make format` or `make f` | Format code |
| `make format-check` | Check formatting without changing files |
| `make lint` or `make l` | Run linter |
| `make check` | Check all: format + lint + test |

## 🧪 Testing

| Command | Description |
|---------|-------------|
| `make test` or `make t` | Run tests |
| `make test-coverage` | Run tests with coverage |
| `make test-watch` | Run tests in watch mode |

## 🔄 Combined Workflows

| Command | Description |
|---------|-------------|
| `make dev` | Full dev workflow: install + generate + run dev |
| `make rebuild` | Rebuild: clean + install + generate + run |
| `make fresh` | Fresh start: clean + install + generate |
| `make check` | Check all: format + lint + test |
| `make build-all` | Build all Android flavors |

## 📱 Device Management

| Command | Description |
|---------|-------------|
| `make devices` or `make d` | List connected devices |
| `make doctor` | Run Flutter doctor |

## 🎯 Daily Development Workflow

### Typical Day:
```bash
# Morning: Start fresh
make fresh          # Clean, install, generate

# During development:
make g              # Generate code after model changes
make r              # Run dev flavor
make f              # Format code
make l              # Check for issues

# Before commit:
make check          # Format + lint + test
```

### Quick Development Cycle:
```bash
make quick-dev      # Generate + run (most common)
# or even shorter:
make g && make r    # Generate then run
```

## 🚢 CI/CD Commands

| Command | Description |
|---------|-------------|
| `make ci-install` | Install dependencies for CI |
| `make ci-gen` | Generate code for CI |
| `make ci-lint` | Run linting checks for CI |
| `make ci-test` | Run tests for CI |
| `make ci-build-dev` | Build dev APK for CI |
| `make ci-build-prod` | Build production APK for CI |

## 📋 Help

| Command | Description |
|---------|-------------|
| `make help` | Show all available commands |
| `make` | Default: shows help |

## 💡 Tips

1. **Most Common**: `make quick-dev` or `make g && make r`
2. **After Model Changes**: Always run `make g` (or `make gen`)
3. **Before Committing**: Run `make check`
4. **Fresh Start**: Use `make fresh` when things get messy
5. **Watch Mode**: Use `make watch` during active development

## 🎨 Example Workflows

### Starting a New Feature:
```bash
make fresh          # Clean start
make quick-dev      # Generate and run
```

### After Adding a New Model:
```bash
make g              # Generate Freezed code
make r              # Run to test
```

### Before Pushing Code:
```bash
make check          # Format + lint + test
```

### Building for Release:
```bash
make build-apk-prod # Production APK
# or
make build-appbundle-prod # Production App Bundle
```

---

**Pro Tip**: Type `make` or `make help` anytime to see all available commands!
