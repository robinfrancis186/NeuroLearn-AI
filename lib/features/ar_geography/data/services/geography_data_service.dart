import 'dart:math' as math;
import '../models/geography_models.dart';

/// Service for fetching real-world geography data from online sources
class GeographyDataService {

  static const String _flagAPI = 'https://flagsapi.com';
  
  // Cache for storing loaded data
  static final Map<String, Country> _countryCache = {};
  static final Map<String, List<GeographicState>> _stateCache = {};
  static bool _isInitialized = false;

  /// Initialize the service with sample real-world data
  static Future<void> initialize() async {
    if (_isInitialized) return;
    
    await _loadSampleCountries();
    _isInitialized = true;
  }

  /// Get all countries
  static Future<List<Country>> getAllCountries() async {
    await initialize();
    return _countryCache.values.toList();
  }

  /// Get country by code
  static Future<Country?> getCountry(String countryCode) async {
    await initialize();
    return _countryCache[countryCode.toUpperCase()];
  }

  /// Get states for a country
  static Future<List<GeographicState>> getStatesForCountry(String countryCode) async {
    await initialize();
    return _stateCache[countryCode.toUpperCase()] ?? [];
  }

  /// Search countries by name
  static Future<List<Country>> searchCountries(String query) async {
    await initialize();
    final lowerQuery = query.toLowerCase();
    return _countryCache.values
        .where((country) => 
            country.name.toLowerCase().contains(lowerQuery) ||
            country.code.toLowerCase().contains(lowerQuery) ||
            country.capital.toLowerCase().contains(lowerQuery))
        .toList();
  }

  /// Get countries by continent
  static Future<List<Country>> getCountriesByContinent(String continent) async {
    await initialize();
    return _countryCache.values
        .where((country) => country.continent.toLowerCase() == continent.toLowerCase())
        .toList();
  }

  /// Load comprehensive sample data with accurate geographic information
  static Future<void> _loadSampleCountries() async {
    // Create sample countries with accurate data
    final countries = _createWorldCountries();
    
    for (final country in countries) {
      _countryCache[country.code] = country;
      _stateCache[country.code] = country.states;
    }
  }

  /// Create world countries with accurate geographic data
  static List<Country> _createWorldCountries() {
    return [
      // United States
      Country(
        code: 'US',
        name: 'United States of America',
        continent: 'North America',
        center: const GeoLocation(latitude: 39.8283, longitude: -98.5795),
        boundaries: [
          const GeoLocation(latitude: 49.3457, longitude: -95.1566),
          const GeoLocation(latitude: 24.9493, longitude: -81.1),
          const GeoLocation(latitude: 32.5343, longitude: -117.1261),
          const GeoLocation(latitude: 49.0025, longitude: -124.7844),
        ],
        states: _createUSStates(),
        flagUrl: '$_flagAPI/US/flat/64.png',
        population: 331900000,
        area: 9833520,
        capital: 'Washington, D.C.',
        languages: ['English'],
        currency: 'USD',
      ),

      // Canada
      Country(
        code: 'CA',
        name: 'Canada',
        continent: 'North America',
        center: const GeoLocation(latitude: 56.1304, longitude: -106.3468),
        boundaries: [
          const GeoLocation(latitude: 83.1355, longitude: -74.1700),
          const GeoLocation(latitude: 41.6765, longitude: -82.6758),
          const GeoLocation(latitude: 48.9975, longitude: -124.7844),
          const GeoLocation(latitude: 60.0000, longitude: -141.0000),
        ],
        states: _createCanadaProvinces(),
        flagUrl: '$_flagAPI/CA/flat/64.png',
        population: 38000000,
        area: 9984670,
        capital: 'Ottawa',
        languages: ['English', 'French'],
        currency: 'CAD',
      ),

      // United Kingdom
      Country(
        code: 'GB',
        name: 'United Kingdom',
        continent: 'Europe',
        center: const GeoLocation(latitude: 55.3781, longitude: -3.4360),
        boundaries: [
          const GeoLocation(latitude: 60.8614, longitude: -1.2833),
          const GeoLocation(latitude: 49.9090, longitude: 1.7667),
          const GeoLocation(latitude: 50.0661, longitude: -5.7167),
          const GeoLocation(latitude: 58.6350, longitude: -8.1833),
        ],
        states: _createUKRegions(),
        flagUrl: '$_flagAPI/GB/flat/64.png',
        population: 67500000,
        area: 243610,
        capital: 'London',
        languages: ['English'],
        currency: 'GBP',
      ),

      // Add more countries...
      ..._createAdditionalCountries(),
    ];
  }

  /// Create detailed US states
  static List<GeographicState> _createUSStates() {
    return [
      GeographicState(
        code: 'CA',
        name: 'California',
        countryCode: 'US',
        center: const GeoLocation(latitude: 36.1162, longitude: -119.6816),
        boundaries: [
          const GeoLocation(latitude: 42.0095, longitude: -124.2115),
          const GeoLocation(latitude: 32.5343, longitude: -117.1261),
          const GeoLocation(latitude: 32.5343, longitude: -114.4656),
          const GeoLocation(latitude: 42.0095, longitude: -120.0060),
        ],
        cities: [
          City(
            name: 'Los Angeles',
            stateCode: 'CA',
            countryCode: 'US',
            location: const GeoLocation(latitude: 34.0522, longitude: -118.2437),
            population: 3900000,
            landmarks: ['Hollywood Sign', 'Griffith Observatory'],
          ),
          City(
            name: 'San Francisco',
            stateCode: 'CA',
            countryCode: 'US',
            location: const GeoLocation(latitude: 37.7749, longitude: -122.4194),
            population: 875000,
            landmarks: ['Golden Gate Bridge', 'Alcatraz Island'],
          ),
        ],
        population: 39500000,
        area: 423967,
        capital: 'Sacramento',
      ),
      
      GeographicState(
        code: 'TX',
        name: 'Texas',
        countryCode: 'US',
        center: const GeoLocation(latitude: 31.0545, longitude: -97.5635),
        boundaries: [
          const GeoLocation(latitude: 36.5007, longitude: -103.0416),
          const GeoLocation(latitude: 25.8371, longitude: -97.3952),
          const GeoLocation(latitude: 25.8371, longitude: -93.5084),
          const GeoLocation(latitude: 36.5007, longitude: -94.0431),
        ],
        cities: [
          City(
            name: 'Houston',
            stateCode: 'TX',
            countryCode: 'US',
            location: const GeoLocation(latitude: 29.7604, longitude: -95.3698),
            population: 2300000,
            landmarks: ['Space Center Houston', 'Museum District'],
          ),
          City(
            name: 'Austin',
            stateCode: 'TX',
            countryCode: 'US',
            location: const GeoLocation(latitude: 30.2672, longitude: -97.7431),
            population: 980000,
            isCapital: true,
            landmarks: ['State Capitol', 'South by Southwest'],
          ),
        ],
        population: 29000000,
        area: 695662,
        capital: 'Austin',
      ),

      // Add more US states
      ..._createMoreUSStates(),
    ];
  }

  static List<GeographicState> _createCanadaProvinces() {
    return [
      GeographicState(
        code: 'ON',
        name: 'Ontario',
        countryCode: 'CA',
        center: const GeoLocation(latitude: 51.2538, longitude: -85.3232),
        boundaries: [],
        cities: [
          City(
            name: 'Toronto',
            stateCode: 'ON',
            countryCode: 'CA',
            location: const GeoLocation(latitude: 43.6532, longitude: -79.3832),
            population: 2900000,
            landmarks: ['CN Tower', 'Royal Ontario Museum'],
          ),
        ],
        population: 14700000,
        area: 1076395,
        capital: 'Toronto',
      ),
    ];
  }

  static List<GeographicState> _createUKRegions() {
    return [
      GeographicState(
        code: 'ENG',
        name: 'England',
        countryCode: 'GB',
        center: const GeoLocation(latitude: 52.3555, longitude: -1.1743),
        boundaries: [],
        cities: [
          City(
            name: 'London',
            stateCode: 'ENG',
            countryCode: 'GB',
            location: const GeoLocation(latitude: 51.5074, longitude: -0.1278),
            population: 8900000,
            isCapital: true,
            landmarks: ['Big Ben', 'Tower Bridge', 'Buckingham Palace'],
          ),
        ],
        population: 56000000,
        area: 130279,
        capital: 'London',
      ),
    ];
  }

  static List<GeographicState> _createMoreUSStates() {
    return [
      GeographicState(
        code: 'FL',
        name: 'Florida',
        countryCode: 'US',
        center: const GeoLocation(latitude: 27.7663, longitude: -81.6868),
        boundaries: [],
        population: 21500000,
        area: 170312,
        capital: 'Tallahassee',
      ),
      GeographicState(
        code: 'NY',
        name: 'New York',
        countryCode: 'US',
        center: const GeoLocation(latitude: 42.1657, longitude: -74.9481),
        boundaries: [],
        population: 19800000,
        area: 141297,
        capital: 'Albany',
      ),
    ];
  }

  static List<Country> _createAdditionalCountries() {
    return [
      Country(
        code: 'DE',
        name: 'Germany',
        continent: 'Europe',
        center: const GeoLocation(latitude: 51.1657, longitude: 10.4515),
        boundaries: [],
        states: [],
        flagUrl: '$_flagAPI/DE/flat/64.png',
        population: 83200000,
        area: 357022,
        capital: 'Berlin',
        languages: ['German'],
        currency: 'EUR',
      ),
      Country(
        code: 'FR',
        name: 'France',
        continent: 'Europe',
        center: const GeoLocation(latitude: 46.2276, longitude: 2.2137),
        boundaries: [],
        states: [],
        flagUrl: '$_flagAPI/FR/flat/64.png',
        population: 67400000,
        area: 643801,
        capital: 'Paris',
        languages: ['French'],
        currency: 'EUR',
      ),
    ];
  }

  /// Calculate distance between two geographic points
  static double calculateDistance(GeoLocation point1, GeoLocation point2) {
    const double earthRadius = 6371; // km
    
    final lat1Rad = point1.latitude * math.pi / 180;
    final lat2Rad = point2.latitude * math.pi / 180;
    final deltaLatRad = (point2.latitude - point1.latitude) * math.pi / 180;
    final deltaLngRad = (point2.longitude - point1.longitude) * math.pi / 180;

    final a = math.sin(deltaLatRad / 2) * math.sin(deltaLatRad / 2) +
        math.cos(lat1Rad) * math.cos(lat2Rad) *
        math.sin(deltaLngRad / 2) * math.sin(deltaLngRad / 2);
    final c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));

    return earthRadius * c;
  }

  /// Get zoom level based on geographic area
  static double getOptimalZoomLevel(List<GeoLocation> boundaries) {
    if (boundaries.length < 2) return 1.0;
    
    double minLat = boundaries.first.latitude;
    double maxLat = boundaries.first.latitude;
    double minLng = boundaries.first.longitude;
    double maxLng = boundaries.first.longitude;
    
    for (final point in boundaries) {
      minLat = math.min(minLat, point.latitude);
      maxLat = math.max(maxLat, point.latitude);
      minLng = math.min(minLng, point.longitude);
      maxLng = math.max(maxLng, point.longitude);
    }
    
    final latSpan = maxLat - minLat;
    final lngSpan = maxLng - minLng;
    final maxSpan = math.max(latSpan, lngSpan);
    
    // Convert span to zoom level (logarithmic scale)
    return math.max(1.0, 180.0 / maxSpan);
  }
} 