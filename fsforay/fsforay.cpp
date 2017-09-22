#include "fsforay.h"


class ProjectExecution {
  protected: // private -> failure for achieving Liskov principle
  int argc;
  char **argv;
  default_container<default_string> args;
  default_map<default_string, default_container<default_string> > args_structured;

  public:
  /*
  templates section.

  templates can't be virtual. therefore no full polymorphism/Liskov principle
  not achievable with these functions.
  */
  template <class CerrAble>  int cerr_something(CerrAble something)
  {
    std::cerr << something << std::endl;
    return 0;
  }


  template <class ostreamAble, class Ostream = std::ostream>  int ostream_something
    (ostreamAble something
      ,  Ostream &os = std::cout
    )
  /* and what if I could choose which stream to use instead of cerr?
     this function is a generalization of cerr_something.
     I templatize Ostream, instead of simply using std::ostream, so I can use this
     pattern with any kind of class that supports the << operator.
  */
  {
    os << something << std::endl;
    return 0;
  }


  template <class ElementsType, template <class , class > class Container>
  int cerr_container(Container<ElementsType, std::allocator<ElementsType> > container
      , bool size=true
      , int(ProjectExecution::*cerr_ElementsType)(ElementsType) = &ProjectExecution::cerr_something
      , int(ProjectExecution::*cerr_int)(int) = &ProjectExecution::cerr_something
    )
  /* example of how to get a generic container and iterate through it using
     a generic function reference, cerr_something by default.
     (and printing the size with a different version of that
     function)
     TODO: use std::function instead
  */
  {
    if (size) (*this.*cerr_int)(container.size());
    for(auto &item : container) {
      (*this.*cerr_ElementsType)(item);
    }
    return 0;
  }


  template <class ElementsType, template <class , class > class Container>
  ElementsType  pop_front
    (
      Container<ElementsType, std::allocator<ElementsType> > &container
      , ElementsType&(Container<ElementsType, std::allocator<ElementsType> >::*front_function)() = &Container<ElementsType, std::allocator<ElementsType> >::front
      , void(Container<ElementsType, std::allocator<ElementsType> >::*pop_front_function)() = &Container<ElementsType, std::allocator<ElementsType> >::pop_front
      , bool(Container<ElementsType, std::allocator<ElementsType> >::*empty_function)() const noexcept(true) = &Container<ElementsType, std::allocator<ElementsType> >::empty
    )
  /* 
   this function implements a fault-tolerant pop_front for Container<ElementsType> > (works even if containers are empty) 
   if ::back, ::pop_back are given instead, the function becomes  a fault-tolerant pop_back -- see test_pop_front for example
  */
  {
    ElementsType result;
    if (! (container.*empty_function)() ) {
      result =  (container.*front_function)();
      (container.*pop_front_function)();
    }
    return result;
  }


  auto cerr_function_name()
  /* note:
     it still  won't print the callee name, now still required copy and paste
     but i will figure out how.
     still a simple example of type agnostic function. With C++17 probably will
     be possible to do it fully, by getting arguments with auto (without having
     to typedef).
     a pity they can't also be virtualized (as far as I know), so again they
     will fail for the Liskov principle.
  */
  {
    std::cerr << __FUNCTION__ << std::endl;
    return __FUNCTION__;
  }


  /* concrete functions section */

  virtual int persist_args(int argc, char** argv)
  /*
    store argc and argv in this class, without consuming them.
    not really "persist"  as in disc.
  */
  {
    this->argc = argc;
    this->argv = argv;
    this->args = default_container<default_string>(argv + 1, argv + argc);
    return 0;
  }


  virtual default_map<default_string, default_container<default_string> > struct_container
    ( 
      default_container<default_string> container
    )
  /*
    stores container in a map of "--option" => container(value), and returns it.
    note: gets a copy of struct_container for simplyfing implementation. #optimization_possible
  */
  {
    default_string current_option("");
    default_map<default_string, default_container<default_string> > container_structured;
    while (!container.empty()) {
      auto element = this->pop_front<default_string, default_container>(args);
      if(boost::starts_with(element, "--")) {
        current_option = element;
      } else {
        container_structured[current_option].push_back(element);
      }
    }
    return container_structured;
  }


  virtual default_map<default_string, default_container<default_string> > struct_args()
  /*
    stores container in args_structured (a map of "--option" => container(value)), and returns it.
  */
  {
    this->args_structured = struct_container(this->args);
    return args_structured;
  }


  virtual ~ProjectExecution()
  {
    std::cerr << __FUNCTION__ << std::endl;
  }

  /* concrete functions section  -- functions for testing the class itself. */

  virtual int cerr_arguments(bool use_cerr=false)
  /*
    output parameters processed in args to cerr (by default, simpler
    example) or to cout.
  */
  {
    if (use_cerr) {
      this->cerr_container<default_string, default_container>(args);
    } else {
      auto l = [this] (default_string s) { 
        // unfortunately I can't use auto, must explicitly say default_string, maybe in C++17:
        this->ostream_something<default_string>(s);
      };
      // TODO: cout_something = l; // of course won't compile, because i am capturing this. how to do it?
      this->cerr_container<default_string, default_container>(args
        , true
        , &ProjectExecution::cerr_something  // TODO: should be cout_something
        , &ProjectExecution::cerr_something
      );
    }
    return 0;
  }


  virtual int test_pop_front()
  {
    auto result = 0;
    /* pop first argument */
    auto first_argument = this->pop_front<default_string, default_container>(args);
    cerr_something<default_string>("first_argument>");
    cerr_something<default_string>(first_argument);
    cerr_something<default_string>("first_argument<");

    /* pop last argument */
    cerr_something<default_string>("last_argument>");
    default_string&(default_container<default_string, std::allocator<default_string> >::*front_function)() =
      &default_container<default_string, std::allocator<default_string> >::back;
    void(default_container<default_string, std::allocator<default_string> >::*pop_front_function)() =
      &default_container<default_string, std::allocator<default_string> >::pop_back;
    bool(default_container<default_string, std::allocator<default_string> >::*empty_function)() const noexcept(true) =
      &default_container<default_string, std::allocator<default_string> >::empty;
    auto last_argument = this->pop_front<default_string, default_container>(args, front_function, pop_front_function, empty_function);
    cerr_something<default_string>(last_argument);
    cerr_something<default_string>("last_argument<");

    /* pop frist argument again -- it must be the second argument, if enough provided, or empty */
    auto first_argument_again = this->pop_front<default_string, default_container>(args);
    cerr_something<default_string>("first_argument_again>");
    cerr_something<default_string>(first_argument_again);
    cerr_something<default_string>("first_argument_again<");

    /* pop frist argument again -- it must be the third argument, if enough provided, or empty */
    auto first_argument_again_and_again = this->pop_front<default_string, default_container>(args);
    cerr_something<default_string>("first_argument_again_and_again>");
    cerr_something<default_string>(first_argument_again_and_again);
    cerr_something<default_string>("first_argument_again_again<");

    return result;
  }


  virtual int test_struct_args()
  {
    /* 
     */
    cerr_something<default_string>( __PRETTY_FUNCTION__);
    auto result = 0;
    auto args_structured = this->struct_args();

    cerr_something<default_string>("args_structured>");
    for (auto &item : args_structured) {
      cerr_something<default_string>("option>");
      cerr_something<default_string>(item.first);
      cerr_something<default_string>("option<");
      auto  local_results = item.second;
      cerr_something<default_string>("local_results>");
      this->cerr_container<default_string, default_container>(local_results);
      cerr_something<default_string>("local_results<");
    }
    cerr_something<default_string>("args_structured<");
    return result;
  }


  virtual int main(int argc, char** argv)
  {
    this->persist_args(argc, argv);
    this->cerr_arguments();
    this->test_struct_args();
    this->test_pop_front();
    /* just override main when deriving.
       call this one with ProjectExecution::main(argc, argv) */
    return 0;
  }

};



class FSForayExecution : public ProjectExecution {
  /* depends on filesystem */
  protected:
  /* default construction yields past-the-end: */
  filesystem_dep::directory_iterator end_directory_iterator; 

  public:

  /*
  templates section.

  templates can't be virtual. therefore no full polymorphism/Liskov principle
  not achievable with these functions.
  */


  /* concrete functions */
  virtual default_container<default_string>  subpaths(const default_path &path
      , default_int max_level =  10000 // ideally find out the "deepest level"
    )
  /* note: filesystem_dep::path dependent. */
  /* runs deep by max_level % current_level levels. */
  {
     default_container<default_string>  result;
     auto path_as_string = path.string();
     if (filesystem_dep::exists( path )) {
       result.push_back(path_as_string);
       if ( max_level == 0 ) {
         // level limited  or max level reached, finishing it up.
       }
       else {

         if (filesystem_dep::is_directory(path) ){
           /* the test for dir shouldn't be necessary if path_directory_iterator
              was fault tolerant. I need to test it only for avoiding an exception
              to throw.
              */

           /* unfortunately, no directory_iterator::end(), like ::path does
            fall back to old fashioned way of iterating: */
           filesystem_dep::directory_iterator path_directory_iterator(path_as_string); 
           for( ; path_directory_iterator !=  end_directory_iterator ; ++path_directory_iterator) {
             auto current_path = path_directory_iterator->path();
             //result.push_back(subpaths(current_path, max_level - 1));
             auto subresult = (subpaths(current_path, max_level - 1));
             result.insert(result.end(), subresult.begin(), subresult.end());
           }

         }
       }
     }
     else {
     }
     return result;
  }


  virtual default_container<default_string>  subpaths(const default_string &path_as_str
      , default_int max_level =  10000 // ideally find out the "deepest level"
    )
  {
     /* note: filesystem_dep::path dependent. */
     /* in this current implementation, this version is uneeded -- it's possible to convert directly from default_string to default_path. */
     default_container<default_string>  result;
     default_path path_converted(path_as_str);
     result = subpaths(path_converted, max_level);
     return result;
  }


  virtual default_string derive_string(const default_string &s, const default_ordered_manymap<default_string, default_string> &deriving_rules, bool rules_are_regex = false )
  {
    auto result = s;
    for (auto &item : deriving_rules)
    {
      if(rules_are_regex) {
        result = std::regex_replace(result, std::regex(item.first), item.second);
      }
    }
    return result;
  }


  virtual default_container<default_string> derive_strings(const default_container<default_string> &strings, const default_ordered_manymap<default_string, default_string> &deriving_rules, bool rules_are_regex = false )
  {
    default_container<default_string> result;
    for(auto &item: strings) {
      result.push_back(derive_string(item, deriving_rules, rules_are_regex));

    }
    return result;
  }


  virtual default_int remove_file(const default_string &path)
  /*
    fault tolerant version to filesystem_dep::remove()
  */
  {
    default_int result = 0;
    if(filesystem_dep::exists(path)) filesystem_dep::remove(path);
    return result;
  }


  virtual default_string write_file(const default_string &path
      , const default_string &contents
      , bool previous_remove=true
      , default_string return_text_if_non_open="FAILURE"
    )
  {
    /*
     fault tolerant - writes files either if exists or not.
     however, if previous_remove=false, the write may fail (TODO: when?)
     reads the contents of the file afterwards and returns it as receipt.
     */
    auto dirname = filesystem_dep::path(path).parent_path();
    filesystem_dep::create_directories(dirname);
    if(previous_remove) this->remove_file(path);
    std::ofstream file_stream(path);
    if (!file_stream.is_open()) {
      return return_text_if_non_open;
    }
    file_stream << contents;
    file_stream.close();
    auto result = this->get_existing_file_contents(path);
    return result;
  }


  virtual default_string get_existing_file_contents(const default_string &path)
  {
    /*
      note: no fault tolerance. call get_file_contents instead.
    */
    std::ifstream file_stream(path);
    std::stringstream string_stream;
    string_stream << file_stream.rdbuf();
    auto result = string_stream.str();
    file_stream.close();
    return result;
  }


  virtual default_string get_file_contents(const default_string &path)
  {
    /*
      fault tolerant (as any function not otherwise stated)
      => return empty string if file does not exist
    */
    bool return_empty_string = (! filesystem_dep::exists(path )) || filesystem_dep::is_directory(path);
    auto result = (return_empty_string ?  "" : get_existing_file_contents(path) );
    return result;
  }


  virtual default_string get_derived_file_contents(const default_string &original_path
      , const default_ordered_manymap<default_string, default_string> &deriving_rules
      , bool rules_are_regex = false
    )
  /*
     gets a copy of file contents, applies the rules, and then returns a default_string.
     note that the original file is untouched.
   */
  {
    default_string result;
    auto file_contents = get_file_contents(original_path);
    result = derive_string(file_contents, deriving_rules, rules_are_regex);
    return result;
  }


  virtual default_string derive_file_contents(const default_string &original_path
      , const default_string &destination_path
      , const default_ordered_manymap<default_string, default_string> &deriving_rules
      , bool rules_are_regex = false
    )
  /*
     derive the contents of the file at original_path with the &deriving_rules,
     and then writes the derived contents to  &destination_path.
   TODO: file permissions are not kept.
   */
  {
    default_string result("");
    if (filesystem_dep::is_directory(original_path) ){
      filesystem_dep::create_directories(destination_path);
    } else {
      auto derived_file_contents =  get_derived_file_contents(original_path
          , deriving_rules
          , rules_are_regex
        );
      result = write_file(destination_path, derived_file_contents);
    }
    return result;
  }


  virtual default_string derive_file(const default_string &original_path
      , const default_ordered_manymap<default_string, default_string> &deriving_rules
      , bool rules_are_regex = false
      , const default_string &destination_path_prefix = ""
    )
  /*
   derive both file path and contents given original_path. 
  */
  {
    default_string derived_path = derive_string(original_path, deriving_rules, rules_are_regex);
    auto result = derive_file_contents(original_path
        , (destination_path_prefix + derived_path)
        , deriving_rules
        , rules_are_regex
      );
    return result;
  }


  virtual default_string derive_file(const default_string &original_path
      , const default_ordered_manymap<default_string, default_string> &deriving_rules
      , const default_string &destination_path_prefix
      , bool rules_are_regex = false
    )
  /*
    same as derive_files before, just changing the order of parameters.
  */
  {
    return this->derive_file(original_path
        , deriving_rules
        , rules_are_regex
        , destination_path_prefix
      );
  }


  virtual default_container<default_string> derive_files(const default_container<default_string> &original_paths
      , const default_ordered_manymap<default_string , default_string> &deriving_rules
      , bool rules_are_regex = false
      , const default_string &destination_path_prefix = ""
    )
  /*
    same as derive_file, but takes a container of &original_paths (and returns a container of results)

    note that the container may contain 2 or more paths that will be squashed into one, after applying the rules. the
    natural order of iteration will make the last one overwrite the others.

    this function is useful for forking the files at original_paths into a destination_path_prefix. it will 
    recreate all the files containing strings in the first column of deriving_rules, with their respective 
    replacements (second column), at the &destination_path_prefix.

    a limitation of this function is that it is really for data duplication -- not data sharing between the elements
    in deriving_rules: if in original_paths there is a file supposed to be shared between
    the elements in the deriving_rules (e.g, the projects in the deriving_rules), the older project will be overwrite.

    so, in the case of forking paths under the same project, it is a good idea to use this function
    with &destination_path_prefix = "/tmp", eg, and check with diff if no important contents were removed afterwards.

    TODO: create a generic pattern for any function.
  */
  {
    default_container<default_string> result;
    for(auto &item: original_paths) {
      result.push_back(this->derive_file(item
          , deriving_rules
          , rules_are_regex
          , destination_path_prefix
        ));

    }
    return result;
  }

  virtual default_container<default_string> derive_files(const default_container<default_string> &original_paths
      , const default_ordered_manymap<default_string, default_string> &deriving_rules
      , const default_string &destination_path_prefix
      , bool rules_are_regex = false
    )
  /*
    same as derive_files before, just changing the order of parameters.
  */
  {
    return this->derive_files(original_paths
        , deriving_rules
        , rules_are_regex
        , destination_path_prefix
      );
  }


  virtual ~FSForayExecution()
  {
    std::cerr << __FUNCTION__ << std::endl;
  }


  /* concrete functions -- testing */


  virtual int test_subpaths()
  /*
    does a  "find"  on each of the arguments in the 
  */
  {
    cerr_something<default_string>( __PRETTY_FUNCTION__);
    auto result = 0;
    cerr_something<default_string>("args>");
    for ( auto &item : args) {  
      cerr_something<default_string>(item);
      auto local_results = this->subpaths(item);
      cerr_something<default_string>("local_results>");
      this->cerr_container<default_string, default_container>(local_results);
      cerr_something<default_string>("local_results<");
    }
    cerr_something<default_string>("args<");
    return result;
  }

  virtual int test_derive_strings()
  {
    /* 
       will derive strings given in args havin project1name to project2name, 
       using similar patterns.
     */
    cerr_something<default_string>( __PRETTY_FUNCTION__);
    auto result = 0;
    default_ordered_manymap<default_string, default_string> rules;
    rules.insert(std::make_pair("project1Name", "project2Name"));
    rules.insert(std::make_pair("project1name", "project2name"));
    rules.insert(std::make_pair("Project1Name", "Project1Name"));
    rules.insert(std::make_pair("Project1name", "Project1name"));
    rules.insert(std::make_pair("project1_name", "project2_name"));

    cerr_something<default_string>("args>");
    for ( auto &item : args) {  
      cerr_something<default_string>(item);
      /* dummy container -- just preserving the pattern */
      default_container<default_string> item_container;
      item_container.push_back(item);
      auto local_results = this->derive_strings(item_container, rules, false);
      cerr_something<default_string>("local_results>");
      this->cerr_container<default_string, default_container>(local_results);
      cerr_something<default_string>("local_results<");
    }
    cerr_something<default_string>("args<");
    return result;
  }


  virtual int test_derive_files()
  {
    /* 
       will fork the paths given in args having project1name to project2name, 
       using similar patterns.
       TODO: offer an interface to read the rules. Right now this is only
       useful by hardcoding this function with the desired rules.
     */
    cerr_something<default_string>( __PRETTY_FUNCTION__);
    auto result = 0;
    default_ordered_manymap<default_string, default_string> rules;

    rules.insert(std::make_pair("project1Name", "project2Name"));
    rules.insert(std::make_pair("project1name", "project2name"));
    rules.insert(std::make_pair("Project1Name", "Project1Name"));
    rules.insert(std::make_pair("Project1name", "Project1name"));
    rules.insert(std::make_pair("project1_name", "project2_name"));

    cerr_something<default_string>("args_subpaths>");
    for ( auto &item : args) {  
      cerr_something<default_string>("arg>");
      cerr_something<default_string>(item);
      cerr_something<default_string>("arg<");
      auto arg_subpaths = this->subpaths(item);
      auto derived_files = this->derive_files(arg_subpaths, rules, default_string("/tmp"), false);
      default_container<default_string> local_results;
      for (auto inner1_item: boost::combine(arg_subpaths, derived_files)) {
        default_string arg_subpath;
        default_string derived_file;
        boost::tie(arg_subpath, derived_file) = inner1_item;
        local_results.push_back(arg_subpath);
        local_results.push_back(derived_file);
      }
      cerr_something<default_string>("local_results>");
      this->cerr_container<default_string, default_container>(local_results);
      cerr_something<default_string>("local_results<");
    }
    cerr_something<default_string>("args_subpaths<");
    return result;
  }


  virtual int main(int argc, char** argv, default_bool call_super_main=false)
  {
    this->persist_args(argc, argv);
    auto super_result = (call_super_main? ProjectExecution::main(argc, argv) : 0 );
    auto result = super_result;
    result += test_subpaths();
    result += test_derive_strings();
    result += test_derive_files();
    return result;
  }


};


int main(int argc, char** argv)
{
  auto pe = std::make_shared<ProjectExecution>();
  auto fe = std::make_shared<FSForayExecution>();
  auto pe_result = ( argc > 0 ? pe->main(argc -0, argv) : -1 );
  auto fe_result = fe->main(argc, argv);
  auto result = fe_result + pe_result;
  return result;
}

