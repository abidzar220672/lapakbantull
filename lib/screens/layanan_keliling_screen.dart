import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../theme/app_theme.dart';

class LayananKelilingScreen extends StatefulWidget {
  const LayananKelilingScreen({super.key});

  @override
  State<LayananKelilingScreen> createState() => _LayananKelilingScreenState();
}

class _LayananKelilingScreenState extends State<LayananKelilingScreen> {
  DateTime _selectedDate = DateTime(2024, 1, 21);

  final List<Map<String, dynamic>> _jadwal = [
    {
      'kendaraan': 'Mobil 01',
      'rute': 'Mangir ke B Mangkir, Sendangsari, Pandak',
      'jam': '08:00 - 14:00',
      'status': 'Aktif',
    },
    {
      'kendaraan': 'Mobil 02',
      'rute': 'Mangir ke B Mangkir, Sendangsari, Pandak',
      'jam': '08:00 - 14:00',
      'status': 'Aktif',
    },
  ];

  final List<DateTime> _availableDates = [
    DateTime(2024, 1, 21),
    DateTime(2024, 5, 31),
    DateTime(2024, 3, 9),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgLight,
      appBar: AppBar(
        title: const Text('Layanan Keliling'),
        backgroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Date selector
          _buildDateSelector(),

          // Jadwal list
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _jadwal.length,
              itemBuilder: (context, i) => _buildJadwalCard(_jadwal[i]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateSelector() {
    return Container(
      height: 56,
      color: Colors.white,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        itemCount: _availableDates.length,
        itemBuilder: (context, i) {
          final date = _availableDates[i];
          final isSelected = DateUtils.isSameDay(date, _selectedDate);
          final formatted = DateFormat('dd/MM/yyyy').format(date);

          return GestureDetector(
            onTap: () => setState(() => _selectedDate = date),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primaryDark : AppColors.grey100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                formatted,
                style: TextStyle(
                  color: isSelected ? Colors.white : AppColors.textSecondary,
                  fontSize: 13,
                  fontWeight:
                      isSelected ? FontWeight.w700 : FontWeight.w400,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildJadwalCard(Map<String, dynamic> item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.primaryDark,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.directions_bus,
                color: Colors.white, size: 26),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item['kendaraan'],
                  style: const TextStyle(
                    color: AppColors.primaryDark,
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  item['rute'],
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(Icons.access_time,
                        color: AppColors.grey400, size: 14),
                    const SizedBox(width: 4),
                    Text(
                      item['jam'],
                      style: const TextStyle(
                        color: AppColors.grey600,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.success.withOpacity(0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              item['status'],
              style: const TextStyle(
                color: AppColors.success,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
