import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../core/app_router.dart';
import '../core/load_status.dart';
import '../models/savings_product.dart';
import '../providers/products/products_cubit.dart';
import '../providers/savings/savings_cubit.dart';
import '../utils/formatters.dart';
import '../utils/validators.dart';
import '../widgets/app_text_field.dart';
import '../widgets/primary_button.dart';
import '../widgets/responsive_body.dart';
import '../widgets/state_views.dart';

class CreateSavingsScreen extends StatefulWidget {
  const CreateSavingsScreen({super.key, this.initialProductId});

  final String? initialProductId;

  @override
  State<CreateSavingsScreen> createState() => _CreateSavingsScreenState();
}

class _CreateSavingsScreenState extends State<CreateSavingsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _targetCtrl = TextEditingController();
  final _monthlyCtrl = TextEditingController();
  final _durationCtrl = TextEditingController();
  String? _productId;

  @override
  void initState() {
    super.initState();
    final products = context.read<ProductsCubit>().state.products;
    final initial = products.where((p) => p.id == widget.initialProductId).firstOrNull;
    if (initial != null) {
      _productId = initial.id;
      _applyProductDefaults(initial);
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _targetCtrl.dispose();
    _monthlyCtrl.dispose();
    _durationCtrl.dispose();
    super.dispose();
  }

  void _applyProductDefaults(SavingsProduct product) {
    if (product.durationMonths != null) {
      _durationCtrl.text = product.durationMonths.toString();
    }
  }

  void _submit(List<SavingsProduct> products) {
    FocusScope.of(context).unfocus();
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final product = products.firstWhere((p) => p.id == _productId);
    context.read<SavingsCubit>().createPlan(
          name: _nameCtrl.text.trim(),
          product: product,
          targetAmount: double.parse(_targetCtrl.text.trim()),
          monthlyContribution: double.parse(_monthlyCtrl.text.trim()),
          durationMonths: int.parse(_durationCtrl.text.trim()),
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SavingsCubit, SavingsState>(
      listenWhen: (p, c) => p.createStatus != c.createStatus,
      listener: (context, state) {
        final messenger = ScaffoldMessenger.of(context);
        final cubit = context.read<SavingsCubit>();
        if (state.createStatus == CreateStatus.success) {
          messenger.showSnackBar(
            const SnackBar(content: Text('Savings Created Successfully')),
          );
          cubit.resetCreateStatus();
          context.go(AppRoutes.home);
        } else if (state.createStatus == CreateStatus.failure) {
          messenger.showSnackBar(
            SnackBar(content: Text(state.errorMessage ?? 'Something went wrong')),
          );
          cubit.resetCreateStatus();
        }
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Create Savings')),
        body: SafeArea(
          child: BlocBuilder<ProductsCubit, ProductsState>(
            builder: (context, productsState) {
              switch (productsState.status) {
                case LoadStatus.initial:
                case LoadStatus.loading:
                  return const LoadingView();
                case LoadStatus.failure:
                  return ErrorState(
                    message: productsState.errorMessage ?? 'Could not load products.',
                    onRetry: () => context.read<ProductsCubit>().load(),
                  );
                case LoadStatus.success:
                  return _buildForm(productsState.products);
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _buildForm(List<SavingsProduct> products) {
    final selected = products.where((p) => p.id == _productId).firstOrNull;
    final digitsOnly = [FilteringTextInputFormatter.digitsOnly];

    return ResponsiveBody(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AppTextField(
                controller: _nameCtrl,
                label: 'Savings Name',
                hint: 'e.g. Rent 2027',
                icon: Icons.edit_outlined,
                textInputAction: TextInputAction.next,
                validator: (v) => Validators.required(v, 'Savings name'),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                initialValue: selected?.id,
                isExpanded: true,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                decoration: InputDecoration(
                  labelText: 'Product Type',
                  filled: true,
                  prefixIcon: const Icon(Icons.category_outlined),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                ),
                items: [
                  for (final p in products)
                    DropdownMenuItem(value: p.id, child: Text('${p.name} • ${p.interestLabel}')),
                ],
                validator: (v) => v == null ? 'Product type is required' : null,
                onChanged: (id) {
                  final product = products.firstWhere((p) => p.id == id);
                  setState(() {
                    _productId = id;
                    _applyProductDefaults(product);
                  });
                },
              ),
              const SizedBox(height: 16),
              AppTextField(
                controller: _targetCtrl,
                label: 'Target Amount (₦)',
                icon: Icons.flag_outlined,
                keyboardType: TextInputType.number,
                inputFormatters: digitsOnly,
                textInputAction: TextInputAction.next,
                validator: (v) => Validators.positiveNumber(v, 'Target amount'),
              ),
              const SizedBox(height: 16),
              AppTextField(
                controller: _monthlyCtrl,
                label: 'Monthly Contribution (₦)',
                icon: Icons.payments_outlined,
                helperText: selected == null
                    ? null
                    : 'Minimum deposit for ${selected.name}: ${Formatters.naira(selected.minimumDeposit)}',
                keyboardType: TextInputType.number,
                inputFormatters: digitsOnly,
                textInputAction: TextInputAction.next,
                validator: (v) => Validators.monthlyContribution(v, _targetCtrl.text),
              ),
              const SizedBox(height: 16),
              AppTextField(
                controller: _durationCtrl,
                label: 'Duration (months)',
                icon: Icons.calendar_month_outlined,
                keyboardType: TextInputType.number,
                inputFormatters: digitsOnly,
                textInputAction: TextInputAction.done,
                onSubmitted: (_) => _submit(products),
                validator: (v) => Validators.positiveNumber(v, 'Duration'),
              ),
              const SizedBox(height: 28),
              BlocBuilder<SavingsCubit, SavingsState>(
                buildWhen: (p, c) => p.createStatus != c.createStatus,
                builder: (context, state) => PrimaryButton(
                  label: 'Create',
                  isLoading: state.createStatus == CreateStatus.submitting,
                  onPressed: () => _submit(products),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
