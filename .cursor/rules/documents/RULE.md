---
description: "This rule provides standards for place of documents generated"
alwaysApply: true
---
All document auto generated have to place in /documents

## Flutter Development Rules

### BLoC/Provider Context Access
When using BlocProvider or Provider, **NEVER** access providers using the State class's `context`. Always pass `BuildContext` from within the provider's widget tree (from builder, listener, or widget callbacks).

**See:** `../FLUTTER_BLOC_PROVIDER_CONTEXT.md` for detailed examples and patterns.