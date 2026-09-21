from node:12
run pwsh SOME_CMD | SOME_OTHER_CMD
shell [ "zsh", "-o","pipefail" ]
run zsh ./some_output | ./some_script
shell [ "/bin/bash", "-o","pipefail" ]
run [ "/bin/bash", "./some_output", "./some_script" ]

