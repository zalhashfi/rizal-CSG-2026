# Rizal CSG 2026 — Comics Study Group

Repository personal untuk **Comics Study Group (CSG) 2026**. Isinya adalah hasil pengerjaan tugas mingguan seputar dasar-dasar Linux dan penggunaan command line (navigasi filesystem, manipulasi file, serta pengaturan permission).

Seluruh pengerjaan dilakukan **lewat terminal** (bukan file explorer) pada environment **WSL2** dengan distro **Ubuntu 22.04.5 LTS**.

> [!IMPORTANT]
> **Status repository: public, sudah di-push, deliverable Assignment 01 lengkap.** Seluruh task (Task 1–5, termasuk Self-Reflection dengan 5 butir jawaban) sudah terisi. Sisa pekerjaan bersifat opsional/kerapian saja dan dirinci di [Catatan Kondisi Saat Ini](#catatan-kondisi-saat-ini).

## Struktur Repository

```text
rizal-CSG-2026/
├── README.md
└── week01/
    ├── assignment-01/
    │   ├── answers.md        # jawaban Task 1–5 + Self-Reflection (5 butir)
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
| Task 4 | File Permission Challenge | ✅ selesai (termasuk `secret/` yang dikembalikan ke `755`) |
| Task 5 | Command Log | ✅ selesai |
| Task 5 | Self-Reflection (Lesson 01) | ✅ selesai (5 pertanyaan, masing-masing 3–5 kalimat) |
| — | Commit & push ke GitHub | ✅ selesai (`05dcf7a` add deliverables, `4a40367` update README) |
| Bonus | OverTheWire Bandit Level 0 → 5 | ⬜ belum dikerjakan |

## Catatan Kondisi Saat Ini

Seluruh deliverable wajib sudah terpenuhi. Yang tersisa hanya hal kecil/opsional:

1. **Path historis di `answers.md`.** Bagian Task 2 no. 5 dan Task 3 langkah 6 masih mencatat `~/comics-sg/week01/...`, yaitu lokasi repo saat assignment dikerjakan. Repo kini berada di `~/comics/rizal-CSG-2026/week01/...`; ini sengaja dibiarkan sebagai jejak kondisi asli saat pengerjaan.
2. **`week01/scripts/run.sh`** (permission `744`) adalah script latihan Guided Practice Lesson 01 (`echo "Script berjalan dari $(pwd)"`). Script yang diuji pada Task 4 (`chmod 700`, isi `Job started on ...`) berada di `~/cluster-project/scripts/run.sh` sesuai instruksi task yang memang menyuruh mengerjakan di direktori tersebut.
3. **File sisa latihan** (`week01/data/hello.txt`, `week01/results/`) bukan bagian deliverable Assignment 01, tetapi ikut ter-commit.
4. **Bonus Bandit Level 0 → 5** belum dikerjakan (opsional, +10%).

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
- Branch: `main` — `05dcf7a` (deliverables), `4a40367` (update README)
