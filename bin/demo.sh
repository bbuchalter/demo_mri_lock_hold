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

ruby_sleep_2_seconds() {
	PANE=$1
	tmux select-pane -t $PANE
	tmux send-keys -t $SESSION_NAME "time curl http://localhost:3000/ruby_sleep_2_seconds"  C-m C-m
}

c_sleep_2_seconds_with_gil() {
	PANE=$1
	tmux select-pane -t $PANE
	tmux send-keys -t $SESSION_NAME "time curl http://localhost:3000/c_sleep_2_seconds_with_gil"  C-m C-m
}

c_sleep_2_seconds_without_gil() {
	PANE=$1
	tmux select-pane -t $PANE
	tmux send-keys -t $SESSION_NAME "time curl http://localhost:3000/c_sleep_2_seconds_without_gil"  C-m C-m
}

cleanup() {
	tmux select-pane -t 0
	tmux send-keys -t $SESSION_NAME C-c C-m # kill rails server
	tmux kill-session -t $SESSION_NAME
	echo "Demo is done."
}

demo_loop() {
	clear
	echo "Which demo would you like?"
	echo "1) ruby_sleep_2_seconds && ruby_sleep_2_seconds"
	echo "2) c_sleep_2_seconds_with_gil && c_sleep_2_seconds_with_gil"
	echo "3) c_sleep_2_seconds_without_gil && c_sleep_2_seconds_without_gil"
	echo "4) c_sleep_2_seconds_without_gil && c_sleep_2_seconds_with_gil"
	echo "5) c_sleep_2_seconds_with_gil && c_sleep_2_seconds_without_gil"
	echo "9) exit"
	read -p "Choose number: " demo_number

	case $demo_number in
		"1")
			ruby_sleep_2_seconds "1"
			ruby_sleep_2_seconds "2"
			demo_loop
			;;
		"2")
			c_sleep_2_seconds_with_gil "1"
			c_sleep_2_seconds_with_gil "2"
			demo_loop
			;;
		"3")
			c_sleep_2_seconds_without_gil "1"
			c_sleep_2_seconds_without_gil "2"
			demo_loop
			;;
		"4")
			c_sleep_2_seconds_without_gil "1"
			c_sleep_2_seconds_with_gil "2"
			demo_loop
			;;
		"5")
			c_sleep_2_seconds_with_gil "1"
			c_sleep_2_seconds_without_gil "2"
			demo_loop
			;;
		"9")
			cleanup
			;;
		*)
			cleanup
			;;
	esac
}

main(){
	check_for_existing_tmux_session_and_kill
	setup_new_tmux_session
	demo_loop
}

main

