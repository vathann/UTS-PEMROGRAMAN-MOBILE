import 'package:flutter/material.dart';
import 'order_history_page.dart';

class TransactionPage extends StatefulWidget {
  final List<Map<String, dynamic>> cartItems;

  const TransactionPage({super.key, required this.cartItems});

  @override
  _TransactionPageState createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage>
    with SingleTickerProviderStateMixin {
  double _discountPercentage = 0.0;
  int _shippingCost = 0;
  late AnimationController _animationController;
  late Animation<double> _opacityAnimation;

  String _selectedPaymentMethod = 'Credit Card'; // Default payment method
  final TextEditingController _noteController =
      TextEditingController(); // Controller for the note to seller

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _opacityAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  // Calculate total price before discount and shipping
  int _calculateTotal() {
    int total = 0;
    for (var item in widget.cartItems) {
      String priceString =
          item['price']?.replaceAll('Rp ', '')?.replaceAll('.', '') ?? '0';
      int price = int.parse(priceString);
      int quantity = item['quantity'] ?? 0;
      total += price * quantity;
    }
    return total;
  }

  // Calculate 10% tax
  double _calculateTax() {
    int total = _calculateTotal();
    return total * 0.1; // 10% tax
  }

  // Calculate the final total price after discount, shipping, and tax
  int _calculateFinalTotal() {
    int total = _calculateTotal();
    int discountedTotal = (total * (1 - _discountPercentage)).toInt();
    double tax = _calculateTax();
    return discountedTotal + _shippingCost + tax.toInt();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Transaction',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0,
      ),
      body: widget.cartItems.isEmpty
          ? const Center(child: Text('Your cart is empty'))
          : FadeTransition(
              opacity: _opacityAnimation,
              child: SingleChildScrollView(
                // Wrap the entire body with this widget to make it scrollable
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListView.builder(
                        shrinkWrap:
                            true, // Ensures the ListView does not take up extra space
                        physics:
                            NeverScrollableScrollPhysics(), // Disables scrolling on ListView to let SingleChildScrollView handle it
                        itemCount: widget.cartItems.length,
                        itemBuilder: (context, index) {
                          final product = widget.cartItems[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(vertical: 10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 4,
                            color: Colors.grey[100],
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.asset(
                                      product['image'],
                                      width: 60,
                                      height: 60,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          product['title'],
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          'Rp ${product['price']}',
                                          style: const TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text('x${product['quantity']}'),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                      // Discount Voucher Option
                      ExpansionTile(
                        title: const Text(
                          'Select Discount Voucher',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        backgroundColor:
                            Colors.grey[300], // Grey background color
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ChoiceChip(
                                label: const Text('30% Off'),
                                selected: _discountPercentage == 0.3,
                                onSelected: (selected) {
                                  setState(() {
                                    _discountPercentage = selected ? 0.3 : 0.0;
                                  });
                                },
                              ),
                              const SizedBox(width: 10),
                              ChoiceChip(
                                label: const Text('50% Off'),
                                selected: _discountPercentage == 0.5,
                                onSelected: (selected) {
                                  setState(() {
                                    _discountPercentage = selected ? 0.5 : 0.0;
                                  });
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                        ],
                      ),
                      // Shipping Method Option
                      ExpansionTile(
                        title: const Text(
                          'Select Shipping Method',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        backgroundColor:
                            Colors.grey[300], // Grey background color
                        children: [
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                ChoiceChip(
                                  label: const Text('Reguler - Rp 20,000'),
                                  selected: _shippingCost == 20000,
                                  onSelected: (selected) {
                                    setState(() {
                                      _shippingCost = selected ? 20000 : 0;
                                    });
                                  },
                                ),
                                const SizedBox(width: 10),
                                ChoiceChip(
                                  label: const Text('Express - Rp 30,000'),
                                  selected: _shippingCost == 30000,
                                  onSelected: (selected) {
                                    setState(() {
                                      _shippingCost = selected ? 30000 : 0;
                                    });
                                  },
                                ),
                                const SizedBox(width: 10),
                                ChoiceChip(
                                  label: const Text('Economy - Free'),
                                  selected: _shippingCost == 0,
                                  onSelected: (selected) {
                                    setState(() {
                                      _shippingCost =
                                          selected ? 0 : _shippingCost;
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 10),
                        ],
                      ),
                      // Payment Method Option
                      ExpansionTile(
                        title: const Text(
                          'Select Payment Method',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        backgroundColor:
                            Colors.grey[300], // Grey background color
                        children: [
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                ChoiceChip(
                                  label: const Text('Credit Card'),
                                  selected:
                                      _selectedPaymentMethod == 'Credit Card',
                                  onSelected: (selected) {
                                    setState(() {
                                      _selectedPaymentMethod = selected
                                          ? 'Credit Card'
                                          : _selectedPaymentMethod;
                                    });
                                  },
                                ),
                                const SizedBox(width: 10),
                                ChoiceChip(
                                  label: const Text('PayPal'),
                                  selected: _selectedPaymentMethod == 'PayPal',
                                  onSelected: (selected) {
                                    setState(() {
                                      _selectedPaymentMethod = selected
                                          ? 'PayPal'
                                          : _selectedPaymentMethod;
                                    });
                                  },
                                ),
                                const SizedBox(width: 10),
                                ChoiceChip(
                                  label: const Text('Bank Transfer'),
                                  selected:
                                      _selectedPaymentMethod == 'Bank Transfer',
                                  onSelected: (selected) {
                                    setState(() {
                                      _selectedPaymentMethod = selected
                                          ? 'Bank Transfer'
                                          : _selectedPaymentMethod;
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 10),
                        ],
                      ),
                      // Note to Seller Option
                      Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: TextField(
                          controller: _noteController,
                          maxLines: 3,
                          decoration: InputDecoration(
                            labelText: 'Note to Seller',
                            hintText: 'Write your note here...',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                      // Total Payment
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Total Price: Rp ${_calculateTotal()}',
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                              ),
                            ),
                            Text(
                              'Tax (10%): Rp ${_calculateTax().toStringAsFixed(0)}',
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                              ),
                            ),
                            Text(
                              'Shipping: Rp $_shippingCost',
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                              ),
                            ),
                            Text(
                              'Discount: ${(_discountPercentage * 100).toInt()}%',
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'Final Total: Rp ${_calculateFinalTotal()}',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          // Create the new order data
                          final newOrder = {
                            'items':
                                widget.cartItems, // Add items from the cart
                            'total': _calculateFinalTotal(),
                            'shipping': _shippingCost == 0
                                ? 'Economy - Free'
                                : _shippingCost == 20000
                                    ? 'Reguler - Rp 20,000'
                                    : 'Express - Rp 30,000',
                            'paymentMethod': _selectedPaymentMethod,
                            'note': _noteController.text,
                          };

                          // Navigate to the Order History page
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => OrderHistoryPage(
                                orderHistory: [newOrder], // Send the order data
                              ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey[300], // Set button color
                          padding: const EdgeInsets.symmetric(
                            horizontal: 40,
                            vertical: 12,
                          ),
                          textStyle: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        child: const Text('Order'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
