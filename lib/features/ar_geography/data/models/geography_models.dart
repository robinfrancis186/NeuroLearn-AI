import 'dart:ui';

/// Geographic Location Data Model
class GeoLocation {
  final double latitude;
  final double longitude;
  final double altitude;

  const GeoLocation({
    required this.latitude,
    required this.longitude,
    this.altitude = 0.0,
  });

  Map<String, dynamic> toJson() => {
    'latitude': latitude,
    'longitude': longitude,
    'altitude': altitude,
  };

  factory GeoLocation.fromJson(Map<String, dynamic> json) => GeoLocation(
    latitude: json['latitude'].toDouble(),
    longitude: json['longitude'].toDouble(),
    altitude: json['altitude']?.toDouble() ?? 0.0,
  );
}

/// Country Data Model
class Country {
  final String code;           // ISO 3166-1 alpha-2 code (e.g., "US", "CA")
  final String name;           // Full country name
  final String continent;     // Continent name
  final GeoLocation center;   // Geographic center
  final List<GeoLocation> boundaries; // Country border coordinates
  final List<GeographicState> states;   // States/provinces within country
  final String flagUrl;       // Country flag image URL
  final int population;       // Population count
  final double area;          // Area in square kilometers
  final String capital;       // Capital city
  final List<String> languages; // Official languages
  final String currency;      // Currency code

  const Country({
    required this.code,
    required this.name,
    required this.continent,
    required this.center,
    required this.boundaries,
    this.states = const [],
    required this.flagUrl,
    required this.population,
    required this.area,
    required this.capital,
    this.languages = const [],
    required this.currency,
  });

  Map<String, dynamic> toJson() => {
    'code': code,
    'name': name,
    'continent': continent,
    'center': center.toJson(),
    'boundaries': boundaries.map((b) => b.toJson()).toList(),
    'states': states.map((s) => s.toJson()).toList(),
    'flagUrl': flagUrl,
    'population': population,
    'area': area,
    'capital': capital,
    'languages': languages,
    'currency': currency,
  };

  factory Country.fromJson(Map<String, dynamic> json) => Country(
    code: json['code'],
    name: json['name'],
    continent: json['continent'],
    center: GeoLocation.fromJson(json['center']),
    boundaries: (json['boundaries'] as List)
        .map((b) => GeoLocation.fromJson(b))
        .toList(),
    states: (json['states'] as List?)
        ?.map((s) => GeographicState.fromJson(s))
        .toList() ?? [],
    flagUrl: json['flagUrl'],
    population: json['population'],
    area: json['area'].toDouble(),
    capital: json['capital'],
    languages: List<String>.from(json['languages'] ?? []),
    currency: json['currency'],
  );
}

/// State/Province Data Model  
class GeographicState {
  final String code;           // State code (e.g., "CA", "TX")
  final String name;           // Full state name
  final String countryCode;   // Parent country code
  final GeoLocation center;   // Geographic center
  final List<GeoLocation> boundaries; // State border coordinates
  final List<City> cities;    // Major cities within state
  final int population;       // Population count
  final double area;          // Area in square kilometers
  final String capital;       // State capital

  const GeographicState({
    required this.code,
    required this.name,
    required this.countryCode,
    required this.center,
    required this.boundaries,
    this.cities = const [],
    required this.population,
    required this.area,
    required this.capital,
  });

  Map<String, dynamic> toJson() => {
    'code': code,
    'name': name,
    'countryCode': countryCode,
    'center': center.toJson(),
    'boundaries': boundaries.map((b) => b.toJson()).toList(),
    'cities': cities.map((c) => c.toJson()).toList(),
    'population': population,
    'area': area,
    'capital': capital,
  };

  factory GeographicState.fromJson(Map<String, dynamic> json) => GeographicState(
    code: json['code'],
    name: json['name'],
    countryCode: json['countryCode'],
    center: GeoLocation.fromJson(json['center']),
    boundaries: (json['boundaries'] as List)
        .map((b) => GeoLocation.fromJson(b))
        .toList(),
    cities: (json['cities'] as List?)
        ?.map((c) => City.fromJson(c))
        .toList() ?? [],
    population: json['population'],
    area: json['area'].toDouble(),
    capital: json['capital'],
  );
}

/// City Data Model
class City {
  final String name;           // City name
  final String stateCode;     // Parent state code
  final String countryCode;   // Parent country code
  final GeoLocation location; // City coordinates
  final int population;       // Population count
  final bool isCapital;       // Is state/country capital
  final List<String> landmarks; // Notable landmarks

  const City({
    required this.name,
    required this.stateCode,
    required this.countryCode,
    required this.location,
    required this.population,
    this.isCapital = false,
    this.landmarks = const [],
  });

  Map<String, dynamic> toJson() => {
    'name': name,
    'stateCode': stateCode,
    'countryCode': countryCode,
    'location': location.toJson(),
    'population': population,
    'isCapital': isCapital,
    'landmarks': landmarks,
  };

  factory City.fromJson(Map<String, dynamic> json) => City(
    name: json['name'],
    stateCode: json['stateCode'],
    countryCode: json['countryCode'],
    location: GeoLocation.fromJson(json['location']),
    population: json['population'],
    isCapital: json['isCapital'] ?? false,
    landmarks: List<String>.from(json['landmarks'] ?? []),
  );
}

/// Hand Tracking Gesture Types
enum HandGesture {
  pinchZoomIn,      // Pinch to zoom in
  pinchZoomOut,     // Spread to zoom out
  pointSelect,      // Point to select location
  palmOpen,         // Open palm for navigation
  fist,             // Closed fist to stop interaction
  swipeLeft,        // Swipe left for rotation
  swipeRight,       // Swipe right for rotation
  grab,             // Grab gesture for dragging
}

/// AR Camera State
class ARCameraState {
  final GeoLocation target;    // Current view target
  final double distance;       // Distance from target
  final double rotation;       // Rotation angle
  final double tilt;           // Tilt angle
  final double zoomLevel;      // Current zoom level (1.0 = global view)

  const ARCameraState({
    required this.target,
    required this.distance,
    this.rotation = 0.0,
    this.tilt = 0.0,
    this.zoomLevel = 1.0,
  });

  ARCameraState copyWith({
    GeoLocation? target,
    double? distance,
    double? rotation,
    double? tilt,
    double? zoomLevel,
  }) {
    return ARCameraState(
      target: target ?? this.target,
      distance: distance ?? this.distance,
      rotation: rotation ?? this.rotation,
      tilt: tilt ?? this.tilt,
      zoomLevel: zoomLevel ?? this.zoomLevel,
    );
  }
}

/// Map Detail Level
enum MapDetailLevel {
  global,           // Full world view
  continent,        // Continent view
  country,          // Country view
  state,            // State/province view
  city,             // City view
  street,           // Street level (if available)
}

/// 3D Map Asset
class MapAsset {
  final String id;
  final String name;
  final String modelUrl;      // 3D model URL
  final String textureUrl;    // Texture/image URL
  final MapDetailLevel level;
  final GeoLocation position;
  final Size size;            // Physical size in AR space

  const MapAsset({
    required this.id,
    required this.name,
    required this.modelUrl,
    required this.textureUrl,
    required this.level,
    required this.position,
    required this.size,
  });
}

/// Interactive Geography Element
class GeoElement {
  final String id;
  final String name;
  final String type;          // country, state, city, landmark
  final GeoLocation position;
  final String? infoText;     // Educational information
  final String? imageUrl;     // Representative image
  final Color highlightColor; // Color when selected
  final bool isInteractive;   // Can be selected/tapped

  const GeoElement({
    required this.id,
    required this.name,
    required this.type,
    required this.position,
    this.infoText,
    this.imageUrl,
    this.highlightColor = const Color(0xFF2196F3),
    this.isInteractive = true,
  });
} 