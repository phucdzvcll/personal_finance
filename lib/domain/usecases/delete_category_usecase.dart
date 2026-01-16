import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../core/error/failures.dart';
import '../../core/usecase/usecase.dart';
import '../repositories/category_repository.dart';

@injectable
class DeleteCategoryUseCase implements UseCase<void, int> {
  final CategoryRepository repository;

  DeleteCategoryUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(int params) async {
    return await repository.deleteCategory(params);
  }
}
