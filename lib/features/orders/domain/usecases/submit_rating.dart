import 'package:dartz/dartz.dart' hide Order;

import '../../../../core/error/failure.dart';
import '../../../../shared/entities/order.dart';
import '../repositories/orders_repository.dart';

class SubmitRating {
  const SubmitRating(this._repository);

  final OrdersRepository _repository;

  Future<Either<Failure, OrderRating>> call({
    required String orderId,
    required int score,
    String? review,
  }) => _repository.submitRating(orderId, score: score, review: review);
}
