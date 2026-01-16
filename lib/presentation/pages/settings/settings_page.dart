import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../app.dart';
import '../../../core/router/app_router.dart';
import '../../../core/utils/language_service.dart';
import '../../../di/injection.dart';
import '../../cubit/auth/logout_cubit.dart';

@RoutePage()
class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<LogoutCubit>(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(context.l10n.settings),
          centerTitle: true,
        ),
        body: ListView(
          children: [
            // Category Management
            ListTile(
              leading: const Icon(Icons.category_outlined),
              title: Text(context.l10n.categoryManagement),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                // TODO: Navigate to category management page
              },
            ),
            const Divider(height: 1),
            // Language
            ListTile(
              leading: const Icon(Icons.language),
              title: Text(context.l10n.language),
              subtitle: Text(
                LanguageService.getLanguageName(
                  Localizations.localeOf(context),
                ),
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (dialogContext) => AlertDialog(
                    title: Text(context.l10n.language),
                    content: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: LanguageService.getSupportedLocales().map((locale) {
                          final isSelected = Localizations.localeOf(context).languageCode ==
                              locale.languageCode;
                          return RadioListTile<Locale>(
                            title: Text(LanguageService.getLanguageName(locale)),
                            value: locale,
                            groupValue: isSelected ? locale : null,
                            onChanged: (value) {
                              if (value != null) {
                                Navigator.of(dialogContext).pop();
                                context.changeLanguage(value);
                              }
                            },
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                );
              },
            ),
            const Divider(height: 1),
            // Log out
            BlocConsumer<LogoutCubit, LogoutState>(
              listener: (context, state) {
                if (state is LogoutSuccess) {
                  // Navigate to login page
                  context.router.replaceAll([const LoginRoute()]);
                } else if (state is LogoutError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.message),
                      backgroundColor: Theme.of(context).colorScheme.error,
                    ),
                  );
                }
              },
              builder: (context, state) {
                final isLoading = state is LogoutLoading;
                return ListTile(
                  leading: isLoading
                      ? SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        )
                      : const Icon(Icons.logout, color: Colors.red),
                  title: Text(
                    context.l10n.logOut,
                    style: TextStyle(
                      color: isLoading ? null : Colors.red,
                    ),
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: isLoading
                      ? null
                      : () {
                          // Show confirmation dialog
                          showDialog(
                            context: context,
                            builder: (dialogContext) => AlertDialog(
                              title: Text(context.l10n.logOut),
                              content: Text(context.l10n.confirmLogout),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.of(dialogContext).pop(),
                                  child: Text(context.l10n.cancel),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(dialogContext).pop();
                                    context.read<LogoutCubit>().logout();
                                  },
                                  child: Text(
                                    context.l10n.logOut,
                                    style: const TextStyle(color: Colors.red),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
