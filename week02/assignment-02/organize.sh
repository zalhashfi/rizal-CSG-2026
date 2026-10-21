#!/bin/bash
#
# organize.sh — menyiapkan struktur direktori untuk simulasi parameter sweep.
# Assignment 02 — Task 5 (CSG 2026)
#
# Penggunaan:
#   ./organize.sh <nama_eksperimen> <jumlah_run>
#
# Contoh:
#   ./organize.sh sweep_test 3
#   -> sweep_test/T100/run_01/params.txt ... dst
#
# Exit code:
#   0 = berhasil
#   1 = argument kurang
#   2 = jumlah_run bukan bilangan bulat positif

set -euo pipefail

# ---- Validasi jumlah argument ----
if [[ $# -lt 2 ]]; then
    echo "Usage: $0 <nama_eksperimen> <jumlah_run>" >&2
    exit 1
fi

EXP_NAME="$1"
NUM_RUN="$2"

# ---- Validasi: NUM_RUN harus bilangan bulat positif ----
if [[ ! "$NUM_RUN" =~ ^[0-9]+$ ]] || (( NUM_RUN < 1 )); then
    echo "Error: <jumlah_run> harus bilangan bulat positif, bukan '${NUM_RUN}'." >&2
    exit 2
fi

# ---- Daftar temperature yang diuji ----
TEMPERATURES=(100 200 300)

TIMESTAMP="$(date '+%Y-%m-%d %H:%M:%S')"

# ---- Buat struktur direktori ----
for temp in "${TEMPERATURES[@]}"; do
    for (( run = 1; run <= NUM_RUN; run++ )); do
        run_label="$(printf '%02d' "$run")"
        run_dir="${EXP_NAME}/T${temp}/run_${run_label}"

        mkdir -p "$run_dir"

        # Tulis parameter eksperimen di setiap run
        {
            echo "experiment=${EXP_NAME}"
            echo "temperature=${temp}"
            echo "run=${run_label}"
            echo "created=${TIMESTAMP}"
        } > "${run_dir}/params.txt"
    done
done

# ---- Ringkasan ----
dir_count="$(find "$EXP_NAME" -type d | wc -l)"
file_count="$(find "$EXP_NAME" -name 'params.txt' | wc -l)"

echo "Eksperimen : ${EXP_NAME}"
echo "Temperature: ${TEMPERATURES[*]}"
echo "Jumlah run : ${NUM_RUN}"
echo "Direktori  : ${dir_count} (termasuk direktori induk)"
echo "params.txt : ${file_count}"
