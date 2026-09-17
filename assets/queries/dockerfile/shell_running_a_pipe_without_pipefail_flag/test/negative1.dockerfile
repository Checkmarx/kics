FROM node:12
RUN pwsh SOME_CMD | SOME_OTHER_CMD
SHELL [ "zsh", "-o","pipefail" ]
RUN zsh ./some_output | ./some_script
SHELL [ "/bin/bash", "-o","pipefail" ]
RUN [ "/bin/bash", "./some_output", "./some_script" ]

