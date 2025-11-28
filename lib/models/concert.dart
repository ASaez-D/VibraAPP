class Concert {
  final String name;
  final String venue;
  final DateTime date;
  final String imageUrl;

  Concert({
    required this.name,
    required this.venue,
    required this.date,
    required this.imageUrl,
  });

  factory Concert.fromJson(Map<String, dynamic> json) {
    return Concert(
      name: json['name'] ?? 'Sin nombre',
      venue: json['_embedded']?['venues']?[0]?['name'] ?? 'Desconocido',
      date: json['dates']?['start']?['dateTime'] != null
          ? DateTime.parse(json['dates']['start']['dateTime'])
          : DateTime.now(),
      imageUrl: json['images']?[0]?['url'] ?? '',
    );
  }
}

