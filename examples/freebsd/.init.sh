# Get dependencies for rcorder-compatible scripts
task_dependencies() {
	local relation="$1"
	local task="$2"
	local action="$3"
	local path="$4"

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

	if [ -e "$path" ]; then
		task_dependencies_result=`awk '/^# '$section': /{for (i=3; i<=NF; ++i) { print $i }}' $path`
	else
		task_dependencies_result=
	fi
}

dependency_action() {
	run_rc_script $INIT_DIR/$1 $2
}
