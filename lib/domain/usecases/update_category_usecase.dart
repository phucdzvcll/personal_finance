import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../core/error/failures.dart';
import '../../core/usecase/usecase.dart';
import '../entities/category.dart';
import '../entities/category_type.dart';
import '../repositories/category_repository.dart';

class UpdateCategoryParams {
  final int id;
  final String name;
  final CategoryType type;
  final String? icon;
  final String? color;

  UpdateCategoryParams({
    required this.id,
    required this.name,
    required this.type,
    this.icon,
    this.color,
  });
}

@injectable
class UpdateCategoryUseCase implements UseCase<Category, UpdateCategoryParams> {
  final CategoryRepository repository;

  UpdateCategoryUseCase(this.repository);

  @override
  Future<Either<Failure, Category>> call(UpdateCategoryParams params) async {
    return await repository.updateCategory(
      id: params.id,
      name: params.name,
      type: params.type,
      icon: params.icon,
      color: params.color,
    );
  }
}
