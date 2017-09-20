#include "fsforay.h"


class ProjectExecution {
  protected: // private -> failure for achieving Liskov principle
  int argc;
  char **argv;
  std::vector<std::string> args;

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

  virtual int cerr_arguments(bool use_cerr=false)
  /*
    output parameters processed in args to cerr (by default, simpler
    example) or to cout.
  */
  {
    if (use_cerr) {
      this->cerr_container<std::string, std::vector>(args);
    } else {
      auto l = [this] (std::string s) { 
        // unfortunately I can't use auto, must explicitly say std::string, maybe in C++17:
        this->ostream_something<std::string>(s);
      };
      // TODO: cout_something = l; // of course won't compile, because i am capturing this. how to do it?
      this->cerr_container<std::string, std::vector>(args
        , true
        , &ProjectExecution::cerr_something  // TODO: should be cout_something
        , &ProjectExecution::cerr_something
      );
    }
    return 0;
  }


  virtual int persist_args(int argc, char** argv)
  /*
    store argc and argv in this class, without consuming them.
    not really "persist"  as in disc.
  */
  {
    this->argc = argc;
    this->argv = argv;
    this->args = std::vector<std::string>(argv + 1, argv + argc);
    return 0;
  }

  virtual int main(int argc, char** argv)
  {
    this->persist_args(argc, argv);
    this->cerr_arguments();
    /* just override main when deriving.
       call this one with ProjectExecution::main(argc, argv) */
    return 0;
  }

  virtual ~ProjectExecution()
  {
    std::cerr << __FUNCTION__ << std::endl;
  }
};



namespace filesystem_dep = boost::filesystem; // tomorrow boost:: will be replaced by std::
#define default_container std::deque // later a better approach can be defined
typedef std::string default_string;
typedef int  default_int;
typedef filesystem_dep::path default_path;


class FSForayExecution : public ProjectExecution {
  /* depends on filesystem */
  protected:
  default_container<std:: string> s;
  public:
  virtual int main(int argc, char** argv)
  {
    return ProjectExecution::main(argc, argv);
  }

  virtual default_container<default_string>  subpaths(const default_path &path
      , default_int max_level =  0
    )
  {
     default_container<default_string>  result;
     return result;
  }

  virtual default_container<default_string>  subpaths(const default_string &path
      , default_int max_level =  0
    )
  {
     default_container<default_string>  result;
     return result;
  }

  virtual ~FSForayExecution()
  {
    std::cerr << __FUNCTION__ << std::endl;
  }

};


int main(int argc, char** argv)
{
  auto pe = std::make_shared<ProjectExecution>();
  auto fe = std::make_shared<FSForayExecution>();
  auto fe_result = pe->main(argc, argv);
  auto pe_result = ( argc > 0 ? pe->main(argc -1, argv) : -1 );
  auto result = fe_result + pe_result;
  return result;
}

