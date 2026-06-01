import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../theme/app_theme.dart';

class PbbScreen extends StatefulWidget {
  const PbbScreen({super.key});

  @override
  State<PbbScreen> createState() => _PbbScreenState();
}

class _PbbScreenState extends State<PbbScreen> {
  final _nopController = TextEditingController();
  bool _isSearching = false;
  Map<String, dynamic>? _pbbResult;

  // Mock data
  final List<Map<String, dynamic>> _mockSppt = [
    {
      'nop': '34010741007840170001',
      'nama': 'AHMAD NABIL BAHROIN ROGER SUMATRA',
      'alamat': 'DS. Ngirinng-Ireng, RT01/RW01',
      'kelurahan': 'Ngirinng-Ireng Desa, Piyungan Kec, DS. Ngirinng-Ireng, RT01/RW01',
      'tahun': '2024',
      'sppt2024': {'status': 'Lunas', 'tagihan': 0},
      'sppt2020': {'status': 'Lunas', 'tagihan': 300000},
      'luas_bumi': 227,
      'luas_bgn': 0,
    }
  ];

  void _searchNop() async {
    if (_nopController.text.isEmpty) return;

    setState(() {
      _isSearching = true;
      _pbbResult = null;
    });

    await Future.delayed(const Duration(milliseconds: 800));

    final result = _mockSppt.firstWhere(
      (e) => e['nop'].contains(_nopController.text),
      orElse: () => {},
    );

    setState(() {
      _isSearching = false;
      _pbbResult = result.isEmpty ? null : result;
    });

    if (result.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Data NOP tidak ditemukan'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  @override
  void dispose() {
    _nopController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgLight,
      appBar: AppBar(
        title: const Text('PBB'),
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search NOP
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Cari Objek Pajak',
                    style: TextStyle(
                      color: AppColors.primaryDark,
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _nopController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            hintText: 'Masukkan NOP...',
                            hintStyle: const TextStyle(
                                color: AppColors.textHint, fontSize: 14),
                            prefixIcon: const Icon(Icons.search,
                                color: AppColors.grey400),
                            filled: true,
                            fillColor: AppColors.grey100,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 14),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      GestureDetector(
                        onTap: _searchNop,
                        child: Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: AppColors.primaryDark,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: _isSearching
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Icon(Icons.search,
                                  color: Colors.white, size: 22),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Result
            if (_pbbResult != null) ...[
              const SizedBox(height: 16),
              _buildResultCard(_pbbResult!),
            ],

            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  Widget _buildResultCard(Map<String, dynamic> data) {
    final formatter = NumberFormat.currency(
        locale: 'id', symbol: 'Rp ', decimalDigits: 0);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header NOP
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: AppColors.primaryDark,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(14),
                topRight: Radius.circular(14),
              ),
            ),
            child: Row(
              children: [
                const Icon(Icons.home, color: Colors.white, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'No. NOP: ${data['nop']}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data['nama'],
                  style: const TextStyle(
                    color: AppColors.primaryDark,
                    fontWeight: FontWeight.w800,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  data['kelurahan'],
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),

                const Divider(height: 24),

                // SPPT Tags
                _buildSpptRow(
                  tahun: 'SPPT 2024',
                  status: data['sppt2024']['status'],
                  tagihan: formatter.format(data['sppt2024']['tagihan']),
                ),
                const SizedBox(height: 8),
                _buildSpptRow(
                  tahun: 'SPPT 2020',
                  status: data['sppt2020']['status'],
                  tagihan: formatter.format(data['sppt2020']['tagihan']),
                ),

                const Divider(height: 24),

                // Info luas
                Row(
                  children: [
                    _buildInfoChip('Luas Bumi', '${data['luas_bumi']} m²'),
                    const SizedBox(width: 10),
                    _buildInfoChip('Luas Bgn', '${data['luas_bgn']} m²'),
                  ],
                ),

                const SizedBox(height: 16),

                // Bayar button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.payment, size: 18),
                    label: const Text('Bayar Sekarang'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryDark,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSpptRow({
    required String tahun,
    required String status,
    required String tagihan,
  }) {
    final isLunas = status == 'Lunas';
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.primaryDark.withOpacity(0.08),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            tahun,
            style: const TextStyle(
              color: AppColors.primaryDark,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            tagihan,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 13,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color:
                isLunas ? AppColors.success.withOpacity(0.1) : AppColors.error.withOpacity(0.1),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            status,
            style: TextStyle(
              color: isLunas ? AppColors.success : AppColors.error,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoChip(String label, String value) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.grey100,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label,
                style: const TextStyle(
                    color: AppColors.textSecondary, fontSize: 11)),
            Text(value,
                style: const TextStyle(
                    color: AppColors.primaryDark,
                    fontWeight: FontWeight.w700,
                    fontSize: 14)),
          ],
        ),
      ),
    );
  }
}
