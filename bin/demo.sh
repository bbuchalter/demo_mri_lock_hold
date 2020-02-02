#!/usr/bin/env bash
set -euo pipefail
SESSION_NAME="gil_demo"

## FUNCTIONS HERE, MAIN PROGRAM BELOW

check_for_existing_tmux_session_and_kill() {
	if [[ "$(tmux has-session -t ${SESSION_NAME}; echo $?)" == 0 ]] # no session found
	then
		echo "Found existing tmux session. Cleaning it up."
		cleanup
	fi
}

setup_new_tmux_session() {
	tmux new-session -s ${SESSION_NAME} -n shell -d
	tmux split-pane -v
	tmux split-pane -v
	tmux select-pane -t 0
	tmux send-keys -t $SESSION_NAME "bin/rails s"  C-m
	echo "Demo ready to start. Connect to tmux session in new terminal with command: 'tmux attach-session -t $SESSION_NAME'"
	read -p "Press enter here when ready" ready
}

ruby_sleep_2_seconds_ruby_sleep_2_seconds() {
	tmux select-pane -t 1
	tmux send-keys -t $SESSION_NAME "time curl http://localhost:3000/ruby_sleep_2_seconds"  C-m
	tmux select-pane -t 2
	tmux send-keys -t $SESSION_NAME "time curl http://localhost:3000/ruby_sleep_2_seconds"  C-m
}

cleanup() {
	tmux select-pane -t 0
	tmux send-keys -t $SESSION_NAME C-c C-m # kill rails server
	tmux kill-session -t $SESSION_NAME
	echo "Demo is done."
}

demo_loop() {
	echo "Which demo would you like?"
	echo "1) ruby_sleep_2_seconds && ruby_sleep_2_seconds"
	echo "9) exit"
	read -p "Choose number: " demo_number

	case $demo_number in
		"1")
			ruby_sleep_2_seconds_ruby_sleep_2_seconds
			demo_loop
			;;
		"9")
			cleanup
			;;
		*)
	esac
}

main(){
	check_for_existing_tmux_session_and_kill
	setup_new_tmux_session
	demo_loop
}

main

