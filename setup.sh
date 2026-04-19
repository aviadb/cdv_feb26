#!/bin/bash

set -e


# sudo apt-get install git help2man perl python3 make
# sudo apt-get install g++  # Alternatively, clang
# sudo apt-get install libgz  # Non-Ubuntu (ignore if gives error)
# sudo apt-get install libfl2  # Ubuntu only (ignore if gives error)
# sudo apt-get install libfl-dev  # Ubuntu only (ignore if gives error)
# sudo apt-get install zlibc zlib1g zlib1g-dev  # Ubuntu only (ignore if gives error)
# sudo apt-get install z3  # Optional solver
# sudo apt-get install perl-doc
# sudo apt-get install ccache  # If present at build, needed for run
# sudo apt-get install mold  # If present at build, needed for run
# sudo apt-get install libgoogle-perftools-dev numactl
# sudo apt-get install git autoconf flex bison
# sudo apt-get install clang clang-format-18 cmake gdb gprof graphviz lcov
# sudo apt-get install python3-clang bear jq
# cpan install Pod::Perldoc

ROOT_DIR=`pwd`

SYNC_MODE="remote"
CLEAN_BUILD=0

for arg in "$@"; do
  case $arg in
    --local)
      SYNC_MODE="local"
      shift
      ;;
    --remote)
      SYNC_MODE="remote"
      shift
      ;;
    --clean)
      CLEAN_BUILD=1
      shift
      ;;
    *)
      # # If it's not a flag, assume it's the target directory
      # REPO_DIR="$arg"
      shift
      ;;
  esac
done

TOOL_DIR="$ROOT_DIR/third-party/verilator"
HASH_FILE="$TOOL_DIR/.last_built_commit"

if [ -d "$TOOL_DIR" ] && [ -f "$TOOL_DIR/.git" ]; then
  cd "$TOOL_DIR"
  if [ "$SYNC_MODE" == "remote" ]; then
    CURRENT_HASH=$(git ls-remote origin HEAD | awk '{print $1}')
  else
    CURRENT_HASH=$(git rev-parse HEAD)
  fi
  
  if [ -f "$HASH_FILE" ]; then
    LAST_BUILT_HASH=$(cat "$HASH_FILE")
  else
    LAST_BUILT_HASH=""
  fi

  echo "Head hash: $CURRENT_HASH , Last build hash: $LAST_BUILT_HASH"

  if [[ "$CURRENT_HASH" != "$LAST_BUILT_HASH" || "$CLEAN_BUILD" == "1" ]]; then
    echo "Updating build for Verilator (Commit: ${CURRENT_HASH:0:7})..."
    git fetch
    git checkout "$CURRENT_HASH"
    autoconf
    ./configure
    # code Makefile
    if [[ "$CLEAN_BUILD" == "1" ]]; then
      make clean
    fi
    make -j$(nproc)

    ./bin/verilator --version

    echo "$CURRENT_HASH" > "$HASH_FILE"
    echo "Build successful. Hash saved."
  else
    echo "No changes in Verilator. Skipping build."
  fi

else
  echo "Error: Submodule $TOOL_DIR not found."
fi

# cd $ROOT_DIR/third-party/verilator/
# autoconf
# ./configure
# code Makefile
# make -j$(nproc)



cd $ROOT_DIR



git submodule update --init --recursive
make -j4 -C lib/cbmc/src minisat2-download
make -j4 -C src