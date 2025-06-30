import 'package:flutter/material.dart';
import '../../data/models/geography_models.dart';

/// Location information panel widget
class LocationInfoPanel extends StatelessWidget {
  final Country? selectedCountry;
  final GeographicState? selectedState;
  final City? selectedCity;
  final VoidCallback onClose;
  final ValueChanged<Country> onCountrySelected;
  final ValueChanged<GeographicState> onStateSelected;
  final ValueChanged<City> onCitySelected;

  const LocationInfoPanel({
    super.key,
    this.selectedCountry,
    this.selectedState,
    this.selectedCity,
    required this.onClose,
    required this.onCountrySelected,
    required this.onStateSelected,
    required this.onCitySelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.9),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.blue, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          _buildHeader(),
          
          // Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: _buildContent(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.2),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(14),
          topRight: Radius.circular(14),
        ),
      ),
      child: Row(
        children: [
          const Icon(Icons.location_on, color: Colors.blue, size: 24),
          const SizedBox(width: 8),
          const Text(
            'Location Details',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          IconButton(
            onPressed: onClose,
            icon: const Icon(Icons.close, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    if (selectedCity != null) {
      return _buildCityInfo();
    } else if (selectedState != null) {
      return _buildStateInfo();
    } else if (selectedCountry != null) {
      return _buildCountryInfo();
    } else {
      return const Center(
        child: Text(
          'Select a location to view details',
          style: TextStyle(color: Colors.white70),
        ),
      );
    }
  }

  Widget _buildCountryInfo() {
    if (selectedCountry == null) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Flag and name
        Row(
          children: [
            Container(
              width: 40,
              height: 30,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Image.network(
                selectedCountry!.flagUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey,
                    child: const Icon(Icons.flag, color: Colors.white),
                  );
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    selectedCountry!.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    selectedCountry!.code,
                    style: const TextStyle(
                      color: Colors.blue,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        
        const SizedBox(height: 16),

        // Basic info
        _buildInfoRow('Capital', selectedCountry!.capital),
        _buildInfoRow('Continent', selectedCountry!.continent),
        _buildInfoRow('Population', _formatNumber(selectedCountry!.population)),
        _buildInfoRow('Area', '${_formatNumber(selectedCountry!.area.toInt())} km²'),
        _buildInfoRow('Currency', selectedCountry!.currency),
        _buildInfoRow('Languages', selectedCountry!.languages.join(', ')),

        const SizedBox(height: 16),

        // Location
        _buildLocationInfo(selectedCountry!.center),

        const SizedBox(height: 16),

        // States/Provinces
        if (selectedCountry!.states.isNotEmpty) ...[
          const Text(
            'States/Provinces',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          ...selectedCountry!.states.take(5).map((state) => _buildStateListItem(state)),
          if (selectedCountry!.states.length > 5)
            Text(
              '+ ${selectedCountry!.states.length - 5} more states',
              style: const TextStyle(color: Colors.blue),
            ),
        ],
      ],
    );
  }

  Widget _buildStateInfo() {
    if (selectedState == null) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Breadcrumb
        _buildBreadcrumb(),
        
        const SizedBox(height: 16),

        // State name
        Text(
          selectedState!.name,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        
        const SizedBox(height: 16),

        // Basic info
        _buildInfoRow('Capital', selectedState!.capital),
        _buildInfoRow('Population', _formatNumber(selectedState!.population)),
        _buildInfoRow('Area', '${_formatNumber(selectedState!.area.toInt())} km²'),

        const SizedBox(height: 16),

        // Location
        _buildLocationInfo(selectedState!.center),

        const SizedBox(height: 16),

        // Cities
        if (selectedState!.cities.isNotEmpty) ...[
          const Text(
            'Major Cities',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          ...selectedState!.cities.map((city) => _buildCityListItem(city)),
        ],
      ],
    );
  }

  Widget _buildCityInfo() {
    if (selectedCity == null) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Breadcrumb
        _buildBreadcrumb(),
        
        const SizedBox(height: 16),

        // City name with capital indicator
        Row(
          children: [
            Text(
              selectedCity!.name,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (selectedCity!.isCapital) ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.yellow,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text(
                  'CAPITAL',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ],
        ),
        
        const SizedBox(height: 16),

        // Basic info
        _buildInfoRow('Population', _formatNumber(selectedCity!.population)),

        const SizedBox(height: 16),

        // Location
        _buildLocationInfo(selectedCity!.location),

        const SizedBox(height: 16),

        // Landmarks
        if (selectedCity!.landmarks.isNotEmpty) ...[
          const Text(
            'Notable Landmarks',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          ...selectedCity!.landmarks.map((landmark) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 2),
            child: Row(
              children: [
                const Icon(Icons.place, color: Colors.green, size: 16),
                const SizedBox(width: 8),
                Text(
                  landmark,
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
          )),
        ],
      ],
    );
  }

  Widget _buildBreadcrumb() {
    return Row(
      children: [
        if (selectedCountry != null) ...[
          GestureDetector(
            onTap: () => onCountrySelected(selectedCountry!),
            child: Text(
              selectedCountry!.name,
              style: const TextStyle(
                color: Colors.blue,
                fontSize: 14,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
          if (selectedState != null) ...[
            const Text(' > ', style: TextStyle(color: Colors.white70)),
            GestureDetector(
              onTap: () => onStateSelected(selectedState!),
              child: Text(
                selectedState!.name,
                style: const TextStyle(
                  color: Colors.blue,
                  fontSize: 14,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
            if (selectedCity != null) ...[
              const Text(' > ', style: TextStyle(color: Colors.white70)),
              Text(
                selectedCity!.name,
                style: const TextStyle(color: Colors.white, fontSize: 14),
              ),
            ],
          ],
        ],
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationInfo(GeoLocation location) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Coordinates',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Latitude: ${location.latitude.toStringAsFixed(4)}°',
            style: const TextStyle(color: Colors.white70, fontSize: 12),
          ),
          Text(
            'Longitude: ${location.longitude.toStringAsFixed(4)}°',
            style: const TextStyle(color: Colors.white70, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildStateListItem(GeographicState state) {
    return GestureDetector(
      onTap: () => onStateSelected(state),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 2),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.1),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          children: [
            const Icon(Icons.location_city, color: Colors.blue, size: 16),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                state.name,
                style: const TextStyle(color: Colors.white),
              ),
            ),
            const Icon(Icons.arrow_forward_ios, color: Colors.white70, size: 12),
          ],
        ),
      ),
    );
  }

  Widget _buildCityListItem(City city) {
    return GestureDetector(
      onTap: () => onCitySelected(city),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 2),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.1),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          children: [
            Icon(
              city.isCapital ? Icons.star : Icons.location_city,
              color: city.isCapital ? Colors.yellow : Colors.green,
              size: 16,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                city.name,
                style: const TextStyle(color: Colors.white),
              ),
            ),
            Text(
              _formatNumber(city.population),
              style: const TextStyle(color: Colors.white70, fontSize: 12),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.arrow_forward_ios, color: Colors.white70, size: 12),
          ],
        ),
      ),
    );
  }

  String _formatNumber(int number) {
    if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(1)}M';
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}K';
    }
    return number.toString();
  }
} 