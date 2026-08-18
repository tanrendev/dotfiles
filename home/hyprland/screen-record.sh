if pkill -INT gpu-screen; then
  exit 0
fi
mkdir -p ~/Videos
gpu-screen-recorder -w screen -a default_output -o ~/Videos/"$(date +%Y%m%d-%H%M%S)".mp4
