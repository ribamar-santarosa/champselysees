#include <iostream>
#include <deque>
#include <vector>
#include <memory>
#include <regex>
#include <map>
#include <fstream>
#include "boost/filesystem.hpp"
#include "boost/algorithm/string.hpp"
#include <boost/algorithm/string/replace.hpp>
#include <boost/range/combine.hpp>


namespace filesystem_dep = boost::filesystem; // tomorrow boost:: will be replaced by std::
/* later a better approach can be defined for template types: */
#define default_container std::deque 
/*
 weirdly, I can't define default_ordered_multimap -- it won't compile.
#define default_ordered_multimap std::multimap
 so I define as "manymap" instead
*/
#define default_ordered_manymap std::multimap
typedef std::string default_string;
typedef int  default_int;
typedef bool default_bool;
typedef filesystem_dep::path default_path;


