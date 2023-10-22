const Map<String, dynamic> LABEL = {
  "id": "ID",
  "role": "Role",
  "nama": "Nama",
  "nohp": "No HP",
  "harga": "Harga",
  "jenis": "Jenis",
  "stok": "Stok",
  "catatan": "Catatan",
  "persentase": "Persentase",
  "tahap": "Tahap",
  "statusPembayaran": "Status Pembayaran",
  "tanggalPesan": "Tanggal Pesan",
  "tanggalSelesai": "Tanggal Selesai",
  "perkiraanSelesai": "Perkiraan Selesai",
  "deskripsi":"Deskripsi",
  "dpharga":"DP",
  "alamat": "Alamat",
  
  "pekerja": "Pekerja",
  "pembeli": "Pembeli",
  "admin": "Admin",

  "status": "Status",
  "selesai": "Selesai",
  "wip": "Dalam Pengerjaan",
  "belumSelesai": "Belum Selesai",
  "lunas": "Lunas",
  "belumLunas": "Belum Lunas",
  "dp": "DP",

  "pengukuran":"Pengukuran",
  "pemotongan":"Pemotongan",
  "perakitan":"Perakitan",
  "pemasangan":"Pemasangan",
};

String equalError(value) => "Nilai bidang ini harus sama dengan $value.";
String maxError(max) => "Nilai harus kurang dari atau sama dengan $max";
String maxLength(maxLength) =>
      "Panjang karakter harus kurang dari atau sama dengan $maxLength";
String minError(min) =>
      "Nilai harus lebih besar dari atau sama dengan $min.";
String minLengthError(minLength) =>
      "Panjang karakter harus lebih besar dari atau sama dengan $minLength";
String notEqualError(value) =>
      "Nilai bidang ini tidak boleh sama dengan $value.";
String creditCardError() => "Nomor kartu kredit tidak valid.";
String dateStringError() => "Tanggal tidak valid.";
String emailError() => "Alamat email tidak valid.";
String integerError() => "Nilai harus berupa bilangan bulat.";
String ipError() => "Alamat IP tidak valid.";
String matchError() => "Nilai tidak cocok dengan pola.";
String numericError() => "Nilai harus berupa angka.";
String requiredError() => "Wajib diisi.";
String urlError() => "URL tidak valid";
String phoneNumberError() => "Nomor HP tidak valid";

