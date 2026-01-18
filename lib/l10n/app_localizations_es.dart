// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appName => 'Finanzas Personales';

  @override
  String get welcomeBack => 'Bienvenido de Nuevo';

  @override
  String get signInToContinue => 'Inicia sesión para continuar';

  @override
  String get usernameOrEmail => 'Nombre de usuario o Correo';

  @override
  String get enterUsernameOrEmail => 'Ingresa nombre de usuario o correo';

  @override
  String get pleaseEnterUsernameOrEmail =>
      'Por favor ingresa tu nombre de usuario o correo';

  @override
  String get pleaseEnterValidUsernameOrEmail =>
      'Por favor ingresa un nombre de usuario o correo válido';

  @override
  String get password => 'Contraseña';

  @override
  String get pleaseEnterPassword => 'Por favor ingresa tu contraseña';

  @override
  String get signIn => 'Iniciar Sesión';

  @override
  String get dontHaveAccount => '¿No tienes una cuenta? ';

  @override
  String get signUp => 'Registrarse';

  @override
  String get createAccount => 'Crear Cuenta';

  @override
  String get signUpToGetStarted => 'Regístrate para comenzar';

  @override
  String get fullNameOptional => 'Nombre Completo (Opcional)';

  @override
  String get email => 'Correo Electrónico';

  @override
  String get pleaseEnterEmail => 'Por favor ingresa tu correo electrónico';

  @override
  String get pleaseEnterValidEmail =>
      'Por favor ingresa un correo electrónico válido';

  @override
  String get pleaseEnterPasswordField => 'Por favor ingresa una contraseña';

  @override
  String get passwordMinLength =>
      'La contraseña debe tener al menos 8 caracteres';

  @override
  String get confirmPassword => 'Confirmar Contraseña';

  @override
  String get pleaseConfirmPassword => 'Por favor confirma tu contraseña';

  @override
  String get passwordsDoNotMatch => 'Las contraseñas no coinciden';

  @override
  String get alreadyHaveAccount => '¿Ya tienes una cuenta? ';

  @override
  String get welcomeToPersonalFinance => 'Bienvenido a Finanzas Personales';

  @override
  String get startManagingFinances => 'Comienza a gestionar tus finanzas';

  @override
  String get settings => 'Configuración';

  @override
  String get configureAppSettings => 'Configura las opciones de tu aplicación';

  @override
  String get categoryManagement => 'Gestión de Categorías';

  @override
  String get language => 'Idioma';

  @override
  String get logOut => 'Cerrar sesión';

  @override
  String get confirmLogout => '¿Estás seguro de que quieres cerrar sesión?';

  @override
  String get cancel => 'Cancelar';

  @override
  String get addNewCategory => 'Agregar Nueva Categoría';

  @override
  String get viewCategoryTransactions => 'Ver Transacciones por Categoría';

  @override
  String get categoryName => 'Nombre de la Categoría';

  @override
  String get enterCategoryName => 'Ingresa el nombre de la categoría';

  @override
  String get pleaseEnterCategoryName =>
      'Por favor ingresa el nombre de la categoría';

  @override
  String get categoryType => 'Tipo de Categoría';

  @override
  String get expense => 'Gasto';

  @override
  String get income => 'Ingreso';

  @override
  String get createCategory => 'Crear Categoría';

  @override
  String get categoryCreatedSuccessfully => 'Categoría creada exitosamente';

  @override
  String get fillCategoryDetails => 'Completa los detalles de la categoría';

  @override
  String get selectIcon => 'Seleccionar Icono';

  @override
  String get selectColor => 'Seleccionar Color';

  @override
  String get select => 'Seleccionar';

  @override
  String get viewCategories => 'Ver Categorías';

  @override
  String get noCategoriesFound => 'No se encontraron categorías';

  @override
  String get retry => 'Reintentar';

  @override
  String get editCategory => 'Editar Categoría';

  @override
  String get updateCategory => 'Actualizar Categoría';

  @override
  String get categoryUpdatedSuccessfully =>
      'Categoría actualizada exitosamente';

  @override
  String get delete => 'Eliminar';

  @override
  String get deleteCategory => 'Eliminar Categoría';

  @override
  String deleteCategoryConfirmation(String categoryName) {
    return '¿Estás seguro de que quieres eliminar \"$categoryName\"?';
  }

  @override
  String get categoryDeletedSuccessfully => 'Categoría eliminada exitosamente';

  @override
  String get addTransaction => 'Agregar Transacción';

  @override
  String get amount => 'Monto';

  @override
  String get enterAmount => 'Ingresa el monto';

  @override
  String get pleaseEnterAmount => 'Por favor ingresa el monto';

  @override
  String get amountMustBeGreaterThanZero => 'El monto debe ser mayor que 0';

  @override
  String get transactionType => 'Tipo de Transacción';

  @override
  String get category => 'Categoría';

  @override
  String get selectCategory => 'Seleccionar Categoría';

  @override
  String get pleaseSelectCategory => 'Por favor selecciona una categoría';

  @override
  String get transactionDate => 'Fecha de Transacción';

  @override
  String get selectDate => 'Seleccionar Fecha';

  @override
  String get pleaseSelectDate => 'Por favor selecciona una fecha';

  @override
  String get note => 'Nota';

  @override
  String get enterNote => 'Ingresa nota (opcional)';

  @override
  String get createTransaction => 'Crear Transacción';

  @override
  String get transactionCreatedSuccessfully =>
      'Transacción creada exitosamente';

  @override
  String get fillTransactionDetails =>
      'Completa los detalles de la transacción';

  @override
  String get transactions => 'Transacciones';

  @override
  String get viewAndManageTransactions => 'Ver y gestionar tus transacciones';

  @override
  String get noTransactionsFound => 'No se encontraron transacciones';

  @override
  String get editTransaction => 'Editar Transacción';

  @override
  String get updateTransaction => 'Actualizar Transacción';

  @override
  String get transactionUpdatedSuccessfully =>
      'Transacción actualizada exitosamente';

  @override
  String get transactionDeletedSuccessfully =>
      'Transacción eliminada exitosamente';
}
