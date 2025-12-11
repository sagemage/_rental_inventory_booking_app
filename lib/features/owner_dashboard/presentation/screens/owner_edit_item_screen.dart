import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OwnerEditItemScreen extends ConsumerStatefulWidget {
  final String id; // 'new' for new item
  const OwnerEditItemScreen({super.key, required this.id});

  @override
  ConsumerState<OwnerEditItemScreen> createState() => _OwnerEditItemScreenState();
}

class _OwnerEditItemScreenState extends ConsumerState<OwnerEditItemScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtl = TextEditingController();
  final _descCtl = TextEditingController();
  final _priceCtl = TextEditingController();
  final _qtyCtl = TextEditingController();

  @override
  void dispose() {
    _nameCtl.dispose();
    _descCtl.dispose();
    _priceCtl.dispose();
    _qtyCtl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isNew = widget.id == 'new';

    return Scaffold(
      appBar: AppBar(title: Text(isNew ? 'Add Item' : 'Edit Item', style: Theme.of(context).textTheme.headlineLarge)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(controller: _nameCtl, decoration: const InputDecoration(labelText: 'Name')),
              const SizedBox(height: 8),
              TextFormField(controller: _descCtl, decoration: const InputDecoration(labelText: 'Description'), maxLines: 3),
              const SizedBox(height: 8),
              TextFormField(controller: _priceCtl, decoration: const InputDecoration(labelText: 'Price per day'), keyboardType: TextInputType.number),
              const SizedBox(height: 8),
              TextFormField(controller: _qtyCtl, decoration: const InputDecoration(labelText: 'Total stock'), keyboardType: TextInputType.number),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Save not implemented')));
                  }
                },
                child: const Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}