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
    this.priceRange = 'Tickets', // Valor por defecto 
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
        // Buscamos calidad > 600px
        final highQualityImg = images.firstWhere(
          (img) => (img["width"] ?? 0) > 600, 
          orElse: () => images[0]
        );
        finalImageUrl = highQualityImg["url"] ?? "";
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

    // 4. PRECIO PREMIUM 
    String finalPrice = "Tickets"; 
    
    try {
      final prices = json["priceRanges"];
      if (prices is List && prices.isNotEmpty) {
        final priceData = prices[0];
        final double? min = priceData["min"]?.toDouble();
        final double? max = priceData["max"]?.toDouble();
        String currency = priceData["currency"] ?? "EUR";

        // Símbolos de moneda
        if (currency == "EUR") currency = "€";
        else if (currency == "USD") currency = "\$";
        else if (currency == "GBP") currency = "£";

        if (min != null) {
          if (min == 0) {
            finalPrice = "GRATIS";
          } else {
            // Quitamos decimales si es redondo (ej: 30.0 -> 30)
            String priceStr = min.toStringAsFixed(min.truncateToDouble() == min ? 0 : 2);
            
            // Si hay rango, ponemos "Desde"
            if (max != null && max > min) {
              finalPrice = "Desde $priceStr$currency";
            } else {
              finalPrice = "$priceStr$currency";
            }
          }
        }
      }
    } catch (e) {}

    // 5. FECHA
    DateTime parsedDate;
    try {
      parsedDate = DateTime.parse(
        json["dates"]?["start"]?["dateTime"] ?? DateTime.now().toIso8601String(),
      ).toLocal();
    } catch (e) {
      parsedDate = DateTime.now();
    }

    return ConcertDetail(
      name: json["name"] ?? "Sin nombre",
      venue: venueName,
      address: venueAddress,
      city: venueCity,
      country: venueCountry,
      date: parsedDate,
      imageUrl: finalImageUrl,
      ticketUrl: json["url"] ?? "",
      genre: finalGenre,
      priceRange: finalPrice,
      latitude: lat,
      longitude: lng,
    );
  }
}