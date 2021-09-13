class PaginationData {
  PaginationData(
      {this.total,
      this.count,
      this.perPage,
      this.currentPage,
      this.totalPages});

  final int total;
  final int count;
  final int perPage;
  final int currentPage;
  final int totalPages;

  factory PaginationData.fromJson(Map<String, dynamic> json) =>
      PaginationData(
        total: json['total'] as int,
         count: json['count'] as int,
         currentPage: json['current_page'] as int,
         perPage: json['per_page'] as int,
         totalPages: json['total_pages'] as int,
          );
}
