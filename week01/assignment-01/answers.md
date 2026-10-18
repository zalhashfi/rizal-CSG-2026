# Assignment 01 — Linux Fundamental

- **Nama:** zalhashfi
- **Hostname:** LAPTOP-LE1SNB19
- **Tanggal:** 2026-10-13

---

## Task 1 — Environment Setup & System Information

### 1. Distro dan versi apa yang Anda gunakan?

| Item | Nilai |
|---|---|
| Distro | Ubuntu |
| Versi | 22.04.5 LTS |
| Codename | Jammy Jellyfish (jammy) |
| Version ID | 22.04 |

**Kesimpulan:** Saya menggunakan distro **Ubuntu 22.04.5 LTS** dengan codename **Jammy Jellyfish**.

### 2. Versi kernel berapa yang berjalan?

| Item | Nilai |
|---|---|
| Versi Kernel | 6.6.87.2 |
| Varian | microsoft-standard-WSL2 |
| Arsitektur | x86_64 |
| Build | #1 SMP PREEMPT_DYNAMIC Thu Jun 5 18:30:46 UTC 2025 |

**Kesimpulan:** Kernel yang berjalan adalah **6.6.87.2-microsoft-standard-WSL2** (kernel khusus WSL2, arsitektur x86_64).

### 3. Shell default apa yang Anda pakai?

| Item | Nilai |
|---|---|
| Path Shell | /bin/bash |
| Nama Shell | Bash (Bourne Again Shell) |
| Home Directory | /home/zalhashfi |

**Kesimpulan:** Shell default yang saya pakai adalah **/bin/bash (Bash)**.

---

## Task 2 — Filesystem Exploration

### 1. Apa isi file /etc/hostname? Apakah sama dengan output hostname?

| Perintah | Output |
|---|---|
| `cat /etc/hostname` | LAPTOP-LE1SNB19 |
| `hostname` | LAPTOP-LE1SNB19 |

**Kesimpulan:** Isi dari file `/etc/hostname` adalah nama device yang sedang kita gunakan saat ini (pc/laptop). Isinya **sama** dengan saat kita menuliskan perintah `hostname` secara langsung.

### 2. Sebutkan 5 direktori di / beserta fungsinya masing-masing (dengan kata-kata Anda sendiri).

| Direktori | Fungsi | Bukti |
|---|---|---|
| `/bin` | Binary/program dasar (ls, cat, cp) | `ls /bin \| head` |
| `/etc` | File konfigurasi sistem | `ls /etc \| head` |
| `/home` | Home directory tiap user | `ls /home` |
| `/var` | Data yang berubah (log, cache) | `ls /var` |
| `/usr` | Program & library untuk user | `ls /usr` |

### 3. Berapa jumlah file/direktori (termasuk hidden) di home directory Anda? (Hint: ls -A | wc -l)

| Item | Nilai |
|---|---|
| Total entri (`ls -A \| wc -l`) | **21** |
| Jumlah file (`-type f`) | 9 |
| Jumlah symlink (`.aws` & `.azure`) | 2 |
| Jumlah direktori asli (bukan home) | 10 |
| Jumlah direktori (`-type d`) | 11 = 10 subdir + `~` sendiri |

**Perintah:**
```bash
cd ~
ls -A | wc -l
find ~ -maxdepth 1 -type f | wc -l   # jumlah file
find ~ -maxdepth 1 -type d | wc -l   # jumlah direktori
```

**Kesimpulan:** `ls -A | wc -l` menghasilkan **21** entri (tanpa `.` dan `..`). Angka ini konsisten dengan rinciannya: **9 file** + **10 direktori asli** + **2 symlink** (`.aws` & `.azure`, symlink dari Windows ke WSL) = **21**. Perlu diperhatikan `find ~ -maxdepth 1 -type d | wc -l` menghasilkan **11**, bukan 10, karena `find` **ikut menghitung direktori home (`~`) itu sendiri** (11 = 10 subdir + 1 home). Karena `.aws` & `.azure` berupa symlink, keduanya tidak terhitung oleh `find -type f` maupun `find -type d`, sehingga totalnya tetap 9 + 10 + 2 = 21.

### 4. Di mana lokasi program ls dan python3 pada filesystem? Apakah cd juga berupa program? (Hint: which, type)

| Perintah | Hasil |
|---|---|
| `which ls` | `/usr/bin/ls` |
| `which python3` | `/usr/bin/python3` |
| `type cd` | cd is a shell builtin |

**Kesimpulan:** lokasi `ls` & `python3` berada di dalam subdir `/usr/bin/`. Hal ini menandakan `ls` & `python3` merupakan program eksternal (file `executable` di disk). Berbeda dengan `cd`: `cd` adalah **shell builtin** (perintah internal shell), sehingga **tidak punya file `executable` tersendiri di disk** dan tidak muncul di `which`. Itulah sebabnya `type cd` menjawab `cd is a shell builtin` — `cd` dijalankan langsung oleh shell (bash), bukan program terpisah.

### 5. Apa yang terjadi ketika Anda menjalankan cd tanpa argumen? Dan cd -?

| Perintah | Efek | `pwd` hasil |
|---|---|---|
| `cd` | Ke home directory (`$HOME`) | `/home/zalhashfi` |
| `cd -` | Ke direktori sebelumnya (`$OLDPWD`) | `/home/zalhashfi/comics-sg/week01/assignment-01` |

**Perintah:**
```bash
pwd      # posisi awal
cd       # tanpa argumen
pwd      # cek hasil
cd -     # kembali ke direktori sebelumnya
pwd
echo $OLDPWD
```

**Kesimpulan:** `cd` tanpa argumen akan membuat kita berpindah ke home directory user (`~/`). Lalu `cd -` akan mengembalikan kita ke directory terakhir sebelum kita berpindah ke directory saat ini. Sebelum menggunakan `cd -`, kita dapat memastikan directory sebelumnya dengan menuliskan `echo $OLDPWD`.

### 6. Apa fungsi option -h pada ls -lh dan -p pada mkdir -p? Tuliskan bagian dari man yang menjelaskannya.

**`-h` pada `ls -lh`:**

| Item | Isi |
|---|---|
| Fungsi | mengubah tulisan yang awalnya dalam bentuk binary menjadi readable oleh manusia dengan lebih singkat |
| Kutipan `man ls` | -h, --human-readable. with -l and -s, print sizes like 1K 234M 2G etc. |
| Bukti (`ls -l` vs `ls -lh`) | `4096` vs `4.0K` |

**`-p` pada `mkdir -p`:**

| Item | Isi |
|---|---|
| Fungsi | membuat sebuah directory, apabila sudah ada maka tidak akan error, kalau belum ada maka akan membuat directory induknya |
| Kutipan `man mkdir` | -p, --parents. no error if existing, make parent directories as needed |
| Bukti (`mkdir a/b/c` vs `mkdir -p a/b/c`) | error vs berhasil |

**Kesimpulan:** Dengan menambahkan -h pada ls (hanya berfungsi dengan -l dan -s) maka keluaran dari fungsi tersebut akan lebih mudah dibaca oleh manusia. Sedangkan -p pada mkdir, akan menghasilkan sebuah directory induk. Akan tetapi, kalau directory tersebut sejak awal sudah ada maka tidak akan terjadi error

---

## Task 3 — Membangun Struktur Direktori Project

### Command yang digunakan (berurutan)

| No | Command | Fungsi |
|---|---|---|
| 1 | `mkdir -p cluster-project/... && touch ...` | Membuat seluruh direktori dan file |
| 2 | `echo "..." > ~/cluster-project/README.md` | Mengisi README.md |
| 3 | `cp .../sample_01.csv .../sample_01_clean.csv` | Copy + rename |
| 4 | `mv .../sample_03.csv .../results/` | Move sample_03 |
| 5 | `rmdir ~/cluster-project/logs` | Hapus direktori logs (kosong) |
| 6 | `cd ... && (tree 2>/dev/null \|\| ls -R) > ~/.../structure.txt` | Simpan struktur akhir |

> **Catatan efisiensi:** command di atas ditulis apa adanya sesuai eksekusi (6 langkah). Secara minimum struktur ini bisa dibuat dalam **5 command**, misalnya langkah `rmdir ~/cluster-project/logs` digabung dengan langkah simpan struktur memakai `&&`. Path `~/comics-sg/...` pada langkah 6 adalah lokasi repo saat assignment ini dikerjakan (kini berada di `rizal-CSG-2026/`).

Berikut command lengkapnya per langkah:

**1. Pembuatan direktori dan file**

```bash
cd ~
mkdir -p cluster-project/{data/raw,data/processed,scripts,results,logs} && touch cluster-project/README.md cluster-project/data/raw/sample_{01..03}.csv cluster-project/scripts/run.sh
```

**2. Isi README.md**

```bash
echo "Cluster project by Rizal Khairul Hashfi" > ~/cluster-project/README.md
```

**3. Copy + rename**

```bash
cp ~/cluster-project/data/raw/sample_01.csv ~/cluster-project/data/processed/sample_01_clean.csv
```

**4. Move sample_03.csv**

```bash
mv ~/cluster-project/data/raw/sample_03.csv ~/cluster-project/results/
```

**5. Hapus direktori logs/ (pastikan kosong)**

```bash
rmdir ~/cluster-project/logs
```

**6. Simpan struktur akhir**

```bash
cd ~/cluster-project && (tree 2>/dev/null || ls -R) > ~/comics-sg/week01/assignment-01/structure.txt
```

### Struktur akhir

```text
.
├── README.md
├── data
│   ├── processed
│   │   └── sample_01_clean.csv
│   └── raw
│       ├── sample_01.csv
│       └── sample_02.csv
├── results
│   └── sample_03.csv
└── scripts
    └── run.sh

5 directories, 6 files
```

---

## Task 4 — File Permission Challenge

### 1. Tampilkan permission `scripts/run.sh` dengan `ls -l`
```bash
ls -l scripts/run.sh
```

**Output:**

```
-rw-r--r-- 1 zalhashfi zalhashfi 0 Oct 13 13:13 scripts/run.sh
```

**Penjelasan:**

```
-  rw-  r--  r--
│  │    │    └─ others (o) [read]
│  │    └────── group (g) [read]
│  └─────────── owner/user (u) [read + write]
└────────────── tipe file: - file
```

### 2. Isi `run.sh` lalu jalankan. Jelaskan kenapa error

```bash
echo '#!/bin/bash' > scripts/run.sh
echo 'echo "Job started on $(hostname) at $(date)"' >> scripts/run.sh
./scripts/run.sh
```

**Error:**

```
-bash: ./scripts/run.sh: Permission denied
```

**Penjelasan:**
file belum punya bit execute (`x`) untuk owner. Permission `644` = `rw-r--r--`, tidak ada `x` sama sekali. Menjalankan `./scripts/run.sh` butuh izin execute.

### 3. Ubah permission: hanya owner bisa read/write/execute

Notasi **oktal** dan **simbolik**:

```bash
chmod 700 scripts/run.sh           # oktal
chmod u=rwx,go= scripts/run.sh     # simbolik
```

### 4. Jalankan kembali script dan tempelkan output-nya

```bash
./scripts/run.sh
```

**Output:**

```
Job started on LAPTOP-LE1SNB19 at Wed Oct 14 18:05:46 WIB 2026
```

### 5. Konversi permission

| Simbolik    | Oktal |
| ----------- | ----- |
| `rw-r--r--` | `644` |
| `rwxr-x---` | `750` |
| `rw-r--r--` | `644` |
| `rwx------` | `700` |
| `rwxrwxr-x` | `775` |

### 6. Direktori `secret/` tanpa permission `x` untuk owner

```bash
mkdir secret
chmod u-x secret
cd secret     # gagal
ls secret     # berhasil
chmod u+x secret   # kembalikan permission
```

**Penjelasan:**
Pada direktori, arti dari `r`/`w`/`x` berbeda dari file.

| Bit | Arti pada direktori |
|---|---|
| `r` | bisa melihat daftar nama isi direktori (menggunakan `ls`) |
| `w` | bisa membuat/menghapus entri di dalamnya |
| `x` | bisa masuk ke direktori (`cd`) dan mengakses isinya |

Ketika `x` owner dihapus (misal jadi `r--` atau `rw-`):

- `cd secret` → **gagal**: `bash: cd: secret: Permission denied`, karena tidak bisa "masuk" tanpa bit `x`.
- `ls secret` → **berhasil** menampilkan nama-nama di dalamnya, karena `ls` hanya butuh bit `r` untuk membaca daftar nama, tidak perlu `cd` ke dalamnya. (Kalau `r` juga dihapus, `ls secret` akan gagal: `Permission denied`.)

Jadi perbedaannya:
- `cd` = butuh `x` → gagal.
- `ls` = butuh `r` → berhasil (hanya menampilkan nama).

Kembalikan permission:

```bash
chmod u+x secret     # atau
chmod 755 secret
```

---

## Task 5 — Command Log & Reflection

### 1. Simpan riwayat command Anda selama mengerjakan assignment:

```bash
history > ~/command_log.txt
```

### 2. Di bagian akhir `answers.md`, jawab pertanyaan Self-Reflection dari Lesson 01 (minimal 3–5 kalimat per pertanyaan).

---

## Task 5 — Self-Reflection (Lesson 01)

### 1. Apa konsep utama yang dipelajari?

Setelah mengerjakan seluruh assignment ini, saya memahami bahwa Linux terdiri dari kernel yang kemudian dilengkapi shell dan tool GNU hingga membentuk sebuah distro. Konsep utama yang paling terasa adalah bahwa semua yang ada di Linux tersusun sebagai satu pohon filesystem yang berakar di `/`, sehingga setiap file selalu punya satu lokasi pasti yang bisa ditunjuk dengan path. Saya juga belajar bahwa sebuah command memiliki anatomi `command [options] [arguments]` dan bahwa sebagian command seperti `cd` adalah shell builtin, bukan program di disk. Selain itu, saya memahami bahwa permission `rwx` pada file dan direktori memiliki arti yang berbeda, sehingga cara mengubahnya perlu dipikirkan sesuai jenis objeknya. Konsep-konsep ini menjadi dasar sebelum masuk ke computer cluster, di mana hampir seluruh interaksi dilakukan lewat terminal.

### 2. Apa kesulitan yang ditemukan?

Kesulitan terbesar saya adalah mengingat sintaks tiap command, karena banyaknya option membuat saya masih sering lupa dan harus membuka `man` atau `--help` kembali. Saya juga sempat bingung saat menghitung jumlah entri di home directory, karena `ls -A` dan `find` memberi angka yang tidak persis sama akibat perbedaan cara menghitung symlink dan direktori itu sendiri. Kesulitan lain muncul pada Task 4, ketika saya harus memahami mengapa script gagal dijalankan padahal isinya sudah benar, yang ternyata murni karena belum ada bit `x`. Kejadian itu mengajarkan saya membaca pesan error seperti `Permission denied` sebagai petunjuk utama. Meski demikian, saya melihat kesulitan ini sebagai hal wajar di tahap awal dan tetap bersemangat untuk memperbaikinya.

### 3. Apa perbedaan absolute path dan relative path, dan kapan sebaiknya masing-masing digunakan dalam script?

Absolute path selalu dimulai dari `/` sehingga menunjuk lokasi yang sama dari mana pun perintah dijalankan, sedangkan relative path dihitung dari direktori kerja saat ini seperti `data/raw/sample_01.csv` atau `../data/hello.txt`. Dalam script, saya cenderung memakai absolute path untuk hal yang harus selalu pasti, misalnya konfigurasi atau lokasi file input yang tidak boleh berubah. Relative path lebih nyaman untuk pekerjaan sehari-hari di dalam satu struktur project karena lebih pendek dan mudah dibaca. Praktik yang saya pelajari adalah menentukan direktori kerja secara eksplisit di awal script, lalu konsisten memakai relative path terhadap direktori tersebut. Dengan begitu script tidak mudah rusak walaupun dijalankan dari lokasi yang berbeda.

### 4. Mengapa permission file penting pada sistem multi-user seperti cluster?

Linux bersifat multi-user, sehingga satu mesin bisa dipakai banyak orang sekaligus dan permission menjadi pembatas pertama agar file saya tidak tersentuh pengguna lain. Pada kasus Task 4, saya melihat langsung bahwa kombinasi `700` membuat hanya owner yang bisa read, write, dan execute, sementara group dan others tidak punya akses apa pun. Ini penting bukan hanya untuk kerahasiaan data, tetapi juga untuk keamanan eksekusi, karena script tanpa bit `x` memang tidak bisa dijalankan dan script yang terlalu terbuka bisa dieksekusi pihak lain. Di cluster, kesalahan permission bisa berakibat data penelitian terbaca orang lain atau job gagal jalan. Karena itu saya belajar membiasakan diri memilih permission sekecil mungkin sesuai kebutuhan.

### 5. Error apa yang paling sering Anda temui minggu ini, dan bagaimana Anda menyelesaikannya?

Error yang paling sering saya temui adalah `Permission denied`, baik saat menjalankan `./scripts/run.sh` yang belum punya bit `x`, maupun saat menjalankan `cd secret` setelah bit `x` owner dihapus. Solusinya saya pelajari bertahap: pertama memeriksa kondisi permission dengan `ls -l`, lalu memutuskan bit mana yang perlu ditambahkan. Untuk script saya memakai `chmod 700` (atau `chmod u=rwx,go=`), sedangkan pada direktori saya memakai `chmod u+x` untuk mengembalikan akses seperti semula. Saya juga sempat menemui error saat membuat direktori bersarang, yang selesai dengan memakai `mkdir -p`. Kebiasaan yang saya ambil dari minggu ini adalah selalu membaca pesan error lebih dulu sebelum menebak penyebabnya.

