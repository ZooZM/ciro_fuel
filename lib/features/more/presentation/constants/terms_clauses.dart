import 'package:easy_localization/easy_localization.dart';

import '../../../../core/localization/translation_keys.dart';

/// One numbered clause of the terms, resolved against the current locale.
class TermsClause {
  const TermsClause({
    required this.number,
    required this.title,
    required this.body,
  });

  /// Two digits, as the badge draws it — '01', not '1'.
  final String number;
  final String title;
  final String body;
}

/// The clauses in the order they are read.
///
/// Built at call time rather than held as a `const` list: the copy comes from
/// `assets/translations/*.json`, so a locale change has to rebuild it.
List<TermsClause> buildTermsClauses() => [
  for (var number = 1; number <= TermsKeys.clauseCount; number++)
    TermsClause(
      number: number.toString().padLeft(2, '0'),
      title: TermsKeys.clauseTitle(number).tr(),
      body: TermsKeys.clauseBody(number).tr(),
    ),
];
