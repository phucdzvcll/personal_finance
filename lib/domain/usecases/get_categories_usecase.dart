import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../core/error/failures.dart';
import '../../core/usecase/usecase.dart';
import '../entities/category.dart';
import '../repositories/category_repository.dart';

@injectable
class GetCategoriesUseCase implements UseCaseNoParams<List<Category>> {
  final CategoryRepository repository;

  GetCategoriesUseCase(this.repository);

  @override
  Future<Either<Failure, List<Category>>> call() async {
    return await repository.getCategories();
  }
}
