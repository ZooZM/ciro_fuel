import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/network/paginated_response.dart';
import '../../../../shared/entities/invoice.dart';
import '../../../../shared/enums/invoice_state.dart';
import '../../../../shared/enums/payment_method.dart';
import '../../domain/entities/credit_standing.dart';
import '../../domain/repositories/invoices_repository.dart';
import '../datasources/invoices_remote_data_source.dart';

class InvoicesRepositoryImpl implements InvoicesRepository {
  InvoicesRepositoryImpl(this._remoteDataSource);

  final InvoicesRemoteDataSource _remoteDataSource;

  @override
  Future<Either<Failure, PaginatedResult<Invoice>>> getInvoices({
    PaymentMethod? method,
    InvoiceState? state,
    String? cursor,
  }) async {
    try {
      return Right(
        await _remoteDataSource.getInvoices(
          method: method,
          state: state,
          cursor: cursor,
        ),
      );
    } on DioException catch (e) {
      return Left(
        e.error is Failure ? e.error as Failure : const Failure.server(),
      );
    } catch (_) {
      // A parse/mapping throw must not escape: an escaping error leaves the
      // awaiting cubit stuck on loading forever (FR-041/FR-003).
      return const Left(Failure.server());
    }
  }

  @override
  Future<Either<Failure, Invoice>> getInvoice(String invoiceId) async {
    try {
      return Right(await _remoteDataSource.getInvoice(invoiceId));
    } on DioException catch (e) {
      return Left(
        e.error is Failure ? e.error as Failure : const Failure.server(),
      );
    } catch (_) {
      // A parse/mapping throw must not escape: an escaping error leaves the
      // awaiting cubit stuck on loading forever (FR-041/FR-003).
      return const Left(Failure.server());
    }
  }

  @override
  Future<Either<Failure, CreditStanding>> getCreditStanding() async {
    try {
      return Right(await _remoteDataSource.getCreditStanding());
    } on DioException catch (e) {
      return Left(
        e.error is Failure ? e.error as Failure : const Failure.server(),
      );
    } catch (_) {
      // A parse/mapping throw must not escape: an escaping error leaves the
      // awaiting cubit stuck on loading forever (FR-041/FR-003).
      return const Left(Failure.server());
    }
  }
}
