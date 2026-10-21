# Rizal CSG 2026 — Comics Study Group

Repository personal untuk **Comics Study Group (CSG) 2026**. Isinya adalah hasil pengerjaan tugas mingguan seputar dasar-dasar Linux dan penggunaan command line: navigasi filesystem, manipulasi file, permission, redirection & pipe, konfigurasi shell, serta bash scripting.

Seluruh pengerjaan dilakukan **lewat terminal** (bukan file explorer) pada environment **WSL2** dengan distro **Ubuntu 22.04.5 LTS**.

> [!IMPORTANT]
> **Status repository:** Week 01 dan Week 02 selesai, termasuk bonus Bandit. Rincian per assignment ada di bagian [Status Task](#status-task).

## Daftar Assignment

| Week | Assignment | Materi | Status |
| ---- | ---------- | ------ | ------ |
| 01 | [Assignment 01](week01/assignment-01/answers.md) | Linux Fundamental | ✅ selesai + bonus Bandit |
| 02 | [Assignment 02](week02/assignment-02/answers.md) | Linux & Shell | ✅ selesai |

## Struktur Repository

```text
rizal-CSG-2026/
├── README.md
├── week01/
│   ├── assignment-01/
│   │   ├── answers.md        # jawaban Task 1–5 + Self-Reflection (5 butir)
│   │   ├── sysinfo.txt       # output Task 1 (identitas environment)
│   │   ├── structure.txt     # output Task 3 (struktur direktori project)
│   │   ├── command_log.txt   # riwayat command Task 5 (output `history`)
│   │   └── bonus-bandit.md   # bonus OverTheWire Bandit Level 0-5 (command kunci)
│   ├── data/
│   │   └── hello.txt         # sisa latihan Guided Practice Lesson 01
│   ├── scripts/
│   │   └── run.sh            # sisa latihan Guided Practice Lesson 01
│   └── results/              # (kosong)
└── week02/
    └── assignment-02/
        ├── answers.md          # jawaban Task 1–3 + Self-Reflection
        ├── bashrc_snippet.txt  # potongan konfigurasi Task 3
        ├── sysreport.sh        # Task 4 — laporan kondisi sistem
        ├── organize.sh         # Task 5 — struktur parameter sweep
        ├── sweep_tree.txt      # output Task 5
        ├── errors_only.log     # hasil Task 2 no. 9
        ├── cluster_jobs.log    # dataset (salinan)
        ├── shellcheck_before.txt # bonus 1 — output shellcheck sebelum
        ├── shellcheck_after.txt  # bonus 1 — output shellcheck sesudah
        └── sweep_test/         # hasil uji organize.sh (T100/T200/T300)
```

Assignment disimpan sebagai `weekNN/assignment-NN/` (bukan langsung `assignment-NN/` di root seperti contoh pada instruksi pengumpulan).

## Status Task

### Week 01 / Assignment 01 — Linux Fundamental

| Task | Materi | Status |
| ---- | ------ | ------ |
| Task 1 | Environment Setup & System Information | ✅ selesai |
| Task 2 | Filesystem Exploration | ✅ selesai |
| Task 3 | Membangun Struktur Direktori Project | ✅ selesai |
| Task 4 | File Permission Challenge | ✅ selesai |
| Task 5 | Command Log | ✅ selesai |
| Task 5 | Self-Reflection (Lesson 01) | ✅ selesai (5 pertanyaan) |
| Bonus | OverTheWire Bandit Level 0 → 5 | ✅ selesai ([`bonus-bandit.md`](week01/assignment-01/bonus-bandit.md)) |

### Week 02 / Assignment 02 — Linux & Shell

| Task | Materi | Status |
| ---- | ------ | ------ |
| Task 1 | Redirection & Pipe Drill | ✅ selesai (5 soal) |
| Task 2 | Log Analysis Pipeline | ✅ selesai (9 soal) |
| Task 3 | Konfigurasi Shell (`.bashrc`, alias, `PATH`) | ✅ selesai |
| Task 4 | Bash Script `sysreport.sh` | ✅ selesai |
| Task 5 | Bash Script `organize.sh` | ✅ selesai |
| Self-Reflection | Lesson 02 | ✅ selesai (5 pertanyaan) |
| Bonus | shellcheck, `-h/--help`, temperature custom | ✅ selesai |

Semua exit code dan validasi Task 4–5 sudah diuji, dan kedua script lulus `shellcheck` tanpa warning.

## Script — Assignment 02

| Script | Fungsi | Exit code |
| ------ | ------ | --------- |
| [`sysreport.sh`](week02/assignment-02/sysreport.sh) | Menulis laporan kondisi sistem (user, hostname, distro, kernel, CPU, memory, disk, 5 process teratas memory) | `0` sukses · `1` file output sudah ada |
| [`organize.sh`](week02/assignment-02/organize.sh) | Membuat struktur `T<temperature>/run_NN` + `params.txt` untuk simulasi parameter sweep | `0` sukses · `1` argumen kurang · `2` jumlah_run tidak valid · `3` temperature tidak valid |

```bash
cd week02/assignment-02

# Task 4 — laporan sistem (default: report_<YYYY-MM-DD>.txt)
./sysreport.sh
./sysreport.sh my_report.txt    # nama custom; jalankan dua kali -> exit 1

# Task 5 — simulasi parameter sweep
./organize.sh sweep_test 3                  # T100 T200 T300 (default)
./organize.sh exp 2 50 150 250              # temperature custom
./organize.sh --help                        # bantuan
cat sweep_test/T200/run_02/params.txt
./organize.sh                               # exit 1
./organize.sh exp abc                       # exit 2
./organize.sh exp 2 50 abc                  # exit 3
```

## Bonus — OverTheWire Bandit Level 0 → 5

Command kunci tiap level beserta penjelasan konsepnya ada di [`week01/assignment-01/bonus-bandit.md`](week01/assignment-01/bonus-bandit.md). Sesuai instruksi, **password setiap level tidak dicatat** di repository.

| Level | Tantangan utama | Command kunci |
| ----- | --------------- | ------------- |
| 0 → 1 | Login SSH pertama | `ssh ... -p 2220`, `cat readme` |
| 1 → 2 | Nama file `-` | `cat ./-` |
| 2 → 3 | Nama file berspasi | `cat ./--spaces\ in\ this\ filename--` |
| 3 → 4 | File hidden dalam direktori | `ls -a`, `cd inhere/` |
| 4 → 5 | Tipe file tidak terlihat dari nama | `file ./*` |
| 5 → 6 | Cari file di banyak subdirektori | `find . -size 1033c ! -executable` |

## Project Direktori (Week 01 — Task 3/4)

Struktur `~/cluster-project/` yang dibangun pada Task 3 (di luar repository ini):

```text
cluster-project/
├── README.md
├── data/
│   ├── raw/
│   │   ├── sample_01.csv
│   │   └── sample_02.csv
│   └── processed/
│       └── sample_01_clean.csv
├── results/
│   └── sample_03.csv
├── scripts/
│   └── run.sh          # permission 700
└── secret/             # uji permission Task 4 no. 6
```

## Catatan

Hal-hal yang perlu diketahui saat membaca repository ini:

1. **Path historis di `week01/assignment-01/answers.md`.** Bagian Task 2 no. 5 dan Task 3 langkah 6 masih mencatat `~/comics-sg/week01/...`, yaitu lokasi repo saat assignment dikerjakan. Repo kini berada di `~/comics/rizal-CSG-2026/week01/...`; dibiarkan sebagai jejak kondisi asli.
2. **`week01/scripts/run.sh`** (permission `744`) adalah script latihan Guided Practice Lesson 01 (`echo "Script berjalan dari $(pwd)"`). Script yang diuji pada Task 4 (`chmod 700`, isi `Job started on ...`) berada di `~/cluster-project/scripts/run.sh`, sesuai instruksi task yang memang menyuruh mengerjakan di direktori tersebut.
3. **File sisa latihan** (`week01/data/hello.txt`, `week01/results/`) bukan bagian deliverable Assignment 01.
4. **`COMICS_HOME` (Week 02, Task 3).** Assignment mencontohkan `~/comics-sg`, tetapi direktori itu tidak ada di mesin ini, sehingga dipakai `~/comics` agar variable benar-benar menunjuk lokasi repo.
5. **Konfigurasi `~/.bashrc` (Week 02, Task 3).** Alias, `COMICS_HOME`, dan `PATH` sudah ditambahkan ke `~/.bashrc` asli (backup di `~/.bashrc.bak`). Bagian ini hanya aktif pada shell interaktif karena `.bashrc` Ubuntu memiliki guard `case $- in *i*) ;; *) return;; esac`.
6. **`sweep_tree.txt`** dibuat dengan `LANG=C` agar karakter box-drawing `tree` keluar sebagai ASCII dan tetap rapi di GitHub.

## Cara Menjalankan / Reproduksi

```bash
# 1. Clone repository
git clone https://github.com/zalhashfi/rizal-CSG-2026.git
cd rizal-CSG-2026

# 2. Assignment 01 — jawaban dan bonus Bandit
cat week01/assignment-01/answers.md
cat week01/assignment-01/bonus-bandit.md

# 3. Assignment 01 — script latihan Guided Practice
chmod +x week01/scripts/run.sh
./week01/scripts/run.sh

# 4. Assignment 02 — jawaban, lalu jalankan script
cat week02/assignment-02/answers.md
cd week02/assignment-02
./sysreport.sh
./organize.sh sweep_test 3
```

## Environment

Ringkasan dari `week01/assignment-01/sysinfo.txt`:

| Item | Nilai |
| ---- | ----- |
| User | `zalhashfi` |
| Hostname | `LAPTOP-LE1SNB19` |
| Distro | Ubuntu 22.04.5 LTS (Jammy Jellyfish) |
| Kernel | 6.6.87.2-microsoft-standard-WSL2 |
| Arsitektur | x86_64 |
| Shell | `/bin/bash` |
| Home | `/home/zalhashfi` |

## Remote

- GitHub: <https://github.com/zalhashfi/rizal-CSG-2026> (public)
- Branch: `main`
