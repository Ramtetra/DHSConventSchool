import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/fee_model.dart';
import '../../utils/fee_card.dart';
import '../../utils/summary_card.dart';

class AdminFeeReportScreen extends ConsumerStatefulWidget {
  const AdminFeeReportScreen({super.key});

  @override
  ConsumerState<AdminFeeReportScreen> createState() =>
      _AdminFeeReportScreenState();
}

class _AdminFeeReportScreenState
    extends ConsumerState<AdminFeeReportScreen> {

  final TextEditingController _searchController = TextEditingController();

  String selectedStatus = 'All';
  String selectedClass = 'All';

  final List<String> statusFilters = ['All', 'Paid', 'Pending', 'Overdue'];
  final List<String> classFilters = [
    'All',
    'Class 6',
    'Class 7',
    'Class 8',
    'Class 9',
    'Class 10',
  ];

  /// Mock Data (Replace with API)
  final List<FeeModel> allFees = [
    FeeModel(
      id: '1',
      studentName: 'Aarav Sharma',
      className: 'Class 8',
      feeType: 'Tuition',
      amount: 2500,
      dueDate: DateTime(2026, 2, 10),
      status: FeeStatus.pending,
    ),
    FeeModel(
      id: '2',
      studentName: 'Neha Verma',
      className: 'Class 7',
      feeType: 'Transport',
      amount: 1200,
      dueDate: DateTime(2026, 1, 25),
      status: FeeStatus.paid,
    ),
    FeeModel(
      id: '3',
      studentName: 'Rohit Kumar',
      className: 'Class 9',
      feeType: 'Exam Fee',
      amount: 800,
      dueDate: DateTime(2026),
      status: FeeStatus.overdue,
    ),
  ];

  List<FeeModel> get filteredFees {
    return allFees.where((f) {
      final matchStatus =
          selectedStatus == 'All' ||
              f.status.name.toLowerCase() == selectedStatus.toLowerCase();

      final matchClass =
          selectedClass == 'All' || f.className == selectedClass;

      final matchSearch = f.studentName
          .toLowerCase()
          .contains(_searchController.text.toLowerCase());

      return matchStatus && matchClass && matchSearch;
    }).toList();
  }

  double get totalCollected => allFees
      .where((f) => f.status == FeeStatus.paid)
      .fold(0, (sum, f) => sum + f.amount);

  double get totalPending => allFees
      .where((f) => f.status != FeeStatus.paid)
      .fold(0, (sum, f) => sum + f.amount);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fee Report'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.download),
            tooltip: 'Export',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Export coming soon')),
              );
            },
          ),
        ],
      ),

      body: Column(
        children: [
      SingleChildScrollView(
      child: Column(children: [
          /// 📊 KPI Summary
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: SummaryCard(
                    title: 'Collected',
                    value: '₹${totalCollected.toStringAsFixed(0)}',
                    color: Colors.green,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: SummaryCard(
                    title: 'Pending',
                    value: '₹${totalPending.toStringAsFixed(0)}',
                    color: Colors.orange,
                  ),
                ),
              ],
            ),
          ),
    ],),),
          /// 🔍 Search
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              controller: _searchController,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                hintText: 'Search student...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ),

          const SizedBox(height: 12),

          /// 🏷 Filters
          _buildFilterSection(),

          const SizedBox(height: 8),

          /// 💳 Fee List
          Expanded(
            child: filteredFees.isEmpty
                ? const Center(child: Text('No fee records found'))
                : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: filteredFees.length,
              separatorBuilder: (_, __) =>
              const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final fee = filteredFees[index];
                return FeeCard(fee: fee);
              },
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildFilterSection() {
    return Column(
      children: [
        /// Status Filters
        SizedBox(
          height: 44,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            scrollDirection: Axis.horizontal,
            itemCount: statusFilters.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final status = statusFilters[index];
              final isSelected = selectedStatus == status;

              return ChoiceChip(
                label: Text(status),
                selected: isSelected,
                onSelected: (_) {
                  setState(() => selectedStatus = status);
                },
              );
            },
          ),
        ),

        const SizedBox(height: 8),

        /// Class Filters
        SizedBox(
          height: 44,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            scrollDirection: Axis.horizontal,
            itemCount: classFilters.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final cls = classFilters[index];
              final isSelected = selectedClass == cls;

              return ChoiceChip(
                label: Text(cls),
                selected: isSelected,
                onSelected: (_) {
                  setState(() => selectedClass = cls);
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
