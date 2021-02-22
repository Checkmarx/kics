FROM node:12
RUN zsh ./some_output | ./some_script
RUN [ "/bin/bash", "./some_output", "|", "./some_script" ]