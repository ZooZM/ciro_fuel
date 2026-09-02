import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../../core/error/failure.dart';
import '../../domain/entities/pricing_config.dart';
import '../../domain/repositories/company_pricing_repository.dart';
import '../datasources/company_pricing_remote_data_source.dart';

class CompanyPricingRepositoryImpl implements CompanyPricingRepository {
  CompanyPricingRepositoryImpl(this._remoteDataSource);

  final CompanyPricingRemoteDataSource _remoteDataSource;

  @override
  Future<Either<Failure, List<FuelPrice>>> getFuelPrices(String companyId) =>
      _guard(() => _remoteDataSource.getFuelPrices(companyId));

  @override
  Future<Either<Failure, PricingConfig?>> getPricingConfig(String companyId) =>
      _guard(() => _remoteDataSource.getPricingConfig(companyId));

  Future<Either<Failure, T>> _guard<T>(Future<T> Function() call) async {
    try {
      return Right(await call());
    } on DioException catch (e) {
      return Left(e.error is Failure ? e.error as Failure : const Failure.server());
    } catch (_) {
      // A parse/mapping throw must not escape: an escaping error leaves the
      // awaiting cubit stuck on loading forever (FR-041/FR-003).
      return const Left(Failure.server());
    }
  }
}
