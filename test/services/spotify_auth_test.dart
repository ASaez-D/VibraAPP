import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vibra_project/services/spotify_auth.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('SpotifyAuth Tests', () {
    setUp(() {
      SharedPreferences.setMockInitialValues({});
    });

    test('getSavedToken retrieves token from SharedPreferences', () async {
      SharedPreferences.setMockInitialValues({'spotify_token': 'test_token'});

      final token = await SpotifyAuth.getSavedToken();
      expect(token, 'test_token');
    });

    test('getSavedToken returns null when no token exists', () async {
      SharedPreferences.setMockInitialValues({});

      final token = await SpotifyAuth.getSavedToken();
      expect(token, null);
    });

    test('logout removes token from SharedPreferences', () async {
      SharedPreferences.setMockInitialValues({'spotify_token': 'test_token'});

      await SpotifyAuth.logout();

      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('spotify_token');
      expect(token, null);
    });

    test('spotify auth service exists and can be instantiated', () {
      final spotifyAuth = SpotifyAuth();
      expect(spotifyAuth, isNotNull);
    });
  });
}
