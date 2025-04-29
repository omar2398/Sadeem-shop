import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sadeem_shop/features/products/presentation/cubit/products_state.dart';
import '../cubit/products_cubit.dart';
import '../widgets/product_grid_item.dart';

class ProductsPage extends StatefulWidget {
  const ProductsPage({Key? key}) : super(key: key);

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    context.read<ProductsCubit>().loadProducts();
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      context.read<ProductsCubit>().loadMoreProducts();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
      ),
      body: BlocBuilder<ProductsCubit, ProductsState>(
        builder: (context, state) {
          if (state is ProductsInitial) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.products.isEmpty) {
            if (state is ProductsError) {
              return Center(child: Text(state.message));
            }
            return const Center(child: CircularProgressIndicator());
          }

          return GridView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.75,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: state.products.length + (state.isLoadingMore ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == state.products.length) {
                return const Center(child: CircularProgressIndicator());
              }

              final product = state.products[index];
              return ProductGridItem(product: product);
            },
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
