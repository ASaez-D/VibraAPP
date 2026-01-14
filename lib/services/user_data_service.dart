import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserDataService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Obtener el ID del usuario actual de forma segura
  String? get _uid => _auth.currentUser?.uid;

  // --- FUNCIÓN AUXILIAR PARA LIMPIAR NOMBRES (EVITA ERRORES EN RUTAS) ---
  // Cambia las barras '/' por guiones bajos '_' para no romper la ruta de Firebase
  String _cleanId(String id) {
    return id.replaceAll('/', '_').replaceAll('\\', '_');
  }

  // ---------------------------------------------------
  // 1. GESTIÓN DE USUARIOS (LOGIN)
  // ---------------------------------------------------

  // Guardar datos al iniciar sesión (Google/Spotify)
  Future<void> saveUserFromMap(Map<String, dynamic> profile) async {
    String? uid = profile['uid'] ?? profile['id'];
    if (uid == null) return;
    try {
      await _db.collection('users').doc(uid).set({
        'id': uid,
        'displayName': profile['displayName'],
        'email': profile['email'],
        'photoURL': profile['photoURL'],
        'lastLogin': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true)); // Merge para no borrar datos existentes
    } catch (e) { 
      print("Error saveUserFromMap: $e"); 
    }
  }

  // Guardar datos si ya existe sesión activa
  Future<void> saveUserProfile(User user) async {
    try {
      await _db.collection('users').doc(user.uid).set({
        'id': user.uid,
        'displayName': user.displayName,
        'email': user.email,
        'photoURL': user.photoURL,
        'lastLogin': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } catch (e) { 
      print("Error saveUserProfile: $e"); 
    }
  }

  // ---------------------------------------------------
  // 2. GESTIÓN DE PREFERENCIAS (ONBOARDING)
  // ---------------------------------------------------
  
  // Guardar géneros y artistas seleccionados
  Future<void> saveUserPreferences(String uid, Map<String, dynamic> preferences) async {
    try {
      await _db.collection('users').doc(uid).set({
        'preferences': preferences
      }, SetOptions(merge: true)); 
      print("✅ Preferencias guardadas para $uid");
    } catch (e) {
      print("❌ Error guardando preferencias: $e");
      throw e; 
    }
  }

  // Recuperar preferencias para filtrar la Home (IMPORTANTE PARA GOOGLE)
  Future<Map<String, dynamic>?> getUserPreferences() async {
    if (_uid == null) return null;
    try {
      final doc = await _db.collection('users').doc(_uid).get();
      if (doc.exists && doc.data() != null) {
        // Devolvemos solo la parte de preferencias
        return doc.data()!['preferences'] as Map<String, dynamic>?;
      }
    } catch (e) {
      print("Error leyendo preferencias: $e");
    }
    return null;
  }

  // ---------------------------------------------------
  // 3. GESTIÓN DE FAVORITOS (CORAZÓN ❤️)
  // ---------------------------------------------------

  Future<void> toggleFavorite(String eventId, Map<String, dynamic> eventData) async {
    if (_uid == null) return;
    
    final safeId = _cleanId(eventId); 
    final ref = _db.collection('users').doc(_uid).collection('favorites').doc(safeId);
    
    final doc = await ref.get();
    if (doc.exists) {
      await ref.delete(); // Si existe, lo borramos (toggle off)
    } else {
      await ref.set({ // Si no existe, lo creamos (toggle on)
        ...eventData,
        'id': safeId,
        'originalName': eventId,
        'addedAt': FieldValue.serverTimestamp(),
      });
    }
  }

  // ---------------------------------------------------
  // 4. GESTIÓN DE GUARDADOS (MARCADOR 🔖)
  // ---------------------------------------------------

  Future<void> toggleSaved(String eventId, Map<String, dynamic> eventData) async {
    if (_uid == null) return;

    final safeId = _cleanId(eventId);
    final ref = _db.collection('users').doc(_uid).collection('saved_events').doc(safeId);
    
    final doc = await ref.get();
    if (doc.exists) {
      await ref.delete(); 
    } else {
      await ref.set({ 
        ...eventData,
        'id': safeId,
        'originalName': eventId,
        'savedAt': FieldValue.serverTimestamp(),
      });
    }
  }
  
  // ---------------------------------------------------
  // 5. CONSULTAS GENERALES
  // ---------------------------------------------------

  // Devuelve la lista de IDs para pintar los iconos rojos/verdes al entrar
  Future<List<String>> getUserInteractions(String collectionName) async {
    if (_uid == null) return [];
    try {
      final snapshot = await _db.collection('users').doc(_uid).collection(collectionName).get();
      // Mapeamos a una lista de Strings con los IDs originales (o limpios)
      return snapshot.docs.map((doc) => doc.id).toList();
    } catch (e) {
      print("Error obteniendo interacciones: $e");
      return [];
    }
  }
}