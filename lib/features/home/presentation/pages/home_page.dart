import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:sadeem_shop/features/products/presentation/pages/products_page.dart';
import 'package:sadeem_shop/features/cart/presentation/pages/cart_page.dart';
import 'package:sadeem_shop/features/favorites/presentation/pages/favorites_page.dart';
import 'package:sadeem_shop/features/profile/presentation/pages/profile_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const ProductsPage(key: PageStorageKey('products_page')),
    const CartPage(key: PageStorageKey('cart_page')),
    const FavoritesPage(key: PageStorageKey('favorites_page')),
    const ProfilePage(key: PageStorageKey('profile_page')),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 5,
            ),
          ],
        ),
        child: Row(
          children: [
            _buildNavItem(0, HugeIcons.strokeRoundedHome12, 'Products'),
            _buildNavItem(1, HugeIcons.strokeRoundedShoppingBasket03, 'Cart'),
            _buildNavItem(2, HugeIcons.strokeRoundedShoppingBasketFavorite03,
                'Favorites'),
            _buildNavItem(3, HugeIcons.strokeRoundedProfile02, 'Profile'),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    final bool isSelected = _selectedIndex == index;

    return Expanded(
      child: InkWell(
        onTap: () => _onItemTapped(index),
        child: Container(
          height: 70,
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFFF4F8FB) : Colors.transparent,
            borderRadius: BorderRadius.circular(0),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: isSelected ? const Color(0xFF5775CD) : Colors.grey,
                size: 30,
              ),
              const SizedBox(height: 15),
            ],
          ),
        ),
      ),
    );
  }
}
