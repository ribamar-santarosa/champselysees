#include "fsforay.h"


class ProjectExecution {
  protected: // private -> failure for achieving Liskov principle
  int argc;
  char **argv;
  default_container<default_string> args;

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
   if ::back, ::pop_back are given instead, the function becomes  a fault-tolerant pop_back
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


  virtual int main(int argc, char** argv)
  {
    this->persist_args(argc, argv);
    this->cerr_arguments();
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
     if (filesystem_dep::exists( path )) {
       auto path_as_string = path.string();
       result.push_back(path_as_string);
       if ( max_level == 0 ) {
         // level limited  or max level reached, finishing it up.
       }
       else {
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

  virtual ~FSForayExecution()
  {
    std::cerr << __FUNCTION__ << std::endl;
  }


  /* concrete functions -- testing */


  virtual int main(int argc, char** argv, default_bool call_super_main=false)
  {
    this->persist_args(argc, argv);
    auto super_result = (call_super_main? ProjectExecution::main(argc, argv) : 0 );
    auto result = super_result;
    return result;
  }


};


int main(int argc, char** argv)
{
  auto pe = std::make_shared<ProjectExecution>();
  auto fe = std::make_shared<FSForayExecution>();
  auto pe_result = ( argc > 0 ? pe->main(argc -1, argv) : -1 );
  auto fe_result = fe->main(argc, argv);
  auto result = fe_result + pe_result;
  return result;
}

