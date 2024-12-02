import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

// Mock class example
class MockDataService extends Mock implements DataService {}

class DataService {
  Future<String> fetchData() async {
    // Simulated data fetch
    return 'Test Data';
  }
}

void main() {
  group('DataService Tests', () {
    late MockDataService mockDataService;

    setUp(() {
      mockDataService = MockDataService();
    });

    test('fetchData returns expected value', () async {
      // Arrange
      when(() => mockDataService.fetchData())
          .thenAnswer((_) async => 'Mocked Data');

      // Act
      final result = await mockDataService.fetchData();

      // Assert
      expect(result, 'Mocked Data');
    });
  });
}
