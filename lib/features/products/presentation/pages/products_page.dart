import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:sadeem_shop/core/widgets/custom_snackbar.dart';
import 'package:sadeem_shop/features/products/domain/entities/product.dart';
import 'package:sadeem_shop/features/products/presentation/widgets/product_grid_item.dart';
import 'package:sadeem_shop/features/products/presentation/constants/products_constants.dart';
import '../cubit/products_cubit.dart';
import '../cubit/products_state.dart';

class ProductsPage extends StatefulWidget {
  const ProductsPage({Key? key}) : super(key: key);

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage>
    with AutomaticKeepAliveClientMixin {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    context.read<ProductsCubit>().loadProducts();
  }

  List<Product> _filterProducts(List<Product> products) {
    if (_searchQuery.isEmpty) return products;
    return products
        .where((product) =>
            product.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            product.description
                .toLowerCase()
                .contains(_searchQuery.toLowerCase()))
        .toList();
  }

  Widget _buildBody(ProductsState state) {
    if (state is ProductsLoading && state.products.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state is ProductsError && state.products.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(state.message),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.read<ProductsCubit>().loadProducts(),
              child: const Text(ProductsTexts.retryButton),
            ),
          ],
        ),
      );
    }

    final filteredProducts = _filterProducts(state.products);

    if (filteredProducts.isEmpty) {
      return const Center(child: Text(ProductsTexts.noProductsFound));
    }

    return ListView.builder(
      key: const PageStorageKey<String>('products_list'),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: filteredProducts.length,
      itemBuilder: (context, index) => ProductGridItem(
        product: filteredProducts[index],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: ProductsColors.backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextField(
                controller: _searchController,
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
                decoration: InputDecoration(
                  hintText: ProductsTexts.searchHint,
                  prefixIcon: const Icon(HugeIcons.strokeRoundedSearch01),
                  suffixIcon: GestureDetector(
                    onTap: () => CustomSnackBar.show(
                        context: context,
                        message: "Filter button isn't implemented yet",
                        isSuccess: false),
                    child: Container(
                      margin: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: ProductsColors.primaryButtonColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.filter_list,
                        color: ProductsColors.searchBarIconColor,
                      ),
                    ),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: ProductsColors.searchBarFillColor,
                ),
              ),
            ),
            Expanded(
              child: BlocBuilder<ProductsCubit, ProductsState>(
                builder: (context, state) {
                  return RefreshIndicator(
                    color: ProductsColors.backgroundColor,
                    backgroundColor: ProductsColors.primaryButtonColor,
                    elevation: 0,
                    onRefresh: () =>
                        context.read<ProductsCubit>().refreshProducts(),
                    child: _buildBody(state),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
