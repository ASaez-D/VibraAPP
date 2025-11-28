class ConcertDetail {
  final String name;
  final String venue;
  final String address;
  final String city;
  final String country;
  final DateTime date;
  final String imageUrl;
  final String ticketUrl;
  final String genre;
  final String priceRange;
  // Nuevas variables para coordenadas
  final double? latitude;
  final double? longitude;

  ConcertDetail({
    required this.name,
    required this.venue,
    this.address = '',
    this.city = '',
    this.country = '',
    required this.date,
    required this.imageUrl,
    this.ticketUrl = '',
    this.genre = '',
    this.priceRange = 'Consultar',
    this.latitude,
    this.longitude,
  });

  factory ConcertDetail.fromJson(Map<String, dynamic> json) {
    // 1. VENUE
    String venueName = "Desconocido";
    String venueAddress = "";
    String venueCity = "";
    String venueCountry = "";
    double? lat;
    double? lng;

    try {
      final venues = json["_embedded"]?["venues"];
      if (venues is List && venues.isNotEmpty) {
        final v = venues[0];
        venueName = v["name"] ?? "Desconocido";
        venueAddress = v["address"]?["line1"] ?? "";
        venueCity = v["city"]?["name"] ?? "";
        venueCountry = v["country"]?["name"] ?? "";
        
        // Extracción de coordenadas
        if (v["location"] != null) {
          lat = double.tryParse(v["location"]["latitude"] ?? "");
          lng = double.tryParse(v["location"]["longitude"] ?? "");
        }
      }
    } catch (e) {}

    // 2. IMAGEN
    String finalImageUrl = "";
    try {
      final images = json["images"];
      if (images is List && images.isNotEmpty) {
        finalImageUrl = images[0]["url"] ?? "";
      }
    } catch (e) {}

    // 3. GÉNERO
    String finalGenre = "";
    try {
      final classifications = json["classifications"];
      if (classifications is List && classifications.isNotEmpty) {
        finalGenre = classifications[0]["genre"]?["name"] ?? "";
      }
    } catch (e) {}

    // 4. PRECIO
    String finalPrice = "No disponible";
    try {
      final prices = json["priceRanges"];
      if (prices is List && prices.isNotEmpty) {
        final min = prices[0]["min"];
        final max = prices[0]["max"];
        final currency = prices[0]["currency"] ?? "";
        if (min != null && max != null) {
          finalPrice = "$min - $max $currency";
        } else {
          finalPrice = "Desde $min $currency";
        }
      }
    } catch (e) {}

    return ConcertDetail(
      name: json["name"] ?? "Sin nombre",
      venue: venueName,
      address: venueAddress,
      city: venueCity,
      country: venueCountry,
      date: DateTime.parse(
        json["dates"]?["start"]?["dateTime"] ?? DateTime.now().toIso8601String(),
      ),
      imageUrl: finalImageUrl,
      ticketUrl: json["url"] ?? "",
      genre: finalGenre,
      priceRange: finalPrice,
      latitude: lat,
      longitude: lng,
    );
  }
}
