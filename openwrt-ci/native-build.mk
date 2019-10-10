HELP += "ci-native-scan-build		build with clang's static analyzer\n"
ci-native-scan-build:
	$(call cmake_build_debug,scan-build -v --status-bugs -o scan)
	$(call cmake_build_release,scan-build -v --status-bugs -o scan)

HELP += "ci-native-cppcheck		build with cppcheck static analyzer\n"
ci-native-cppcheck:
	cppcheck --version
	cppcheck $(CI_CPPCHECK_EXTRA_ARGS) --force --error-exitcode=1 .

HELP += "ci-native-build		build with gcc $(CI_GCC_VERSION_LIST) and clang $(CI_CLANG_VERSION_LIST)\n"
ci-native-build:
	cmake --version
	for v in $(CI_GCC_VERSION_LIST); do \
		$(call cmake_build_debug,CC=gcc-$$v) ; \
		$(call cmake_build_release,CC=gcc-$$v) ; \
	done
	for v in $(CI_CLANG_VERSION_LIST); do \
		$(call cmake_build_debug,CC=clang-$$v CXX=clang-$$v) ; \
		$(call cmake_build_release,CC=clang-$$v CXX=clang-$$v) ; \
	done

HELP += "ci-native-checks		run complete suite of native checks\n"
ci-native-checks: \
		ci-native-scan-build \
		ci-native-cppcheck \
		ci-native-build
