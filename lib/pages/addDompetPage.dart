import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dompetku/models/dompet.dart';
import 'package:dompetku/providers/dompet_provider.dart';

class AddDompetPage extends ConsumerStatefulWidget {
  const AddDompetPage({super.key});

  @override
  ConsumerState<AddDompetPage> createState() => _AddDompetPageState();
}

class _AddDompetPageState extends ConsumerState<AddDompetPage> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  
  String selectedCategory = 'Makan';
  TransactionType _selectedType = TransactionType.expense;

  IconData _getIconForCategory(String category) {
    switch (category) {
      case 'Makan':
        return Icons.restaurant;
      case 'Transport':
        return Icons.two_wheeler;
      case 'Kuliah':
        return Icons.school;
      default:
        return Icons.more_horiz;
    }
  }

  Color _getColorForCategory(String category) {
    switch (category) {
      case 'Makan':
        return Colors.orange;
      case 'Transport':
        return Colors.blue;
      case 'Kuliah':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  void _saveTransaction() {
    final amountText = _amountController.text;
    final titleText = _titleController.text.isEmpty
        ? selectedCategory
        : _titleController.text;

    if (amountText.isEmpty) return;

    final double? amount = double.tryParse(amountText);
    if (amount == null || amount <= 0) return;

    final now = DateTime.now();
    final timeStr = '${now.hour.toString().padLeft(2, '0')}.${now.minute.toString().padLeft(2, '0')}';

    final newTransaction = TransactionModel(
      title: titleText,
      amount: amount,
      time: timeStr,
      icon: _getIconForCategory(selectedCategory),
      iconColor: _getColorForCategory(selectedCategory),
      type: _selectedType,
    );

    ref.read(dompetProvider.notifier).addTransaction(newTransaction);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Tambah Transaksi',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Pilihan Tipe Transaksi (Pemasukan / Pengeluaran)
            Row(
              children: [
                Expanded(
                  child: ChoiceChip(
                    label: const Center(child: Text('Pengeluaran')),
                    selected: _selectedType == TransactionType.expense,
                    selectedColor: Colors.red.shade100,
                    onSelected: (selected) {
                      if (selected) {
                        setState(() {
                          _selectedType = TransactionType.expense;
                        });
                      }
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ChoiceChip(
                    label: const Center(child: Text('Pemasukan')),
                    selected: _selectedType == TransactionType.income,
                    selectedColor: Colors.green.shade100,
                    onSelected: (selected) {
                      if (selected) {
                        setState(() {
                          _selectedType = TransactionType.income;
                        });
                      }
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            const Text(
              'Nominal',
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
            const SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                const Text(
                  'Rp ',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Expanded(
                  child: TextField(
                    controller: _amountController,
                    keyboardType: TextInputType.number,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                    decoration: const InputDecoration(
                      hintText: '0',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ),
              ],
            ),
            const Divider(thickness: 1.5),

            const SizedBox(height: 24),

            const Text(
              'Kategori',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                _buildCategoryChip('Makan', Icons.restaurant),
                _buildCategoryChip('Transport', Icons.two_wheeler),
                _buildCategoryChip('Kuliah', Icons.school),
                _buildCategoryChip('Lainnya', Icons.more_horiz),
              ],
            ),

            const SizedBox(height: 24),

            Container(
              height: 120,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextField(
                controller: _titleController,
                maxLines: null,
                decoration: const InputDecoration(
                  hintText: 'Catatan / Keterangan',
                  hintStyle: TextStyle(color: Colors.grey),
                  border: InputBorder.none,
                ),
              ),
            ),

            const Spacer(),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: Colors.grey.shade300),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                onPressed: _saveTransaction,
                child: const Text(
                  'Simpan',
                  style: TextStyle(
                    color: Color(0xFF3F4EAD),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryChip(String label, IconData icon) {
    final bool isSelected = selectedCategory == label;
    return ChoiceChip(
      showCheckmark: false,
      avatar: Icon(
        icon,
        size: 18,
        color: isSelected ? const Color(0xFF3F4EAD) : Colors.grey,
      ),
      label: Text(label),
      selected: isSelected,
      selectedColor: const Color(0xFFEEF0FF),
      backgroundColor: Colors.white,
      labelStyle: TextStyle(
        color: isSelected ? const Color(0xFF3F4EAD) : Colors.black87,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(
          color: isSelected ? const Color(0xFF3F4EAD) : Colors.grey.shade300,
        ),
      ),
      onSelected: (bool selected) {
        setState(() {
          selectedCategory = label;
        });
      },
    );
  }
}