# SA TodoListApp

Aplikasi **SA TodoListApp** adalah aplikasi to-do list yang memudahkan pengguna dalam mencatat, menyelesaikan, dan mengarsipkan aktivitas harian mereka.

---

## ✨ Fitur Aplikasi

Fitur-fitur utama yang tersedia dalam aplikasi ini:

- 🔐 **Autentikasi Pengguna**  
  Pengguna dapat melakukan:
  - Register
  - Login
  - Logout

- 🚀 **Halaman Get Started**  
  Tampil saat pertama kali aplikasi dibuka untuk memperkenalkan aplikasi.

- ✅ **CRUD Todo List**  
  - Menambahkan, mengedit, dan menghapus aktivitas.
  - Checklist kegiatan yang telah selesai.
  - Arsipkan kegiatan yang ingin disimpan sebagai riwayat.

---

## 🛠️ Langkah Install dan Build

1. Buka terminal pada root proyek.
2. Jalankan perintah berikut untuk build aplikasi: flutter build apk
3. Setelah build selesai, akan muncul output "√ Built build\app\outputs\flutter-apk\app-release.apk" yang menandakan file APK berhasil dibuat dan tersimpan pada path tersebut.
4. Bagikan file APK (misalnya melalui WhatsApp) untuk menginstall aplikasi di HP.
5. Setelah terinstall, jalankan aplikasi di perangkat HP Anda.

---

## 💻 Teknologi yang Digunakan

- 🔧 **Supabase**  
Digunakan untuk proses autentikasi user dan penyimpanan data to-do list.

- 🐝 **Hive**  
Digunakan untuk menyimpan status apakah halaman get started sudah pernah dibuka.

- 📦 **SharedPreferences**  
Menyimpan sesi login pengguna agar tetap login saat aplikasi dibuka kembali.

---

## 🧪 Dummy User untuk Uji Coba Login

Gunakan akun berikut untuk mencoba login ke dalam aplikasi:

- **Email:** `test@gmail.com`  
- **Password:** `testuasambw123`

---
