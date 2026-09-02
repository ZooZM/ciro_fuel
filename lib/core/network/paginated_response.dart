/// One page of a cursor-paginated list (feature 005, FR-048) — the client
/// side of `{ items, nextCursor }` (contracts/rest-api-delta.md §1).
class PaginatedResult<T> {
  const PaginatedResult({required this.items, required this.nextCursor});

  final List<T> items;

  /// `null` means the end of the list. The parser below enforces the
  /// contract's rule that a *missing* `nextCursor` key is never treated the
  /// same as an explicit `null` — the two mean different things (one is
  /// "no more pages", the other is "the backend didn't answer the
  /// question"), and collapsing them would make a malformed response look
  /// like a normal last page instead of the bug it is.
  final String? nextCursor;
}

/// Parses a paginated envelope, mapping each raw item through [fromJson].
/// Throws a [FormatException] — deliberately not swallowed into an empty
/// page — when the envelope doesn't match the contract, since a backend
/// response missing `items` or `nextCursor` is a defect to surface loudly,
/// not a "no results" state to render quietly.
PaginatedResult<T> parsePaginatedResponse<T>(
  Map<String, dynamic> json,
  T Function(Map<String, dynamic>) fromJson,
) {
  if (!json.containsKey('items')) {
    throw const FormatException('Paginated response is missing "items"');
  }
  if (!json.containsKey('nextCursor')) {
    throw const FormatException('Paginated response is missing "nextCursor"');
  }

  final rawItems = json['items'];
  if (rawItems is! List) {
    throw const FormatException('Paginated response "items" is not a list');
  }

  final nextCursor = json['nextCursor'];
  if (nextCursor != null && nextCursor is! String) {
    throw const FormatException('Paginated response "nextCursor" is not a string or null');
  }

  return PaginatedResult<T>(
    items: rawItems.cast<Map<String, dynamic>>().map(fromJson).toList(),
    nextCursor: nextCursor as String?,
  );
}
