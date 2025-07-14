#!/usr/bin/env bash
#================================================================
#  pve-nonag-trigger.sh ─ Build & install a dpkg-trigger package
#                         that permanently removes the Proxmox
#                         "subscription nag" and re-applies the
#                         patch whenever proxmox-widget-toolkit
#                         is upgraded.
#
#  USAGE
#      sudo ./pve-nonag-trigger.sh # install / update
#      sudo ./pve-nonag-trigger.sh --uninstall # purge package
#================================================================

set -euo pipefail
IFS=$'\n\t'
readonly SELF="${0##*/}"
WORKDIR="$(mktemp -d)"
readonly WORKDIR
readonly PKGNAME='pve-nonag-trigger'
readonly VERSION='1.0'
readonly DEBDIR="$WORKDIR/$PKGNAME/DEBIAN"
readonly PREFIX="$WORKDIR/$PKGNAME/usr/local"
readonly PATCHER="$PREFIX/bin/pve-nonag-patch.sh"
readonly JS_DIR='/usr/share/javascript/proxmox-widget-toolkit'
readonly PATTERN='nag_screen_removed'

log()      { printf '%s %s\n' "$1" "$2"; }
log_ok()   { log '✓' "$1"; }
log_info() { log '-' "$1"; }
log_err()  { log '✗' "$1"; }
need_root()  { (( EUID == 0 )) || { log_err "Run $SELF as root"; exit 1; } }

#------------------------------------------------------#
#  Build package                                       #
#------------------------------------------------------#

build_pkg() {
  log_info "Building $PKGNAME $VERSION …"

  #── directory tree
  install -dm755 "$DEBDIR" "$PREFIX/bin"

  #── control
  cat > "$DEBDIR/control" <<EOF
Package: $PKGNAME
Version: $VERSION
Section: admin
Priority: optional
Architecture: all
Depends: proxmox-widget-toolkit (>= 1)
Maintainer: localhost <admin@host.local>
Description: Re-applies the Proxmox -subscription nag- patch after toolkit upgrades.
EOF

  #── triggers (fire on JS files)
  cat > "$DEBDIR/triggers" <<EOF
interest-noawait $JS_DIR/proxmoxlib.js
interest-noawait $JS_DIR/proxmoxlib.min.js
EOF

  #── postinst (run at configure & when trigger fires)
  cat > "$DEBDIR/postinst" <<'EOF'
#!/bin/sh
set -e
if [ "$1" = configure ] || [ "$1" = triggered ]; then
    /usr/local/bin/pve-nonag-patch.sh || true
fi
exit 0
EOF
  chmod 755 "$DEBDIR/postinst"

  #── patcher script (your verified sed logic)
  cat > "$PATCHER" <<'EOF'
#!/usr/bin/env bash
set -euo pipefail
PATTERN=nag_screen_removed
patch() {
  local file="$1" expr="$2"
  grep -qF "//$PATTERN" "$file" && return
  cp -n -- "$file" "${file}.backup"
  sed -i.backup -z "$expr" "$file"
  printf '\n//%s\n' "$PATTERN" >> "$file"
}
patch /usr/share/javascript/proxmox-widget-toolkit/proxmoxlib.js \
      "s@res === null || res === undefined || \\!res || res\n\t\t\t.data.status.toLowerCase() \\!== 'active'@false@g"
patch /usr/share/javascript/proxmox-widget-toolkit/proxmoxlib.min.js \
      's@null=\\!e||\\!e.data||\"active\"!==e.data.status.toLowerCase()@false@g'
EOF
  chmod 755 "$PATCHER"

  #── build .deb
  dpkg-deb --build "$WORKDIR/$PKGNAME" >/dev/null
  log_ok "Package built → $WORKDIR/${PKGNAME}.deb"
}

#------------------------------------------------------#
#  Install / configure package                         #
#------------------------------------------------------#

install_pkg() {
  log_info "Installing $PKGNAME …"
  dpkg -i "$WORKDIR/${PKGNAME}.deb" >/dev/null
  log_ok "Package installed"
  systemctl restart pveproxy.service
  log_ok "pveproxy.service restarted"
}

#------------------------------------------------------#
#  Self-test                                           #
#------------------------------------------------------#

self_test() {
  log_info "Self-test: reinstalling toolkit to trigger patch …"
  apt-get update -qq
  apt-get install --reinstall -qq proxmox-widget-toolkit

  for f in "$JS_DIR/proxmoxlib.js" "$JS_DIR/proxmoxlib.min.js"; do
      if grep -qF "//$PATTERN" "$f"; then
          log_ok "$(basename "$f") patched"
      else
          log_err "$(basename "$f") NOT patched"
          exit 1
      fi
  done
  log_ok "Trigger verified - nag cannot return."
}

#------------------------------------------------------#
#  Uninstall                                           #
#------------------------------------------------------#

uninstall_pkg() {
  log_info "Purging $PKGNAME …"
  apt-get purge -y "$PKGNAME" >/dev/null || true
  apt-get install --reinstall -qq proxmox-widget-toolkit
  systemctl restart pveproxy.service
  log_ok "Package removed; vendor files restored."
}

#------------------------------------------------------#
#  Main                                                #
#------------------------------------------------------#

need_root
case "${1:-}" in
  --uninstall)
        uninstall_pkg
        ;;
  "")
        build_pkg
        install_pkg
        self_test
        ;;
  *)
        log_err "Unknown option: $1  (only --uninstall)"; exit 1 ;;
esac
