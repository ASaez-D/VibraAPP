import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../utils/app_logger.dart';

/// Service for managing user data in Firestore
/// Handles user profiles, preferences, favorites, and saved events
class UserDataService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Collection names
  static const String _usersCollection = 'users';
  static const String _favoritesCollection = 'favorites';
  static const String _savedEventsCollection = 'saved_events';

  /// Gets the current user's UID safely
  String? get _uid => _auth.currentUser?.uid;

  /// Cleans IDs to prevent Firebase path errors
  ///
  /// Replaces forward and backward slashes with underscores
  /// to avoid breaking Firestore document paths
  String _cleanId(String id) {
    return id.replaceAll('/', '_').replaceAll('\\', '_');
  }

  // ---------------------------------------------------
  // USER MANAGEMENT (LOGIN)
  // ---------------------------------------------------

  /// Saves user data from authentication profile map
  ///
  /// Used after Google/Spotify login to store user info
  /// Merges with existing data to preserve preferences
  Future<void> saveUserFromMap(Map<String, dynamic> profile) async {
    String? uid = profile['uid'] ?? profile['id'];
    if (uid == null) {
      AppLogger.warning('saveUserFromMap: No se encontró UID en el perfil');
      return;
    }

    try {
      await _db.collection(_usersCollection).doc(uid).set({
        'id': uid,
        'displayName': profile['displayName'],
        'email': profile['email'],
        'photoURL': profile['photoURL'],
        'lastLogin': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      AppLogger.info('Usuario guardado desde mapa: $uid');
    } catch (e, stackTrace) {
      AppLogger.error('Error en saveUserFromMap', e, stackTrace);
    }
  }

  /// Saves user profile from Firebase User object
  ///
  /// Used when there's an active Firebase session
  /// Merges with existing data to preserve preferences
  Future<void> saveUserProfile(User user) async {
    try {
      await _db.collection(_usersCollection).doc(user.uid).set({
        'id': user.uid,
        'displayName': user.displayName,
        'email': user.email,
        'photoURL': user.photoURL,
        'lastLogin': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      AppLogger.info('Perfil de usuario guardado: ${user.uid}');
    } catch (e, stackTrace) {
      AppLogger.error('Error en saveUserProfile', e, stackTrace);
    }
  }

  // ---------------------------------------------------
  // PREFERENCES MANAGEMENT (ONBOARDING)
  // ---------------------------------------------------

  /// Saves user music preferences (genres and artists)
  ///
  /// Used during onboarding to store user's music taste
  /// Throws exception on error for proper error handling in UI
  Future<void> saveUserPreferences(
    String uid,
    Map<String, dynamic> preferences,
  ) async {
    try {
      await _db.collection(_usersCollection).doc(uid).set({
        'preferences': preferences,
      }, SetOptions(merge: true));

      AppLogger.info('Preferencias guardadas para usuario: $uid');
    } catch (e, stackTrace) {
      AppLogger.error('Error guardando preferencias', e, stackTrace);
      rethrow;
    }
  }

  /// Retrieves user's music preferences
  ///
  /// Returns preferences map or null if not found
  /// Used to filter home screen concerts by user taste
  Future<Map<String, dynamic>?> getUserPreferences() async {
    if (_uid == null) {
      AppLogger.warning('getUserPreferences: No hay usuario autenticado');
      return null;
    }

    try {
      final doc = await _db.collection(_usersCollection).doc(_uid).get();
      if (doc.exists && doc.data() != null) {
        final prefs = doc.data()!['preferences'] as Map<String, dynamic>?;
        AppLogger.debug('Preferencias obtenidas para usuario: $_uid');
        return prefs;
      }
    } catch (e, stackTrace) {
      AppLogger.error('Error leyendo preferencias', e, stackTrace);
    }
    return null;
  }

  // ---------------------------------------------------
  // FAVORITES MANAGEMENT (HEART ❤️)
  // ---------------------------------------------------

  /// Toggles favorite status for an event
  ///
  /// If event is already favorited, removes it
  /// If event is not favorited, adds it
  Future<void> toggleFavorite(
    String eventId,
    Map<String, dynamic> eventData,
  ) async {
    if (_uid == null) {
      AppLogger.warning('toggleFavorite: No hay usuario autenticado');
      return;
    }

    try {
      final safeId = _cleanId(eventId);
      final ref = _db
          .collection(_usersCollection)
          .doc(_uid)
          .collection(_favoritesCollection)
          .doc(safeId);

      final doc = await ref.get();
      if (doc.exists) {
        await ref.delete();
        AppLogger.debug('Favorito eliminado: $safeId');
      } else {
        await ref.set({
          ...eventData,
          'id': safeId,
          'originalName': eventId,
          'addedAt': FieldValue.serverTimestamp(),
        });
        AppLogger.debug('Favorito añadido: $safeId');
      }
    } catch (e, stackTrace) {
      AppLogger.error('Error en toggleFavorite', e, stackTrace);
    }
  }

  // ---------------------------------------------------
  // SAVED EVENTS MANAGEMENT (BOOKMARK 🔖)
  // ---------------------------------------------------

  /// Toggles saved status for an event
  ///
  /// If event is already saved, removes it
  /// If event is not saved, adds it
  Future<void> toggleSaved(
    String eventId,
    Map<String, dynamic> eventData,
  ) async {
    if (_uid == null) {
      AppLogger.warning('toggleSaved: No hay usuario autenticado');
      return;
    }

    try {
      final safeId = _cleanId(eventId);
      final ref = _db
          .collection(_usersCollection)
          .doc(_uid)
          .collection(_savedEventsCollection)
          .doc(safeId);

      final doc = await ref.get();
      if (doc.exists) {
        await ref.delete();
        AppLogger.debug('Evento guardado eliminado: $safeId');
      } else {
        await ref.set({
          ...eventData,
          'id': safeId,
          'originalName': eventId,
          'savedAt': FieldValue.serverTimestamp(),
        });
        AppLogger.debug('Evento guardado añadido: $safeId');
      }
    } catch (e, stackTrace) {
      AppLogger.error('Error en toggleSaved', e, stackTrace);
    }
  }

  // ---------------------------------------------------
  // GENERAL QUERIES
  // ---------------------------------------------------

  /// Gets list of event IDs for a specific collection
  ///
  /// Used to determine which events are favorited/saved
  /// for displaying correct icon states in UI
  ///
  /// [collectionName] should be 'favorites' or 'saved_events'
  Future<List<String>> getUserInteractions(String collectionName) async {
    if (_uid == null) {
      AppLogger.warning('getUserInteractions: No hay usuario autenticado');
      return [];
    }

    try {
      final snapshot = await _db
          .collection(_usersCollection)
          .doc(_uid)
          .collection(collectionName)
          .get();

      final ids = snapshot.docs.map((doc) => doc.id).toList();
      AppLogger.debug(
        'Interacciones obtenidas de $collectionName: ${ids.length}',
      );
      return ids;
    } catch (e, stackTrace) {
      AppLogger.error('Error obteniendo interacciones', e, stackTrace);
      return [];
    }
  }

  /// Retrieves all saved events for the current user
  ///
  /// Used by SavedEventsScreen to display global saved events
  /// regardless of current region
  Future<List<Map<String, dynamic>>> getSavedEvents() async {
    if (_uid == null) {
      return [];
    }

    try {
      final snapshot = await _db
          .collection(_usersCollection)
          .doc(_uid)
          .collection(_savedEventsCollection)
          .orderBy('savedAt', descending: true)
          .get();

      return snapshot.docs.map((doc) => doc.data()).toList();
    } catch (e, stackTrace) {
      AppLogger.error('Error obteniendo eventos guardados', e, stackTrace);
      return [];
    }
  }
}
