#!/bin/bash
# devenv_precmd
source $(realpath "$HOME/.devenv.sources.sh")

echo "Testing: common.functions.test.sh"

test_process_args3() {
	echo "Should reflect in extract_test_functions list"
}

test_process_args2() {
	echo "Should reflect in extract_test_functions list"
}

test_process_args() {
	log_info "Testing 'process_args' function"
    local requested_vars=("var1" "var2" "var3" "var4")
    local args=("$@")
	args=("-var1:\"var1 data\"" \
		"--var2:\"var2 data\"" \
		"--var3=\"var3 data\"" \
		"--var4=\"var4 data\"" \
		"-a" "-r" "-g" "-s")
	local expected_remaining_args=("-a" "-r" "-g" "-s")
    declare -A result
    declare -a remaining_parameters

	IFS=','; joined_string="${args[*]}"; unset IFS
	echo "Passed Arguments: ($joined_string)"

    process_args result remaining_parameters requested_vars[@] "${args[@]}"

    echo "Request Parameters:"
    for key in "${!result[@]}"; do
        echo "$key: ${result[$key]}"
    done

    echo "Remaining Parameters:"
    for param in "${remaining_parameters[@]}"; do
        echo "$param"
    done

	local has_error=false

	echo "Checking vars 1-4..."
	for i in {1..4}; do
		local var_key="var$i"
		result_var="${result[$var_key]}"
		# Remove leading and trailing double quotes
		result_var="${result_var#\"}"
		result_var="${result_var%\"}"

		if [ ! "$result_var" = "var$i data" ]; then
			has_error=true
		fi
	done

	echo "Checking expected_remaining_args..."
	# # Test failure!
	# expected_remaining_args=("-a" "-r" "-g" "-s" "--f")
    for param in "${expected_remaining_args[@]}"; do
        if ! in_array "$param" "${remaining_parameters[@]}"; then
			has_error=true
		fi
    done

	if $has_error; then
		log_error "Status: Failed"
	else
		log_success "Status: Passed"
	fi
}

# ===========================================
# run_all_tests
# ===========================================
this_file="$PATH_DEVENV/common/tests/common.functions.test.sh"
if [ ! -f "$this_file" ]; then
	echo "Error: File '$this_file' does not exist or is not readable."
	exit 1
fi

list=($(extract_test_functions "$this_file"))
# Get all functions starting with 'test_'
# for commonfunc in $(declare -F | awk '{print $3}' | grep -E '^test_'); do
for func in "${list[@]}"; do
	# Call the function
	$func
done