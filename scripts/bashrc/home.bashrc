# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions

export BASHRC_SCRIPT="${HOME}"/bin/scripts/bashrc/peddycoartte.bashrc
printf "Loading %s\n" "${BASHRC_SCRIPT}"
source "${BASHRC_SCRIPT}"



export FLT2_DIR="/home/peddycoartte/Software/flites/flites-2.2.0"
export FLT2_ARCH="linux-x64"
export FLT2_LIBRARY_DIR="/home/peddycoartte/Software/flites/flites-2.2.0/binaries/linux-x64/lib"
export FLT2_CXX11_ABI="0"
export PLPLOT_LIB="/home/peddycoartte/Software/flites/flites-2.2.0/binaries/linux-x64/ext/share/plplot5.13.0"
export __GL_SYNC_TO_VBLANK="0"
export PATH="/home/peddycoartte/Software/flites/flites-2.2.0/binaries/linux-x64/bin:$PATH"
export LD_LIBRARY_PATH="/home/peddycoartte/Software/flites/flites-2.2.0/binaries/linux-x64/lib:/home/peddycoartte/Software/flites/flites-2.2.0/binaries/linux-x64/ext/lib:$LD_LIBRARY_PATH"
