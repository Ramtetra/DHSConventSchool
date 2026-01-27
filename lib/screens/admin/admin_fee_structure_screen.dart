import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../utils/add_fee_sheet.dart';
import '../../utils/fee_items_tile.dart';
import '../../utils/fee_summary_card.dart';

class AdminFeeStructureScreen extends ConsumerStatefulWidget {
  const AdminFeeStructureScreen({super.key});

  @override
  ConsumerState<AdminFeeStructureScreen> createState() =>
      _AdminFeeStructureScreenState();
}

class _AdminFeeStructureScreenState
    extends ConsumerState<AdminFeeStructureScreen> {
  String selectedClass = "Class 8 A";

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Fee Structure"),
      ),

      // ➕ ADD FEE BUTTON
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.add),
        label: const Text("Add Fee"),
        onPressed: _openAddFeeBottomSheet,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // 🔍 FILTER
            DropdownButtonFormField<String>(
              value: selectedClass,
              decoration: const InputDecoration(
                labelText: "Select Class",
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(
                    value: "Class 8 A", child: Text("Class 8 A")),
                DropdownMenuItem(
                    value: "Class 9 B", child: Text("Class 9 B")),
                DropdownMenuItem(
                    value: "Class 10 C", child: Text("Class 10 C")),
              ],
              onChanged: (value) {
                setState(() => selectedClass = value!);
              },
            ),

            const SizedBox(height: 24),

            // 📊 SUMMARY
            Row(
              children: const [
                FeeSummaryCard(
                  title: "Total Fee",
                  value: "₹42,000",
                  color: Colors.blue,
                ),
                FeeSummaryCard(
                  title: "Paid",
                  value: "₹30,500",
                  color: Colors.green,
                ),
                FeeSummaryCard(
                  title: "Pending",
                  value: "₹11,500",
                  color: Colors.red,
                ),
              ],
            ),

            const SizedBox(height: 24),

            // 📋 FEE HEADS
            Text(
              "Fee Breakdown",
              style: theme.textTheme.titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            const FeeItemTile(
              title: "Tuition Fee",
              amount: "₹25,000",
              frequency: "Yearly",
            ),
            const FeeItemTile(
              title: "Transport Fee",
              amount: "₹10,000",
              frequency: "Yearly",
            ),
            const FeeItemTile(
              title: "Exam Fee",
              amount: "₹5,000",
              frequency: "Yearly",
            ),
            const FeeItemTile(
              title: "Library Fee",
              amount: "₹2,000",
              frequency: "Yearly",
            ),
          ],
        ),
      ),
    );
  }

  // ➕ ADD FEE BOTTOM SHEET
  void _openAddFeeBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => const AddFeeSheet(),
    );
  }
}
