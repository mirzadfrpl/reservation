import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:ecommerce/providers/restaurant_provider.dart';
import 'package:ecommerce/models/restaurant.dart';
import 'package:ecommerce/service/api_service.dart';

@GenerateMocks([ApiService]) 
import 'restaurant_provider_test.mocks.dart';

void main() {
  group('RestaurantProvider', () {
    late MockApiService mockApiService;

    setUp(() {
      mockApiService = MockApiService();
    });

    test('Initial state should be loading', () {
      when(mockApiService.fetchAllRestaurants()).thenAnswer((_) async => []);
      final provider = RestaurantProvider(apiService: mockApiService);
      expect(provider.state, ResultState.loading);
    });

    test('Should return a list of restaurants when API call is successful', () async {
      final dummyRestaurants = [
        RestaurantListItem(
          id: '1',
          name: 'Restoran A',
          description: 'Deskripsi A',
          pictureId: 'pic1',
          city: 'Kota A',
          rating: 4.5,
        ),
      ];
      
      when(mockApiService.fetchAllRestaurants()).thenAnswer((_) async => dummyRestaurants);
      final provider = RestaurantProvider(apiService: mockApiService);
      await untilCalled(mockApiService.fetchAllRestaurants());
      
      expect(provider.state, ResultState.hasData);
      expect(provider.restaurants, dummyRestaurants);
    });

    test('Should return an error when API call fails', () async {
      when(mockApiService.fetchAllRestaurants()).thenThrow(Exception('Failed to load data'));
      final provider = RestaurantProvider(apiService: mockApiService);
      await untilCalled(mockApiService.fetchAllRestaurants());

      expect(provider.state, ResultState.error);
      expect(provider.message, 'Gagal memuat data. Periksa koneksi internet Anda.');
    });
  });
}