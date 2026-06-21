SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
echo $SCRIPT_DIR
export PATH=${SCRIPT_DIR}:${SCRIPT_DIR}/third-party/bin:${SCRIPT_DIR}/third-party/verilator/bin:${SCRIPT_DIR}/third-party/bin:$PATH
