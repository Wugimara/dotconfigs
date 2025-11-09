#!/usr/bin/env bash

# === GET ALL WORKSPACES ===
workspaces=$(swaymsg -t get_workspaces | awk -F'"' '/"name": "[1-9][0-9]"/ {print $4}')

# === GROUP BY COLUMN ===
declare -A col_rows
for ws in $workspaces; do
    col=${ws:0:1}
    row=${ws:1}
    col_rows[$col]="${col_rows[$col]} $row"
done

# === 1. NORMALIZE ROWS PER COLUMN (existing logic) ===
for col in "${!col_rows[@]}"; do
    IFS=' ' read -ra rows <<< "${col_rows[$col]}"
    # Sort
    for ((i=0; i<${#rows[@]}; i++)); do
        for ((j=i+1; j<${#rows[@]}; j++)); do
            [ "${rows[i]}" -gt "${rows[j]}" ] && \
                temp=${rows[i]}; rows[i]=${rows[j]}; rows[j]=$temp
        done
    done

    # Enforce row 1
    if [ "${rows[0]}" -ne 1 ]; then
        swaymsg rename workspace "${col}${rows[-1]}" to "${col}1" > /dev/null 2>&1
        rows[-1]=1
    fi

    # Pack rows
    for i in "${!rows[@]}"; do
        old=${rows[$i]}
        new=$((i + 1))
        [ "$old" -ne "$new" ] && \
            swaymsg rename workspace "${col}${old}" to "${col}${new}" > /dev/null 2>&1
    done
done

# === 2. NORMALIZE COLUMNS (NEW: pack columns globally) ===
active_cols=($(printf '%s\n' "${!col_rows[@]}" | sort -n))

# Enforce column 1 exists
if [ "${active_cols[0]}" -ne 1 ]; then
    old_col=${active_cols[-1]}
    for ws in $workspaces; do
        [[ $ws == ${old_col}* ]] && \
            swaymsg rename workspace "$ws" to "1${ws:1}" > /dev/null 2>&1
    done
fi

# Pack columns: remap to 1,2,3...
sorted_cols=($(printf '%s\n' "${active_cols[@]}" | sort -n))
for i in "${!sorted_cols[@]}"; do
    old_col=${sorted_cols[$i]}
    new_col=$((i + 1))
    if [ "$old_col" -ne "$new_col" ]; then
        for ws in $workspaces; do
            [[ $ws == ${old_col}* ]] && \
                swaymsg rename workspace "$ws" to "${new_col}${ws:1}" > /dev/null 2>&1
        done
    fi
done
