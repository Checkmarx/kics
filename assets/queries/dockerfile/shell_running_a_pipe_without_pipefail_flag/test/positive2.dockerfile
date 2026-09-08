from node:12
run zsh ./some_output | ./some_script
run [ "/bin/bash", "./some_output", "|", "./some_script" ]