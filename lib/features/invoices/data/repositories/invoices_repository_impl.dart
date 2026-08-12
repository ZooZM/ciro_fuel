import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../../core/error/failure.dart';
import '../../../../shared/entities/invoice.dart';
import '../../domain/repositories/invoices_repository.dart';
import '../datasources/invoices_remote_data_source.dart';

class InvoicesRepositoryImpl implements InvoicesRepository {
  InvoicesRepositoryImpl(this._remoteDataSource);

  final InvoicesRemoteDataSource _remoteDataSource;

  @override
  Future<Either<Failure, List<Invoice>>> getInvoices() async {
    try {
      return Right(await _remoteDataSource.getInvoices());
    } on DioException catch (e) {
      return Left(
        e.error is Failure ? e.error as Failure : const Failure.server(),
      );
    }
  }
}
