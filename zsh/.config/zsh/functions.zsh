cl() { cd "${1:-$HOME}" && l } # cd + ls
mkcd() { mkdir -p "$1" && cd "$1" } 

# Backs up files into .bak/, preserving attributes
# output: .sndrc.2026-07-03-143205.bak
backup() {
    local dir=".bak"
    local timestamp
    timestamp="$(date +%F-%H%M%S)"

    if [[ $# -eq 0 ]]; then
        echo "Usage: backup <file1> [file2 ...]"
        return 1
    fi

    mkdir -p "$dir"

    for file in "$@"; do
        if [[ ! -f "$file" ]]; then
            echo "Skipping (not found): $file"
            continue
        fi
        cp -p -- "$file" "$dir/$(basename "$file").${timestamp}.bak"
        echo "Backed up: $file -> $dir/$(basename "$file").${timestamp}.bak"
    done
}

# Go up N directories (up 3)
up() {
    local n=${1:-1}
    while ((n--)); do
        cd .. || return
    done
}

# Search process
pc() {
    ps -ef | grep -i "$1" | grep -v grep
}

# Extract almost anything
extract() {
    case "$1" in
        *.tar.bz2) tar xjf "$1" ;;
        *.tar.gz)  tar xzf "$1" ;;
        *.bz2)     bunzip2 "$1" ;;
        *.gz)      gunzip "$1" ;;
        *.tar)     tar xf "$1" ;;
        *.tbz2)    tar xjf "$1" ;;
        *.tgz)     tar xzf "$1" ;;
        *.zip)     unzip "$1" ;;
        *.7z)      7z x "$1" ;;
        *) echo "Don't know how to extract $1" ;;
    esac
}