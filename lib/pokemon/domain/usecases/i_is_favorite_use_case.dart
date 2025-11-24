import 'package:fpdart/fpdart.dart';
import 'package:pokemon_clean_arch/core/errors/failure.dart';

abstract class IIsFavoriteUseCase {
  Future<Either<Failure, bool>> call(int id);
}
