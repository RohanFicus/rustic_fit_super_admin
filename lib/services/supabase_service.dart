import 'dart:typed_data';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  static final SupabaseService _instance = SupabaseService._internal();
  factory SupabaseService() => _instance;
  SupabaseService._internal();

  final SupabaseClient _client = Supabase.instance.client;

  SupabaseClient get client => _client;

  // ==========================================
  // AUTHENTICATION
  // ==========================================

  Future<AuthResponse> signIn(String email, String password) async {
    return await _client.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  Future<void> signOut() async {
    await _client.auth.signOut();
  }

  Session? get currentSession => _client.auth.currentSession;
  User? get currentUser => _client.auth.currentUser;

  Future<String> registerUserCredentials(String email, String password) async {
    const supabaseUrl = String.fromEnvironment(
      'SUPABASE_URL',
      defaultValue: 'https://giethkxggfmfmmxkittu.supabase.co',
    );
    const supabaseAnonKey = String.fromEnvironment(
      'SUPABASE_ANON_KEY',
      defaultValue: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImdpZXRoa3hnZ2ZtZm1teGtpdHR1Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODQyMTcxMjAsImV4cCI6MjA5OTc5MzEyMH0.0UYre4tFlBazwbetDJ8QEuodPzIpzBmM-_a13ybwoPU',
    );

    final authClient = SupabaseClient(
      supabaseUrl,
      supabaseAnonKey,
      authOptions: const AuthClientOptions(
        authFlowType: AuthFlowType.implicit,
      ),
    );
    final response = await authClient.auth.signUp(
      email: email,
      password: password,
    );

    if (response.user == null) {
      throw Exception('Failed to sign up user.');
    }

    return response.user!.id;
  }

  // ==========================================
  // CATEGORIES
  // ==========================================

  Future<List<Map<String, dynamic>>> getCategories() async {
    final response = await _client
        .from('categories')
        .select()
        .order('name', ascending: true);
    return List<Map<String, dynamic>>.from(response);
  }

  Future<Map<String, dynamic>> createCategory(Map<String, dynamic> data) async {
    final response = await _client.from('categories').insert(data).select().single();
    return response;
  }

  Future<Map<String, dynamic>> updateCategory(String id, Map<String, dynamic> data) async {
    final response = await _client
        .from('categories')
        .update(data)
        .eq('id', id)
        .select()
        .single();
    return response;
  }

  Future<void> deleteCategory(String id) async {
    await _client.from('categories').delete().eq('id', id);
  }

  // ==========================================
  // CUSTOMERS
  // ==========================================

  Future<List<Map<String, dynamic>>> getCustomers() async {
    final response = await _client
        .from('customers')
        .select()
        .order('created_at', ascending: false);
    return List<Map<String, dynamic>>.from(response);
  }

  Future<Map<String, dynamic>> createCustomer(Map<String, dynamic> data) async {
    final response = await _client.from('customers').insert(data).select().single();
    return response;
  }

  Future<Map<String, dynamic>> updateCustomer(String id, Map<String, dynamic> data) async {
    final response = await _client
        .from('customers')
        .update(data)
        .eq('id', id)
        .select()
        .single();
    return response;
  }

  Future<void> deleteCustomer(String id) async {
    await _client.from('customers').delete().eq('id', id);
  }

  // ==========================================
  // TAILORS
  // ==========================================

  Future<List<Map<String, dynamic>>> getTailors() async {
    final response = await _client
        .from('tailors')
        .select()
        .order('name', ascending: true);
    return List<Map<String, dynamic>>.from(response);
  }

  Future<Map<String, dynamic>> createTailor(Map<String, dynamic> data) async {
    final response = await _client.from('tailors').insert(data).select().single();
    return response;
  }

  Future<Map<String, dynamic>> updateTailor(String id, Map<String, dynamic> data) async {
    final response = await _client
        .from('tailors')
        .update(data)
        .eq('id', id)
        .select()
        .single();
    return response;
  }

  Future<void> deleteTailor(String id) async {
    await _client.from('tailors').delete().eq('id', id);
  }

  // ==========================================
  // DELIVERY PARTNERS
  // ==========================================

  Future<List<Map<String, dynamic>>> getDeliveryPartners() async {
    final response = await _client
        .from('delivery_partners')
        .select()
        .order('name', ascending: true);
    return List<Map<String, dynamic>>.from(response);
  }

  Future<Map<String, dynamic>> createDeliveryPartner(Map<String, dynamic> data) async {
    final response = await _client.from('delivery_partners').insert(data).select().single();
    return response;
  }

  Future<Map<String, dynamic>> updateDeliveryPartner(String id, Map<String, dynamic> data) async {
    final response = await _client
        .from('delivery_partners')
        .update(data)
        .eq('id', id)
        .select()
        .single();
    return response;
  }

  Future<void> deleteDeliveryPartner(String id) async {
    await _client.from('delivery_partners').delete().eq('id', id);
  }

  // ==========================================
  // PRODUCTS
  // ==========================================

  Future<List<Map<String, dynamic>>> getProducts() async {
    final response = await _client
        .from('products')
        .select('*, categories(name)')
        .order('name', ascending: true);
    return List<Map<String, dynamic>>.from(response);
  }

  Future<Map<String, dynamic>> createProduct(Map<String, dynamic> data) async {
    final response = await _client.from('products').insert(data).select().single();
    return response;
  }

  Future<Map<String, dynamic>> updateProduct(String id, Map<String, dynamic> data) async {
    final response = await _client
        .from('products')
        .update(data)
        .eq('id', id)
        .select()
        .single();
    return response;
  }

  Future<void> deleteProduct(String id) async {
    await _client.from('products').delete().eq('id', id);
  }

  // ==========================================
  // ORDERS
  // ==========================================

  Future<List<Map<String, dynamic>>> getOrders() async {
    final response = await _client
        .from('orders')
        .select('*, customers(name), tailors(name)')
        .order('created_at', ascending: false);
    return List<Map<String, dynamic>>.from(response);
  }

  Future<Map<String, dynamic>> createOrder(Map<String, dynamic> data) async {
    final response = await _client.from('orders').insert(data).select().single();
    return response;
  }

  Future<Map<String, dynamic>> updateOrder(String id, Map<String, dynamic> data) async {
    final response = await _client
        .from('orders')
        .update(data)
        .eq('id', id)
        .select()
        .single();
    return response;
  }

  Future<void> deleteOrder(String id) async {
    await _client.from('orders').delete().eq('id', id);
  }

  // ==========================================
  // TRANSACTIONS
  // ==========================================

  Future<List<Map<String, dynamic>>> getTransactions() async {
    final response = await _client
        .from('transactions')
        .select('*, orders(order_number, customer_id, customers(name))')
        .order('created_at', ascending: false);
    return List<Map<String, dynamic>>.from(response);
  }

  Future<Map<String, dynamic>> createTransaction(Map<String, dynamic> data) async {
    final response = await _client.from('transactions').insert(data).select().single();
    return response;
  }

  // ==========================================
  // LOCATIONS
  // ==========================================

  Future<List<Map<String, dynamic>>> getLocations() async {
    final response = await _client
        .from('locations')
        .select()
        .order('city', ascending: true);
    return List<Map<String, dynamic>>.from(response);
  }

  Future<Map<String, dynamic>> createLocation(Map<String, dynamic> data) async {
    final response = await _client.from('locations').insert(data).select().single();
    return response;
  }

  Future<Map<String, dynamic>> updateLocation(String id, Map<String, dynamic> data) async {
    final response = await _client
        .from('locations')
        .update(data)
        .eq('id', id)
        .select()
        .single();
    return response;
  }

  Future<void> deleteLocation(String id) async {
    await _client.from('locations').delete().eq('id', id);
  }

  // ==========================================
  // MEASUREMENT TEMPLATES
  // ==========================================

  Future<List<Map<String, dynamic>>> getMeasurementTemplates() async {
    final response = await _client
        .from('measurement_templates')
        .select()
        .order('name', ascending: true);
    return List<Map<String, dynamic>>.from(response);
  }

  Future<Map<String, dynamic>> createMeasurementTemplate(Map<String, dynamic> data) async {
    final response = await _client.from('measurement_templates').insert(data).select().single();
    return response;
  }

  Future<Map<String, dynamic>> updateMeasurementTemplate(String id, Map<String, dynamic> data) async {
    final response = await _client
        .from('measurement_templates')
        .update(data)
        .eq('id', id)
        .select()
        .single();
    return response;
  }

  Future<void> deleteMeasurementTemplate(String id) async {
    await _client.from('measurement_templates').delete().eq('id', id);
  }

  // ==========================================
  // STORAGE
  // ==========================================

  Future<String> uploadProductImage(String path, Uint8List fileBytes) async {
    final fileName = '${DateTime.now().millisecondsSinceEpoch}_$path';
    await _client.storage.from('products').uploadBinary(
          fileName,
          fileBytes,
          fileOptions: const FileOptions(
            contentType: 'image/jpeg',
            upsert: true,
          ),
        );
    return _client.storage.from('products').getPublicUrl(fileName);
  }
}
