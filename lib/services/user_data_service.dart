import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserDataService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? get _uid => _auth.currentUser?.uid;

  // --- FUNCIÓN AUXILIAR PARA LIMPIAR NOMBRES ---
  // Cambia las barras '/' por guiones bajos '_' para no romper Firebase
  String _cleanId(String id) {
    return id.replaceAll('/', '_').replaceAll('\\', '_');
  }

  // --- 1. LOGIN Y PERFILES ---
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
      }, SetOptions(merge: true));
    } catch (e) { print("Error saveUserFromMap: $e"); }
  }

  Future<void> saveUserProfile(User user) async {
    try {
      await _db.collection('users').doc(user.uid).set({
        'id': user.uid,
        'displayName': user.displayName,
        'email': user.email,
        'photoURL': user.photoURL,
        'lastLogin': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } catch (e) { print("Error saveUserProfile: $e"); }
  }

  // --- 2. GESTIÓN DE FAVORITOS (CORAZÓN ❤️) ---
  Future<void> toggleFavorite(String eventId, Map<String, dynamic> eventData) async {
    if (_uid == null) return;
    
    // USAMOS EL ID LIMPIO AQUI
    final safeId = _cleanId(eventId); 
    final ref = _db.collection('users').doc(_uid).collection('favorites').doc(safeId);
    
    final doc = await ref.get();
    if (doc.exists) {
      await ref.delete(); 
    } else {
      await ref.set({ 
        ...eventData,
        'id': safeId, // Guardamos el ID limpio también dentro
        'originalName': eventId, // Opcional: guardamos el nombre real por si acaso
        'addedAt': FieldValue.serverTimestamp(),
      });
    }
  }

  // --- 3. GESTIÓN DE GUARDADOS (MARCADOR 🔖) ---
  Future<void> toggleSaved(String eventId, Map<String, dynamic> eventData) async {
    if (_uid == null) return;

    // USAMOS EL ID LIMPIO AQUI TAMBIÉN
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
  
  // --- CONSULTAS ---
  Future<List<String>> getUserInteractions(String collectionName) async {
    if (_uid == null) return [];
    final snapshot = await _db.collection('users').doc(_uid).collection(collectionName).get();
    
    // Aquí podríamos devolver 'originalName' si lo guardamos, pero por ahora el ID sirve
    return snapshot.docs.map((doc) => doc.id).toList();
  }
}