# Get dependencies for rcorder-compatible scripts

task_dependencies() {
	local task=$1 relation=$2 action=$3
	local script section dependency dependencies
	task_dependencies_result=
	eval script=\$path_$task

	if [ -e $script ]; then
		case "$action" in
		start|faststart|quietstart)
			case "$relation" in
			wait) section="REQUIRE" ;;
			lead) section="BEFORE" ;;
			mark) section="PROVIDE" ;;
			esac
			;;
		stop|faststop)
			case "$relation" in
			wait) section="BEFORE" ;;
			lead) section="REQUIRE" ;;
			mark) section="PROVIDE" ;;
			esac
			;;
		esac

		dependencies=`awk '/^# '$section': /{for (i=3; i<=NF; ++i) { print $i }}' $script`
		for dependency in $dependencies; do
			task_internal $dependency
			task_dependencies_result="$task_dependencies_result $task_internal_result"
		done
	fi
}

# Get script path by task name and pass the path and the action to run_rc_script
task_execute() {
	eval run_rc_script \$path_$1 $2
}

