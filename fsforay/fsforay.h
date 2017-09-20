#include <iostream>
#include <deque>
#include <vector>
#include <memory>
#include "boost/filesystem.hpp"

namespace filesystem_dep = boost::filesystem; // tomorrow boost:: will be replaced by std::
#define default_container std::deque // later a better approach can be defined
typedef std::string default_string;
typedef int  default_int;
typedef bool default_bool;
typedef filesystem_dep::path default_path;


