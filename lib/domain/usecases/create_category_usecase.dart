import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../core/error/failures.dart';
import '../../core/usecase/usecase.dart';
import '../entities/category.dart';
import '../entities/category_type.dart';
import '../repositories/category_repository.dart';

class CreateCategoryParams {
  final String name;
  final CategoryType type;
  final String? icon;
  final String? color;

  CreateCategoryParams({
    required this.name,
    required this.type,
    this.icon,
    this.color,
  });
}

@injectable
class CreateCategoryUseCase implements UseCase<Category, CreateCategoryParams> {
  final CategoryRepository repository;

  CreateCategoryUseCase(this.repository);

  @override
  Future<Either<Failure, Category>> call(CreateCategoryParams params) async {
    return await repository.createCategory(
      name: params.name,
      type: params.type,
      icon: params.icon,
      color: params.color,
    );
  }
}
