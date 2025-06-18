// Script untuk menambahkan produk dummy dengan gambar yang valid
import 'package:cloud_firestore/cloud_firestore.dart';

class ProductSetup {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addSampleProducts() async {
    try {
      // Hapus produk lama jika ada
      final existingProducts = await _firestore.collection('products').get();
      for (final doc in existingProducts.docs) {
        await doc.reference.delete();
      } // Tambah produk baru dengan URL gambar yang valid
      final products = [
        {
          'name': 'Tenda Camping 4 Orang',
          'price': 150000,
          'imageUrl': 'https://picsum.photos/400/300?random=1',
          'description':
              'Tenda camping berkualitas untuk 4 orang dengan bahan tahan air',
          'category': 'tenda',
          'condition': 'baik',
          'available': true,
        },
        {
          'name': 'Sleeping Bag Premium',
          'price': 75000,
          'imageUrl': 'https://picsum.photos/400/300?random=2',
          'description': 'Sleeping bag hangat dan nyaman untuk camping',
          'category': 'sleeping-bag',
          'condition': 'baik',
          'available': true,
        },
        {
          'name': 'Tenda Dome 2 Orang',
          'price': 100000,
          'imageUrl': 'https://picsum.photos/400/300?random=3',
          'description': 'Tenda dome compact untuk 2 orang',
          'category': 'tenda',
          'condition': 'baik',
          'available': true,
        },
        {
          'name': 'Tas Carrier 60L',
          'price': 50000,
          'imageUrl': 'https://picsum.photos/400/300?random=4',
          'description': 'Tas carrier besar 60 liter untuk hiking dan camping',
          'category': 'tas',
          'condition': 'baik',
          'available': true,
        },
        {
          'name': 'Kompor Portable',
          'price': 25000,
          'imageUrl': 'https://picsum.photos/400/300?random=5',
          'description': 'Kompor portable untuk memasak di alam',
          'category': 'kitchenware',
          'condition': 'baik',
          'available': true,
        },
        {
          'name': 'Matras Camping',
          'price': 30000,
          'imageUrl': 'https://picsum.photos/400/300?random=6',
          'description': 'Matras empuk untuk tidur nyaman saat camping',
          'category': 'sleeping-bag',
          'condition': 'baik',
          'available': true,
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
