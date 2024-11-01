import 'package:fpdart/fpdart.dart';
import 'package:cliff_pickleball/core/Failure.dart';

typedef FutureEither<T> = Future<Either<Failure, T>>;
typedef FutureVoid = FutureEither<void>;
