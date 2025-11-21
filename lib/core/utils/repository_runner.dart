import 'package:fpdart/fpdart.dart';
import 'package:pokemon_clean_arch/core/errors/failure.dart';
import 'package:pokemon_clean_arch/core/exceptions/network_exception.dart';
import 'package:pokemon_clean_arch/core/network/rest_client/rest_client_exception.dart';

Future<Either<Failure, T>> runRepositorySafe<T>(Future<T> Function() call) async {
  try {
    final result = await call();
    return Right(result); 
    
  } on RestClientException catch (e) {
    if (e.statusCode == 404) {
      return Left(NotFoundFailure());
    }
    return Left(ServerFailure(e.message ?? 'Erro no servidor'));
    
  } on NetworkException {
    return Left(NetworkFailure());
    
  } catch (e) {
    return Left(DataParsingFailure());
  }
}
