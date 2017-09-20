# vim: noexpandtab
# don't use "" for Makefiles.
# ensure what's before g++ is actually a tab.
BOOST_FS_DEPS=-lboost_filesystem
BOOST_DEPS=-lboost_system ${BOOST_FS_DEPS}
FLAGS=-fmax-errors=2
STD_DEPS=-std=c++11
default: fsforay.cpp
	g++ -o fsforay fsforay.cpp -I.  ${FLAGS}  ${STD_DEPS} ${BOOST_DEPS}
