import 'package:fpdart/fpdart.dart';
import 'package:pokemon_clean_arch/core/errors/failure.dart';

abstract class IRemoveFavoriteUseCase {
  Future<Either<Failure, void>> call(int id);
}