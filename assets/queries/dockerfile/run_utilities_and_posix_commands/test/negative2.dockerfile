from ubuntu
run apt-get update && apt-get install -y x11vnc xvfb firefox
run mkdir ~/.vnc
run x11vnc -storepasswd 1234 ~/.vnc/passwd
run bash -c 'echo "firefox" >> /.bashrc'
run apt-get install nano vim
expose 5900
cmd    ["x11vnc", "-forever", "-usepw", "-create"]
