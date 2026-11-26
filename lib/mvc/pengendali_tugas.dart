import '../data/repositori_tugas.dart';
import '../model/tugas.dart';

class PengendaliTugas {
  PengendaliTugas(this._repo);

  final RepositoriTugas _repo;
  String? _galat;
  bool _filterBelumSelesai = false;

  List<Tugas> get daftar {
    if (_filterBelumSelesai) {
      return _repo.daftar.where((tugas) => !tugas.selesai).toList();
    }
    return _repo.daftar;
  }

  int get totalTugas => _repo.daftar.length;
  String? get galat => _galat;
  bool get filterBelumSelesai => _filterBelumSelesai;
  int get jumlahSelesai => _repo.daftar.where((tugas) => tugas.selesai).length;

  bool tambah(String input) {
    _galat = validasiJudul(input);
    if (_galat != null) return false;
    _repo.tambah(input.trim());
    return true;
  }

  void ubahStatus(int id) => _repo.ubahStatus(id);

  void aturFilter(bool nilai) {
    _filterBelumSelesai = nilai;
  }
}