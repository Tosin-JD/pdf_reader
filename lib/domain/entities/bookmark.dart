class Bookmark {
  final int page;
  final String label;

  Bookmark({required this.page, required this.label});

  Map<String, dynamic> toJson() => {
    'page': page,
    'label': label,
  };

  factory Bookmark.fromJson(Map<String, dynamic> json) => Bookmark(
    page: json['page'],
    label: json['label'],
  );
}