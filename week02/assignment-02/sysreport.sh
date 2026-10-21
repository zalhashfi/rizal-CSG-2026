#!/bin/bash
#
# sysreport.sh — laporan singkat kondisi sistem.
# Assignment 02 — Task 4 (CSG 2026)
#
# Penggunaan:
#   ./sysreport.sh                # output: report_<YYYY-MM-DD>.txt
#   ./sysreport.sh nama_file.txt  # output: nama_file.txt
#
# Exit code:
#   0 = laporan berhasil dibuat
#   1 = file output sudah ada

set -euo pipefail

# ---- Argument: nama file output (default report_<tanggal>.txt) ----
OUTPUT="${1:-report_$(date +%Y-%m-%d).txt}"

# ---- Validasi: jangan menimpa file yang sudah ada ----
if [[ -e "$OUTPUT" ]]; then
    echo "Error: file '${OUTPUT}' sudah ada. Hapus atau pilih nama lain." >&2
    exit 1
fi

# ---- Susun laporan ----
{
    echo "=============================================="
    echo " SYSTEM REPORT"
    echo "=============================================="
    echo "User       : $(whoami)"
    echo "Hostname   : $(hostname)"
    echo "Tanggal    : $(date '+%Y-%m-%d %H:%M:%S %Z')"
    # Baca nama distro tanpa `source` (shellcheck SC1091: file eksternal)
    echo "Distro     : $(grep -E '^PRETTY_NAME=' /etc/os-release | cut -d= -f2- | tr -d '"')"
    echo "Kernel     : $(uname -r)"
    echo "CPU core   : $(nproc)"
    echo
    echo "---- Memory ----"
    free -h
    echo
    echo "---- Disk home directory ----"
    df -h ~
    echo
    echo "---- 5 process teratas berdasarkan memory ----"
    ps aux --sort=-%mem | head -n 6
} > "$OUTPUT"

echo "Report saved to ${OUTPUT}"
