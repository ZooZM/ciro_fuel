// `hide TextDirection`: easy_localization re-exports intl, whose
// TextDirection would shadow the one this screen lays out with.
import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';

import '../../../../core/localization/translation_keys.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_top_bar.dart';
import '../constants/credit_limit_constants.dart';
import '../widgets/credit_limit/credit_acknowledgement.dart';
import '../widgets/credit_limit/credit_amount_stepper.dart';
import '../widgets/credit_limit/credit_limit_card.dart';
import '../widgets/credit_limit/credit_request_status_card.dart';
import '../widgets/credit_limit/credit_submit_button.dart';
import '../widgets/credit_limit/credit_terms_row.dart';

/// The client's credit limit: what they have today (nothing, until the petrol
/// company grants one) and the form for requesting or renewing it.
class ClientCreditLimitScreen extends StatefulWidget {
  const ClientCreditLimitScreen({super.key});

  @override
  State<ClientCreditLimitScreen> createState() =>
      _ClientCreditLimitScreenState();
}

class _ClientCreditLimitScreenState extends State<ClientCreditLimitScreen> {
  double _amount = CreditLimitConstants.initialAmount;
  bool _firstAcknowledged = true;
  bool _secondAcknowledged = true;

  /// Once submitted the form gives way to the request's status card; the
  /// amount is frozen at whatever was asked for.
  bool _submitted = false;
  double _requestedAmount = 0;

  /// The request only goes through once both acknowledgements are ticked.
  bool get _canSubmit => _firstAcknowledged && _secondAcknowledged;

  void _changeAmount(double delta) {
    setState(() {
      _amount = (_amount + delta).clamp(
        CreditLimitConstants.minAmount,
        double.maxFinite,
      );
    });
  }

  void _submit() {
    setState(() {
      _requestedAmount = _amount;
      _submitted = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.canvas,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg,
              AppSpacing.lg,
              AppSpacing.lg,
              AppSpacing.xxl,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const AppTopBar(),
                const SizedBox(height: AppSpacing.xl),
                const CreditLimitCard(),
                // Once the request is in, the form is replaced by its status —
                // there is nothing left to fill in until the company answers.
                if (_submitted) ...[
                  const SizedBox(height: AppSpacing.space40),
                  CreditRequestStatusCard(requestedAmount: _requestedAmount),
                ] else
                  ..._buildRequestForm(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildRequestForm() {
    return [
      const SizedBox(height: AppSpacing.xxl),
      Text(
        CreditLimitKeys.requestHeading.tr(),
        style: const TextStyle(
          fontSize: AppFontSizes.titleLarge,
          fontWeight: FontWeight.w800,
          color: AppColors.heading,
        ),
      ),
      const SizedBox(height: AppSpacing.lg),
      CreditAmountStepper(
        amount: _amount,
        onIncrement: () => _changeAmount(CreditLimitConstants.amountStep),
        onDecrement: _amount > CreditLimitConstants.minAmount
            ? () => _changeAmount(-CreditLimitConstants.amountStep)
            : null,
      ),
      const SizedBox(height: AppSpacing.xxl),
      // Two acknowledgements carrying the same copy, as the design draws
      // them — they are ticked independently.
      CreditAcknowledgement(
        value: _firstAcknowledged,
        onChanged: (value) => setState(() => _firstAcknowledged = value),
      ),
      const SizedBox(height: AppSpacing.space20),
      CreditAcknowledgement(
        value: _secondAcknowledged,
        onChanged: (value) => setState(() => _secondAcknowledged = value),
      ),
      const SizedBox(height: AppSpacing.xl),
      const CreditTermsRow(),
      const SizedBox(height: AppSpacing.xl),
      CreditSubmitButton(isEnabled: _canSubmit, onPressed: _submit),
    ];
  }
}
