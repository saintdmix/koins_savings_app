import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../core/app_router.dart';
import '../core/load_status.dart';
import '../providers/products/products_cubit.dart';
import '../widgets/fade_slide_in.dart';
import '../widgets/product_card.dart';
import '../widgets/responsive_body.dart';
import '../widgets/state_views.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  final _searchCtrl = TextEditingController();

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ProductsCubit>();

    return Scaffold(
      appBar: AppBar(title: const Text('Savings Products')),
      body: SafeArea(
        child: ResponsiveBody(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 4, 20, 8),
                child: TextField(
                  controller: _searchCtrl,
                  onChanged: cubit.search,
                  textInputAction: TextInputAction.search,
                  decoration: InputDecoration(
                    hintText: 'Search savings products',
                    filled: true,
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: IconButton(
                      tooltip: 'Clear',
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        _searchCtrl.clear();
                        cubit.search('');
                      },
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              BlocBuilder<ProductsCubit, ProductsState>(
                buildWhen: (p, c) => p.filter != c.filter,
                builder: (context, state) => SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      for (final f in ProductFilter.values)
                        Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: ChoiceChip(
                            label: Text(f.label),
                            selected: state.filter == f,
                            onSelected: (_) => cubit.setFilter(f),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: BlocBuilder<ProductsCubit, ProductsState>(
                  builder: (context, state) {
                    switch (state.status) {
                      case LoadStatus.initial:
                      case LoadStatus.loading:
                        return const LoadingView();
                      case LoadStatus.failure:
                        return ErrorState(
                          message: state.errorMessage ?? 'Could not load products.',
                          onRetry: cubit.load,
                        );
                      case LoadStatus.success:
                        final items = state.visibleProducts;
                        return RefreshIndicator(
                          onRefresh: cubit.load,
                          child: items.isEmpty
                              ? ListView(
                                  physics: const AlwaysScrollableScrollPhysics(),
                                  children: const [
                                    SizedBox(height: 48),
                                    EmptyState(
                                      icon: Icons.search_off,
                                      title: 'No products found',
                                      message: 'Try a different search or filter.',
                                    ),
                                  ],
                                )
                              : ListView.separated(
                                  physics: const AlwaysScrollableScrollPhysics(),
                                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                                  itemCount: items.length,
                                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                                  itemBuilder: (context, i) => FadeSlideIn(
                                    index: i,
                                    child: ProductCard(
                                      product: items[i],
                                      onViewDetails: () => context.push(
                                        AppRoutes.productDetails(items[i].id),
                                      ),
                                    ),
                                  ),
                                ),
                        );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
