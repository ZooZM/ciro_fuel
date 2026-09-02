import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/error/failure.dart';
import '../../../../../core/localization/translation_keys.dart';
import '../../../../../core/network/error_codes.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/theme_context.dart';
import '../../../../../core/widgets/order_card.dart';
import '../../../../../shared/entities/order.dart';
import '../../cubit/rating_cubit.dart';
import '../../cubit/rating_state.dart';

/// spec 007 US6 (FR-037/FR-037a/FR-037c): the client's own rating control,
/// shown inline on the delivered order card — no new screen, no automatic
/// prompt. A score is required; the written review is optional.
class RatingCard extends StatefulWidget {
  const RatingCard({super.key});

  @override
  State<RatingCard> createState() => _RatingCardState();
}

class _RatingCardState extends State<RatingCard> {
  int _score = 0;
  final _reviewController = TextEditingController();

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }

  String _failureMessage(Failure failure) => switch (failure) {
    ValidationFailure(code: ErrorCodes.alreadyRated) => RatingKeys.alreadyRated.tr(),
    ValidationFailure(code: ErrorCodes.orderNotDelivered) => RatingKeys.notDelivered.tr(),
    _ => RatingKeys.submitFailed.tr(),
  };

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RatingCubit, RatingState>(
      builder: (context, state) {
        final submitting = state is RatingSubmitting;
        return OrderCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                RatingKeys.prompt.tr(),
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: context.colors.textPrimary),
              ),
              const SizedBox(height: AppSpacing.md),
              Row(
                children: [
                  for (var i = 1; i <= 5; i++)
                    GestureDetector(
                      onTap: submitting ? null : () => setState(() => _score = i),
                      child: Padding(
                        padding: const EdgeInsetsDirectional.only(end: 4),
                        child: Icon(
                          i <= _score ? Icons.star : Icons.star_border,
                          color: Colors.orange,
                          size: 32,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              TextField(
                controller: _reviewController,
                enabled: !submitting,
                maxLength: 500,
                maxLines: 3,
                decoration: InputDecoration(hintText: RatingKeys.reviewHint.tr()),
              ),
              if (state is RatingFailureState) ...[
                const SizedBox(height: AppSpacing.sm),
                Text(_failureMessage(state.failure), style: TextStyle(color: context.colors.brandRed, fontSize: 12)),
              ],
              const SizedBox(height: AppSpacing.sm),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: (_score > 0 && !submitting)
                      ? () {
                          final review = _reviewController.text.trim();
                          context.read<RatingCubit>().submit(
                            score: _score,
                            review: review.isEmpty ? null : review,
                          );
                        }
                      : null,
                  child: submitting
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                        )
                      : Text(RatingKeys.submit.tr()),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

/// FR-037d: once the customer has rated, the delivered card shows what
/// they gave instead of the control — never both.
class RatingSummaryCard extends StatelessWidget {
  const RatingSummaryCard({super.key, required this.rating});

  final OrderRating rating;

  @override
  Widget build(BuildContext context) {
    return OrderCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              for (var i = 1; i <= 5; i++)
                Icon(
                  i <= rating.score ? Icons.star : Icons.star_border,
                  color: Colors.orange,
                  size: 20,
                ),
              const SizedBox(width: AppSpacing.sm),
              Text(RatingKeys.submitted.tr(), style: TextStyle(fontSize: 12, color: context.colors.textSecondary)),
            ],
          ),
          if (rating.review != null && rating.review!.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.sm),
            // FR-037b: plain text only — never interpreted as markup.
            Text(rating.review!, style: TextStyle(fontSize: 13, color: context.colors.textPrimary)),
          ],
        ],
      ),
    );
  }
}
