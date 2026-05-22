#!/usr/bin/env bash
detect_os() {
    case "$(uname -s)" in
        Linux)
            OS="linux"
            . /etc/os-release
            case "$ID" in
                ubuntu|debian|linuxmint|pop)      DISTRO="ubuntu" ; PKG_MGR="apt-get" ;;
                rhel|centos|rocky|alma|fedora)    DISTRO="rhel"   ; PKG_MGR="dnf" ;;
                *)                                DISTRO="$ID"    ; PKG_MGR="unknown" ;;
            esac
            ;;
        Darwin)
            OS="darwin" ; DISTRO="macos" ; PKG_MGR="brew" ;;
    esac
    export OS DISTRO PKG_MGR
}
