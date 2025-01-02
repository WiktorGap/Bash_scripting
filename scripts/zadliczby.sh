#!/bin/bash

check_is_prime() {
    local num=$1
    if ((num <= 1)); then
        return 1
    fi
    for ((i = 2; i * i <= num; i++)); do
        if ((num % i == 0)); then
            return 1
        fi
    done
    return 0
}

prime_count=0

while true; do
    echo "Podaj liczbę: "
    read number

    if ((number == 0)); then
        echo "Program zakończony. Liczba liczb pierwszych: $prime_count"
        break
    fi

    if ((number > 0)); then
        if check_is_prime "$number"; then
            echo "$number" >> prime.txt
            ((prime_count++))
        fi
    fi

    if ((number < 0)); then
        local val=$(( -number ))
        echo "$val" >> abs.txt
    fi
done
