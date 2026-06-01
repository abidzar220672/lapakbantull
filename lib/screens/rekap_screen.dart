import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../theme/app_theme.dart';

class RekapScreen extends StatefulWidget {
  const RekapScreen({super.key});

  @override
  State<RekapScreen> createState() => _RekapScreenState();
}

class _RekapScreenState extends State<RekapScreen> {
  String _selectedTahun = '2024';
  String _selectedFilter = 'Semua';

  final List<String> _tahunList = ['2024', '2023', '2022', '2021'];
  final List<String> _filterList = ['Semua', 'Lunas', 'Belum Lunas'];

  final List<Map<String, dynamic>> _rekapData = [
    {
      'nop': '34010741...0001',
      'nama': 'Ahmad Nabil Bahroin',
      'alamat': 'DS. Ngirinng-Ireng, Piyungan',
      'tahun': '2024',
      'tagihan': 350000,
      'status': 'Lunas',
      'tanggal': '12 Mar 2024',
    },
    {
      'nop': '34010741...0002',
      'nama': 'Siti Rahayu Widiastuti',
      'alamat': 'Jl. Bantul Raya No. 45, Bantul',
      'tahun': '2024',
      'tagihan': 480000,
      'status': 'Belum Lunas',
      'tanggal': '-',
    },
    {
      'nop': '34010741...0003',
      'nama': 'Budi Santoso Wibowo',
      'alamat': 'Dk. Karangasem, RT02/RW03, Sewon',
      'tahun': '2024',
      'tagihan': 210000,
      'status': 'Lunas',
      'tanggal': '05 Jan 2024',
    },
    {
      'nop': '34010741...0004',
      'nama': 'Dewi Kusuma Wardani',
      'alamat': 'Perum Griya Asri Blok B12, Banguntapan',
      'tahun': '2024',
      'tagihan': 720000,
      'status': 'Belum Lunas',
      'tanggal': '-',
    },
    {
      'nop': '34010741...0005',
      'nama': 'Hendra Prasetya Putra',
      'alamat': 'Jl. Parangtritis Km 7, Kretek',
      'tahun': '2024',
      'tagihan': 165000,
      'status': 'Lunas',
      'tanggal': '20 Feb 2024',
    },
    {
      'nop': '34010741...0001',
      'nama': 'Ahmad Nabil Bahroin',
      'alamat': 'DS. Ngirinng-Ireng, Piyungan',
      'tahun': '2023',
      'tagihan': 340000,
      'status': 'Lunas',
      'tanggal': '08 Apr 2023',
    },
    {
      'nop': '34010741...0002',
      'nama': 'Siti Rahayu Widiastuti',
      'alamat': 'Jl. Bantul Raya No. 45, Bantul',
      'tahun': '2023',
      'tagihan': 460000,
      'status': 'Lunas',
      'tanggal': '15 Jun 2023',
    },
  ];

  List<Map<String, dynamic>> get _filtered => _rekapData.where((item) {
        final matchTahun = item['tahun'] == _selectedTahun;
        final matchFilter =
            _selectedFilter == 'Semua' || item['status'] == _selectedFilter;
        return matchTahun && matchFilter;
      }).toList();

  int get _totalTagihan =>
      _filtered.fold(0, (s, i) => s + (i['tagihan'] as int));
  int get _jumlahLunas =>
      _filtered.where((e) => e['status'] == 'Lunas').length;
  int get _jumlahBelumLunas =>
      _filtered.where((e) => e['status'] == 'Belum Lunas').length;

  @override
  Widget build(BuildContext context) {
    final fmt =
        NumberFormat.currency(locale: 'id', symbol: 'Rp ', decimalDigits: 0);

    return Scaffold(
      backgroundColor: AppColors.bgLight,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Rekap Pajak',
          style: TextStyle(
            color: AppColors.primaryDark,
            fontSize: 18,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: Column(
        children: [
          // ── Summary card ──────────────────────────────
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF0D1B3E), Color(0xFF1A2F5A)],
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryDark.withOpacity(0.25),
                  blurRadius: 14,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Total Tagihan $_selectedTahun',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.65),
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  fmt.format(_totalTagihan),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    _summaryBadge(
                      label: 'Lunas',
                      value: '$_jumlahLunas objek',
                      color: AppColors.success,
                    ),
                    const SizedBox(width: 10),
                    _summaryBadge(
                      label: 'Belum Lunas',
                      value: '$_jumlahBelumLunas objek',
                      color: AppColors.error,
                    ),
                  ],
                ),
              ],
            ),
          ),

          // ── Filter bar ────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                // Tahun
                Expanded(
                  child: _dropdownBox(
                    value: _selectedTahun,
                    items: _tahunList,
                    onChanged: (v) => setState(() => _selectedTahun = v!),
                  ),
                ),
                const SizedBox(width: 10),
                // Status
                Expanded(
                  child: _dropdownBox(
                    value: _selectedFilter,
                    items: _filterList,
                    onChanged: (v) => setState(() => _selectedFilter = v!),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),

          // ── List ──────────────────────────────────────
          Expanded(
            child: _filtered.isEmpty
                ? _emptyState()
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 4, 16, 80),
                    itemCount: _filtered.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (_, i) => _itemCard(_filtered[i], fmt),
                  ),
          ),
        ],
      ),
    );
  }

  // ── Widgets kecil ─────────────────────────────────────

  Widget _summaryBadge({
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.09),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withOpacity(0.45)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 6),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: TextStyle(
                      color: color, fontSize: 10, fontWeight: FontWeight.w600)),
              Text(value,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w700)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _dropdownBox({
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down,
              color: AppColors.grey500, size: 18),
          style: const TextStyle(
            color: AppColors.primaryDark,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
          items: items
              .map((t) => DropdownMenuItem(value: t, child: Text(t)))
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _itemCard(Map<String, dynamic> item, NumberFormat fmt) {
    final isLunas = item['status'] == 'Lunas';

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(13),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon kiri
          Container(
            padding: const EdgeInsets.all(9),
            decoration: BoxDecoration(
              color: (isLunas ? AppColors.success : AppColors.error)
                  .withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              isLunas
                  ? Icons.check_circle_outline
                  : Icons.pending_outlined,
              color: isLunas ? AppColors.success : AppColors.error,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),

          // Konten tengah
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item['nama'],
                  style: const TextStyle(
                    color: AppColors.primaryDark,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  item['alamat'],
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 11,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  item['nop'],
                  style: const TextStyle(
                    color: AppColors.grey400,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 10),

          // Kanan: tagihan + badge
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                fmt.format(item['tagihan']),
                style: const TextStyle(
                  color: AppColors.primaryDark,
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 4),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: (isLunas ? AppColors.success : AppColors.error)
                      .withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  item['status'],
                  style: TextStyle(
                    color: isLunas ? AppColors.success : AppColors.error,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              if (isLunas) ...[
                const SizedBox(height: 4),
                Text(
                  item['tanggal'],
                  style: const TextStyle(
                    color: AppColors.grey400,
                    fontSize: 10,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _emptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.inbox_outlined, size: 52, color: AppColors.grey300),
          const SizedBox(height: 10),
          const Text(
            'Tidak ada data',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Coba ubah filter tahun atau status',
            style: TextStyle(color: AppColors.grey400, fontSize: 12),
          ),
        ],
      ),
    );
  }
}