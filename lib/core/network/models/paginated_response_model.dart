// ================================
// Paginated Response Model
// ================================

class PaginatedResponse<T> {
  final List<T> data;
  final PaginationMeta meta;

  const PaginatedResponse({required this.data, required this.meta});

  bool get hasNextPage => meta.hasNextPage;
  bool get hasPreviousPage => meta.hasPreviousPage;

  factory PaginatedResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromJson,
  ) =>
      PaginatedResponse(
        data: (json['data'] as List).map((item) => fromJson(item as Map<String, dynamic>)).toList(),
        meta: PaginationMeta.fromJson(json['meta'] as Map<String, dynamic>),
      );
}

class PaginationMeta {
  final int currentPage;
  final int totalPages;
  final int totalItems;
  final int itemsPerPage;
  final bool hasNextPage;
  final bool hasPreviousPage;

  const PaginationMeta({
    required this.currentPage,
    required this.totalPages,
    required this.totalItems,
    required this.itemsPerPage,
    required this.hasNextPage,
    required this.hasPreviousPage,
  });

  factory PaginationMeta.fromJson(Map<String, dynamic> json) => PaginationMeta(
        currentPage: json['current_page'] ?? 1,
        totalPages: json['total_pages'] ?? 1,
        totalItems: json['total_items'] ?? 0,
        itemsPerPage: json['items_per_page'] ?? 20,
        hasNextPage: json['has_next_page'] ?? false,
        hasPreviousPage: json['has_previous_page'] ?? false,
      );

  Map<String, dynamic> toJson() => {
        'current_page': currentPage,
        'total_pages': totalPages,
        'total_items': totalItems,
        'items_per_page': itemsPerPage,
        'has_next_page': hasNextPage,
        'has_previous_page': hasPreviousPage,
      };
}
