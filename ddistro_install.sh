#!/bin/bash

set -euo pipefail

cd /home/dwemer/piper
echo "Installing Piper-TTS."
echo "This will take a while so please wait."

python3 -m venv /home/dwemer/python-piper/

source /home/dwemer/python-piper/bin/activate

python -m pip install --upgrade pip setuptools wheel
python -m pip install 'piper-tts[http]'

./conf.sh

START_TARGET="$(readlink -f /home/dwemer/piper/start.sh)"
if [ "$START_TARGET" = "/home/dwemer/piper/start-piper-gpu.sh" ]; then
    python -m pip uninstall -y onnxruntime || true
    python -m pip install --upgrade --force-reinstall 'onnxruntime-gpu[cuda,cudnn]'
    echo "[OK] Piper-TTS installed for GPU / CUDA mode."
else
    if python -m pip show onnxruntime-gpu >/dev/null 2>&1; then
        python -m pip uninstall -y onnxruntime-gpu
        python -m pip install --upgrade --force-reinstall onnxruntime
    fi
    echo "[OK] Piper-TTS installed for CPU mode."
fi
