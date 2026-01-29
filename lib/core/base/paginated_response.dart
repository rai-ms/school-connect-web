class PaginatedResponse<T> {
  final List<T> content;
  final int totalPages;
  final int totalElements;
  final int number;
  final int size;
  final bool last;

  const PaginatedResponse({
    required this.content,
    required this.totalPages,
    required this.totalElements,
    required this.number,
    required this.size,
    required this.last,
  });

  factory PaginatedResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromJsonT,
  ) {
    final contentList = json['content'] as List? ?? [];
    return PaginatedResponse<T>(
      content: contentList.map((e) => fromJsonT(e as Map<String, dynamic>)).toList(),
      totalPages: json['totalPages'] as int? ?? 0,
      totalElements: json['totalElements'] as int? ?? 0,
      number: json['number'] as int? ?? 0,
      size: json['size'] as int? ?? 20,
      last: json['last'] as bool? ?? true,
    );
  }

  /// Fallback factory for non-paginated (plain list) responses.
  factory PaginatedResponse.fromList(List<T> items) {
    return PaginatedResponse<T>(
      content: items,
      totalPages: 1,
      totalElements: items.length,
      number: 0,
      size: items.length,
      last: true,
    );
  }
}
