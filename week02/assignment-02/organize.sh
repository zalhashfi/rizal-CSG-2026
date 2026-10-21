#!/bin/bash
#
# organize.sh — menyiapkan struktur direktori untuk simulasi parameter sweep.
# Assignment 02 — Task 5 (CSG 2026), termasuk bonus -h/--help dan temperature custom.
#
# Penggunaan:
#   ./organize.sh <nama_eksperimen> <jumlah_run> [temperature ...]
#   ./organize.sh -h | --help
#
# Contoh:
#   ./organize.sh sweep_test 3
#       -> sweep_test/T100/run_01 .. T300/run_03/params.txt
#   ./organize.sh exp 3 50 150 250
#       -> exp/T50/run_01 .. exp/T250/run_03/params.txt
#
# Exit code:
#   0 = berhasil
#   1 = argument kurang
#   2 = jumlah_run bukan bilangan bulat positif
#   3 = temperature tidak valid

set -euo pipefail

# ---- Temperature default bila tidak diberikan ----
DEFAULT_TEMPERATURES=(100 200 300)

# ---- Tampilkan bantuan ----
usage() {
    cat <<EOF
Penggunaan: ${0##*/} <nama_eksperimen> <jumlah_run> [temperature ...]

Menyiapkan struktur direktori untuk simulasi parameter sweep.

Argument:
  <nama_eksperimen>   nama direktori eksperimen (dibuat bila belum ada)
  <jumlah_run>        bilangan bulat positif, jumlah run per temperature
  [temperature ...]   daftar temperature; default: ${DEFAULT_TEMPERATURES[*]}

Opsi:
  -h, --help          tampilkan bantuan ini lalu keluar

Contoh:
  ${0##*/} sweep_test 3
  ${0##*/} exp 2 50 150 250

Exit code:
  0 berhasil · 1 argument kurang · 2 jumlah_run tidak valid · 3 temperature tidak valid
EOF
}

# ---- Opsi bantuan ----
case "${1:-}" in
    -h|--help)
        usage
        exit 0
        ;;
esac

# ---- Validasi jumlah argument ----
if [[ $# -lt 2 ]]; then
    usage >&2
    exit 1
fi

EXP_NAME="$1"
NUM_RUN="$2"
shift 2

# ---- Validasi: NUM_RUN harus bilangan bulat positif ----
if [[ ! "$NUM_RUN" =~ ^[0-9]+$ ]] || (( NUM_RUN < 1 )); then
    echo "Error: <jumlah_run> harus bilangan bulat positif, bukan '${NUM_RUN}'." >&2
    exit 2
fi

# ---- Validasi: EXP_NAME tidak boleh kosong ----
if [[ -z "$EXP_NAME" ]]; then
    echo "Error: <nama_eksperimen> tidak boleh kosong." >&2
    exit 1
fi

# ---- Daftar temperature: argument sisa, atau default ----
if [[ $# -gt 0 ]]; then
    TEMPERATURES=("$@")
else
    TEMPERATURES=("${DEFAULT_TEMPERATURES[@]}")
fi

# ---- Validasi setiap temperature ----
for temp in "${TEMPERATURES[@]}"; do
    if [[ ! "$temp" =~ ^[0-9]+$ ]]; then
        echo "Error: temperature '${temp}' bukan bilangan bulat non-negatif." >&2
        exit 3
    fi
done

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
echo "Direktori  : ${dir_count} (termasuk direktori eksperimen)"
echo "params.txt : ${file_count}"
