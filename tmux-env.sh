#!/bin/bash

tmux new-session -s 'dev-env' -d 'vim .'

tmux split-window -h -l 30 'make run-dev'
tmux split-window -v 'make test-watch'
tmux select-pane -L

tmux -2 attach-session -d
