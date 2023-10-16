#!/bin/bash
source_directory=$(realpath $(dirname "$BASH_SOURCE"))

# =================================================================================================
# Parse CLI arguments.
# https://gist.github.com/cosimo/3760587
# =================================================================================================
function print_help_and_exit() {
  echo \
"
Usage: $0 [options]

Options:
  -h, --help                print this help message
  -y, --skip-confirm        skip confirmation prompts
  -f, --force-tool-install  force tool installations
  -u, --unbundle-appimages  force unbundle appimage executables
  -p PREFIX_DIR, --prefix-dir PREFIX_DIR
                            tools install prefix directory (default: \$HOME/.local)
  -t TMP_DIR, --tmp-dir TMP_DIR
                            tmp directory for temporaily stored download files (default: /tmp/dotfiles)
"
  exit 1
}

TEMP=`getopt -o hyfup:t: \
  --long \
    help,skip-confirm,force-tool-install,unbundle-appimages,prefix-dir:,tmp-dir: -n "$0" -- "$@"`

if [ $? != 0 ]; then
  print_help_and_exit
fi

eval set -- "$TEMP"

SKIP_CONFIRM=false
FORCE_TOOL_INSTALL=false
UNBUNDLE_APPIMAGES=false
INSTALL_PREFIX=${HOME}/.local
TMP_DIR=/tmp/dotfiles

while true; do
  case "$1" in
    -h | --help )
      print_help_and_exit
      shift;;
    -y | --skip-confirm )
      SKIP_CONFIRM=true
      shift;;
    -f | --force-tool-install )
      FORCE_TOOL_INSTALL=true
      shift;;
    -u | --unbundle-appimages )
      UNBUNDLE_APPIMAGES=true
      shift;;
    -p | --prefix-dir )
      INSTALL_PREFIX="$2";
      shift 2;;
    -t | --tmp-dir )
      TMP_DIR="$2";
      shift 2;;
    -- )
      shift;
      break;;
    * )
      echo "$1 is not a valid option"
      print_help_and_exit
  esac
done
# =================================================================================================

mkdir -p $INSTALL_PREFIX/share/fonts
mkdir -p $INSTALL_PREFIX/bin
mkdir -p $TMP_DIR

function wait_user_confirmation() {
  if [ "$SKIP_CONFIRM" = "true" ]; then
    return 0
  fi

  echo $1

  PROMPT="Enter 'y' to confirm: (Ctrl-C to cancel) "
  read -p "$PROMPT" input

  while [[ $input != "y" ]]; do
      read -p "$PROMPT" input
  done
}

if [ ! -d $INSTALL_PREFIX/share/base16-shell ]; then
  wait_user_confirmation "Install base16-shell into '$INSTALL_PREFIX'?"

  git clone https://github.com/chriskempson/base16-shell \
    $INSTALL_PREFIX/share/base16-shell || exit 1
fi

function nvim_install_unbundled_appimage() {
  wait_user_confirmation "Extract the appimage?"

  cd $TMP_DIR && $TMP_DIR/nvim.appimage --appimage-extract || exit 1
  cd -;
  $TMP_DIR/squashfs-root/usr/bin/nvim --version &> /dev/null

  if [ $? != 0 ]; then
    echo "unbundled NVIM is also unexecutable. aborting..."
    exit 1
  fi

  echo "Unbundled NVIM version:"
  $TMP_DIR/squashfs-root/usr/bin/nvim --version

  wait_user_confirmation "Install unbundled files into '$INSTALL_PREFIX'?"

  rsync -r $TMP_DIR/squashfs-root/usr/* $INSTALL_PREFIX/ || exit 1

  rm $TMP_DIR/nvim.appimage
  rm -rf $TMP_DIR/squashfs-root
}

if [ "$FORCE_TOOL_INSTALL" = true ] || [ ! -f $INSTALL_PREFIX/bin/nvim ]; then
  wait_user_confirmation "Install NVIM into '$INSTALL_PREFIX'?"

  wget -O $TMP_DIR/nvim.appimage \
    https://github.com/neovim/neovim/releases/download/stable/nvim.appimage || exit 1
  chmod u+x $TMP_DIR/nvim.appimage && $TMP_DIR/nvim.appimage --version &> /dev/null

  if [ $? != 0 ]; then
    echo "NVIM appimage is unable to execute"
    nvim_install_unbundled_appimage
  elif [ "$UNBUNDLE_APPIMAGES" = true ]; then
    nvim_install_unbundled_appimage
  else
    mv $TMP_DIR/nvim.appimage $INSTALL_PREFIX/bin/nvim || exit 1
  fi
fi

PACKER_DIR=$INSTALL_PREFIX/share/nvim/site/pack/packer/start/packer.nvim
if [ "$FORCE_TOOL_INSTALL" = true ] || [ ! -d $PACKER_DIR ]; then
  wait_user_confirmation "Install packer.nvim into '$INSTALL_PREFIX'?"

  rm -rf $PACKER_DIR || exit 1
  git clone --depth 1 https://github.com/wbthomason/packer.nvim $PACKER_DIR
fi

HACK_NERD_FONTS=$(find $INSTALL_PREFIX/share/fonts -type f -name "HackNerdFont*.ttf")
if [ "$FORCE_TOOL_INSTALL" = true ] || [[ -z "$HACK_NERD_FONTS" ]]; then
  wait_user_confirmation "Install Hack Nerd fonts into '$INSTALL_PREFIX'?"

  wget -O $TMP_DIR/Hack.zip \
    https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.2/Hack.zip || exit 1
  cd $TMP_DIR && mkdir -p Hack && unzip Hack.zip -d $TMP_DIR/Hack || exit 1
  cd -

  rsync -r $TMP_DIR/Hack/*.ttf $INSTALL_PREFIX/share/fonts/ || exit 1

  rm $TMP_DIR/Hack.zip
  rm -rf $TMP_DIR/Hack
fi

wait_user_confirmation "Update ~/.config/nvim?"
rsync -r $source_directory/nvim $HOME/.config

wait_user_confirmation "Update tmux.conf?"
cp $source_directory/tmux.conf $HOME/.tmux.conf
