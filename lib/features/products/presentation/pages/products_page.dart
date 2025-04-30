import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    context.read<ProductsCubit>().loadProducts();
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

    if (state.products.isEmpty) {
      return const Center(child: Text(ProductsTexts.noProductsFound));
    }

    return ListView.builder(
      key: const PageStorageKey<String>('products_list'),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: state.products.length,
      itemBuilder: (context, index) => ProductGridItem(
        product: state.products[index],
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
                decoration: InputDecoration(
                  hintText: ProductsTexts.searchHint,
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: Container(
                    margin: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: ProductsColors.filterButtonColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.filter_list,
                      color: ProductsColors.searchBarIconColor,
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
