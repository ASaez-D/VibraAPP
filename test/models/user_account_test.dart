import 'package:flutter_test/flutter_test.dart';
import 'package:vibra_project/models/user_account.dart';

void main() {
  group('UserAccount Model Tests', () {
    test('fromMap should create a valid UserAccount with all fields', () {
      final map = {
        'displayName': 'John Doe',
        'email': 'john.doe@example.com',
        'photoURL': 'https://example.com/photo.jpg',
        'profileUrl': 'https://example.com/profile',
      };

      final userAccount = UserAccount.fromMap(map);

      expect(userAccount.displayName, 'John Doe');
      expect(userAccount.email, 'john.doe@example.com');
      expect(userAccount.imageUrl, 'https://example.com/photo.jpg');
      expect(userAccount.profileUrl, 'https://example.com/profile');
    });

    test('fromMap should use default displayName when missing', () {
      final map = {'email': 'test@example.com'};

      final userAccount = UserAccount.fromMap(map);

      expect(userAccount.displayName, 'Usuario Vibra');
      expect(userAccount.email, 'test@example.com');
    });

    test('fromMap should use default email when missing', () {
      final map = {'displayName': 'Test User'};

      final userAccount = UserAccount.fromMap(map);

      expect(userAccount.displayName, 'Test User');
      expect(userAccount.email, 'correo@oculto.com');
    });

    test('fromMap should handle null optional fields', () {
      final map = {
        'displayName': 'Jane Smith',
        'email': 'jane@example.com',
        'photoURL': null,
        'profileUrl': null,
      };

      final userAccount = UserAccount.fromMap(map);

      expect(userAccount.displayName, 'Jane Smith');
      expect(userAccount.email, 'jane@example.com');
      expect(userAccount.imageUrl, null);
      expect(userAccount.profileUrl, null);
    });

    test('fromMap should handle missing optional fields', () {
      final map = {'displayName': 'Bob Johnson', 'email': 'bob@example.com'};

      final userAccount = UserAccount.fromMap(map);

      expect(userAccount.displayName, 'Bob Johnson');
      expect(userAccount.email, 'bob@example.com');
      expect(userAccount.imageUrl, null);
      expect(userAccount.profileUrl, null);
    });

    test('fromMap should handle empty map with all defaults', () {
      final map = <String, dynamic>{};

      final userAccount = UserAccount.fromMap(map);

      expect(userAccount.displayName, 'Usuario Vibra');
      expect(userAccount.email, 'correo@oculto.com');
      expect(userAccount.imageUrl, null);
      expect(userAccount.profileUrl, null);
    });

    test('fromMap should handle Google Sign-In data structure', () {
      final map = {
        'displayName': 'Google User',
        'email': 'googleuser@gmail.com',
        'photoURL': 'https://lh3.googleusercontent.com/photo.jpg',
      };

      final userAccount = UserAccount.fromMap(map);

      expect(userAccount.displayName, 'Google User');
      expect(userAccount.email, 'googleuser@gmail.com');
      expect(
        userAccount.imageUrl,
        'https://lh3.googleusercontent.com/photo.jpg',
      );
    });

    test('fromMap should handle Spotify data structure', () {
      final map = {
        'displayName': 'Spotify User',
        'email': 'spotifyuser@example.com',
        'photoURL': 'https://i.scdn.co/image/avatar.jpg',
        'profileUrl': 'https://open.spotify.com/user/12345',
      };

      final userAccount = UserAccount.fromMap(map);

      expect(userAccount.displayName, 'Spotify User');
      expect(userAccount.email, 'spotifyuser@example.com');
      expect(userAccount.imageUrl, 'https://i.scdn.co/image/avatar.jpg');
      expect(userAccount.profileUrl, 'https://open.spotify.com/user/12345');
    });
  });
}
