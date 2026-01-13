# Flutter BLoC Provider Context Rule

## Problem

When using `BlocProvider` or `Provider` in Flutter, accessing the provider from methods in State classes can cause `ProviderNotFoundException` because the State's `context` is outside the provider's widget tree.

## Common Error Pattern

```dart
class _MyPageState extends State<MyPage> {
  void _handleAction() {
    // ❌ WRONG: This context is from State class, outside BlocProvider tree
    context.read<MyCubit>().doSomething();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<MyCubit>(),
      child: Scaffold(
        body: ElevatedButton(
          onPressed: _handleAction, // ❌ Wrong context used
          child: Text('Action'),
        ),
      ),
    );
  }
}
```

## Solution Pattern

Always pass `BuildContext` from within the provider's widget tree to methods that need to access providers.

### Pattern 1: Pass context from builder/callback

```dart
class _MyPageState extends State<MyPage> {
  void _handleAction(BuildContext context) {
    // ✅ CORRECT: Context is passed from within BlocProvider tree
    context.read<MyCubit>().doSomething();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<MyCubit>(),
      child: Scaffold(
        body: BlocBuilder<MyCubit, MyState>(
          builder: (context, state) {
            return ElevatedButton(
              onPressed: () => _handleAction(context), // ✅ Pass context from builder
              child: Text('Action'),
            );
          },
        ),
      ),
    );
  }
}
```

### Pattern 2: Use BlocConsumer builder context

```dart
class _MyPageState extends State<MyPage> {
  void _handleAction(BuildContext context) {
    context.read<MyCubit>().doSomething();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<MyCubit>(),
      child: Scaffold(
        body: BlocConsumer<MyCubit, MyState>(
          listener: (context, state) {
            // ✅ Context here is inside BlocProvider tree
          },
          builder: (context, state) {
            return ElevatedButton(
              onPressed: () => _handleAction(context), // ✅ Pass context from builder
              child: Text('Action'),
            );
          },
        ),
      ),
    );
  }
}
```

### Pattern 3: Store cubit reference (Alternative)

```dart
class _MyPageState extends State<MyPage> {
  late final MyCubit _cubit;

  void _handleAction() {
    _cubit.doSomething(); // ✅ Direct access to cubit
  }

  @override
  Widget build(BuildContext context) {
    _cubit = getIt<MyCubit>(); // Get from DI
    return BlocProvider.value(
      value: _cubit, // Provide existing instance
      child: Scaffold(
        body: ElevatedButton(
          onPressed: _handleAction,
          child: Text('Action'),
        ),
      ),
    );
  }
}
```

## Rules to Follow

1. **Never use State's `context` to access providers** - The State's `context` is outside the provider tree
2. **Always pass `BuildContext` from builder/callback** - Use context from `builder`, `listener`, or widget callbacks
3. **Use arrow functions with context** - `onPressed: () => _handleAction(context)` instead of `onPressed: _handleAction`
4. **When in doubt, check context scope** - Make sure the context you're using is a descendant of the `BlocProvider`

## Common Scenarios

### ✅ CORRECT: Form submission with validation

```dart
void _handleSubmit(BuildContext context) {
  if (_formKey.currentState!.validate()) {
    context.read<LoginCubit>().login(email, password);
  }
}

// In builder:
ElevatedButton(
  onPressed: () => _handleSubmit(context), // ✅ Correct
  child: Text('Submit'),
)
```

### ✅ CORRECT: Navigation after action

```dart
BlocConsumer<LoginCubit, LoginState>(
  listener: (context, state) {
    if (state is LoginSuccess) {
      context.router.push(HomeRoute()); // ✅ Context from listener
    }
  },
  builder: (context, state) {
    return ElevatedButton(
      onPressed: () => _handleLogin(context), // ✅ Context from builder
      child: Text('Login'),
    );
  },
)
```

### ❌ WRONG: Direct context access

```dart
void _handleAction() {
  context.read<MyCubit>().doSomething(); // ❌ Wrong context
}

ElevatedButton(
  onPressed: _handleAction, // ❌ No context passed
  child: Text('Action'),
)
```

## Testing

When writing tests, ensure you wrap widgets with `BlocProvider`:

```dart
testWidgets('should handle action', (tester) async {
  final cubit = MockMyCubit();
  
  await tester.pumpWidget(
    BlocProvider<MyCubit>(
      create: (_) => cubit,
      child: MyPage(),
    ),
  );
  
  // Test interactions
});
```

## Related Files

- `lib/presentation/pages/auth/login_page.dart` - Example of correct pattern
- `lib/presentation/pages/auth/register_page.dart` - Example of correct pattern

## Remember

**The context must come from within the provider's widget tree, not from the State class!**
