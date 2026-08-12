import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../core/localization/translation_keys.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../../../core/widgets/step_tracker.dart';
import '../../constants/credit_limit_mock_data.dart';
import 'credit_amount.dart';
import 'credit_status_pill.dart';

/// Where the submitted request stands: what was asked for, and how far it has
/// got through تم الإرسال ← قيد المراجعة ← القرار.
///
/// [requestedAmount] is frozen at whatever the stepper held when the form was
/// sent — the client cannot change it while the company decides.
class CreditRequestStatusCard extends StatelessWidget {
  const CreditRequestStatusCard({required this.requestedAmount, super.key});

  final double requestedAmount;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadii.dashboardCard),
        boxShadow: AppColors.shadowCard,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    CreditLimitKeys.requestTitle.tr(),
                    style: const TextStyle(
                      fontSize: AppFontSizes.titleLarge,
                      fontWeight: FontWeight.w800,
                      color: AppColors.heading,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.space6),
                  const Text(
                    CreditLimitMockData.requestDate,
                    style: TextStyle(
                      fontSize: AppFontSizes.footnote,
                      color: AppColors.mutedLabel,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              CreditStatusPill(
                label: CreditLimitKeys.underReview.tr(),
                color: AppColors.successGreen,
                background: AppColors.greenTint,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.space20),
          Text(
            CreditLimitKeys.requestedLimit.tr(),
            style: const TextStyle(
              fontSize: AppFontSizes.body,
              color: AppColors.mutedLabel,
            ),
          ),
          const SizedBox(height: AppSpacing.space6),
          CreditAmount(
            amount: requestedAmount,
            color: AppColors.ignitionOrange,
          ),
          const SizedBox(height: AppSpacing.space20),
          StepTracker(
            steps: [
              StepItem(
                CreditLimitKeys.stepSubmitted.tr(),
                TrackerStepState.done,
              ),
              StepItem(
                CreditLimitKeys.stepUnderReview.tr(),
                TrackerStepState.current,
              ),
              StepItem(
                CreditLimitKeys.stepDecision.tr(),
                TrackerStepState.pending,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          Center(
            child: Text(
              CreditLimitKeys.expectedReply.tr(),
              style: const TextStyle(
                fontSize: AppFontSizes.footnote,
                color: AppColors.mutedLabel,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
