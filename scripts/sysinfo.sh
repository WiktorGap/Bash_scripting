#!/bin/bash

# Funkcje do uzyskiwania informacji
get_cpu() {
  awk -F': ' '/model name/ {print $2; exit}' /proc/cpuinfo
}

get_memory() {
  local total used
  total=$(free -m | awk '/Mem:/ {print $2}')
  used=$(free -m | awk '/Mem:/ {print $3}')

	if [ -z "$total" ]; then
		echo "Memory info is not aviabale"
		return
	fi

  local percent=$((100 * used / total))
  echo "$used / $total MiB ($percent%)"
}

get_load() {
  awk '{print $1", "$2", "$3}' /proc/loadavg
}

get_uptime() {
  awk '{print int($1/3600) " hour, " int(($1%3600)/60) " minutes"}' /proc/uptime
}

get_kernel() {
  uname -r
}

get_gpu() {
  lspci | grep -i 'vga' | awk -F': ' '{print $2}'
}

get_user() {
  whoami
}

get_shell() {
  basename "$SHELL"
}

get_processes() {
  ps -e --no-headers | wc -l
}

get_threads() {
  ps -eo nlwp --no-headers | awk '{sum += $1} END {print sum}'
}

get_ip() {
  ip -o -4 addr show | awk '{print $2, $4}'
}

get_dns() {
  awk '/nameserver/ {print $2}' /etc/resolv.conf
}

check_internet() {
  timeout 1 ping -c 1 8.8.8.8 &>/dev/null && echo "OK" || echo "Unavailable"
}

# Główna funkcja
show_info() {
  local argument=$1
  case "$argument" in
    cpu) echo "CPU: $(get_cpu)" ;;
    memory) echo "Memory: $(get_memory)" ;;
    load) echo "Load: $(get_load)" ;;
    uptime) echo "Uptime: $(get_uptime)" ;;
    kernel) echo "Kernel: $(get_kernel)" ;;
    gpu) echo "GPU: $(get_gpu)" ;;
    user) echo "User: $(get_user)" ;;
    shell) echo "Shell: $(get_shell)" ;;
    processes) echo "Processes: $(get_processes)" ;;
    threads) echo "Threads: $(get_threads)" ;;
    ip) echo "IP: $(get_ip)" ;;
    dns) echo "DNS: $(get_dns)" ;;
    internet) echo "Internet: $(check_internet)" ;;
    *) return 1 ;; # Niepoprawny argument
  esac
}

# Obsługa argumentów
if [[ $# -eq 0 ]]; then
  # Wyświetl wszystkie informacje
  echo "CPU: $(get_cpu)"
  echo "Memory: $(get_memory)"
  echo "Load: $(get_load)"
  echo "Uptime: $(get_uptime)"
  echo "Kernel: $(get_kernel)"
  echo "GPU: $(get_gpu)"
  echo "User: $(get_user)"
  echo "Shell: $(get_shell)"
  echo "Processes: $(get_processes)"
  echo "Threads: $(get_threads)"
  echo "IP: $(get_ip)"
  echo "DNS: $(get_dns)"
  echo "Internet: $(check_internet)"
else
  # Wyświetl wybrane informacje
  for arg in "$@"; do
    if ! show_info "$(echo "$arg" | tr '[:upper:]' '[:lower:]')"; then
      echo "Invalid argument: $arg" >&2
      exit 1
    fi
  done
fi

exit 0
