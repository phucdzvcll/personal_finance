import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:personal_finance/core/router/app_router.dart';
import '../../../app.dart';
import '../../../core/utils/input_validator.dart';
import '../../../di/injection.dart';
import '../../cubit/auth/login_cubit.dart';
import '../../widgets/common/loading_widget.dart';

@RoutePage()
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameOrEmailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _usernameOrEmailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      context.read<LoginCubit>().login(
            _usernameOrEmailController.text.trim(),
            _passwordController.text,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<LoginCubit>(),
      child: Scaffold(
        body: SafeArea(
          child: GestureDetector(
            onTap: () {
              // Unfocus when tapping outside input fields
              FocusScope.of(context).unfocus();
            },
            behavior: HitTestBehavior.opaque,
            child: SingleChildScrollView(
              padding: EdgeInsets.all(24.w),
              child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: 60.h),
                  Icon(
                    Icons.account_balance_wallet,
                    size: 80.sp,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  SizedBox(height: 24.h),
                  Text(
                    context.l10n.welcomeBack,
                    style: Theme.of(context).textTheme.headlineLarge,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    context.l10n.signInToContinue,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                        ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 48.h),
                  TextFormField(
                    controller: _usernameOrEmailController,
                    keyboardType: TextInputType.text,
                    textCapitalization: TextCapitalization.none,
                    decoration: InputDecoration(
                      labelText: context.l10n.usernameOrEmail,
                      hintText: context.l10n.enterUsernameOrEmail,
                      prefixIcon: const Icon(Icons.person_outlined),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return context.l10n.pleaseEnterUsernameOrEmail;
                      }
                      if (!InputValidator.isValidUsernameOrEmail(value.trim())) {
                        return context.l10n.pleaseEnterValidUsernameOrEmail;
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16.h),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    decoration: InputDecoration(
                      labelText: context.l10n.password,
                      prefixIcon: const Icon(Icons.lock_outlined),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return context.l10n.pleaseEnterPassword;
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 32.h),
                  BlocConsumer<LoginCubit, LoginState>(
                    listener: (context, state) {
                      if (state is LoginSuccess) {
                        // Navigate to main tab page
                        context.router.replaceAll([const MainTabRoute()]);
                      } else if (state is LoginError) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(state.message),
                            backgroundColor: Theme.of(context).colorScheme.error,
                          ),
                        );
                      }
                    },
                    builder: (context, state) {
                      if (state is LoginLoading) {
                        return const LoadingWidget();
                      }
                      return ElevatedButton(
                        onPressed: () => _handleLogin(context),
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 16.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                        ),
                        child: Text(
                          context.l10n.signIn,
                          style: TextStyle(fontSize: 16.sp),
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 24.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        context.l10n.dontHaveAccount,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      TextButton(
                        onPressed: () {
                          context.router.push(const RegisterRoute());
                        },
                        child: Text(context.l10n.signUp),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            ),
          ),
        ),
      ),
    );
  }
}
