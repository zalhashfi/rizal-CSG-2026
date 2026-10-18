# Rizal CSG 2026 — Comics Study Group

Repository personal untuk **Comics Study Group (CSG) 2026**. Isinya adalah hasil pengerjaan tugas mingguan seputar dasar-dasar Linux dan penggunaan command line (navigasi filesystem, manipulasi file, serta pengaturan permission).

Seluruh pengerjaan dilakukan **lewat terminal** (bukan file explorer) pada environment **WSL2** dengan distro **Ubuntu 22.04.5 LTS**.

> [!IMPORTANT]
> **Status repository: work-in-progress.** Belum ada commit sama sekali pada branch `main` (file masih *staged*) dan repository ini **belum di-push** ke GitHub. Bagian yang masih kurang dijelaskan di bawah.

## Struktur Repository

```text
rizal-CSG-2026/
├── README.md
└── week01/
    ├── assignment-01/
    │   ├── answers.md        # jawaban Task 1–5 (Self-Reflection masih kosong)
    │   ├── sysinfo.txt       # output Task 1 (identitas environment)
    │   ├── structure.txt     # output Task 3 (struktur direktori project)
    │   └── command_log.txt   # ⚠ belum berisi output `history` (lihat catatan)
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
| Task 5 | Command Log | ⚠️ `command_log.txt` belum berisi output `history` |
| Task 5 | Self-Reflection (Lesson 01) | ⬜ belum diisi (pertanyaan tersedia di Lesson 01) |
| — | Push ke GitHub | ⬜ belum dilakukan, belum ada commit |
| Bonus | OverTheWire Bandit Level 0 → 5 | ⬜ belum dikerjakan |

## Catatan Kondisi Saat Ini

Hal-hal yang belum sesuai dengan instruksi pengumpulan Assignment 01:

1. **Belum ada commit/push.** Repository lokal masih kosong (tidak ada commit) dan remote GitHub belum berisi file.
2. **`command_log.txt`** berisi ringkasan status Git, bukan riwayat command. Perlu dibuat ulang dengan `history > ~/command_log.txt`.
3. **Self-Reflection** pada `answers.md` masih berupa placeholder.
4. **Path di `answers.md`** masih menyebut `~/comics-sg/week01/...`, padahal repository kini berada di `~/comics/rizal-CSG-2026/week01/...`.
5. **`week01/scripts/run.sh`** adalah versi latihan Guided Practice (`echo "Script berjalan dari $(pwd)"`), bukan script Task 4 yang diuji permission-nya. Script Task 4 (`chmod 700`, isi `Job started on ...`) berada di `~/cluster-project/scripts/run.sh`.
6. **File sisa latihan** (`week01/data/hello.txt`, `week01/results/`) bukan bagian deliverable Assignment 01.

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
└── scripts/
    └── run.sh          # permission 700
```

## Cara Menjalankan / Reproduksi

```bash
# 1. Clone repository (perlu dilakukan setelah repo di-push)
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

- GitHub: <https://github.com/zalhashfi/rizal-CSG-2026.git> (belum berisi commit)
