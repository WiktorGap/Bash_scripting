#!/bin/bash

if [ "$#" -lt 1 ]; then
    echo "Użycie: $0 katalog1 [katalog2 ...]"
    exit 1
fi

tmp_dir=$(mktemp -d)
echo "Utworzono katalog tymczasowy: $tmp_dir"

start=$(date +%s.%N)

for dir in "$@"; do
    if [ ! -d "$dir" ]; then
        echo "Błąd: katalog $dir nie istnieje"
        continue
    fi

    arch="$tmp_dir/$(basename "$dir").tar"
    tar cvf "$arch" "$dir" > /dev/null
done

end=$(date +%s.%N)

result=$(echo "$end - $start" | bc -l)
echo "Czas tworzenia archiwów tar: $result"

compressor=("gzip -k" "bzip2 -k" "xz -k" "zstd -k" "lz4 -k" "7z a -t7z")
decompressor=("gzip -d" "bzip2 -d" "xz -d" "zstd -d" "lz4 -d" "7z x")

for dir in "$@"; do
    if [ ! -d "$dir" ]; then
        continue
    fi

    arch="$tmp_dir/$(basename "$dir").tar"
    original_size=$(stat --printf="%s" "$arch")

    echo -e "\n$dir"
    echo -e "name\tcompress\tdecompress\tratio"

    for i in "${!compressor[@]}"; do
        comp_cmd="${compressor[$i]}"
        decomp_cmd="${decompressor[$i]}"
        comp_file="$arch.compressed"

        comp_start=$(date +%s.%N)
        eval "$comp_cmd $arch > $comp_file"
        comp_end=$(date +%s.%N)
        comp_time=$(echo "$comp_end - $comp_start" | bc -l)

        comp_size=$(stat --printf="%s" "$comp_file")

        decomp_start=$(date +%s.%N)
        eval "$decomp_cmd $comp_file > /dev/null"
        decomp_end=$(date +%s.%N)
        decomp_time=$(echo "$decomp_end - $decomp_start" | bc -l)

        ratio=$(echo "scale=2; $comp_size / $original_size * 100" | bc -l)

        printf "%s\t%.6f\t%.6f\t%.2f%%\n" "${comp_cmd%% *}" "$comp_time" "$decomp_time" "$ratio"

        rm -f "$comp_file"
    done

    rm -f "$arch"
done

rm -rf "$tmp_dir"
exit 0
