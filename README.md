# Rizal CSG 2026 — Comics Study Group

Repository personal untuk **Comics Study Group (CSG) 2026**. Isinya adalah hasil pengerjaan tugas mingguan seputar dasar-dasar Linux dan penggunaan command line (navigasi filesystem, manipulasi file, serta pengaturan permission).

Seluruh pengerjaan dilakukan **lewat terminal** (bukan file explorer) pada environment **WSL2** dengan distro **Ubuntu 22.04.5 LTS**.

> [!IMPORTANT]
> **Status repository: public dan sudah tersinkron.** Commit `05dcf7a` ("Add Assignment 01 Linux Fundamental deliverables") sudah ada di branch `main` dan sudah di-push ke GitHub. Pekerjaan yang masih tersisa hanya **Self-Reflection Task 5**; rincian ketidaksesuaian lain ada di [Catatan Kondisi Saat Ini](#catatan-kondisi-saat-ini).

## Struktur Repository

```text
rizal-CSG-2026/
├── README.md
└── week01/
    ├── assignment-01/
    │   ├── answers.md        # jawaban Task 1–5 (Self-Reflection masih kosong)
    │   ├── sysinfo.txt       # output Task 1 (identitas environment)
    │   ├── structure.txt     # output Task 3 (struktur direktori project)
    │   └── command_log.txt   # riwayat command Task 5 (output `history`)
    ├── data/
    │   └── hello.txt         # sisa latihan Guided Practice Lesson 01
    ├── scripts/
    │   └── run.sh            # sisa latihan Guided Practice Lesson 01
    └── results/              # (kosong)
```

Assignment 01 disimpan di `week01/assignment-01/` (bukan langsung `assignment-01/` di root seperti contoh pada instruksi pengumpulan).

## Status Task — Week 01 / Assignment 01

| Task | Materi | Status |
| ---- | ------ | ------ |
| Task 1 | Environment Setup & System Information | ✅ selesai |
| Task 2 | Filesystem Exploration | ✅ selesai |
| Task 3 | Membangun Struktur Direktori Project | ✅ selesai |
| Task 4 | File Permission Challenge | ⚠️ jawaban ada, tetapi penjelasan no. 6 perlu dikoreksi (`ls secret` sebenarnya juga `Permission denied` saat bit `x` owner dihapus) |
| Task 5 | Command Log | ✅ selesai |
| Task 5 | Self-Reflection (Lesson 01) | ⬜ belum diisi (pertanyaan tersedia di Lesson 01) |
| — | Commit & push ke GitHub | ✅ selesai (`05dcf7a` di `origin/main`) |
| Bonus | OverTheWire Bandit Level 0 → 5 | ⬜ belum dikerjakan |

## Catatan Kondisi Saat Ini

Hal-hal yang masih belum sesuai dengan instruksi pengumpulan Assignment 01:

1. **Self-Reflection belum diisi.** Bagian Task 5 pada `answers.md` masih berupa placeholder. Pertanyaan (5 butir) sudah tersedia di bagian *Self-Reflection* Lesson 01.
2. **Penjelasan Task 4 no. 6 perlu dikoreksi.** Saat bit `x` owner dihapus (`chmod u-x secret`), `ls secret` **juga gagal** dengan `Permission denied`. Yang hanya butuh bit `r` tanpa `x` adalah `ls -l secret` atau `ls -d secret`, bukan `ls secret`.
3. **Path di `answers.md`.** Beberapa bagian masih menyebut `~/comics-sg/week01/...`, padahal repository kini berada di `~/comics/rizal-CSG-2026/week01/...`.
4. **`week01/scripts/run.sh`** (permission `744`) adalah versi latihan Guided Practice (`echo "Script berjalan dari $(pwd)"`), bukan script Task 4 yang diuji permission-nya. Script Task 4 (`chmod 700`, isi `Job started on ...`) berada di `~/cluster-project/scripts/run.sh`.
5. **File sisa latihan** (`week01/data/hello.txt`, `week01/results/`) bukan bagian deliverable Assignment 01.

## Project Direktori Task 3

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

## Cara Menjalankan / Reproduksi

```bash
# 1. Clone repository
git clone https://github.com/zalhashfi/rizal-CSG-2026.git
cd rizal-CSG-2026

# 2. Lihat jawaban Assignment 01
cat week01/assignment-01/answers.md

# 3. Coba jalankan script latihan Guided Practice
chmod +x week01/scripts/run.sh
./week01/scripts/run.sh
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
- Branch: `main`, commit terakhir `05dcf7a`
