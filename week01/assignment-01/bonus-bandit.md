# OverTheWire — Bandit (Level 0 → 5)

Catatan command kunci untuk bonus Assignment 01 — Linux Fundamental.
Password setiap level **tidak dicatat** di file ini.

## Ketentuan Umum

- Server: `bandit.labs.overthewire.org`, port **2220** (bukan port SSH default 22).
- Setiap level adalah user berbeda, jadi home directory (`~`) berbeda tiap level.
- Password untuk level berikutnya selalu ditemukan setelah login.
- Saat login, password **tidak tampil** ketika diketik (normal).

---

## Bandit 0 → 1

Login pertama ke server Bandit, lalu baca petunjuk di home directory.

```bash
ssh bandit0@bandit.labs.overthewire.org -p 2220
ls -a
cat readme
```

**Konsep:** SSH memakai port non-default (`-p 2220`). File `readme` di home directory berisi petunjuk setiap level. `ls -a` dipakai agar file hidden ikut terlihat.

---

## Bandit 1 → 2

File bernama `-` bertabrakan dengan konvensi command line, karena `-` diartikan sebagai stdin.

```bash
ssh bandit1@bandit.labs.overthewire.org -p 2220
ls -a
cat ./-
```

**Konsep:** `cat -` akan menunggu input dari stdin, bukan membaca file. Dengan path eksplisit (`./-` atau `~/`), argumen dipastikan merujuk ke file. Alternatif lain: `cat -- -` untuk mengakhiri parsing option.

---

## Bandit 2 → 3

Nama file mengandung spasi, sehingga terpecah menjadi beberapa argumen oleh shell.

```bash
ssh bandit2@bandit.labs.overthewire.org -p 2220
ls -a
cat ./--spaces\ in\ this\ filename--
```

**Konsep:** shell memisahkan argumen berdasarkan whitespace. Backslash (`\ `) meng-escape spasi; alternatifnya memakai kutip tunggal, misalnya `cat './--spaces in this filename--'`. Tab completion juga otomatis menambahkan backslash.

---

## Bandit 3 → 4

File tersembunyi di dalam direktori `inhere`.

```bash
ssh bandit3@bandit.labs.overthewire.org -p 2220
ls -a
cd inhere/
ls -a
cat ./...Hiding-From-You
```

**Konsep:** nama berawalan titik bersifat *hidden*. `ls` biasa melewatkannya, sedangkan `ls -a` menampilkannya. Hidden hanya soal tampilan, bukan perlindungan keamanan.

---

## Bandit 4 → 5

Terdapat banyak file, dan hanya satu yang berisi teks yang bisa dibaca manusia.

```bash
ssh bandit4@bandit.labs.overthewire.org -p 2220
ls -a
cd inhere/
ls -a
file ./*
cat ./-file07
```

**Konsep:** tipe file ditentukan oleh isinya (*magic number*), bukan oleh nama/ekstensi. `file` menebak tipe tanpa perlu membuka isi penuh. Membaca file biner dengan `cat` bisa merusak tampilan terminal — pulihkan dengan `reset`.

---

## Bandit 5 → 6

Mencari satu file di dalam banyak subdirektori berdasarkan metadata.

```bash
ssh bandit5@bandit.labs.overthewire.org -p 2220
ls -a
cd inhere/
find . -type f -size 1033c ! -executable -readable
cat ./maybehere07/.file2
```

**Konsep:** `find` menelusuri direktori secara rekursif dan memfilter berdasarkan metadata. `-type f` = hanya file, `-size 1033c` = tepat 1033 byte (`c` = bytes), `!` = negasi, `-executable`/`-readable` = filter permission. Kondisi yang ditulis berderet dibaca sebagai logika AND.

---

## Ringkasan

| Level | Tantangan | Command kunci |
| ----- | --------- | ------------- |
| 0 → 1 | Login SSH pertama | `ssh ... -p 2220`, `cat readme` |
| 1 → 2 | Nama file `-` | `cat ./-` |
| 2 → 3 | Nama file berspasi | `cat ./--spaces\ in\ this\ filename--` |
| 3 → 4 | File hidden dalam direktori | `ls -a`, `cd inhere/` |
| 4 → 5 | Tipe file tidak terlihat dari nama | `file ./*` |
| 5 → 6 | Cari file di banyak subdirektori | `find . -size 1033c ! -executable` |

## Yang Dipelajari

- Akses remote lewat SSH dengan port non-default, sebagai gambaran cara mengakses cluster.
- Menangani nama file yang "aneh" (`-`, spasi, diawali titik) memakai path eksplisit, escape, dan kutip.
- Membedakan tiga cara mencari: `ls` (isi direktori), `file` (tipe isi), `find` (metadata secara rekursif).
- Membaca `readme`/petunjuk sebelum menebak, serta membaca pesan error sebagai petunjuk utama.
