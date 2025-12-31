# Buttons of Logic

Sebuah aplikasi Android sederhana yang mendemonstrasikan manajemen state dan logika interaktif menggunakan Flutter.

## Deskripsi Aplikasi

"Buttons of Logic" adalah aplikasi yang menampilkan sebuah bilangan bulat yang dapat dimanipulasi melalui tiga tombol:
- **Tambah (+1)**: Menambah nilai dengan 1
- **Kurang (-1)**: Mengurangi nilai dengan 1
- **Reset**: Mengatur ulang nilai ke 0 dan menghapus semua riwayat

### Fitur Utama

1. **Nilai Awal**: Dimulai dari 0
2. **Tampilan Status Bilangan**: Menampilkan nilai counter saat ini dalam ukuran besar
3. **Zero Counter**: Menampilkan berapa kali nilai sudah menyentuh 0
4. **Riwayat Perubahan**: Menyimpan dan menampilkan perubahan nilai dalam urutan terbaru
5. **Logika Khusus - Triple Zero Condition**: 
   - Menghitung **setiap kali nilai menyentuh 0**
   - zeroCounter **tidak akan pernah direset** kecuali tombol Reset ditekan
   - Ketika zeroCounter mencapai **3 kali**, tombol Tambah dan Kurang akan otomatis dinonaktifkan
   - Dialog akan muncul dengan pesan: "Angka 0 dah nyentuh 3 kali!"
   - Menekan Reset akan mengatur ulang semua state (counter, penghitung, riwayat, dan mengaktifkan kembali tombol)

## Arsitektur Teknis

- **Framework**: Flutter (Dart)
- **State Management**: StatefulWidget dengan setState
- **Storage**: Semua state disimpan di memori (tidak menggunakan backend atau penyimpanan eksternal)
- **Platform Target**: Android (x86_64 Architecture untuk Emulator)

## Struktur State

```dart
int counter = 0;              // Nilai bilangan bulat saat ini
int zeroCounter = 0;          // Penghitung berapa kali counter menyentuh 0
bool isDisabled = false;      // Status disabled untuk tombol Tambah/Kurang
List<int> history = [];       // Riwayat perubahan nilai
```

## Alur Logika Detail

### Saat Tambah atau Kurang Ditekan:

1. **Update nilai counter**: `counter++` atau `counter--`
2. **Panggil `_afterAction()`** untuk proses setelah action:
   - Tambahkan nilai counter ke riwayat (maksimal 5 item)
   - **Cek apakah `counter == 0`**:
     - **Jika YA**: `zeroCounter++` (increment penghitung tanpa ada kondisi untuk reset)
     - **Jika TIDAK**: `zeroCounter` tidak berubah (tetap)
   - **Cek apakah `zeroCounter == 3`**:
     - **Jika YA**: Set `isDisabled = true` dan tampilkan dialog

### Saat Reset Ditekan:

1. **Reset counter ke 0**
2. **Reset `zeroCounter` ke 0`** (penghitung kembali ke awal)
3. **Reset `isDisabled` ke false`** (tombol Tambah dan Kurang aktif kembali)
4. **Kosongkan riwayat**

## Contoh Skenario Penggunaan

### Skenario: Mencapai Triple Zero

```
Start: counter=0, zeroCounter=0

1. Tekan Tambah    → counter=1,  zeroCounter=0 (bukan 0, tidak increment)
2. Tekan Kurang    → counter=0,  zeroCounter=1 ✓ (sentuh 0 - increment)
3. Tekan Kurang    → counter=-1, zeroCounter=1 (bukan 0, tetap 1)
4. Tekan Tambah    → counter=0,  zeroCounter=2 ✓ (sentuh 0 - increment)
5. Tekan Kurang    → counter=-1, zeroCounter=2 (bukan 0, tetap 2)
6. Tekan Tambah    → counter=0,  zeroCounter=3 ✓ (sentuh 0 - increment)
   → DISABLE! Dialog muncul: "Angka 0 dah nyentuh 3 kali!"
   → Tombol Tambah dan Kurang tidak bisa ditekan sampai Reset

7. Tekan Reset     → counter=0, zeroCounter=0, isDisabled=false
   → Semua state direset, siap dimulai lagi!
```

### Karakteristik Logika:

- **Setiap sentuhan 0** → selalu increment `zeroCounter`
- **Tidak ada reset** kecuali tombol Reset ditekan
- **Perjalanan ke 0** bisa dari nilai positif atau negatif
- **Setelah zeroCounter mencapai 3 kali** → semua button "terkunci/disabled" sampai Reset

## Build dan Instalasi

### Prerequisites

- Flutter SDK (versi ^3.9.0)
- Android SDK dan NDK
- Java Development Kit (JDK)

### Build APK

```bash
# Navigate ke project directory
cd test

# Clean build lama (untuk menghapus cache)
flutter clean

# Get dependencies
flutter pub get

# Build APK release
flutter build apk --release
```

APK akan dihasilkan di:
```
build/app/outputs/flutter-apk/app-release.apk
```

### Instalasi ke Android Device/Emulator

```bash
# Pastikan emulator berjalan atau device terhubung
flutter devices

# Install APK
flutter install

# Atau langsung jalankan aplikasi
flutter run --release
```

## Informasi File

- **Executable APK**: `build/app/outputs/flutter-apk/app-release.apk` (41.5 MB)
- **Main Code**: `lib/main.dart`
- **Pubspec**: `pubspec.yaml`
- **README**: `README.md` (file ini)

## Kompatibilitas

- **Minimum SDK**: Android 5.0 (API 21)
- **Target SDK**: Android sesuai konfigurasi Flutter
- **Arsitektur CPU**: x86_64 (untuk emulator), armv8 (untuk device ARM 64-bit)

## Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.8
```

## User Interface

- **Display Area**: 
  - Nilai counter ditampilkan besar (60pt, bold)
  - Penghitung zero sentiment ditampilkan dengan warna orange (18pt)
- **Control Buttons**: Tiga tombol (Kurang, Reset, Tambah)
  - Tombol Kurang dan Tambah: akan disabled secara visual ketika `isDisabled = true`
  - Tombol Reset: selalu aktif
- **History Box**: Container dengan border yang menampilkan list riwayat
- **Status Message**: Pesan merah jelas saat tombol disabled ("Tombol dinonaktifkan, tekan Reset")

## Logika Pemrograman - Penjelasan Kode

### Fungsi `tambah()` dan `kurang()`

```dart
void tambah() {
  if (isDisabled) return;  // Jika disabled, tidak lakukan apa-apa
  
  setState(() {
    counter++;             // Increment value
    _afterAction();        // Proses setelah action
  });
}

void kurang() {
  if (isDisabled) return;  // Jika disabled, tidak lakukan apa-apa
  
  setState(() {
    counter--;             // Decrement value
    _afterAction();        // Proses setelah action
  });
}
```

### Fungsi `_afterAction()`

```dart
void _afterAction() {
  // Tambah ke riwayat
  history.insert(0, counter);
  if (history.length > 5) {
    history.removeLast();
  }

  // Cek apakah menyentuh 0
  if (counter == 0) {
    zeroCounter++;        // Selalu increment jika sentuh 0
  }

  // Cek apakah sudah 3 kali
  if (zeroCounter == 3) {
    isDisabled = true;    // Disable tombol
    _showDialog();        // Tampilkan dialog
  }
}
```

### Fungsi `reset()`

```dart
void reset() {
  setState(() {
    counter = 0;          // Reset nilai ke 0
    zeroCounter = 0;      // Reset penghitung ke 0
    isDisabled = false;   // Aktifkan tombol kembali
    history.clear();      // Kosongkan riwayat
  });
}
```

### Fungsi `_showDialog()`

```dart
void _showDialog() {
  showDialog(
    context: context,
    barrierDismissible: false,  // User harus klik OK, tidak bisa klik di luar dialog
    builder: (_) {
      return AlertDialog(
        title: const Text('Alert!'),
        content: const Text('Angka 0 dah nyentuh 3 kali!'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      );
    },
  );
}
```

## Catatan Pengembangan

- State disimpan sepenuhnya di memori aplikasi
- Tidak ada penyimpanan data persisten antar session
- UI diperbarui secara real-time menggunakan `setState()`
- Dialog non-dismissible untuk memastikan user membaca pesan
- Riwayat hanya menyimpan maksimal 5 nilai terakhir
- Tidak menggunakan package eksternal untuk state management (hanya built-in Flutter)

## Changelog

### Version 1.0.0 (31 December 2025)
- ✅ Initial release
- ✅ Implementasi logic counter dengan 3 button (Tambah, Kurang, Reset)
- ✅ Riwayat perubahan nilai
- ✅ Zero Counter yang tidak direset kecuali Reset ditekan
- ✅ Triple zero condition dengan disable tombol dan dialog
- ✅ APK build untuk Android x86_64

## Lisensi

Bagian dari Studi Kasus II: "Buttons of Logic"

---

**Build Date**: 31 December 2025
**Flutter Version**: ^3.9.0
**Platform**: Android (x86_64 Emulator, ARM64 Device)
**Logic Version**: Triple Zero (Simple Counter - No Auto Reset)