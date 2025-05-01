import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:sadeem_shop/features/products/domain/entities/product.dart';
import 'package:sadeem_shop/features/products/presentation/widgets/product_grid_item.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sadeem_shop/features/products/presentation/cubit/products_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({Key? key}) : super(key: key);

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  List<Product> likedProducts = [];

  @override
  void initState() {
    super.initState();
    _loadLikedProducts();
  }

  Future<void> _loadLikedProducts() async {
    final prefs = await SharedPreferences.getInstance();
    final likedProductIds = prefs.getStringList('liked_products') ?? [];

    final allProducts = context.read<ProductsCubit>().state.products;
    final liked = allProducts
        .where((product) => likedProductIds.contains(product.id.toString()))
        .toList();

    setState(() {
      likedProducts = liked;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Wishlist',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: StreamBuilder<List<String>>(
        stream: Stream.periodic(const Duration(seconds: 1)).asyncMap((_) async {
          final prefs = await SharedPreferences.getInstance();
          return prefs.getStringList('liked_products') ?? [];
        }),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final likedProductIds = snapshot.data!;
            final allProducts = context.read<ProductsCubit>().state.products;
            likedProducts = allProducts
                .where((product) =>
                    likedProductIds.contains(product.id.toString()))
                .toList();
          }

          return likedProducts.isEmpty
              ? const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        HugeIcons.strokeRoundedFavourite,
                        size: 64,
                        color: Colors.grey,
                      ),
                      SizedBox(height: 16),
                      Text(
                        'No items in wishlist',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: likedProducts.length,
                  itemBuilder: (context, index) => ProductGridItem(
                    product: likedProducts[index],
                  ),
                );
        },
      ),
    );
  }
}
