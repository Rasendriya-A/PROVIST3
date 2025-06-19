// Script untuk menambahkan produk dummy dengan gambar yang valid
import 'package:cloud_firestore/cloud_firestore.dart';

class ProductSetup {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addSampleProducts() async {
    try {
      final productsCollection = _firestore.collection('products');
      final reviewsCollection = _firestore.collection('reviews');
      final cartsCollection = _firestore.collection('carts');

      // Cek apakah produk sudah ada
      final existingProducts = await productsCollection.limit(1).get();
      if (existingProducts.docs.isNotEmpty) {
        print('ℹ️ Sample products already exist. Skipping setup.');
        return;
      }

      // Hapus data lama dari reviews dan carts untuk memastikan konsistensi
      print('🗑️ Clearing old reviews and carts...');
      final oldReviews = await reviewsCollection.get();
      for (final doc in oldReviews.docs) {
        await doc.reference.delete();
      }
      final oldCarts = await cartsCollection.get();
      for (final doc in oldCarts.docs) {
        await doc.reference.delete();
      }
      print('✅ Old data cleared.');

      // Tambah produk baru dengan URL gambar yang valid dari Unsplash
      final products = [
        {
          'name': 'Tenda Camping 4 Orang',
          'price': 150000,
          'imageUrl': 'https://images.unsplash.com/photo-1504280390367-361c6d9f38f4?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1170&q=80',
          'description':
              'Tenda camping berkualitas untuk 4 orang dengan bahan tahan air.',
          'category': 'Tenda',
          'condition': 'Baik',
          'available': true,
          'stock': 10,
          'averageRating': 0.0,
          'reviewCount': 0,
        },
        {
          'name': 'Sleeping Bag Premium',
          'price': 75000,
          'imageUrl': 'https://images.unsplash.com/photo-1587562436840-aa35b83eadc2?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1170&q=80',
          'description': 'Sleeping bag hangat dan nyaman untuk camping.',
          'category': 'Sleeping Bag',
          'condition': 'Baik',
          'available': true,
          'stock': 15,
          'averageRating': 0.0,
          'reviewCount': 0,
        },
        {
          'name': 'Tas Carrier 60L',
          'price': 50000,
          'imageUrl': 'https://images.unsplash.com/photo-1579783902614-a34749092835?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=704&q=80',
          'description': 'Tas carrier besar 60 liter untuk hiking dan camping.',
          'category': 'Tas',
          'condition': 'Baik',
          'available': true,
          'stock': 20,
          'averageRating': 0.0,
          'reviewCount': 0,
        },
        {
          'name': 'Paket Camping Lengkap',
          'price': 250000,
          'imageUrl': 'https://images.unsplash.com/photo-1525811902-f2342640856e?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1171&q=80',
          'description': 'Paket lengkap untuk camping: tenda, sleeping bag, dan alat masak.',
          'category': 'Paket Camping',
          'condition': 'Baik',
          'available': true,
          'stock': 5,
          'averageRating': 0.0,
          'reviewCount': 0,
        },
      ];

      // Tambahkan setiap produk ke Firestore
      for (final product in products) {
        await _firestore.collection('products').add(product);
      }

      print('✅ Sample products added successfully!');
    } catch (e) {
      print('❌ Error adding sample products: $e');
    }
  }
}
