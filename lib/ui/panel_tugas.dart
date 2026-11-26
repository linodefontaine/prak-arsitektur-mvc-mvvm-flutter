import 'package:flutter/material.dart';
import '../model/tugas.dart';

class PanelTugas extends StatefulWidget {
  const PanelTugas({
    super.key,
    required this.judul,
    required this.daftar,
    required this.totalTugas,
    required this.jumlahSelesai,
    required this.filterBelumSelesai,
    required this.onFilterChanged,
    required this.galat,
    required this.onTambah,
    required this.onUbahStatus,
  });

  final String judul;
  final List<Tugas> daftar;
  final int totalTugas;
  final int jumlahSelesai;
  final bool filterBelumSelesai;
  final ValueChanged<bool> onFilterChanged;
  final String? galat;
  final bool Function(String) onTambah;
  final void Function(int) onUbahStatus;

  @override
  State<PanelTugas> createState() => _PanelTugasState();
}

class _PanelTugasState extends State<PanelTugas> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _kirim() {
    if (widget.onTambah(_controller.text)) {
      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final String pesanKosong = widget.totalTugas == 0
        ? 'Belum ada tugas.'
        : 'Tidak ada tugas yang belum selesai.';

    return Scaffold(
      appBar: AppBar(title: Text(widget.judul)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              key: const ValueKey('judul-tugas'),
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Judul tugas',
                hintText: 'Contoh: Rancang UI Flutter',
                errorText: widget.galat,
                border: const OutlineInputBorder(),
              ),
              onSubmitted: (_) => _kirim(),
            ),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: _kirim,
              child: const Text('Tambah tugas'),
            ),
            const SizedBox(height: 16),
            Text(
              '${widget.jumlahSelesai} dari ${widget.totalTugas} selesai',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerLeft,
              child: FilterChip(
                key: const ValueKey('filter-belum-selesai'),
                label: const Text('Belum selesai'),
                selected: widget.filterBelumSelesai,
                onSelected: widget.onFilterChanged,
              ),
            ),
            const Divider(height: 24),
            Expanded(
              child: widget.daftar.isEmpty
                  ? Text(pesanKosong)
                  : ListView.builder(
                      itemCount: widget.daftar.length,
                      itemBuilder: (context, index) {
                        final tugas = widget.daftar[index];
                        return CheckboxListTile(
                          value: tugas.selesai,
                          title: Text(tugas.judul),
                          controlAffinity: ListTileControlAffinity.leading,
                          onChanged: (_) => widget.onUbahStatus(tugas.id),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}