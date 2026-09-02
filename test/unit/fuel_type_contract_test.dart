import 'dart:io';

import 'package:dartz/dartz.dart' hide Order;
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/core/error/failure.dart';
import 'package:mobile_app/core/network/paginated_response.dart';
import 'package:mobile_app/features/orders/data/repositories/orders_repository_impl.dart';
import 'package:mobile_app/features/orders/data/datasources/orders_remote_data_source.dart';
import 'package:mobile_app/shared/entities/order.dart';
import 'package:mobile_app/shared/enums/fuel_grade.dart';
import 'package:mobile_app/shared/enums/fuel_type.dart';
import 'package:mocktail/mocktail.dart';

class _MockOrdersRemoteDataSource extends Mock
    implements OrdersRemoteDataSource {}

/// Where the backend declares the enum this app mirrors. Relative to the
/// mobile root, in the sibling backend checkout.
const _backendEnumPath = '../ciro_fuel/src/common/enums/fuel-type.enum.ts';

void main() {
  // These two enums drifting apart is what left the orders list spinning
  // forever and the create-order fuel section empty: the backend served
  // `KEROSENE`, `FuelType.fromWire` threw on it, and the throw escaped the
  // repository. Both halves are pinned here.
  group('FuelType mirrors the backend catalogue', () {
    test('every backend wire value parses', () {
      final file = File(_backendEnumPath);
      if (!file.existsSync()) {
        markTestSkipped('backend checkout not present at $_backendEnumPath');
        return;
      }

      // Matches `KEROSENE = 'KEROSENE',` — the quoted wire value is what
      // actually travels, so that is what is asserted.
      final wireValues = RegExp(r"=\s*'([A-Z0-9_]+)'")
          .allMatches(file.readAsStringSync())
          .map((m) => m.group(1)!)
          .toSet();

      expect(
        wireValues,
        isNotEmpty,
        reason: 'failed to parse any value out of the backend enum',
      );

      for (final wire in wireValues) {
        expect(
          () => FuelType.fromWire(wire),
          returnsNormally,
          reason:
              'the backend serves "$wire" but FuelType cannot parse it — '
              'every screen showing a record with that fuel type will fail',
        );
      }
    });

    test('every FuelType is offerable as a FuelGrade tile', () {
      final mapped = FuelGrade.values
          .map((g) => g.type)
          .whereType<FuelType>()
          .toSet();

      expect(
        mapped,
        containsAll(FuelType.values),
        reason:
            'a FuelType with no FuelGrade carrying it can never be offered '
            'in the create-order form, so the company sells a grade the '
            'client cannot pick (FR-010)',
      );
    });
  });

  group('a repository never lets a mapping throw escape', () {
    setUpAll(() {
      registerFallbackValue(const PaginatedResult<Order>(
        items: [],
        nextCursor: null,
      ));
    });

    test('a non-Dio throw becomes a Failure rather than an escaped error', () {
      final dataSource = _MockOrdersRemoteDataSource();
      when(() => dataSource.getOrders(status: any(named: 'status'), cursor: any(named: 'cursor')))
          .thenThrow(ArgumentError.value('KEROSENE', 'wire', 'Unknown FuelType'));

      final repository = OrdersRepositoryImpl(dataSource);

      // The contract that matters is that this future *completes*. An
      // escaping error would leave the awaiting cubit on its loading state
      // forever, which is exactly the bug this guards (FR-041/FR-003).
      expect(
        repository.getOrders(),
        completion(isA<Left<Failure, PaginatedResult<Order>>>()),
      );
    });
  });
}
