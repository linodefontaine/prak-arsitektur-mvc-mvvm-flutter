# Laporan Praktikum Mandiri: Arsitektur Aplikasi (MVC & MVVM) dan Pengujian Flutter

## Identitas Mahasiswa
- **Nama:** Farrelino Putra Setiawan
- **NIM:** 362558302013
- **Kelas / Prodi:** 2E / Sarjana Terapan Teknologi Rekayasa Perangkat Lunak
- **Mata Kuliah:** Pemrograman Perangkat Bergerak
- **Institusi:** Politeknik Negeri Banyuwangi (2026)

---

## Cara Menjalankan Aplikasi & Pengujian

1. Pastikan Flutter SDK terpasang (modul diverifikasi pada Flutter 3.29.2)
2. Masuk ke folder proyek `prak_arsitektur_tugas` lalu jalankan:
   flutter pub get
   flutter run -d chrome
 
3. Jalankan analisis statis dan seluruh pengujian otomatis:

   flutter analyze
   flutter test

---

## Tabel Perbandingan Arsitektur (MVC vs MVVM)

| Pertanyaan | Implementasi MVC | Implementasi MVVM |
| :--- | :--- | :--- |
| **Ketika filter diketuk, class mana yang menerima aksi dan menyimpan pilihan?** | Aksi diteruskan dari `PanelTugas` melalui `_LayarMvcState` menuju class **`PengendaliTugas`** pada metode **`aturFilter(bool nilai)`**, lalu disimpan pada field `_filterBelumSelesai`. | Aksi diteruskan dari `PanelTugas` menuju class **`TugasViewModel`** pada metode **`aturFilter(bool nilai)`**, lalu disimpan pada field `_filterBelumSelesai`. |
| **Apa yang memicu rebuild? Apa akibatnya jika pemicu itu dihapus?** | **Pemicu:** Pemanggilan **`setState()`** di dalam `_LayarMvcState` saat aksi dijalankan.<br>**Akibat jika dihapus:** Nilai `_filterBelumSelesai` berubah di memori, tetapi UI tidak di-rebuild sehingga tampilan chip dan daftar tugas tetap tidak berubah dan pengujian gagal. | **Pemicu:** Pemanggilan **`notifyListeners()`** pada `TugasViewModel` yang ditangkap oleh **`ListenableBuilder`** pada `LayarMvvm`.<br>**Akibat jika dihapus:** State berubah di `TugasViewModel`, tetapi `ListenableBuilder` tidak memicu rebuild ulang sehingga UI tidak berubah dan pengujian gagal. |
| **Kapan Anda memilih masing-masing pola?** | **Skenario cocok:** Layar tunggal dengan interaksi sederhana.<br>**Kelebihan:** Alur aksi dan `setState()` mudah ditelusuri langsung di satu View.<br>**Biaya/Risiko:** Jika ada aksi baru yang lupa dipanggilkan `setState()`, data berubah tanpa memperbarui layar. | **Skenario cocok:** Layar dengan state turunan seperti daftar terfilter, ringkasan, dan pesan error yang perlu diuji secara terpusat.<br>**Kelebihan:** UI state terpusat di ViewModel, notifikasi dapat diuji tanpa UI, dan daftar terfilter serta data lengkap dapat dikelola jelas.<br>**Biaya/Risiko:** Perlu menghubungkan View ke instance ViewModel yang tepat serta mengelola siklus hidupnya (`dispose()`). |

---

## Hasil Percobaan Penghapusan Pemicu Rebuild

### 1. Percobaan pada MVC (`setState` dihapus sementara pada `_LayarMvcState._ubahFilter`)
- **Sebelum Dihapus:** Mengetuk `FilterChip` "Belum selesai" memicu `setState()`, sehingga chip terpilih dan tugas yang sudah selesai disembunyikan.
- **Saat Dihapus:** Nilai `_filterBelumSelesai` di `PengendaliTugas` berubah menjadi `true`, namun UI tidak diperbarui (chip tetap tidak aktif dan kedua tugas tetap terlihat).
- **Setelah Dipulihkan:** Setelah `setState()` dikembalikan, chip dan daftar terfilter kembali berjalan normal serta pengujian lulus.
- **Potongan Keluaran Terminal Saat Gagal (`flutter test test/filter_test.dart`):**

  ══╡ EXCEPTION CAUGHT BY FLUTTER TEST FRAMEWORK ╞════════════════════════════════════════════════════
  The following TestFailure was thrown running a test:
    Expected: no matching nodes in the widget tree
      Actual: _TextWidgetFinder:<Found "Rancang 1 Flutter")] Flutter": UI [Text("Rancang text widget with>
  

### 2. Percobaan pada MVVM (`notifyListeners()` dihapus sementara pada `TugasViewModel.aturFilter`)
- **Sebelum Dihapus:** Mengetuk `FilterChip` memanggil `notifyListeners()`, sehingga `ListenableBuilder` membangun ulang `PanelTugas` dengan daftar tugas yang belum selesai.
- **Saat Dihapus:** State `_filterBelumSelesai` di `TugasViewModel` berubah, namun `ListenableBuilder` tidak menerima sinyal notifikasi sehingga tampilan layar tidak berubah.
- **Setelah Dipulihkan:** Setelah `notifyListeners()` dikembalikan, pembaruan UI otomatis kembali berfungsi dan seluruh pengujian lulus.
- **Potongan Keluaran Terminal Saat Gagal (`flutter test test/filter_test.dart`):**

  ══╡ EXCEPTION CAUGHT BY FLUTTER TEST FRAMEWORK ╞════════════════════════════════════════════════════
  The following TestFailure was thrown running a test:
    Expected: no matching nodes in the widget tree
      Actual: _TextWidgetFinder:<Found "Rancang 1 Flutter")] Flutter": UI [Text("Rancang text widget with>


---

## Bukti Tangkapan Layar & Keluaran Terminal Akhir

### Bukti Tangkapan Layar (`bukti/`)
- `bukti/MVC/mvc_filter_mati.png` — Tampilan MVC saat filter mati (menampilkan 2 tugas yang sama, ringkasan `1 dari 2 selesai`)
- `bukti/MVC/mvc_filter_aktif.png` — Tampilan MVC saat filter aktif (hanya menampilkan 1 tugas belum selesai, ringkasan tetap `1 dari 2 selesai`)
- `bukti/MVVM/mvvm_filter_mati.png` — Tampilan MVVM saat filter mati (menampilkan 2 tugas yang sama, ringkasan `1 dari 2 selesai`)
- `bukti/MVVM/mvvm_filter_aktif.png` — Tampilan MVVM saat filter aktif (hanya menampilkan 1 tugas belum selesai, ringkasan tetap `1 dari 2 selesai`)
- `bukti/Flutter analyze & Test.png` — Tangkapan layar keluaran terminal `flutter analyze` dan `flutter test` setelah kode dipulihkan

### Keluaran Terminal Akhir (Setelah Kode Dipulihkan)

PS C:\Users\Galeri Laptop\Downloads\Starter-Praktikum-MVC-MVVM-Flutter\prak_arsitektur_tugas> flutter analyze
Analyzing prak_arsitektur_tugas...
No issues found! (ran in 2.0s)
PS C:\Users\Galeri Laptop\Downloads\Starter-Praktikum-MVC-MVVM-Flutter\prak_arsitektur_tugas> flutter test
00:04 +7: All tests passed!
