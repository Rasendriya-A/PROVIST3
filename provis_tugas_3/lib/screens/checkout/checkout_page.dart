// lib/screens/checkout_screen.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart'; // Import this for locale initialization
import 'package:provis_tugas_3/models/checkout_model.dart';
import 'package:provis_tugas_3/screens/checkout/services/checkout_service.dart';
import 'package:provis_tugas_3/widgets/checkout_widget.dart';
import 'package:provis_tugas_3/utils/app_colors.dart';
import 'order_confirmation_screen.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({Key? key}) : super(key: key);

  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final CheckoutService _checkoutService = CheckoutService();

  List<RentalItemModel> _items = [];
  List<PaymentMethodModel> _availablePaymentMethods = [];
  late PaymentMethodModel _selectedPaymentMethod;

  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now().add(const Duration(days: 3));

  bool _isLoading = true;
  bool _isProcessing = false;

  double _subtotal = 0;
  double _serviceFee = 0;
  double _total = 0;

  @override
  void initState() {
    super.initState();
    // Initialize date formatting for Indonesian locale
    initializeDateFormatting('id_ID', null).then((_) {
      _loadData();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    
    // Get the passed arguments from cart page
    final Map<String, dynamic>? checkoutData = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    
    if (checkoutData != null) {
      // Convert Map items to RentalItemModel objects
      final items = (checkoutData['items'] as List).map((itemMap) {
        final item = itemMap as Map<String, dynamic>;
        // Adapt to your RentalItemModel constructor - adjust these parameters based on your model
        return RentalItemModel(
          name: item['productName'], 
          price: item['price'],
          quantity: item['quantity'],
          imageUrl: item['imageUrl'],
          // Remove any parameters that aren't in your RentalItemModel constructor
          // or add any required parameters with default values
        );
      }).toList();
      
      setState(() {
        _items = items;
        _startDate = checkoutData['startDate'] as DateTime;
        _endDate = checkoutData['endDate'] as DateTime;
        _subtotal = checkoutData['subtotal'] as double;
        _serviceFee = checkoutData['serviceFee'] as double;
        _total = checkoutData['total'] as double;
      });
    }
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);

    try {
      // Only load cart items if not already loaded from arguments
      if (_items.isEmpty) {
        final items = await _checkoutService.getCartItems();
        setState(() {
          _items = items;
          _subtotal = items.fold(
            0,
            (sum, item) => sum + (item.price * item.quantity),
          );
        });
      }

      // Load payment methods
      final paymentMethods = await _checkoutService.getAvailablePaymentMethods();

      // Calculate service fee if not loaded from arguments
      if (_serviceFee == 0) {
        double serviceFee = _checkoutService.calculateServiceFee(_subtotal);
        setState(() {
          _serviceFee = serviceFee;
          _total = _subtotal + serviceFee;
        });
      }

      setState(() {
        _availablePaymentMethods = paymentMethods;
        _selectedPaymentMethod = paymentMethods.first;
        _isLoading = false;
      });
    } catch (e) {
      // Handle errors
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal memuat data: ${e.toString()}')),
      );
    }
  }

  void _updateRentalDuration(DateTime startDate, DateTime endDate) {
    setState(() {
      _startDate = startDate;
      _endDate = endDate;
      
      // Recalculate costs based on new duration
      int durationInDays = RentalPeriodModel(startDate: startDate, endDate: endDate).durationInDays;
      
      // Assume daily rate is total / original duration
      int originalDuration = RentalPeriodModel(startDate: _startDate, endDate: _endDate).durationInDays;
      double dailyRate = _subtotal / (originalDuration > 0 ? originalDuration : 1);
      
      _subtotal = dailyRate * durationInDays;
      _serviceFee = _checkoutService.calculateServiceFee(_subtotal);
      _total = _subtotal + _serviceFee;
    });
  }

  Future<void> _processCheckout() async {
    setState(() => _isProcessing = true);

    try {
      final checkoutSummary = CheckoutSummaryModel(
        items: _items,
        rentalPeriod: RentalPeriodModel(
          startDate: _startDate,
          endDate: _endDate,
        ),
        paymentMethod: _selectedPaymentMethod,
        subtotal: _subtotal,
        serviceFee: _serviceFee,
        total: _total,
      );

      final success = await _checkoutService.processCheckout(checkoutSummary);

      if (success) {
        // Navigate to confirmation page
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => OrderConfirmationScreen(orderSummary: checkoutSummary),
          ),
        );
      } else {
        throw Exception('Gagal memproses pesanan');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal membuat pesanan: ${e.toString()}')),
      );
      setState(() => _isProcessing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: Text('Checkout', style: TextStyle(color: AppColors.textLight)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.textLight),
          onPressed: () => Navigator.pop(context),
        ),
        elevation: 0,
      ),
      body: _isLoading
        ? Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Rental items
                ..._items.map((item) => RentalItemCard(item: item)),

                const SizedBox(height: 24),

                // Rental duration
                Text(
                  'Lama Sewa',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    DateSelector(
                      label: 'Mulai',
                      selectedDate: _startDate,
                      onDateChanged: (date) {
                        if (date.isAfter(_endDate)) {
                          _updateRentalDuration(date, date);
                        } else {
                          _updateRentalDuration(date, _endDate);
                        }
                      },
                    ),
                    const SizedBox(width: 12),
                    DateSelector(
                      label: 'Selesai',
                      selectedDate: _endDate,
                      onDateChanged: (date) {
                        if (date.isBefore(_startDate)) {
                          _updateRentalDuration(_startDate, _startDate);
                        } else {
                          _updateRentalDuration(_startDate, date);
                        }
                      },
                    ),
                  ],
                ),

                // Duration summary
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    '${RentalPeriodModel(startDate: _startDate, endDate: _endDate).durationInDays} hari',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Product summary
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total ${_items.length} Produk',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      NumberFormat.currency(
                        locale: 'id_ID',
                        symbol: 'Rp ',
                        decimalDigits: 0,
                      ).format(_subtotal),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Payment method
                Text(
                  'Metode Pembayaran',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                PaymentMethodSelector(
                  selectedMethod: _selectedPaymentMethod,
                  availableMethods: _availablePaymentMethods,
                  onMethodChanged: (method) {
                    setState(() => _selectedPaymentMethod = method);
                  },
                ),

                // Payment details
                CheckoutSummaryCard(
                  summary: CheckoutSummaryModel(
                    items: _items,
                    rentalPeriod: RentalPeriodModel(
                      startDate: _startDate,
                      endDate: _endDate,
                    ),
                    paymentMethod: _selectedPaymentMethod,
                    subtotal: _subtotal,
                    serviceFee: _serviceFee,
                    total: _total,
                  ),
                ),

                const SizedBox(height: 24),

                // Checkout button
                CheckoutButton(
                  onPressed: _processCheckout,
                  isLoading: _isProcessing,
                ),
              ],
            ),
          ),
    );
  }
}
