# Assignment 02 — Linux & Shell

- **Nama:** zalhashfi
- **Hostname:** LAPTOP-LE1SNB19
- **Environment:** WSL2 — Ubuntu 22.04.5 LTS
- **Tanggal:** 2026-10-21

---

## Task 1 — Redirection & Pipe Drill

### 1. Daftar `/etc` (long format) lalu tambahkan tanggal

```bash
ls -l /etc > etc_list.txt; date >> etc_list.txt
```

`>` membuat file baru (menimpa), `>>` menambahkan ke akhir file yang sama. Hasil akhir `etc_list.txt` berisi **167 baris**: 166 baris hasil `ls -l /etc` ditambah 1 baris tanggal di akhir.

```text
-rw-r--r-- 1 root root        460 Dec  8  2021 zsh_command_not_found
Wed Oct 21 13:40:18 WIB 2026
```

### 2. stdout dan stderr dipisah ke file berbeda

```bash
ls /etc /folder-palsu > out.txt 2> err.txt
```

`out.txt` berisi 166 baris (daftar isi `/etc`). `err.txt` berisi:

```text
ls: cannot access '/folder-palsu': No such file or directory
```

Nomor file descriptor: **1 = stdout**, **2 = stderr**. Jadi `> out.txt` mengalihkan stdout, dan `2> err.txt` mengalihkan stderr.

### 3. Gabungkan stdout dan stderr ke satu file

```bash
ls /etc /folder-palsu > all.txt 2>&1
```

`all.txt` berisi **167 baris** — 166 baris output normal ditambah 1 baris error. Bisa juga ditulis lebih ringkas dengan `&>`:

```bash
ls /etc /folder-palsu &> all.txt
```

### 4. Hitung file di `/usr/bin` yang diawali huruf `p`

```bash
ls /usr/bin | grep '^p' | wc -l
```

Hasil: **85**

Penjelasan: `ls /usr/bin` menghasilkan satu nama per baris → `grep '^p'` menyaring baris yang diawali `p` (`^` = awal baris) → `wc -l` menghitung jumlah baris.

### 5. Perbedaan `cmd > file 2>&1` dan `cmd 2>&1 > file`

Kuncinya adalah **urutan evaluasi redirection, dari kiri ke kanan**.

**Kasus A — `cmd > file 2>&1`**

1. `> file` — stdout (fd 1) diarahkan ke `file`.
2. `2>&1` — stderr (fd 2) dibuat **menyalin tujuan fd 1 saat itu**, yaitu `file`.

Hasil: stdout **dan** stderr masuk ke `file`. (Ini yang biasanya kita inginkan.)

**Kasus B — `cmd 2>&1 > file`**

1. `2>&1` — stderr dibuat menyalin tujuan fd 1 saat itu, yaitu **terminal**.
2. `> file` — stdout dipindahkan ke `file`, tetapi fd 2 **tidak ikut berubah** karena sudah menunjuk ke terminal.

Hasil: stdout masuk ke `file`, stderr **tetap muncul di terminal**.

**Uji:**

```bash
ls /etc /folder-palsu > a.txt 2>&1     # Kasus A
ls /etc /folder-palsu 2>&1 > b.txt     # Kasus B
```

| File | Jumlah baris | Error `folder-palsu` ada di file? |
| ---- | ------------ | --------------------------------- |
| `a.txt` | 167 | ✅ ya (1 baris) |
| `b.txt` | 166 | ❌ tidak (error tampil di terminal) |

**Kesimpulan:** `2>&1` bersifat *pointer copy* — menyalin tujuan fd 1 **pada saat itu**, bukan tautan permanen. Karena itu urutan penulisan menentukan hasil.

---

## Task 2 — Log Analysis Pipeline

Dataset: `cluster_jobs.log` (60 baris). Format field: `$1=tanggal $2=jam $3=level $4=node $5=job_id $6=user $7=status $8=runtime`.

### 1. Total job dalam log

```bash
wc -l < cluster_jobs.log
```

Hasil: **60**

### 2. Jumlah job per status (satu command)

```bash
grep -oE 'status=[A-Z]+' cluster_jobs.log | cut -d= -f2 | sort | uniq -c | sort -rn
```

Hasil:

| Status | Jumlah |
| ------ | ------ |
| `COMPLETED` | 27 |
| `TIMEOUT` | 12 |
| `CANCELLED` | 12 |
| `FAILED` | 9 |
| **Total** | **60** |

`sort` sebelum `uniq` wajib, karena `uniq` hanya menghapus duplikat yang **berurutan**.

### 3. Jumlah user unik dan daftarnya

```bash
grep -oE 'user=[a-z]+' cluster_jobs.log | cut -d= -f2 | sort -u
```

Hasil: **6 user** — `andi`, `budi`, `citra`, `dewi`, `eka`, `fajar`.

### 4. Jumlah job per node, urut terbanyak

```bash
grep -oE 'node[0-9]+' cluster_jobs.log | sort | uniq -c | sort -rn
```

Hasil:

| Node | Jumlah job |
| ---- | ---------- |
| `node03` | 20 |
| `node04` | 18 |
| `node01` | 13 |
| `node02` | 9 |

Node dengan job terbanyak: **node03 (20 job)**.

### 5. User dengan job gagal (`FAILED` + `TIMEOUT`) terbanyak

```bash
grep -E 'status=(FAILED|TIMEOUT)' cluster_jobs.log | grep -oE 'user=[a-z]+' | cut -d= -f2 | sort | uniq -c | sort -rn
```

Hasil:

| User | Jumlah job gagal |
| ---- | ---------------- |
| `eka` | 8 |
| `budi` | 4 |
| `fajar` | 3 |
| `citra` | 3 |
| `dewi` | 2 |
| `andi` | 1 |

Jawaban: **eka** dengan **8 job** gagal.

### 6. Rata-rata runtime job `COMPLETED`

```bash
awk '/status=COMPLETED/ {split($8, a, "="); sum += a[2]; n++} END {printf "%.2f detik = %.2f menit\n", sum/n, sum/n/60}' cluster_jobs.log
```

Hasil: **2155.48 detik ≈ 35.92 menit** (total 58198 detik dari 27 job).

Alternatif dengan `cut`:

```bash
grep 'status=COMPLETED' cluster_jobs.log | cut -d= -f5 | awk '{s+=$1; n++} END {printf "%.2f detik = %.2f menit\n", s/n, s/n/60}'
```

### 7. 5 job `COMPLETED` dengan runtime terlama

```bash
grep 'status=COMPLETED' cluster_jobs.log \
  | awk '{split($5,j,"="); split($6,u,"="); split($8,r,"="); print j[2], u[2], r[2]}' \
  | sort -k3 -rn | head -5
```

Hasil:

| job_id | user | runtime (detik) |
| ------ | ---- | --------------- |
| 10036 | budi | 3377 |
| 10040 | budi | 3217 |
| 10022 | citra | 3171 |
| 10030 | fajar | 3118 |
| 10039 | budi | 3039 |

### 8. Jam dengan job terbanyak

```bash
cut -d' ' -f2 cluster_jobs.log | cut -d: -f1 | sort | uniq -c | sort -rn
```

Hasil teratas:

| Jam | Jumlah job |
| --- | ---------- |
| 10 | 6 |
| 14 | 5 |
| 18 | 5 |

Jawaban: jam **10** dengan **6 job** (terbanyak).

### 9. Simpan baris `ERROR` ke `errors_only.log`

```bash
grep ' ERROR ' cluster_jobs.log > errors_only.log; wc -l < errors_only.log
```

Hasil: **21 baris** tersimpan di `errors_only.log`.

---

## Task 3 — Konfigurasi Shell

### 1. Backup `~/.bashrc`

```bash
cp ~/.bashrc ~/.bashrc.bak
```

### 2. Isi yang ditambahkan

```bash
alias ll='ls -lah'
alias ..='cd ..'
alias cls='clear'

export COMICS_HOME="$HOME/comics"

export PATH="$HOME/bin:$PATH"
```

> Catatan: assignment mencontohkan `~/comics-sg`, namun direktori tersebut tidak ada di mesin ini. Repository CSG saya berada di `~/comics`, sehingga `COMICS_HOME` diarahkan ke sana agar benar-benar berfungsi.

### 3. Bukti konfigurasi bekerja setelah `source ~/.bashrc`

```bash
source ~/.bashrc
alias
echo $COMICS_HOME
echo $PATH
```

Hasil:

```text
$ alias | grep -E '^(alias (ll|\.\.|cls))='
alias ..='cd ..'
alias cls='clear'
alias ll='ls -lah'

$ echo $COMICS_HOME
/home/zalhashfi/comics

$ echo $PATH | cut -d: -f1
/home/zalhashfi/bin
```

> Temuan saat pengujian: `~/.bashrc` Ubuntu memiliki guard di awal file:
> ```bash
> case $- in
>     *i*) ;;
>       *) return;;
> esac
> ```
> Artinya `.bashrc` **berhenti di baris itu jika shell tidak interaktif**. Jadi `source ~/.bashrc` dari dalam script non-interaktif tidak akan menerapkan bagian kita — itu perilaku normal, bukan error. Verifikasi harus dilakukan di shell interaktif, misalnya `bash -ic 'alias; echo $COMICS_HOME'`.

### 4. Potongan konfigurasi

Disimpan di [`bashrc_snippet.txt`](bashrc_snippet.txt).

### 5. Mengapa variable perlu di-`export`?

Variable shell biasa hanya hidup di proses shell itu sendiri. Setiap program yang dijalankan dari shell (misalnya `python3`, `ssh`, atau script bash lain) adalah **child process** yang menerima salinan environment, bukan salinan semua variable shell.

- Tanpa `export` → `COMICS_HOME="x"` hanya dikenal shell induk; `bash -c 'echo $COMICS_HOME'` akan kosong.
- Dengan `export` → variable dimasukkan ke *environment block* dan **diwariskan** ke semua child process.

`PATH` wajib di-`export` karena justru dibaca oleh shell saat mencari program, dan oleh program lain untuk mencari executable.

### 6. `~/bin` di akhir vs di awal `PATH`

`PATH` dibaca **dari kiri ke kanan**, dan program pertama yang ditemukan itulah yang dipakai.

**Di awal** — `export PATH="$HOME/bin:$PATH"`:

- `~/bin` diprioritaskan. Jika Anda membuat `~/bin/ls`, maka `ls` akan menjalankan versi Anda, **menimpa** `/usr/bin/ls`.
- Cocok untuk **menimpa** tool bawaan dengan versi kustom (misalnya compiler atau Python versi tertentu).

**Di akhir** — `export PATH="$PATH:$HOME/bin"`:

- Tool sistem tetap diprioritaskan. `~/bin` hanya dipakai jika namanya belum ada di direktori lain.
- Cocok dan lebih **aman**: script pribadi tidak akan menimpa command sistem secara tak sengaja.

Pada konfigurasi ini saya pilih **di awal**, agar script pribadi di `~/bin` mudah dipakai. Risikonya harus disadari: nama file di `~/bin` jangan sama dengan command penting.

---

## Task 4 — Bash Script: `sysreport.sh`

File: [`sysreport.sh`](sysreport.sh)

### Fitur yang diimplementasikan

| Spesifikasi | Implementasi |
| ----------- | ------------ |
| Shebang & `set -euo pipefail` | ✅ baris 1 dan 16 |
| Argument opsional nama file | `OUTPUT="${1:-report_$(date +%Y-%m-%d).txt}"` |
| Username, hostname, tanggal/jam | `whoami`, `hostname`, `date` |
| Distro & kernel | `grep PRETTY_NAME /etc/os-release`, `uname -r` |
| Jumlah CPU core | `nproc` |
| Memory & disk | `free -h`, `df -h ~` |
| 5 process memori teratas | `ps aux --sort=-%mem \| head -n 6` |
| Pesan akhir | `Report saved to <file>` |
| File sudah ada → stderr + exit 1 | `[[ -e "$OUTPUT" ]]` |

### Pengujian

```bash
./sysreport.sh
./sysreport.sh my_report.txt
./sysreport.sh my_report.txt
echo $?
```

```text
=== 1) default ===
Report saved to report_2026-10-21.txt
exit=0
=== 2) nama custom ===
Report saved to my_report.txt
exit=0
=== 3) file sudah ada ===
Error: file 'my_report.txt' sudah ada. Hapus atau pilih nama lain.
exit=1
```

### Contoh isi laporan

```text
==============================================
 SYSTEM REPORT
==============================================
User       : zalhashfi
Hostname   : LAPTOP-LE1SNB19
Tanggal    : 2026-10-21 13:42:50 WIB
Distro     : Ubuntu 22.04.5 LTS
Kernel     : 6.6.87.2-microsoft-standard-WSL2
CPU core   : 16

---- Memory ----
               total        used        free      shared  buff/cache   available
Mem:           7.7Gi       739Mi       5.7Gi       4.0Mi       1.2Gi       6.8Gi
Swap:          2.0Gi          0B       2.0Gi

---- Disk home directory ----
Filesystem      Size  Used Avail Use% Mounted on
/dev/sdf       1007G  3.0G  953G   1% /
```

---

## Task 5 — Bash Script: `organize.sh`

File: [`organize.sh`](organize.sh)

### Fitur yang diimplementasikan

| Spesifikasi | Implementasi |
| ----------- | ------------ |
| Usage `<nama_eksperimen> <jumlah_run>` | `EXP_NAME="$1"`, `NUM_RUN="$2"` |
| Argumen < 2 → usage ke stderr, exit 1 | `if [[ $# -lt 2 ]]` dengan `usage >&2` |
| `jumlah_run` bukan integer positif → exit 2 | `[[ ! "$NUM_RUN" =~ ^[0-9]+$ ]] \|\| (( NUM_RUN < 1 ))` |
| Direktori `T{100,200,300}/run_NN/` | loop `TEMPERATURES` + `printf '%02d'` |
| `params.txt` tiap run | blok `{ ... } > params.txt` |
| Ringkasan jumlah direktori & file | `find ... \| wc -l` |
| **Bonus** `-h` / `--help` | fungsi `usage()`, `case "${1:-}" in -h\|--help)` → exit 0 |
| **Bonus** temperature custom | `./organize.sh exp 3 50 150 250`; `shift 2` lalu `TEMPERATURES=("$@")` |

### Pengujian

```bash
./organize.sh sweep_test 3
(tree sweep_test 2>/dev/null || find sweep_test) > sweep_tree.txt
cat sweep_test/T200/run_02/params.txt
./organize.sh
./organize.sh exp abc
```

Hasil:

```text
=== 1) normal ===
Eksperimen : sweep_test
Temperature: 100 200 300
Jumlah run : 3
Direktori  : 13 (termasuk direktori eksperimen)
params.txt : 9
exit=0

=== 3) params T200/run_02 ===
experiment=sweep_test
temperature=200
run=02
created=2026-10-21 13:42:25

=== 4) tanpa argumen ===
Penggunaan: organize.sh <nama_eksperimen> <jumlah_run> [temperature ...]
...
exit=1

=== 5) jumlah_run bukan angka ===
Error: <jumlah_run> harus bilangan bulat positif, bukan 'abc'.
exit=2

=== 6) jumlah_run = 0 ===
Error: <jumlah_run> harus bilangan bulat positif, bukan '0'.
exit=2

=== 7) temperature custom ===
Eksperimen : exp
Temperature: 50 150 250
Jumlah run : 2
params.txt : 6
exit=0

=== 8) temperature bukan angka ===
Error: temperature 'abc' bukan bilangan bulat non-negatif.
exit=3

=== 9) --help ===
Penggunaan: organize.sh <nama_eksperimen> <jumlah_run> [temperature ...]
exit=0
```

Struktur akhir tersimpan di [`sweep_tree.txt`](sweep_tree.txt):

```text
sweep_test
|-- T100
|   |-- run_01
|   |   `-- params.txt
|   |-- run_02
|   |   `-- params.txt
|   `-- run_03
|       `-- params.txt
|-- T200
|   |-- run_01
|   ...
`-- T300
    ...

12 directories, 9 files
```

### Catatan penerapan

- `printf '%02d'` dipakai agar nama run menjadi `01`, `02`, `03` sehingga urutan alfabetis sama dengan urutan numerik (penting untuk SLURM job array nanti).
- `mkdir -p` membuat direktori induk (`<eksperimen>`, `T<temp>`) secara otomatis.
- Semua variable diberi double quote (`"$run_dir"`) agar aman terhadap nama berspasi.
- `sweep_tree.txt` dibuat dengan `LANG=C` supaya karakter box-drawing `tree` keluar sebagai ASCII dan tetap rapi di GitHub.

---

## Bonus

Semua bonus Assignment 02 dikerjakan.

### Bonus 1 — `shellcheck` pada kedua script

```bash
shellcheck organize.sh
shellcheck sysreport.sh
```

Output sebelum dan sesudah disimpan lengkap di [`shellcheck_before.txt`](shellcheck_before.txt) dan [`shellcheck_after.txt`](shellcheck_after.txt). ShellCheck versi `0.8.0`.

| Script | Sebelum | Sesudah |
| ------ | ------- | ------- |
| `organize.sh` | exit 0 (clean) | exit 0 (clean) |
| `sysreport.sh` | exit 0 (clean) | exit 0 (clean) |

Satu-satunya temuan muncul pada versi awal `sysreport.sh`, yang sudah diperbaiki sebelum bonus ini dikerjakan:

```text
In sysreport.sh line 33:
    echo "Distro     : $(. /etc/os-release && echo "$PRETTY_NAME")"
                           ^-------------^ SC1091 (info): Not following: /etc/os-release was not specified as input
```

**Perbaikan:** file eksternal tidak lagi di-`source`, melainkan dibaca langsung:

```bash
grep -E '^PRETTY_NAME=' /etc/os-release | cut -d= -f2- | tr -d '"'
```

Alasan memilih perbaikan ini dibanding `shellcheck -x`: `-x` hanya menekan peringatan dengan cara membaca file yang di-`source`, padahal masalah sebenarnya adalah kita tidak butuh seluruh variabel — cukup satu baris. Membaca langsung lebih sederhana dan tidak bergantung pada struktur file.

### Bonus 2 — Opsi `-h` / `--help` pada `organize.sh`

```bash
./organize.sh --help
```

```text
Penggunaan: organize.sh <nama_eksperimen> <jumlah_run> [temperature ...]

Menyiapkan struktur direktori untuk simulasi parameter sweep.

Argument:
  <nama_eksperimen>   nama direktori eksperimen (dibuat bila belum ada)
  <jumlah_run>        bilangan bulat positif, jumlah run per temperature
  [temperature ...]   daftar temperature; default: 100 200 300

Opsi:
  -h, --help          tampilkan bantuan ini lalu keluar

Contoh:
  organize.sh sweep_test 3
  organize.sh exp 2 50 150 250

Exit code:
  0 berhasil · 1 argument kurang · 2 jumlah_run tidak valid · 3 temperature tidak valid
```

Bantuan ditulis sekali di fungsi `usage()` agar teks usage dan help tidak pernah berbeda. `--help` dikeluarkan dengan **exit 0** karena itu permintaan yang sah, sedangkan argumen kurang tetap **exit 1**.

### Bonus 3 — Temperature sebagai argument tambahan

```bash
./organize.sh exp 3 50 150 250
```

```text
Eksperimen : exp
Temperature: 50 150 250
Jumlah run : 3
Direktori  : 13 (termasuk direktori eksperimen)
params.txt : 9
```

Implementasinya: setelah `EXP_NAME="$1"` dan `NUM_RUN="$2"`, gunakan `shift 2` sehingga `"$@"` hanya berisi temperature tambahan. Jika tidak ada, dipakai default:

```bash
if [[ $# -gt 0 ]]; then
    TEMPERATURES=("$@")
else
    TEMPERATURES=("${DEFAULT_TEMPERATURES[@]}")
fi
```

Setiap temperature divalidasi harus bilangan bulat non-negatif; jika tidak, keluar dengan **exit 3**.

### Seluruh exit code akhir

| Kode | Arti | Pemicu |
| ---- | ---- | ------ |
| 0 | berhasil | `./organize.sh sweep_test 3`, `./organize.sh --help` |
| 1 | argumen kurang | `./organize.sh` |
| 2 | `jumlah_run` tidak valid | `./organize.sh exp abc`, `./organize.sh exp 0` |
| 3 | temperature tidak valid | `./organize.sh exp 2 50 abc` |

### Ringkasan pengujian bonus

| No | Perintah | Hasil |
| -- | -------- | ----- |
| 1 | `./organize.sh sweep_test 3` | exit 0, 12 direktori, 9 `params.txt`, temperature `100 200 300` |
| 2 | `./organize.sh exp 2 50 150 250` | exit 0, 9 direktori, 6 `params.txt`, temperature `50 150 250` |
| 3 | `cat exp/T150/run_02/params.txt` | `temperature=150`, `run=02` |
| 4 | `./organize.sh --help` | exit 0, tampil bantuan |
| 5 | `./organize.sh -h` | exit 0, tampil bantuan |
| 6 | `./organize.sh` | exit 1 |
| 7 | `./organize.sh exp abc` | exit 2 |
| 8 | `./organize.sh exp 2 50 abc` | exit 3 |
| 9 | `shellcheck organize.sh` | clean |

---

## Self-Reflection (Lesson 02)

### 1. Apa konsep utama yang dipelajari?

Konsep utama minggu ini adalah bahwa command line bisa **dirangkai** menjadi pipeline untuk mengolah data, bukan hanya dijalankan satu per satu. Saya belajar bahwa setiap process punya tiga saluran (stdin, stdout, stderr) dan bahwa operator redirection bekerja berdasarkan urutan evaluasi, yang ternyata sangat menentukan hasil seperti pada perbedaan `> file 2>&1` dan `2>&1 > file`. Saya juga memahami bahwa pipe meneruskan hanya stdout, sehingga penyaringan (`grep`), pengurutan (`sort`), agregasi (`uniq -c`, `awk`), dan pemotongan baris (`head`) bisa dikombinasikan menjadi satu baris command. Selain itu, saya belajar bahwa shell dapat dikonfigurasi melalui `~/.bashrc` dan bahwa variable harus di-`export` agar diwariskan ke child process. Terakhir, konsep bash scripting dengan argument, validasi, loop, dan exit code menjadi dasar sebelum menulis SLURM job script.

### 2. Apa kesulitan yang ditemukan?

Kesulitan pertama adalah salah menghitung nomor field saat memakai `awk`: saya sempat memakai `$7` untuk `runtime`, padahal `runtime` berada di field ke-8, sehingga hasil rata-rata muncul `0.00`. Saya perbaiki dengan mencetak field satu per satu lebih dulu. Kesulitan kedua adalah karakter Unicode `tree` yang rusak saat diarahkan ke file, yang saya atasi dengan `LANG=C`. Kesulitan ketiga adalah ketika `source ~/.bashrc` di dalam script tidak menerapkan konfigurasi, yang ternyata karena ada guard `case $- in *i*) ;; *) return;; esac` untuk shell non-interaktif. Saya juga sempat bingung membedakan kapan memakai `2>&1` sebelum atau sesudah `>`, dan baru paham setelah menguji keduanya secara langsung.

### 3. Bagaimana pipe mengubah cara Anda berpikir dalam menyelesaikan masalah pemrosesan data?

Sebelumnya saya berpikir "buka file, lihat, lalu hitung manual". Dengan pipe, saya mulai berpikir sebagai **rantai transformasi**: dari bentuk data mentah, apa langkah kecil yang perlu dilakukan agar hasil akhirnya muncul. Contohnya untuk menghitung status job, saya memecahnya menjadi ambil field → urutkan → hitung → urutkan hasil. Pola berpikir ini membuat masalah besar terasa seperti gabungan masalah kecil yang masing-masing bisa diuji sendiri. Saya juga jadi terbiasa **menguji pipeline bertahap** — menambah satu `| command` setiap kali dan memeriksa output — daripada menulis satu baris panjang lalu bingung ketika hasilnya salah.

### 4. Bagian mana dari bash scripting yang menurut Anda paling berguna untuk menjalankan eksperimen komputasi berulang?

Menurut saya yang paling berguna adalah **loop `for` dikombinasikan dengan `printf` untuk format nama**, karena itulah inti dari parameter sweep: menghasilkan puluhan kombinasi direktori dan file parameter secara otomatis dan konsisten. Validasi argument dan **exit code** juga sangat penting, karena pada eksperimen yang dijalankan otomatis, script harus bisa memberi tahu apakah berhasil atau gagal tanpa perlu dilihat manusia. `set -euo pipefail` juga terasa berguna, karena menghentikan script begitu ada error sehingga tidak menghasilkan data setengah jadi yang menyesatkan.

### 5. Apa yang ingin Anda tanyakan atau diskusikan pada Meeting 1 (22 Oktober)?

Saya ingin mendiskusikan **praktik terbaik penempatan `~/bin` di `PATH`** saat bekerja di cluster bersama, karena menaruhnya di awal berisiko menimpa command sistem, tetapi menaruhnya di akhir membuat tool pribadi kalah prioritas. Saya juga ingin bertanya tentang **penanganan log yang lebih besar**: pipeline yang saya buat cukup untuk 60 baris, tetapi bagaimana kebiasaan yang benar ketika log berukuran gigabyte — apakah tetap pipe, atau perlu `awk` yang lebih efisien. Terakhir, saya penasaran bagaimana `organize.sh` nantinya dipetakan ke **SLURM job array**, khususnya bagaimana satu `sbatch --array` bisa merujuk setiap direktori `run_NN` yang sudah dibuat script ini.

---

## Daftar File

| File | Keterangan |
| ---- | ---------- |
| [`answers.md`](answers.md) | jawaban Task 1–3 + refleksi |
| [`bashrc_snippet.txt`](bashrc_snippet.txt) | potongan konfigurasi Task 3 |
| [`sysreport.sh`](sysreport.sh) | script Task 4 |
| [`organize.sh`](organize.sh) | script Task 5 |
| [`sweep_tree.txt`](sweep_tree.txt) | output struktur Task 5 |
| [`cluster_jobs.log`](cluster_jobs.log) | dataset (salinan) |
| [`errors_only.log`](errors_only.log) | hasil Task 2 no. 9 |
| [`shellcheck_before.txt`](shellcheck_before.txt) | output shellcheck (bonus 1, sebelum) |
| [`shellcheck_after.txt`](shellcheck_after.txt) | output shellcheck (bonus 1, sesudah) |
