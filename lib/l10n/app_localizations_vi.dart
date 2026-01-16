// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Vietnamese (`vi`).
class AppLocalizationsVi extends AppLocalizations {
  AppLocalizationsVi([String locale = 'vi']) : super(locale);

  @override
  String get appName => 'Tài Chính Cá Nhân';

  @override
  String get welcomeBack => 'Chào Mừng Trở Lại';

  @override
  String get signInToContinue => 'Đăng nhập để tiếp tục';

  @override
  String get usernameOrEmail => 'Tên đăng nhập hoặc Email';

  @override
  String get enterUsernameOrEmail => 'Nhập tên đăng nhập hoặc email';

  @override
  String get pleaseEnterUsernameOrEmail =>
      'Vui lòng nhập tên đăng nhập hoặc email';

  @override
  String get pleaseEnterValidUsernameOrEmail =>
      'Vui lòng nhập tên đăng nhập hoặc email hợp lệ';

  @override
  String get password => 'Mật khẩu';

  @override
  String get pleaseEnterPassword => 'Vui lòng nhập mật khẩu';

  @override
  String get signIn => 'Đăng Nhập';

  @override
  String get dontHaveAccount => 'Chưa có tài khoản? ';

  @override
  String get signUp => 'Đăng Ký';

  @override
  String get createAccount => 'Tạo Tài Khoản';

  @override
  String get signUpToGetStarted => 'Đăng ký để bắt đầu';

  @override
  String get fullNameOptional => 'Họ và Tên (Tùy chọn)';

  @override
  String get email => 'Email';

  @override
  String get pleaseEnterEmail => 'Vui lòng nhập email';

  @override
  String get pleaseEnterValidEmail => 'Vui lòng nhập email hợp lệ';

  @override
  String get pleaseEnterPasswordField => 'Vui lòng nhập mật khẩu';

  @override
  String get passwordMinLength => 'Mật khẩu phải có ít nhất 8 ký tự';

  @override
  String get confirmPassword => 'Xác Nhận Mật Khẩu';

  @override
  String get pleaseConfirmPassword => 'Vui lòng xác nhận mật khẩu';

  @override
  String get passwordsDoNotMatch => 'Mật khẩu không khớp';

  @override
  String get alreadyHaveAccount => 'Đã có tài khoản? ';

  @override
  String get welcomeToPersonalFinance => 'Chào Mừng Đến Tài Chính Cá Nhân';

  @override
  String get startManagingFinances => 'Bắt đầu quản lý tài chính của bạn';

  @override
  String get settings => 'Cài Đặt';

  @override
  String get configureAppSettings => 'Cấu hình cài đặt ứng dụng của bạn';

  @override
  String get categoryManagement => 'Quản Lý Danh Mục';

  @override
  String get language => 'Ngôn Ngữ';

  @override
  String get logOut => 'Đăng Xuất';

  @override
  String get confirmLogout => 'Bạn có chắc chắn muốn đăng xuất?';

  @override
  String get cancel => 'Hủy';

  @override
  String get addNewCategory => 'Thêm Danh Mục Mới';

  @override
  String get viewCategoryTransactions => 'Xem Giao Dịch Theo Danh Mục';

  @override
  String get categoryName => 'Tên Danh Mục';

  @override
  String get enterCategoryName => 'Nhập tên danh mục';

  @override
  String get pleaseEnterCategoryName => 'Vui lòng nhập tên danh mục';

  @override
  String get categoryType => 'Loại Danh Mục';

  @override
  String get expense => 'Chi Tiêu';

  @override
  String get income => 'Thu Nhập';

  @override
  String get createCategory => 'Tạo Danh Mục';

  @override
  String get categoryCreatedSuccessfully => 'Tạo danh mục thành công';

  @override
  String get fillCategoryDetails => 'Điền thông tin chi tiết danh mục';

  @override
  String get selectIcon => 'Chọn Biểu Tượng';

  @override
  String get selectColor => 'Chọn Màu';

  @override
  String get select => 'Chọn';

  @override
  String get viewCategories => 'Xem Danh Mục';

  @override
  String get noCategoriesFound => 'Không tìm thấy danh mục nào';

  @override
  String get retry => 'Thử Lại';

  @override
  String get editCategory => 'Chỉnh Sửa Danh Mục';

  @override
  String get updateCategory => 'Cập Nhật Danh Mục';

  @override
  String get categoryUpdatedSuccessfully => 'Cập nhật danh mục thành công';

  @override
  String get delete => 'Xóa';

  @override
  String get deleteCategory => 'Xóa Danh Mục';

  @override
  String deleteCategoryConfirmation(String categoryName) {
    return 'Bạn có chắc chắn muốn xóa \"$categoryName\"?';
  }

  @override
  String get categoryDeletedSuccessfully => 'Xóa danh mục thành công';
}
