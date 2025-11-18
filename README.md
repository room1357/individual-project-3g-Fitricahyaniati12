# pemrograman_mobile

A new Flutter project.

Biodata :

name : Fitri Cahyaniati

Class : SIB3G

NIM : 2341760198

Expense Tracker Manager adalah aplikasi seluler yang dibangun menggunakan Flutter untuk membantu pengguna mencatat, mengelola, dan menganalisis pengeluaran berdasarkan kategori. Selain itu, aplikasi ini menyertakan fitur integrasi REST API (menggunakan Posts API dari JSONPlaceholder) sebagai demonstrasi kemampuan komunikasi data client-server.
---

## 🚀 Fitur Utama

| Fitur                        | Deskripsi                                                                         |
| ---------------------------- | --------------------------------------------------------------------------------- |
| 🧾 **Manajemen Pengeluaran** | Melakukan operasi CRUD (Tambah, Ubah, Hapus, Lihat) pada semua transaksi pengeluaran pengguna.|
| 📊 **Statistik Pengeluaran** | Menyajikan visualisasi data (grafik) pengeluaran, dikelompokkan berdasarkan kategori dan rentang waktu.|
| 🏷️ **Manajemen Kategori**    | Memungkinkan pengelolaan (membuat, mengubah, menghapus) kategori agar data pengeluaran lebih terorganisir.|
| 👤 **Profil Pengguna**       | Menampilkan data pengguna yang sedang login.                                      |
| ⚙️ **Pengaturan Aplikasi**   | Mengatur preferensi aplikasi seperti bahasa dan notifikasi.                       |
| ☁️ **Posts (API)**           | Fitur tambahan untuk latihan REST API (GET, POST, DELETE) dengan JSONPlaceholder. |
| 🔐 **Autentikasi Login**     | Sistem dasar untuk masuk dan keluar (login/logout) dengan penyimpanan sesi menggunakan SharedPreferences.|

---

## 🧩 Teknologi yang Digunakan

- **Flutter 3.35.4**
- **Dart 3.9.2**
- **DevTools 2.48.0**
- **HTTP package** — komunikasi REST API
- **Shared Preferences** — penyimpanan lokal sesi pengguna
- **Material Design 3** — komponen UI
- **JSONPlaceholder API** — API dummy untuk testing CRUD

---

## ⚙️ Cara Menjalankan Aplikasi

1️⃣ **Clone Repository**

```bash
git https://github.com/room1357/individual-project-3g-Fitricahyaniati12.git
cd individual-project-3g-Fitricahyaniati12
```

2️⃣ **Install Dependencies**

```bash
flutter pub get
```

3️⃣ **Jalankan di Emulator atau Device**

```bash
flutter run
```


## 📂 Struktur Folder Utama

```plaintext
lib
│   main.dart                       # Entry point utama aplikasi
│   rest_client.dart                # Client HTTP dasar (tidak digunakan langsung)
│
├───client
│       rest_client.dart            # Implementasi REST client untuk konsumsi API JSONPlaceholder
│
├───models
│       category.dart               # Model data kategori pengeluaran
│       expense.dart                # Model data pengeluaran
│       post.dart                   # Model data postingan (API)
│       user.dart                   # Model data pengguna
│
├───screens
│       about_screen.dart               # Halaman tentang aplikasi
│       add_expense_screen.dart         # Form tambah pengeluaran baru
│       advanced_expense_list_screen.dart  # Daftar pengeluaran lengkap (fitur utama)
│       category_screen.dart            # Manajemen kategori pengeluaran
│       edit_expense_screen.dart        # Form edit pengeluaran
│       edit_profile_screen.dart        # Form edit profil pengguna
│       expense_list_screen.dart        # Tampilan daftar pengeluaran sederhana
│       home_screen.dart                # Halaman utama (menu cepat & ringkasan)
│       login_screen.dart               # Halaman login pengguna
│       posts_screen.dart               # Halaman demonstrasi API eksternal (CRUD Post)
│       profile_screen.dart             # Halaman profil pengguna
│       register_screen.dart            # Halaman pendaftaran pengguna
│       settings_screen.dart            # Halaman pengaturan aplikasi
│       statistics_screen.dart          # Halaman statistik & grafik pengeluaran
│
├───services
│       auth_service.dart               # Layanan autentikasi (login/logout)
│       expense_manager.dart            # Logika tambahan untuk pengelolaan pengeluaran
│       expense_service.dart            # CRUD data pengeluaran (local + shared preferences)
│       looping_examples.dart           # Contoh fungsi looping (latihan/eksperimen)
│       post_service.dart               # CRUD data posts via REST API
│
├───utils
│       currency_utils.dart             # Utilitas format mata uang (Rp)
│       date_utils.dart                 # Utilitas format dan manipulasi tanggal
│
└───widgets
        expense_card.dart               # Widget tampilan kartu pengeluaran
```
---

##  Penjelasan Setiap Halaman

| File                                  | Deskripsi Singkat                                                                                                         |
| ------------------------------------- | ------------------------------------------------------------------------------------------------------------------------- |
| **home_screen.dart**                  | Tampilan utama aplikasi. Menampilkan sapaan pengguna, ringkasan cepat, dan menu navigasi ke fitur lain.                   |
| **login_screen.dart**                 | Halaman untuk login pengguna dengan validasi input.                                                                       |
| **register_screen.dart**              | Form pendaftaran pengguna baru.                                                                                           |
| **advanced_expense_list_screen.dart** | Daftar pengeluaran lengkap dengan opsi tambah, edit, dan hapus.                                                           |
| **add_expense_screen.dart**           | Form untuk menambahkan pengeluaran baru.                                                                                  |
| **edit_expense_screen.dart**          | Form untuk memperbarui pengeluaran yang sudah ada.                                                                        |
| **statistics_screen.dart**            | Menampilkan grafik dan ringkasan statistik pengeluaran bulanan.                                                           |
| **category_screen.dart**              | Mengelola daftar kategori pengeluaran.                                                                                    |
| **profile_screen.dart**               | Menampilkan profil pengguna dan tombol edit profil.                                                                       |
| **edit_profile_screen.dart**          | Form untuk mengubah nama/email pengguna.                                                                                  |
| **settings_screen.dart**              | Pengaturan aplikasi seperti notifikasi, bahasa, versi, dan tautan ke halaman _About_.                                     |
| **about_screen.dart**                 | Informasi singkat tentang aplikasi dan pengembang.                                                                        |
| **posts_screen.dart**                 | Menampilkan daftar posting dari API eksternal (_JSONPlaceholder_). Dapat menambah, menghapus, dan memuat ulang postingan. |
| **expense_list_screen.dart**          | Tampilan daftar pengeluaran sederhana, versi dasar dari _Advanced Expense List_.                                          |


---
## 🖼️ Screenshot & Deskripsi Setiap Halaman

---
### 🧠 About Screen

Menampilkan informasi tentang aplikasi, tujuan pembuatannya, serta identitas pengembang.  
Biasanya berisi versi aplikasi dan deskripsi singkat proyek.  
![Image](https://github.com/user-attachments/assets/e0a625aa-a965-495c-bc19-b8e0d7fc0ad7)

### ⚙️ Settings Screen

Halaman pengaturan aplikasi seperti tema, bahasa, notifikasi, dan informasi versi.

- 🔘 **Tentang Aplikasi:** Menuju halaman _About_.
- 🔘 **Notifikasi:** Mengaktifkan atau menonaktifkan notifikasi.
<img width="497" height="693" alt="Image" src="https://github.com/user-attachments/assets/7e6b19d9-516d-4d0f-9bd6-a575bd62986a" />

### 🔐 Login Screen

Halaman untuk masuk ke aplikasi menggunakan email dan password.
- 🔘 **Login:** Memverifikasi dan masuk ke aplikasi.
- 🔘 **Daftar:** Arahkan ke halaman Register.   

<img width="497" height="691" alt="Image" src="https://github.com/user-attachments/assets/d3b06dec-3b52-4167-ac07-6d1f04d9f114" />

### 📝 Register Screen

Form pendaftaran untuk pengguna baru.
- 🔘 **Daftar:** Membuat akun baru.
- 🔘 **Login:** Kembali ke halaman login.  
<img width="502" height="696" alt="Image" src="https://github.com/user-attachments/assets/9eb38cd4-ab9c-43d8-945a-7e5f87044638" />

### 💼 Advanced Expense List Screen

Menampilkan daftar pengeluaran lengkap dengan fitur **cari, tambah, edit, dan hapus**.

- ➕ **Tambah:** Membuka form tambah pengeluaran.
- ✏️ **Edit:** Mengubah detail pengeluaran tertentu.
- 🗑️ **Hapus:** Menghapus pengeluaran dari daftar.
- 🔁 **Refresh:** Memuat ulang daftar pengeluaran.
- 
  <img width="496" height="694" alt="Image" src="https://github.com/user-attachments/assets/583925b5-c4f0-410b-bac8-f5232c8efcfb" />

### 💼 Pengeluaran bersama 

Menampilkan daftar pengeluaran bersama dengan beberapa orang 

- ➕ **Tambah:** Membuka form tambah pengeluaran.
<img width="380" height="705" alt="Image" src="https://github.com/user-attachments/assets/f82912dd-5c35-44ce-b325-4df9b2a74f2e" />

### 🗂️ Category Screen

Mengelola kategori pengeluaran yang dapat digunakan saat input data.
- ➕ **Tambah Kategori:** Menambahkan kategori baru.
- 🗑️ **Hapus Kategori:** Menghapus kategori yang tidak digunakan.
  
  <img width="500" height="696" alt="Image" src="https://github.com/user-attachments/assets/17e4e291-e664-42ea-99a4-606c41797213" />

### 👤 Edit Profile Screen

Formulir untuk memperbarui profil pengguna seperti nama, email, dan foto profil.
- 🔘 **Simpan:** Menyimpan perubahan profil.
- 🔘 **Batal:** Membatalkan perubahan.
- 
<img width="379" height="710" alt="Image" src="https://github.com/user-attachments/assets/f9e9255f-7350-4ca4-9c76-f76ee18a2d5c" />


### 🏠 Home Screen

Halaman utama setelah login. Menampilkan sapaan pengguna, total pengeluaran, dan menu cepat ke fitur lain.

- 🏷️ **Menu Grid:** Navigasi cepat ke Statistik, Kategori, Profil, Pengaturan, dan Posts.
- 🔘 **Logout:** Keluar dari aplikasi.
  
  <img width="499" height="694" alt="Image" src="https://github.com/user-attachments/assets/26b25a4e-46b2-4dc7-8c2b-efdadcedf139" />
  <img width="500" height="689" alt="Image" src="https://github.com/user-attachments/assets/dfe9060f-6a56-48f7-9672-4208f3b5e7ad" />

### 📊 Statistics Screen

Menampilkan grafik dan ringkasan statistik pengeluaran pengguna.  
Bisa difilter berdasarkan harian, mingguan, bulanan, atau kategori.

- 🔘 **Filter:** Menyaring data berdasarkan waktu atau kategori.
- 🔁 **Refresh:** Memperbarui data statistik.
  
  <img width="502" height="702" alt="Image" src="https://github.com/user-attachments/assets/5866f487-f8cf-4f35-bbb8-f9cf1a37da12" />

### ☁️ Posts Screen

Menampilkan daftar postingan dari API eksternal (`jsonplaceholder.typicode.com`).

- ➕ **Tambah:** Membuat posting baru ke API.
- 🗑️ **Hapus:** Menghapus posting yang dipilih.
- 🔁 **Refresh:** Memuat ulang daftar posting.
  
  <img width="561" height="400" alt="Image" src="https://github.com/user-attachments/assets/7a47e893-3141-4ec9-8779-8892cb427d13" />
  <img width="493" height="692" alt="Image" src="https://github.com/user-attachments/assets/00d283e9-9471-423e-a988-29b52c6cfcfb" />

  ## 🧑‍💻 Pengembang

| **Atribut**                     | **Keterangan**                                                                                                                                                      |
| ------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| 👤 **Nama**                     | **Fitri cahyaniati**                                                                                                                                             |
| 💼 **Project**                  | _Individual Project — Expense Tracker Manager_                                                                                                                      |
| 📘 **Mata Kuliah**              | **Pemrograman Mobile (Flutter)**                                                                                                                                    |
| 🧭 **Deskripsi Singkat**        | Aplikasi untuk mencatat, mengelola, dan menganalisis pengeluaran pengguna berdasarkan kategori dan rentang waktu tertentu (harian, mingguan, bulanan, atau custom). |
| 🧠 **Teknologi yang Digunakan** | Flutter, Dart, HTTP Client, REST API (JSONPlaceholder), dan stateful widgets dengan UI modern berbasis gradient.                                                    |
| 📅 **Tahun Pengerjaan**         | **2025**                                                                                                                                                            |
  
## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
