#  rubyment

A ruby class having many functions.

Each of the functions are callable from the command line.

E.g: the `main` function just outputs the arguments given
to `rubyment.rb`, like this:

````
./rubyment.rb main arg1 arg2 arg3
main arg1 arg2 arg3
````

For functions that won't get strings as
parameter, it may be difficult to give the arguments
from the command line. Functions starting with `shell_`
are specially prepared to be called from the command
line.

### standards

There is an effort to preserve the open-closed principle. It means that an interface call should never require maintenance for not to stop working.

But interfaces can be extended. Then, how to ensure that an extension is not actually changing its agreements? That's not a simple question, and eventually there may be failures.

#### parameters are always an ordered list of parameters

Some functions will take a splat (a list of arguments separated by comma, but not between square brackets), others will take explicitly an Array -- by default, sometimes `ARGV`, an old pattern that won't be used for new functions, and sometimes `[]` (ideally). The agreement is that some parameters may be added always to the end of that list. If a parameter is added, and given as +nil+, it should always correspond to the previous version of the interface.

#### return value are always ordered list of parameters

The same is valid for return values (not that they're not necessarily an Array, in which case the return value is stated closed, can't be extended)

#### non working cases: e.g: interfaces never raise exceptions

If an interface throws exceptions, it bubbled from an inner call. That's considered a bug or an undefined case case. Clients are not supposed to catch them -- the case is supposed to be undefined. Clients have 3 options: 1) ensure they use only the working uses cases 2) or consider the interface as not available or 3) rescue exceptions under their own risk (ie, maintenance should be required in the future).

This principle is general and  it's applied in the case of any failure, like a bug.  If a function is called `validate_something`, it has to validate it properly,  and it will be changed until it is properly validate something. Usage of unintended bugs as feature is not covered. Changes will be made only as the last resource, still.

#### documentation

Each function is documented in a format tought to comply to https://devhints.io/rdoc, but both `yard` and `rdoc` won't generate proper pages at ( https://rawgit.com/ribamar-santarosa/champselysees/master/rubyment/doc/index.html ). It results from that the documentation is better read from the source code.

