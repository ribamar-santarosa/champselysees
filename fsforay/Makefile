# vim: noexpandtab
# don't use "" for Makefiles.
# ensure what's before g++ is actually a tab.
BOOST_FS_DEPS=-lboost_filesystem
BOOST_DEPS=-lboost_system ${BOOST_FS_DEPS}
FLAGS=-fmax-errors=1
STD_DEPS=-std=c++11
COMPILE_LINE_STD=g++ -o fsforay fsforay.cpp -I.  ${FLAGS}  ${STD_DEPS} ${BOOST_DEPS}
COMPILE_LINE_NO_STD=g++ -o fsforay fsforay.cpp -I.  ${FLAGS} ${BOOST_DEPS}
COMPILE_LINE=${COMPILE_LINE_STD} || ${COMPILE_LINE_NO_STD}
default: fsforay.cpp
	${COMPILE_LINE}
