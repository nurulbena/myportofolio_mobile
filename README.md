# myportofolio_mobile

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

### TUGAS 7 ###
1. widget tree adalah struktur hierarki berbentuk pohon yang merepresentasikan seluruh tampilan UI sebuah aplikasi. Setiap widget dapat memiliki widget lain sebagai anaknya. Widget parent mengatur tata letak atau perilaku widget child. Contohnya, Scaffold menjadi parent yang memiliki AppBar dan body sebagai child.
2. nama wideget :
- MaterialApp: Mengatur konfigurasi dasar aplikasi.
- Scaffold: Menyediakan struktur dasar halaman.
- AppBar: Menampilkan bagian atas aplikasi.
- Text: Menampilkan teks.
- Padding: Memberikan jarak di sekitar widget.
- Column: Menyusun widget secara vertikal.
- Row: Menyusun widget secara horizontal.
- Center: Menempatkan widget di tengah.
- Card: Menampilkan informasi dalam bentuk kartu.
- Container: Mengatur ukuran, padding, dan tampilan widget.
- SizedBox: Memberikan jarak antar-widget.
-GridView.count: Menampilkan kumpulan widget dalam bentuk grid.
- Material: Menentukan tampilan dan warna kartu.
- InkWell: Menambahkan interaksi ketika kartu ditekan.
- Icon: Menampilkan ikon.
- SnackBar: Menampilkan pesan sementara ketika tombol ditekan.
- MediaQuery: Mengambil informasi ukuran layar perangkat.
- Theme: Mengakses konfigurasi tema aplikasi.
3. MaterialApp berfungsi untuk mengatur konfigurasi utama aplikasi, seperti tema, navigasi, dan halaman awal. Widget ini digunakan sebagai root widget karena menyediakan dasar desain Material Design dan mengatur struktur aplikasi secara keseluruhan.
4. StatelessWidget adalah widget yang tampilannya tidak berubah berdasarkan perubahan state internal. Sementara itu, StatefulWidget adalah widget yang dapat berubah ketika state-nya diperbarui menggunakan setState(). StatelessWidget cocok untuk tampilan statis, sedangkan StatefulWidget digunakan untuk tampilan yang membutuhkan perubahan data atau interaksi dinamis.
5. BuildContext adalah informasi mengenai posisi sebuah widget di dalam widget tree. BuildContext penting karena digunakan untuk mengakses widget atau konfigurasi yang berada di atasnya, seperti Theme dan MediaQuery. Di dalam metode build, context digunakan untuk mengambil informasi tersebut sesuai kebutuhan tampilan aplikasi.
6. Hot reload adalah fitur untuk menerapkan perubahan kode ke aplikasi tanpa memulai ulang aplikasi dari awal, sehingga state yang sedang berjalan umumnya tetap dipertahankan. Hot restart memulai ulang aplikasi dari awal sehingga state kembali ke kondisi awal. Hot reload cocok untuk perubahan tampilan atau kode biasa, sedangkan hot restart diperlukan ketika perubahan memengaruhi state atau inisialisasi aplikasi. Full restart diperlukan jika perubahan melibatkan konfigurasi native atau perubahan yang tidak dapat diterapkan melalui hot reload maupun hot restart.

Dokumentasi & AI Disclosure
saya menggunakan Claude untuk memandu saya dengan strategi bertanya step by step
### TUGAS 7 ###
- menanyakan secara bertahap dan brainstorming jawaban pertanyaan reflektif
