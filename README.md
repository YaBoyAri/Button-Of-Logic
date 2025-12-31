# Buttons of Logic

Sebuah aplikasi Android sederhana yang mendemonstrasikan manajemen state dan logika interaktif menggunakan Flutter.

## Deskripsi Aplikasi

"Buttons of Logic" adalah aplikasi yang menampilkan sebuah bilangan bulat yang dapat dimanipulasi melalui tiga tombol:
- **Tambah (+1)**: Menambah nilai dengan 1
- **Kurang (-1)**: Mengurangi nilai dengan 1
- **Reset**: Mengatur ulang nilai ke 0 dan menghapus semua riwayat

### Fitur Utama

1. **Nilai Awal**: Dimulai dari 0
2. **Tampilan Status Bilangan**: Menampilkan apakah nilai saat ini adalah ganjil atau genap
3. **Riwayat Perubahan**: Menyimpan dan menampilkan 5 perubahan nilai terakhir dalam urutan terbaru ke terlama
4. **Logika Khusus - Triple Zero Condition**: 
   - Menghitung setiap **aksi tombol yang menghasilkan nilai 0**
   - Ketika nilai mencapai 0 sebanyak **3 kali berturut-turut** (tanpa aksi yang menghasilkan nilai non-zero di antaranya)
   - Tombol Tambah dan Kurang akan otomatis dinonaktifkan
   - Dialog akan muncul dengan pesan: "Nilai 0 tercapai 3 kali berturut-turut"
   - Menekan Reset akan mengatur ulang penghitung kejadian nol dan memperbarui nilai serta riwayat

## Arsitektur Teknis

- **Framework**: Flutter (Dart)
- **State Management**: StatefulWidget dengan setState
- **Storage**: Semua state disimpan di memori (tidak menggunakan backend atau penyimpanan eksternal)
- **Platform Target**: Android (x86_64 Architecture untuk Emulator)

## Struktur State

```dart
int counter = 0;                 // Nilai bilangan bulat saat ini
int zeroActionCount = 0;         // Penghitung aksi yang menghasilkan nilai 0 berturut-turut
bool isDisabled = false;         // Status disabled untuk tombol Tambah/Kurang
List<int> history = [];          // Riwayat 5 perubahan nilai terakhir
```

## Alur Logika Detail

### Saat Tambah atau Kurang Ditekan:

1. **Update nilai counter**: `counter++` atau `counter--`
2. **Update riwayat**: Tambahkan nilai baru ke awal list (maksimal 5 item)
3. **Cek hasil aksi**:
   - **Jika `counter == 0`**: `zeroActionCount++` (increment penghitung)
   - **Jika `counter != 0`**: `zeroActionCount = 0` (reset penghitung karena putus)
4. **Cek kondisi disable**:
   - **Jika `zeroActionCount == 3`**: Disable tombol dan tampilkan dialog

### Saat Reset Ditekan:

1. **Reset counter ke 0**
2. **Reset `zeroActionCount` ke 0`** (penghitung aksi nol direset)
3. **Reset `isDisabled` ke false`** (tombol kembali aktif)
4. **Kosongkan riwayat**
5. **Debug message**: Print pesan ke console untuk tracking

## Contoh Skenario Penggunaan

### Skenario 1: Tidak Mencapai Triple Zero

```
Start: counter=0, zeroActionCount=0

1. Tekan Tambah    → counter=1,  zeroActionCount=0 (bukan 0, reset)
2. Tekan Kurang    → counter=0,  zeroActionCount=1 ✓ (aksi 1 menghasilkan 0)
3. Tekan Tambah    → counter=1,  zeroActionCount=0 (bukan 0, reset - PUTUS)
4. Tekan Kurang    → counter=0,  zeroActionCount=1 ✓ (aksi 1 mulai lagi)
5. Tekan Kurang    → counter=-1, zeroActionCount=0 (bukan 0, reset - PUTUS)

Hasil: Tidak pernah mencapai 3 berturut-turut ✗
```

### Skenario 2: Cara Mencapai Triple Zero

Untuk mencapai kondisi `zeroActionCount == 3`, **nilai harus menjadi 0 sebanyak 3 kali berturut-turut tanpa ada aksi yang menghasilkan nilai non-zero di antaranya**.

Contoh yang BERHASIL trigger disable:
```
Misal start dari counter=2:

1. Tekan Kurang    → counter=1,  zeroActionCount=0
2. Tekan Kurang    → counter=0,  zeroActionCount=1 ✓ (aksi 1)
3. Tekan Kurang    → counter=-1, zeroActionCount=0 (bukan 0, reset)

TIDAK BISA dengan urutan ini. Perlu urutan yang menghasilkan 0 setiap aksi.
```

Skenario yang MUNGKIN:
```
Jika counter sudah di posisi yang "strategis":

1. Dari counter=1, Tekan Kurang → counter=0, zeroActionCount=1
2. Dari counter=-1, Tekan Tambah → counter=0, zeroActionCount=2
3. Dari counter=-1, Tekan Tambah → counter=0, zeroActionCount=3 → DISABLE! 🔒
```

## Build dan Instalasi

### Prerequisites

- Flutter SDK (versi ^3.9.0)
- Android SDK dan NDK
- Java Development Kit (JDK)

### Build APK

```bash
# Navigate ke project directory
cd test

# Clean build lama (PENTING untuk menghapus cache state)
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

# Atau langsung jalankan aplikasi (TANPA hot reload)
flutter run --release
```

### ⚠️ PENTING: Cara Test yang Benar

**JANGAN gunakan hot reload** (`r` di terminal) karena state aplikasi akan tetap tertinggal. Gunakan:

- **Full Restart** (`R` di terminal) - untuk mereset state aplikasi
- **flutter run --release** - untuk test yang fresh
- **Rebuild APK dan reinstall** - untuk test yang paling akurat

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

## Testing dan Debugging

### Debug Output

Aplikasi menampilkan debug messages di console saat melakukan aksi:

```
DEBUG: Tambah - counter = 0, zeroActionCount = 1
DEBUG: Kurang - counter = -1, zeroActionCount = 0
DEBUG: Reset - semua state direset
```

Untuk melihat debug output, jalankan:

```bash
flutter run --release -v
```

Atau gunakan emulator dan lihat di Logcat Android Studio.

### Widget Tests

Untuk menjalankan widget tests:

```bash
flutter test
```

## User Interface

- **Display Area**: Menampilkan nilai counter besar (60pt), status ganjil/genap (24pt), dan penghitung aksi zero (18pt)
- **Control Buttons**: Tiga tombol dengan disabled state visual (tombol tampak faded saat disabled)
- **History Box**: Container dengan border yang menampilkan list riwayat
- **Status Message**: Pesan merah jelas saat tombol disabled

## Logika Pemrograman - Penjelasan Kode

### Fungsi `tambah()` dan `kurang()`

```dart
void tambah() {
  if (isDisabled) return;  // Jika disabled, tidak lakukan apa-apa
  
  setState(() {
    counter++;              // Increment value
    history.insert(0, counter);  // Tambah ke riwayat
    
    // Cek hasil aksi
    if (counter == 0) {
      zeroActionCount++;    // Increment karena hasilnya 0
      print('DEBUG: Tambah - counter = $counter, zeroActionCount = $zeroActionCount');
    } else {
      zeroActionCount = 0;  // Reset karena hasilnya bukan 0
      print('DEBUG: Tambah - counter = $counter, zeroActionCount direset ke 0');
    }
    
    // Jika sudah 3 kali berturut-turut
    if (zeroActionCount == 3) {
      isDisabled = true;
      _showZeroDialog();
    }
  });
}
```

### Fungsi `reset()`

```dart
void reset() {
  setState(() {
    counter = 0;            // Reset nilai
    zeroActionCount = 0;    // Reset penghitung aksi nol
    isDisabled = false;     // Aktifkan kembali tombol
    history.clear();        // Kosongkan riwayat
    print('DEBUG: Reset - semua state direset');
  });
}
```

### Fungsi `getStatus()`

```dart
String getStatus() {
  return counter % 2 == 0 ? 'Genap' : 'Ganjil';
}
```

Mengembalikan string 'Genap' jika counter habis dibagi 2, 'Ganjil' sebaliknya.

## Catatan Pengembangan

- State disimpan sepenuhnya di memori aplikasi
- Tidak ada penyimpanan data persisten antar session
- UI diperbarui secara real-time menggunakan `setState()`
- Dialog non-dismissible untuk memastikan user membaca pesan kondisi triple zero
- Debug prints tersedia untuk tracking di console
- Tidak menggunakan package eksternal untuk state management (hanya built-in Flutter)

## Changelog

### Version 1.0.0 (31 December 2025)
- ✅ Initial release
- ✅ Implementasi logic counter dengan 3 button (Tambah, Kurang, Reset)
- ✅ Riwayat 5 perubahan terakhir
- ✅ Triple zero condition dengan disable tombol dan dialog
- ✅ Tampilan ganjil/genap
- ✅ Debug logging
- ✅ APK build untuk Android x86_64

## Lisensi

Bagian dari Studi Kasus II: "Buttons of Logic"

---

**Build Date**: 31 December 2025
**Flutter Version**: ^3.9.0
**Platform**: Android (x86_64 Emulator, ARM64 Device)