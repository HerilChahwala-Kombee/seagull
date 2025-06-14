import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/routers/my_app_route_constant.dart';

// Data Models
class CartItem {
  final String id;
  final String title;
  final String company;
  final String date;
  final String time;
  final double price;
  final double? originalPrice;
  final String imageUrl;
  final int quantity;

  const CartItem({
    required this.id,
    required this.title,
    required this.company,
    required this.date,
    required this.time,
    required this.price,
    this.originalPrice,
    required this.imageUrl,
    this.quantity = 1,
  });

  CartItem copyWith({
    String? id,
    String? title,
    String? company,
    String? date,
    String? time,
    double? price,
    double? originalPrice,
    String? imageUrl,
    int? quantity,
  }) {
    return CartItem(
      id: id ?? this.id,
      title: title ?? this.title,
      company: company ?? this.company,
      date: date ?? this.date,
      time: time ?? this.time,
      price: price ?? this.price,
      originalPrice: originalPrice ?? this.originalPrice,
      imageUrl: imageUrl ?? this.imageUrl,
      quantity: quantity ?? this.quantity,
    );
  }
}

class CartState {
  final List<CartItem> items;
  final double discount;

  const CartState({required this.items, this.discount = 20.0});

  double get subtotal =>
      items.fold(0.0, (sum, item) => sum + (item.price * item.quantity));
  double get total => subtotal - discount;

  CartState copyWith({List<CartItem>? items, double? discount}) {
    return CartState(
      items: items ?? this.items,
      discount: discount ?? this.discount,
    );
  }
}

// Cart State Notifier
class CartNotifier extends StateNotifier<CartState> {
  CartNotifier() : super(CartState(items: _initialItems));

  static const List<CartItem> _initialItems = [
    CartItem(
      id: '1',
      title: 'Deep House Cleaning',
      company: 'CleanCo Professional Services',
      date: 'Aug 15, 2023',
      time: '10:30 AM',
      price: 80.0,
      originalPrice: 100.0,
      imageUrl: 'assets/images/cleaning.jpg',
      quantity: 1,
    ),
    CartItem(
      id: '2',
      title: 'Garden Maintenance',
      company: 'GreenThumb Services',
      date: 'Aug 18, 2023',
      time: '9:00 AM',
      price: 65.0,
      imageUrl: 'assets/images/garden.jpg',
      quantity: 2,
    ),
    CartItem(
      id: '3',
      title: 'Plumbing Repair',
      company: 'FixIt Plumbing Co.',
      date: 'Aug 20, 2023',
      time: '1:30 PM',
      price: 120.0,
      imageUrl: 'assets/images/plumbing.jpg',
      quantity: 1,
    ),
  ];

  void updateQuantity(String itemId, int newQuantity) {
    if (newQuantity <= 0) return;

    final updatedItems = state.items.map((item) {
      if (item.id == itemId) {
        return item.copyWith(quantity: newQuantity);
      }
      return item;
    }).toList();

    state = state.copyWith(items: updatedItems);
  }

  void removeItem(String itemId) {
    final updatedItems = state.items
        .where((item) => item.id != itemId)
        .toList();
    state = state.copyWith(items: updatedItems);
  }

  void addItem(CartItem item) {
    final existingItemIndex = state.items.indexWhere((i) => i.id == item.id);

    if (existingItemIndex >= 0) {
      updateQuantity(item.id, state.items[existingItemIndex].quantity + 1);
    } else {
      state = state.copyWith(items: [...state.items, item]);
    }
  }

  void clearCart() {
    state = state.copyWith(items: []);
  }
}

// Riverpod Providers
final cartProvider = StateNotifierProvider<CartNotifier, CartState>((ref) {
  return CartNotifier();
});

// Computed providers for specific cart data
final cartItemsProvider = Provider<List<CartItem>>((ref) {
  return ref.watch(cartProvider).items;
});

final cartSubtotalProvider = Provider<double>((ref) {
  return ref.watch(cartProvider).subtotal;
});

final cartDiscountProvider = Provider<double>((ref) {
  return ref.watch(cartProvider).discount;
});

final cartTotalProvider = Provider<double>((ref) {
  return ref.watch(cartProvider).total;
});

final cartItemCountProvider = Provider<int>((ref) {
  return ref
      .watch(cartProvider)
      .items
      .fold(0, (sum, item) => sum + item.quantity);
});

// Main Cart Page
class CartPage extends ConsumerWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Your Cart',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w600,
            color: Color(0xFF2E5266),
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const SizedBox(),
        actions: [
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.close, color: Color(0xFF666666), size: 28),
          ),
        ],
      ),
      body: const CartView(),
    );
  }
}

class CartView extends ConsumerWidget {
  const CartView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartItems = ref.watch(cartItemsProvider);

    return Column(
      children: [
        Expanded(
          child: cartItems.isEmpty
              ? const EmptyCartWidget()
              : ListView.separated(
                  padding: const EdgeInsets.all(20),
                  itemCount: cartItems.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 20),
                  itemBuilder: (context, index) {
                    return CartItemWidget(item: cartItems[index]);
                  },
                ),
        ),
        if (cartItems.isNotEmpty) const CartSummary(),
      ],
    );
  }
}

// Empty Cart Widget
class EmptyCartWidget extends StatelessWidget {
  const EmptyCartWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.shopping_cart_outlined, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'Your cart is empty',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

// Individual Cart Item Widget
class CartItemWidget extends ConsumerWidget {
  final CartItem item;

  const CartItemWidget({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Service Image
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.grey[200],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: _buildServiceImage(),
            ),
          ),
          const SizedBox(width: 16),

          // Service Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        item.title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF2E5266),
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () =>
                          ref.read(cartProvider.notifier).removeItem(item.id),
                      icon: const Icon(
                        Icons.delete_outline,
                        color: Color(0xFF999999),
                        size: 24,
                      ),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),

                Text(
                  item.company,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF999999),
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  '${item.date} • ${item.time}',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF999999),
                  ),
                ),

                const SizedBox(height: 12),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Price
                    Row(
                      children: [
                        Text(
                          '\$${item.price.toInt()}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF2E5266),
                          ),
                        ),
                        if (item.originalPrice != null) ...[
                          const SizedBox(width: 8),
                          Text(
                            '\$${item.originalPrice!.toInt()}',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Color(0xFF999999),
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                        ],
                      ],
                    ),

                    // Quantity Controls
                    QuantitySelector(item: item),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceImage() {
    // Since we can't load actual images, we'll use colored containers with icons
    Color color;
    IconData icon;

    switch (item.title) {
      case 'Deep House Cleaning':
        color = Colors.blue[100]!;
        icon = Icons.cleaning_services;
        break;
      case 'Garden Maintenance':
        color = Colors.green[100]!;
        icon = Icons.grass;
        break;
      case 'Plumbing Repair':
        color = Colors.orange[100]!;
        icon = Icons.plumbing;
        break;
      default:
        color = Colors.grey[200]!;
        icon = Icons.home_repair_service;
    }

    return Container(
      color: color,
      child: Icon(icon, size: 40, color: color.withOpacity(0.7)),
    );
  }
}

// Quantity Selector Widget
class QuantitySelector extends ConsumerWidget {
  final CartItem item;

  const QuantitySelector({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      children: [
        _buildQuantityButton(
          icon: Icons.remove,
          onTap: () => ref
              .read(cartProvider.notifier)
              .updateQuantity(item.id, item.quantity - 1),
        ),

        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            '${item.quantity}',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Color(0xFF2E5266),
            ),
          ),
        ),

        _buildQuantityButton(
          icon: Icons.add,
          onTap: () => ref
              .read(cartProvider.notifier)
              .updateQuantity(item.id, item.quantity + 1),
        ),
      ],
    );
  }

  Widget _buildQuantityButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: Colors.grey[100],
          shape: BoxShape.circle,
        ),
        child: Icon(icon, size: 18, color: const Color(0xFF666666)),
      ),
    );
  }
}

// Cart Summary Widget
class CartSummary extends ConsumerWidget {
  const CartSummary({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final subtotal = ref.watch(cartSubtotalProvider);
    final discount = ref.watch(cartDiscountProvider);
    final total = ref.watch(cartTotalProvider);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          children: [
            // Subtotal
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Subtotal',
                  style: TextStyle(fontSize: 16, color: Color(0xFF666666)),
                ),
                Text(
                  '\$${subtotal.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 16,
                    color: Color(0xFF666666),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            // Discount
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Discount',
                  style: TextStyle(fontSize: 16, color: Color(0xFF4CAF50)),
                ),
                Text(
                  '-\$${discount.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 16,
                    color: Color(0xFF4CAF50),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Divider
            Container(height: 1, color: Colors.grey[200]),

            const SizedBox(height: 16),

            // Total
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2E5266),
                  ),
                ),
                Text(
                  '\$${total.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2E5266),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Promo Code Input
            const PromoCodeInput(),

            const SizedBox(height: 20),

            // Checkout Button
            CheckoutButton(),
          ],
        ),
      ),
    );
  }
}

// Promo Code Input Widget
class PromoCodeInput extends ConsumerStatefulWidget {
  const PromoCodeInput({Key? key}) : super(key: key);

  @override
  ConsumerState<PromoCodeInput> createState() => _PromoCodeInputState();
}

class _PromoCodeInputState extends ConsumerState<PromoCodeInput> {
  bool _isExpanded = false;
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () => setState(() => _isExpanded = !_isExpanded),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey[200]!),
            ),
            child: Row(
              children: [
                const Expanded(
                  child: Text(
                    'Add promo code',
                    style: TextStyle(fontSize: 16, color: Color(0xFF999999)),
                  ),
                ),
                Icon(
                  _isExpanded
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  color: Colors.grey[400],
                ),
              ],
            ),
          ),
        ),
        if (_isExpanded) ...[
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  decoration: InputDecoration(
                    hintText: 'Enter promo code',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: () {
                  // Handle promo code application
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Promo code "${_controller.text}" applied!',
                      ),
                    ),
                  );
                  setState(() => _isExpanded = false);
                  _controller.clear();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF5A67D8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Apply',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}

// Checkout Button Widget
class CheckoutButton extends ConsumerWidget {
  const CheckoutButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final itemCount = ref.watch(cartItemCountProvider);

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: itemCount > 0
            ? () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Proceeding to checkout...'),
                    backgroundColor: Color(0xFF4CAF50),
                  ),
                );
                Future.delayed(const Duration(milliseconds: 500), () {
                  context.push(Routes.bookingConfirmation);
                });
              }
            : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF5A67D8),
          disabledBackgroundColor: Colors.grey[300],
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
        child: Text(
          'Proceed to Checkout',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: itemCount > 0 ? Colors.white : Colors.grey[600],
          ),
        ),
      ),
    );
  }
}
