// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appName => 'Finance Personnelle';

  @override
  String get welcomeBack => 'Bon Retour';

  @override
  String get signInToContinue => 'Connectez-vous pour continuer';

  @override
  String get usernameOrEmail => 'Nom d\'utilisateur ou Email';

  @override
  String get enterUsernameOrEmail => 'Entrez le nom d\'utilisateur ou l\'email';

  @override
  String get pleaseEnterUsernameOrEmail =>
      'Veuillez entrer votre nom d\'utilisateur ou votre email';

  @override
  String get pleaseEnterValidUsernameOrEmail =>
      'Veuillez entrer un nom d\'utilisateur ou un email valide';

  @override
  String get password => 'Mot de passe';

  @override
  String get pleaseEnterPassword => 'Veuillez entrer votre mot de passe';

  @override
  String get signIn => 'Se connecter';

  @override
  String get dontHaveAccount => 'Vous n\'avez pas de compte ? ';

  @override
  String get signUp => 'S\'inscrire';

  @override
  String get createAccount => 'Créer un compte';

  @override
  String get signUpToGetStarted => 'Inscrivez-vous pour commencer';

  @override
  String get fullNameOptional => 'Nom complet (Optionnel)';

  @override
  String get email => 'Email';

  @override
  String get pleaseEnterEmail => 'Veuillez entrer votre email';

  @override
  String get pleaseEnterValidEmail => 'Veuillez entrer un email valide';

  @override
  String get pleaseEnterPasswordField => 'Veuillez entrer un mot de passe';

  @override
  String get passwordMinLength =>
      'Le mot de passe doit contenir au moins 8 caractères';

  @override
  String get confirmPassword => 'Confirmer le mot de passe';

  @override
  String get pleaseConfirmPassword => 'Veuillez confirmer votre mot de passe';

  @override
  String get passwordsDoNotMatch => 'Les mots de passe ne correspondent pas';

  @override
  String get alreadyHaveAccount => 'Vous avez déjà un compte ? ';

  @override
  String get welcomeToPersonalFinance => 'Bienvenue dans Finance Personnelle';

  @override
  String get startManagingFinances => 'Commencez à gérer vos finances';

  @override
  String get settings => 'Paramètres';

  @override
  String get configureAppSettings =>
      'Configurez les paramètres de votre application';

  @override
  String get categoryManagement => 'Gestion des Catégories';

  @override
  String get language => 'Langue';

  @override
  String get logOut => 'Se déconnecter';

  @override
  String get confirmLogout => 'Êtes-vous sûr de vouloir vous déconnecter ?';

  @override
  String get cancel => 'Annuler';

  @override
  String get addNewCategory => 'Ajouter une Nouvelle Catégorie';

  @override
  String get viewCategoryTransactions => 'Voir les Transactions par Catégorie';

  @override
  String get categoryName => 'Nom de la Catégorie';

  @override
  String get enterCategoryName => 'Entrez le nom de la catégorie';

  @override
  String get pleaseEnterCategoryName =>
      'Veuillez entrer le nom de la catégorie';

  @override
  String get categoryType => 'Type de Catégorie';

  @override
  String get expense => 'Dépense';

  @override
  String get income => 'Revenu';

  @override
  String get createCategory => 'Créer la Catégorie';

  @override
  String get categoryCreatedSuccessfully => 'Catégorie créée avec succès';

  @override
  String get fillCategoryDetails => 'Remplissez les détails de la catégorie';

  @override
  String get selectIcon => 'Sélectionner l\'Icône';

  @override
  String get selectColor => 'Sélectionner la Couleur';

  @override
  String get select => 'Sélectionner';

  @override
  String get viewCategories => 'Voir les Catégories';

  @override
  String get noCategoriesFound => 'Aucune catégorie trouvée';

  @override
  String get retry => 'Réessayer';

  @override
  String get editCategory => 'Modifier la Catégorie';

  @override
  String get updateCategory => 'Mettre à jour la Catégorie';

  @override
  String get categoryUpdatedSuccessfully => 'Catégorie mise à jour avec succès';

  @override
  String get delete => 'Supprimer';

  @override
  String get deleteCategory => 'Supprimer la Catégorie';

  @override
  String deleteCategoryConfirmation(String categoryName) {
    return 'Êtes-vous sûr de vouloir supprimer \"$categoryName\"?';
  }

  @override
  String get categoryDeletedSuccessfully => 'Catégorie supprimée avec succès';

  @override
  String get addTransaction => 'Ajouter une Transaction';

  @override
  String get amount => 'Montant';

  @override
  String get enterAmount => 'Entrez le montant';

  @override
  String get pleaseEnterAmount => 'Veuillez entrer le montant';

  @override
  String get amountMustBeGreaterThanZero =>
      'Le montant doit être supérieur à 0';

  @override
  String get transactionType => 'Type de Transaction';

  @override
  String get category => 'Catégorie';

  @override
  String get selectCategory => 'Sélectionner la Catégorie';

  @override
  String get pleaseSelectCategory => 'Veuillez sélectionner une catégorie';

  @override
  String get transactionDate => 'Date de Transaction';

  @override
  String get selectDate => 'Sélectionner la Date';

  @override
  String get pleaseSelectDate => 'Veuillez sélectionner une date';

  @override
  String get note => 'Note';

  @override
  String get enterNote => 'Entrez une note (optionnel)';

  @override
  String get createTransaction => 'Créer la Transaction';

  @override
  String get transactionCreatedSuccessfully => 'Transaction créée avec succès';

  @override
  String get fillTransactionDetails =>
      'Remplissez les détails de la transaction';

  @override
  String get transactions => 'Transactions';

  @override
  String get viewAndManageTransactions => 'Voir et gérer vos transactions';

  @override
  String get noTransactionsFound => 'Aucune transaction trouvée';

  @override
  String get editTransaction => 'Modifier la Transaction';

  @override
  String get updateTransaction => 'Mettre à jour la Transaction';

  @override
  String get transactionUpdatedSuccessfully =>
      'Transaction mise à jour avec succès';

  @override
  String get transactionDeletedSuccessfully =>
      'Transaction supprimée avec succès';

  @override
  String get monthlySummary => 'Résumé Mensuel';

  @override
  String get totalIncome => 'Revenus Totaux';

  @override
  String get totalExpense => 'Dépenses Totales';

  @override
  String get balance => 'Solde';

  @override
  String get expenseByCategory => 'Dépenses par Catégorie';

  @override
  String get noExpenseData => 'Aucune donnée de dépense disponible';

  @override
  String get loading => 'Chargement...';

  @override
  String get filter => 'Filtrer';

  @override
  String get selectMonthYear => 'Sélectionner le Mois et l\'Année';

  @override
  String get year => 'Année';

  @override
  String get month => 'Mois';

  @override
  String get list => 'Liste';

  @override
  String get chart => 'Graphique';

  @override
  String get selectDateRange => 'Sélectionner une plage de dates';

  @override
  String get startDate => 'Date de début';

  @override
  String get endDate => 'Date de fin';

  @override
  String get notSelected => 'Non sélectionné';

  @override
  String get clear => 'Effacer';

  @override
  String get apply => 'Appliquer';

  @override
  String get all => 'Tous';
}
