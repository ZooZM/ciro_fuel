import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injector.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/widgets/error_presenter.dart';
import '../../../../shared/enums/fuel_type.dart';
import '../../domain/usecases/create_order.dart';

class CreateOrderScreen extends StatefulWidget {
  const CreateOrderScreen({super.key});

  @override
  State<CreateOrderScreen> createState() => _CreateOrderScreenState();
}

class _CreateOrderScreenState extends State<CreateOrderScreen> {
  final _formKey = GlobalKey<FormState>();
  final _quantityController = TextEditingController();
  FuelType _fuelType = FuelType.diesel;
  bool _submitting = false;

  @override
  void dispose() {
    _quantityController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _submitting = true);

    final result = await getIt<CreateOrder>()(
      fuelType: _fuelType,
      quantityLiters: int.parse(_quantityController.text),
    );

    if (!mounted) return;
    setState(() => _submitting = false);

    result.fold(
      (failure) => presentFailure(context, failure),
      (order) => context.go(AppRoutes.clientOrderDetail(order.id)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('New order')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            DropdownButtonFormField<FuelType>(
              initialValue: _fuelType,
              decoration: const InputDecoration(labelText: 'Fuel type'),
              items: FuelType.values
                  .map((f) => DropdownMenuItem(value: f, child: Text(f.name)))
                  .toList(),
              onChanged: (value) => setState(() => _fuelType = value!),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _quantityController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Quantity (liters)'),
              validator: (value) {
                final quantity = int.tryParse(value ?? '');
                return (quantity == null || quantity <= 0)
                    ? 'Enter a valid quantity'
                    : null;
              },
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: _submitting ? null : _submit,
              child: _submitting
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Create order'),
            ),
          ],
        ),
      ),
    );
  }
}
