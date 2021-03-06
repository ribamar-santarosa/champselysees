#!/usr/bin/env ruby


=begin
  # begin_documentation
  TrueClass will be changed just by including
  this file or requiring rubyment, which is not the
  best approach, but kept to respect the open/closed
  principle, but new functions should NOT be added here.
  # end_documentation
=end
class TrueClass
  # returns +false+ (purpose of simplifying
  # functional programming)
  def false?
    false
  end
end


=begin
  # begin_documentation
  Object will be changed just by including
  this file or requiring rubyment, which is not the
  best approach, but kept to respect the open/closed
  principle, but new functions should NOT be added here.

  only a bunch of methods, is, however, added:
  . negate_me
  . to_nil
  . nne

  # end_documentation
=end
class Object
  # returns +self+ if +self+ is not considered
  # to be the neutral element of its class.
  # an object is considered to the neutral
  # element if it answers +true+ to any of
  # a global +asserting_methods+ list.
  # this list is by now the following:
  # [ empty?, :zero?, :false? ]
  # but it will grow as more classes are
  # known to have different +asserting_methods+.
  # it returns +nil+ when the element is
  # considered the neutral element.
  #
  # data from other languagues, like most
  # shell input, can't be +nil+ so sometimes
  # "" has to be interpreted as +nil+. so,
  # one example usage of the neutral element
  # concept.
  #
  def nne default=nil
    asserting_methods = [
      :empty?,
      :zero?,
      :false?,
    ]
    responds_false_to = asserting_methods.map { |am|
      (self.respond_to? am) && (
        self.method(am).call.negate_me
      ) || nil
    }
    responds_false_to.any? && self || default
  end


  # returns nil out of an object.
  # usage examples:
  # "this_parameter_is_nil".to_nil
  def to_nil
    nil
  end


  # returns +!self+, unless +unless_condition+
  # is +true+; in such case returns +self+.
  # e.g: +false.negate_me true+ returns
  # +false+.
  # (by default, if no params are given,
  # just # negates +self+)
  # experiment
  # [1, 2, nil, 3, nil, 4].select &:negate_me
  # to find the nil elements in an array
  def negate_me condition=true
    (condition) && (
      !self
    ) || (!condition) && (
      self
    )
  end


=begin
  Turns any Ruby object into a composite.

  Examples:

  1.as_container(:components_only).entries
  # => []

  1.as_container.entries
  # => [1]

  "hello".as_container.entries
  # => ["hello"]

  [1, 2, 3].as_container().entries
  # => [1, 2, 3]

  [1, 2, 3].as_container(:components_only).entries
  # => [1, 2, 3]

  # Take the first element of the operation on the object a:
  # a.as_container.entries - a.as_container(:only_components).entries
  # to find what's the non composite component of a:

  a = [ 1, 2, 3 ] ; a.as_container.entries - a.as_container(:only_components).entries
  # => []

  a = "str" ; a.as_container.entries - a.as_container(:only_components).entries
  # => ["str"]

=end
  def as_container components_only=nil, method_name=:map
    self.respond_to?(method_name) && (
      self.send method_name
    ) || (!components_only) && (
      [self].send method_name
    ) || (
      [].send method_name
    )
  end


end # of class Object


=begin
  # begin_documentation

  This module offers function to generate ruby code

  # end_documentation
=end
module RubymentRubyCodeGenerationModule


=begin
if you use vim or a similar  editor, you can use such a function as:
:read !./rubyment.rb invoke_double puts code_ruby_comment_multiline_empty
=end
  def code_ruby_comment_multiline_empty
    code =<<-ENDHEREDOC
=begin
=end
    ENDHEREDOC
    [code]

  end


=begin
if you use vim or a similar  editor, you can use such a function as:
:read !./rubyment.rb invoke_double puts code_ruby_module_newmodule_empty
=end
  def code_ruby_module_newmodule_empty
    code =<<-ENDHEREDOC
=begin
  # begin_documentation

  # end_documentation
=end
module NewModule


end # of NewModule


    ENDHEREDOC
    [code]

  end


=begin
if you use vim or a similar  editor, you can use such a function as:
:read !./rubyment.rb invoke_double puts code_rubyment_debug_puts
=end
  def code_rubyment_debug_puts
    code =<<-ENDHEREDOC
    debug && (stderr.puts "=\#{}")
    ENDHEREDOC
    [code]

  end


end # of RubymentRubyCodeGenerationModule


=begin 
  # begin_documentation
  This module offers function to generate computer languages code
  # end_documentation
=end
module RubymentCodeGenerationModule


  include RubymentRubyCodeGenerationModule


end


=begin
  # begin_documentation

  this module provides functions to generate html code.

  # end_documentation
=end
module RubymentHTMLModule


=begin
  this is a template for functions in this module.
=end
  def html_content__ args=[]
    html =<<-ENDHEREDOC

    ENDHEREDOC
    payload = "#{html}"
  end


=begin
  generates an html code with javascript,
  to display a shell/invocation line to call
  a GET <contents of the invocation line> on
  the current server. The output is output
  on a <PRE> tag.
  If a server such
  #test__experiment__web_http_https_server
  is running, this html may provide an interface
  to rubyment itself. By calling, eg
  #autoreload on the invocation line, the
  Ruby code can be even reloaded dynamically
  without requiring the server to restart.
=end
  def html_content__basic_shell
    html =<<-ENDHEREDOC
<!DOCTYPE html>
<html>
<body>

<form>
  Invoke:<br>
  <input id="invocation_line" size=100 type="text" name="username"><br>
</form>
<button type="button" onclick="loadDoc()">Ok</button>
<pre id="demo">
</pre>


<script>
function loadDoc() {
  var xhttp = new XMLHttpRequest();
  xhttp.onreadystatechange = function() {
    if (this.readyState == 4 && this.status == 200) {
      ih = document.getElementById("demo").innerHTML
      document.getElementById("demo").innerHTML =
      this.responseText;
    }
  };
  xhttp.open("GET", document.getElementById("invocation_line").value, true);
  xhttp.send();
}
</script>

</body>
</html>
    ENDHEREDOC
    payload = "#{html}"
  end


end


=begin 
  # begin_documentation
   This module offers functions to manipulate
   Strings.

  # end_documentation
=end
module RubymentStringsModule


=begin
  returns a quoted version of a string; does not escape against
  quoting chars inside it.
=end
  def quoted_string__no_escaping s
    "\"#{s}\""
  end


=begin
  returns a quoted version of a string; does not escape against
  quoting chars inside it.
=end
  def quoted_string__no_escaping_single s
    "\'#{s}\'"
  end


=begin
  Function that can generate distribution or combinations of
  an array of strings.

  Closed for extension

  examples:
  strings__product [ "model 1", "model 2"], [":"], ["variant with sound system", "variant no sound system"], [" "],  ["and stabilizer", "and without stabilizer"]
  # => ["model 1:variant with sound system and stabilizer",
  #  "model 1:variant with sound system and without stabilizer",
  # ...
  #  "model 2:variant no sound system and stabilizer",
  #  "model 2:variant no sound system and without stabilizer"]


=end
  def strings__product *strings
    arrays = arrays__product *strings
    invoke__basic_sender_array [ arrays, :map  ], &:join
  end


=begin
  Function that can generate a match of
  an array of strings.

  Closed for extension

  examples:

  # compare the results below, with calling strings__product [ "model 1", "model 2"], [":"], ["variant with sound system", "variant no sound system"], [" "],  ["and stabilizer", "and without stabilizer"]

  strings__zip [ "model 1", "model 2"], [":"], ["variant with sound system", "variant no sound system"], [" "],  ["and stabilizer", "and without stabilizer"]
  # => ["model 1:variant with sound system and stabilizer",
  #  "model 2variant no sound systemand without stabilizer"]

=end
  def strings__zip *strings
    arrays = arrays__zip *strings
    invoke__basic_sender_array [ arrays, :map  ], &:join
  end


=begin
  Makes possible to join, similarly to Array#join, recursively.

  Note of difference in behavior:

  [ "", "" ].join "+"
  # => "+"

  [ nil, nil ].join "+"
  # => "+"

  In this function, empty strings are not joinned
  (.nne and .compact are run before). It's a planned
  change to expand the interface to be able to
  instruct for not nne/compact strings/arrays before.
  TODO: via inheritable joinner; possibly indenter

  Examples:

  string__recursive_join ["+", 1, 2, 3 ]
  # => "1+2+3"

  string__recursive_join [ "; ",  ["+", 1, 2, 3 ], ["-", 2, 1] ]
  # => "1+2+3; 2-1"

  string__recursive_join [ "; ",  ["+", 1, ["/", "a", "b"], 3 ], ["-", 2, 1] ]
  # => "1+a/b+3; 2-1"



=end
  def string__recursive_join joinner_arrays_tuple
    return joinner_arrays_tuple if (
      joinner_arrays_tuple.respond_to?(:map).negate_me
    )

    joinner,
      *operands = joinner_arrays_tuple
    operands.map! { |operand|
      (
        send __method__, operand # recursive call
      ).nne
    }

    operands.compact.join(joinner)
  end


=begin
  If definition cannot map, retuns itself.

  Otherwise, it will generate a string out of the values
  given in that array, which can describe, for instance,
  recursive expressions. Better explained by examples:

  Examples:

  string__from_definition [ "value", "var" ]
  # => "var value"

  string__from_definition [ "value" ]
  # => "value"

  string__from_definition [ "value", ["var"], "="   ]
  # => "var=value"

  string__from_definition [ "value", ["var"], ""  ]
  # => "varvalue"

  string__from_definition [ nil, ["var"], "="   ]
  # => "var="

  string__from_definition [ "value", ["var", "EXPORT"], "="  ]
  # => "EXPORT var=value"

  string__from_definition [ ["value"], ["var", "EXPORT"], "="  ]
  # => "EXPORT var=value"

  string__from_definition ["value", nil, nil, nil, "`", "`"]
  # => "`value`"

  string__from_definition [    ["value", nil, nil, nil, "`", "`"] , ["var", "EXPORT"], "="  ]
  # => "EXPORT var=`value`"

  # ----- test the spacer:

  string__from_definition [ "value", ["var"], "=", ","  ]
  # => "var,=,value"

  string__from_definition [ "value", ["var"], nil, ","  ]
  # => "var, ,value"

  string__from_definition [ "value", ["var"], "", ","  ]
  # => "var,value"

  string__from_definition [ " ... describe here ... ", "contents:", "", "\n", "# begin section", "# end section "]
  # => "# begin section\ncontents:\n ... describe here ... \n# end section "


=end
  def string__from_definition definition
    return definition if (
      definition.respond_to?(:map).negate_me
    )

    value,
      variable,
      operation,
      spacer,
      open,
      close,
      reserved = definition.map { |d|
      send __method__, d # recursive call
    }

    # if variable is non empty, the default operation is "="
    # of course, only applied if operation is not set
    # A priori, nne not to be used, otherwise "" operation
    # won't be allowed
    operation ||= (variable && " " ||  "")
    spacer = spacer.nne ""
    variable  = variable.nne ""

    rv = string__recursive_join [
      spacer,  # separator
      open,
      [
        spacer, # separator
        variable,
        operation,
        value,
      ],
      close,
    ]

    rv

  end


end # of RubymentStringsModule


=begin 
  # begin_documentation

   This module offers functions to manipulate
   Arrays.

  # end_documentation
=end
module RubymentArraysModule


=begin
  zip will finish with the dimension of
  the first array. It may sound like a feature,
  I guess it is that way because it was the easiest
  thing to implement. This one does the harder thing:
  zip arrays: the generated array will have the
  longest needed dimension.

  The transpose method of Array suffers from the
  same problem (indeed a bigger one, because it will
  completely refuse to tranpose arrays with different
  dimensions, while it could fill them with nil for us),
  and, again, this function is the solution.

  returns an #arrays__ definition, which is an array of array
  having a transposition of arrays, which can be interpreted
  as a zip of those arrays.

  examples:

  # this case is the same as [1, 2, 3].zip [4, 5]
  arrays__zip [1, 2, 3], [4, 5]
  # => [[1, 4], [2, 5], [3, nil]]

  # this case is not the same as [1, 2].zip [3, 4, 5]
  arrays__zip [1, 2], [3, 4, 5]
  # => [[1, 3], [2, 4], [nil, 5]]


=end
  def arrays__zip *arrays
    dimension = arrays.map(&:size).max - 1
    (0..dimension).map { |i|
      arrays.map { |a| a[i] }
    }
  end


=begin

  merge a list of arrays (like applying || on
  each column of the matrix that arrays forms).

  examples:
  array__merge_shallow [1, false ], [false, 2, 3]
  # => [1, 2, 3]

=end
  def array__merge_shallow *arrays

    arrays__zip(*arrays).map { |a|
      a.reduce "nne"
    }

  end


=begin
  returns an array with the indexes of ocurrences
  of element in each array of arrays.

  examples:
  array__index [ [ :a, :b, :c], [ nil, :b ], [:a] ], :a
  # => [0, nil, 0]

  r.array__index [ [ :a, :b, :c], [ nil, :b ], [:a] ], :b
  # => [1, 1, nil]


=end
  def array__index arrays, element

    pattern_exec__mapping_an_object [
      arrays,
      "map",
      "index",
      element,
    ]

  end


=begin

  returns an array with the elements at the given
  position in each array of arrays.

  it's equivalent of calling arrays.transpose[position],
  however, it saves the transposed memory.

  examples:
  array__at [ [ :a, :b, :c], [ nil, :b ], [:a] ], 0
  # => [:a, nil, :a]

  array__at [ [ :a, :b, :c], [ nil, :b ], [:a] ], 2
  # => [:c, nil, nil]

  # slices can be given in an array:
  array__at [ [ :a, :b, :c], [ nil, :b ], [:a] ], [1..2]
  # => [[:b, :c], [:b], []]

=end
  def array__at arrays, position

    pattern_exec__mapping_an_object [
      arrays,
      "map",
      "slice",
      position,
    ]

  end


=begin
  Just a convenience function for achieving the
  same as first_array.product other_arrays

  Closed for extension

  examples:

  arrays__product [ "model 1", "model 2"], [":"], ["variant with sound system", "variant no system"], ["and stabilizer", "and without stabilizer"]
  #  => [["model 1", ":", "variant with sound system", "and stabilizer"],
  #  ["model 1", ":", "variant with sound system", "and without stabilizer"],
  # ...
  #  ["model 2", ":", "variant no system", "and stabilizer"],
  #  ["model 2", ":", "variant no system", "and without stabilizer"]]




=end
  def arrays__product *args
    first, *others = args
    first.product *others
  end


end # of RubymentArraysModule


=begin
  # begin_documentation

  CLOSED for extensions: The module InternalRubymentModule
  should have been called RubymentInternalModule instead,
  to preserve the naming standards. RubymentInternalModule
  will receive the new functions, and
  InternalRubymentModule must be closed for extensions.

  This module offers function to interface with certain
  internal structures. Ie, these functions are supposed
  to be useless unless running Rubyment.


  # end_documentation
=end
module InternalRubymentModule


=begin
  gets the current @memory
=end
  def rubyment_memory__
    @memory
  end


=begin
  updates the current @memory with a new hash m
=end
  def rubyment_memory__shallow_update m
    @memory.update m
  end


=begin
  sets the current @memory with a new hash m
=end
  def rubyment_memory__set m
    @memory =  m
  end


=begin
  set the current @memory[k] with v
=end
  def rubyment_memory__set_key k, v
    @memory[k] = v
  end


=begin
  get the current @memory[k]
=end
  def rubyment_memory__get_key k
    @memory[k]
  end


=begin
  load __FILE__ -- so a threaded invocation,
  like the functions running a tcp server,
  can call this function and reload without
  having to restart the process.

=end
  def autoreload wtime=1
    (
      sleep wtime
    ) while rubyment_memory__get_key :file_reloading
    rubyment_memory__set_key :file_reloading, true
    load rubyment_memory__get_key :filepath
    rubyment_memory__set_key :file_reloading, false
  end


end


=begin 
  # begin_documentation
  This module offers function to interface with certain
  internal structures. Ie, these functions are supposed
  to be useless unless running Rubyment.

  The module InternalRubymentModule
  should have been called RubymentInternalModule instead,
  to preserve the naming standards. RubymentInternalModule
  will receive the new functions, and
  InternalRubymentModule must be closed for extensions.

  # end_documentation
=end
module RubymentInternalModule


  include InternalRubymentModule


=begin
  merges the current @memory with m
  (so @memory will contain the resulting merged
  hash).
  The merge is shallow, ie, only top-level
  keys are merged.
  If the same key is present in both objects,
  the one in m will prevail.
=end
  def rubyment_memory__merge_shallow m
    @memory.merge!  m
  end


=begin
  merges the m with the current @memory
  (so @memory will contain the resulting merged
  hash).
  The merge is shallow, ie, only top-level
  keys are merged.
  If the same key is present in both objects,
  the one in @memory will prevail. Note that this
  is the inverted behaviour as of
  #rubyment_memory__merge_shallow
=end
  def rubyment_memory__merge_shallow_on m
    rubyment_memory__set m.merge @memory
  end


=begin
  returns a m, or copy of @memory if not given,
  without the keys listed in closure_keys, or m[:closure_keys],
  if not given (still, m["closure_keys"] if m[:closure_keys]
  is empty).
=end
  def rubyment_memory__without_closure_keys m=nil, closure_keys=nil
    m = m.nne @memory.dup
    closure_keys = closure_keys.nne(
      m[:closure_keys]
    ).nne(
      m["closure_keys"]
    )
    closure_keys.each {|closure_key|
      m.delete closure_key
    }
    m
  end


=begin
  dumps the contents of m, or @memory if not given,
  into filepath, or m[:memory_json_file_default]
  if not given (still m["memory_json_file_default"]
  if nil).
=end
  def rubyment_memory__to_json_file filepath=nil, m=nil
    m = m.nne @memory
    filepath = filepath.nne(
      m[:memory_json_file_default]
    ).nne(
      m["memory_json_file_default"]
    )
    file__json [
      filepath,
      m,
    ]
  end


=begin
  ensure the top level keys of m, @memory if not given,
  are all symbols
  returns a copy of m, @memory if not given, where
  all the keys are ensured to be symbols.

  When a ruby hash is stored as a JSON file, the symbol
  keys will be restored as strings. When that JSON file
  is reloaded, those strings will be loaded as strings.
  Therefore the resulting hash is not the same as the
  original. There may be other issues with keys having
  other types than strings and symbols, and deep keys
  can also be lost with that transformation. This function
  just takes cares of the issues created by the Rubyment
  memory implementation itself.

  other special cases:
  m[:closure_keys] contents will be converted into symbols

=end
  def rubyment_memory__symbol_keys_shallow m = nil
    update_memory = m.nne.negate_me
    m = m.nne @memory
    m = m.map { |k, v|  [k.to_sym, v] }.to_h
    m[:closure_keys].map!(&:to_sym)
    update_memory && (@memory = m) || m
  end


=begin
  merge
  @memory with the hash loaded from filepath, or
  @memory[:memory_json_file_default] if not given
  (still @memory["memory_json_file_default"] if nil).

  The merge is shallow, ie, only top-level
  keys are merged.
  If the same key is present in both objects,
  the one in m will prevail.
=end
  def rubyment_memory__merge_shallow_with_json_file filepath=nil, debug=nil
    filepath = filepath.nne(
      @memory[:memory_json_file_default]
    ).nne(
      @memory["memory_json_file_default"]
    )
    m = load__file_json_quiet [
      filepath,
      debug,
    ]
    rubyment_memory__merge_shallow(
      rubyment_memory__without_closure_keys(
        rubyment_memory__symbol_keys_shallow m
      )
    )
  end


=begin
  merge
  @memory with the hash loaded from filepath, or
  @memory[:memory_json_file_default] if not given
  (still @memory["memory_json_file_default"] if nil).

  The merge is shallow, ie, only top-level
  keys are merged.
  If the same key is present in both objects,
  the one in @memory will prevail. Note that
  this is the inverse behaviour compared to
  #rubyment_memory__merge_shallow_with_json_file
=end
  def rubyment_memory__merge_shallow_on_load_json_file filepath=nil, debug=nil
    filepath = filepath.nne(
      @memory[:memory_json_file_default]
    ).nne(
      @memory["memory_json_file_default"]
    )
    m = load__file_json_quiet [
      filepath,
      debug,
    ]
    rubyment_memory__merge_shallow_on(
      rubyment_memory__without_closure_keys(
        rubyment_memory__symbol_keys_shallow m
      )
    )
  end


=begin
  returns a string having help for the idea of persistence
  achieved with many of the functions of this module:
=end
  def help__concept__rubyment_memory_persistence
    string = [
      "# saves the current memory to the default memory_json_file_default ('memory.rubyment.json' by default, in the current dir): ",
      "rubyment_memory__to_json_file",
      "",
      "# if you add a new key to that file, you can load it to memory with",
      "rubyment_memory__merge_shallow_on_load_json_file",
      "# in the above case, keys in the current memory will prevail, when they equal.",
      "",
      "# this function will try to restore the memory, as much as possible (not everything is serializable), to the state of when it was saved: ",
      "rubyment_memory__merge_shallow_with_json_file",
      "# in the above case, keys in the json file will prevail, when they equal.",
      "",
    ]
    [ string.join("\n") ]
  end


=begin
  The actual release of rubyment it is not tied
  to the version returned by #version (that's the
  execution version).
  This function returns a SHA256 hex digest (string)
  for this file, which is unique per file change set.
  However, it's not sequencial, and therefore not
  used for versioning.
=end
  def rubyment_file_sha256 file=nil
    require 'openssl'
    file = containerize(file).first.nne __FILE__
    (Digest::SHA256.hexdigest File.read file)
  end


=begin
  By default, @memory (see rubyment_memory__ functions),
  is lost after a rubyment invocation.

  This function allows a rudimentar method of persisting
  the memory (just that "on load" method is used, check
  #help__concept__rubyment_memory_persistence ;
  here rubyment_memory__merge_shallow_on_load_json_file but
  it will be replaced by a deep version when that's available),
  based on the current PWD.

  The invocation lines will be logged along
  with their results in memory.rubyment.json. Just try running
  rubyment multiple times and check that file.

  Note: changed running dir, another context,
  another memory. If you return to the current
  dir you can retake the state. Either carry memory.rubyment.json
  around or symlink it, if really needed to run rubyment from
  another dir.
=end
  def invoke_pwd_persistent *args
    rubyment_memory__merge_shallow_on_load_json_file
    result = invoke *args
    @memory[:invocation_history] ||=  Array.new
    time = time__now_strftime_default
    @memory[:invocation_history].push({
      "time" => time,
      "command" => args,
      "result" => result,
    })
    rubyment_memory__to_json_file
    result
  end


end # of  RubymentInternalModule


=begin 
  # begin_documentation

  This module offers generic functions to help
  achieving certain programming patterns.

  # end_documentation
=end
module RubymentPatternsModule


=begin
  Turns any_object into a composite, and
  returns it in an array with its two parts:
  the leaf, and its children (another
  container)

  Note that if an object can be decomposed
  by duck_type_method (:map) by default,
  it stays in the leaf, otherwise it is
  components are returned in the children.
  So expect always a nil for the leaf or
  [] for children components.

  Decompose an object is useful, for example,
  to write a recursive function in functional
  style.  Normally a recursive function will
  require a test to check if it is the base
  (leaf) case, otherwise will iterate through
  children and call recursively the function.
  With this, no test is needed. Since the "map"
  call is not defined for every object, it won't
  go infinite. Also, it won't throw an exception,
  because the children is a container (empty,
  when the leaf is defined):

  def rec leaf_or_children
    l, c = object__decompose leaf_or_children
    c.map { |children| rec leaf_or_children }
    do_something_with_leaf l # must be already in
                             # a functional/fault
                             # tolerant style
  end

  Examples:

  l, c  = object__decompose [ "a", "b", "c"]
  # => [nil, ["a", "b", "c"]]

  l, c  = object__decompose "string"
  # => ["string", []]

  l, c  = object__decompose ["a", "b", "c"], :bytes
  # => [["a", "b", "c"], []]

  l, c  = object__decompose "string", :bytes
  # => [nil, [115, 116, 114, 105, 110, 103]]


=end
  def object__decompose any_object, duck_type_method=:map

    children = bled {
      any_object.as_container(:only_components, duck_type_method).entries
    }.first.call.first || []

    leaf = bled([any_object]) {
      (
        any_object.as_container(nil, duck_type_method).entries -
        children
      ).first
    }.first.call.first

    [
      leaf,
      children,
    ]
  end


end # of RubymentPatternsModule


=begin
  # begin_documentation

  CLOSED for extensions:
  The module:
  ModifierForClassObjectModule
  should have been called:
  RubymentModifierForClassObjectModule
  instead, to preserve the naming standards.
  RubymentModifierForClassObjectModule
  will receive the new functions, and
  ModifierForClassObjectModule
  must be closed for extensions.

  Object will be changed just by including
  this file or requiring rubyment, which is not the
  best approach, but kept to respect the open/closed
  principle, the Object class is kept adding some
  methods.

  However, the best approach is to add new functions
  to this module, which will only be used to modify
  the Object class if the RubymentModule is included.


  # end_documentation
=end
module ModifierForClassObjectModule


  def __is object
    object
  end


  def array__is *args
    args
  end


  def __note arg
    self
  end


end


=begin 
  # begin_documentation

  The module:
  ModifierForClassObjectModule
  should have been called:
  RubymentModifierForClassObjectModule
  instead, to preserve the naming standards.
  RubymentModifierForClassObjectModule
  will receive the new functions, and
  ModifierForClassObjectModule
  must be closed for extensions.

  Object will be changed just by including
  this file or requiring rubyment, which is not the
  best approach, but kept to respect the open/closed
  principle, the Object class is kept adding some
  methods.

  However, the best approach is to add new functions
  to this module, which will only be used to modify
  the Object class if the RubymentModule is included.


  # end_documentation
=end
module RubymentModifierForClassObjectModule


  include ModifierForClassObjectModule


end


=begin 
  # begin_documentation

  This module offers functions for invocation of Rubyment
  (and Ruby) code in general.

  # end_documentation
=end
module RubymentInvocationModule


=begin
  Takes an array as parameter and invokes a
  method (second element of that array) of an object
  (first element of that array) giving the remaining
  array as argument list, and optionally giving
  a block as extra parameter.

  Closed for extensions

  examples:

  invoke__basic_sender_array [ 9, "next" ]
  # => 10

  invoke__basic_sender_array [ self, "p", "args", "to", "p" ]
  # => ["args", "to", "p"]

  invoke__basic_sender_array [ [["S", "2"], ["<", "3" ]], :map  ], &:join
  # => ["S2", "<3"]


=end
  def invoke__basic_sender_array args, &block
    object, method_name, *args_to_method = args
    object.send method_name, *args_to_method, &block
  end


=begin
  Just a convenience for typing less. Calls
  the block inside a bled, which is a function
  which captures and returns exceptions and
  runtime errors in a functional way, instead
  of Ruby's way.

  Examples:

   bled_call {:return_value }
   # => [:return_value, nil, nil]

   bled_call { UndefinedStuff }
   # => [nil,
   # ...
   #    nil],
   #  NameError],
   #   #<NameError: uninitialized constant #<Class:#<Rubyment:0x000000035adcc0>>::UndefinedStuff>]


   bled_call [:return_value_on_error] { UndefinedStuff }
   # => [:return_value_on_error,
   #  [nil,
   #   "message{\nuninitialized constant #<Class:#<Rubyment:0x0000000308e078>>::UndefinedStuff\

=end
  def bled_call *args, &block
    b = bled *args, &block
    b.first.call
  end


=begin
  Generates a string that can be given to system (or any other
  command line executor) to execute a binary in memory (Ie,
  a file is generated having as contents a given string).
  If not file path is given a default one in /tmp will be
  generated (using the digest sha256 of the file (truncated
  at 96 chars, by now).
  Arguments can be given in an array (they will be escaped
  with Shellwords.join) or String (no escape apply)

  Examples:

  # write the contents of /bin/ls to a temporary file and offers
  # a command to execute it:
  system_command__exec_via_file [ [nil, File.read("/bin/ls") ] , ["-l", "-h"] ]
  # => "/tmp/rubyment.file.a90ba058c747458330ba26b5e2a744f4fc57f92f9d0c9112b1cb2f76c66c4ba0 -l -h"

  system_command__exec_via_file [ ["/tmp/my_ls", File.read("/bin/ls") ] , ["-l", "-h"] ]
  # => "/tmp/my_ls -l -h"

  system_command__exec_via_file [ ["/tmp/my_ls", File.read("/bin/ls") ] , "-l -h" ]
  # => "/tmp/my_ls -l -h"


=end
  def system_command__exec_via_file exec_via_file
   args = exec_via_file

    binary_or_script_blob,
    args_to_binary_or_blob,
      reserved = containerize(args)

    file_path_src,
      string_src,
      reserved = containerize(binary_or_script_blob)

    require 'openssl'
    string_src_sha256 = string_truncate [
      Digest::SHA256.hexdigest(string_src.to_s),
      96,
    ]
    default_path_for_string_src = "/tmp/rubyment.file.#{string_src_sha256}"

    actual_file_path,
      old_contents,
      reserved = file_string__experimental [
        file_path_src.nne(default_path_for_string_src),
        string_src,
      ]

    bled_call {
      require 'fileutils'
      FileUtils.chmod "+x", actual_file_path
    }
    require "shellwords"
    escaped_args_as_str = (
      bled_call [ args_to_binary_or_blob ] {
        Shellwords.join args_to_binary_or_blob
      }
    ).first.to_s
    string__recursive_join [
      " ",
      actual_file_path,
      escaped_args_as_str,
    ]
  end # of system_command__exec_via_file


=begin
  "Rubyfy" a system's executable binary string/blob/memory chunk.
  Ruby gems won't distribute binaries other than Ruby executables
  (no whims, it is just their mechanisms of handling binaries with
  multiple versions in the system, they solved only for Ruby case).

  With this function, a binary string can be given (in a file_string
  definition/structure; ie as second element), and a ruby code
  (which normally relies on Rubyment) will be generated to wrap
  that binary in a ruby code. A temporary file (not for the ruby
  code, but for storing the binary memory chunk/string is by
  default generated at /tmp/ dir; however it can set if given
  as the first element of that file_string.

  Examples:

  ruby_code__from_binary [nil, File.read("/bin/ls") ] # long output
  # => "#!/usr/bin/env ruby\n# Autogenerated on 2018.12.21_16:45:11\nrequire 'base64'\nblob_base64 = \"f0VMRgIBAQAAAAAAAAAAAAIAPgABAAAAoElAAAAAAABAAAAAAAAAADjnAQAA\\nAAAAAAAAAEAAOAAJAEAAHQAcAAYAAAA

  # this version is good for self development: include this current .rb file, which contains function not yet in the gem package:
  ruby_code__from_binary [nil, File.read("/bin/ls") ], [ nil, :include_this_file ] # long output
  # => "#!/usr/bin/env ruby\n# Autogenerated on 2018.12.21_16:45:11\nrequire 'base64'\nblob_base64 = \"f0VMRgIBAQAAAAAAAAAAAAIAPgABAAAAoElAAAAAAABAAAAAAAAAADjnAQAA\\nAAAAAAAAAEAAOAAJAEAAHQAcAAYAAAA

  ruby_code__from_binary ["/tmp/temporary_ls", File.read("/bin/ls") ] # long output
  # => "#!/usr/bin/env ruby\n# Autogenerated on 2018.12.21_16:50:37\nrequire \"rubyment\"\nrequire 'base64'\nblob_base64 =

  system_command__exec_via_file   [ [ nil, (ruby_code__from_binary [nil, File.read("/bin/ls") ]) ] ]
  # => "/tmp/rubyment.file.1e7f29e90deb6ba33b3e2e21540c77c56fca5995bb88141b572481f322290cad"

  # this version is good for self development: include this current .rb file, which contains function not yet in the gem package:
  system_command__exec_via_file [ [ nil, (ruby_code__from_binary [nil, File.read("/bin/ls") ], [ nil, :include_this_file ])  ] ]

  # or even:
  # this version is good for self development: include this current .rb file
  system_command__exec_via_file [ [ nil, (ruby_code__from_binary [nil, File.read("/bin/ls") ], [ nil, :include_this_file ])  ] , "-l" ]


=end
  def ruby_code__from_binary binary_or_script_blob, requirements=nil
    require 'base64'
    temporary_file_path,
      blob_string = containerize(binary_or_script_blob)
    blob_base64 = Base64.encode64 blob_string

    required_gems,
      load_current,
      object_creator,
      memory_exec_function,
      reserved = containerize(requirements)

    memory_exec_function = memory_exec_function.nne(
      "system_command__exec_via_file"
    )

    object_creator = object_creator.nne(
      "#{self.class}.new"
    )

    memory_exec_function_call = string__recursive_join [
      ".",
      object_creator,
      memory_exec_function,
    ]


    required_gem,
      *only_one_currently_supported,
      reserved = containerize(required_gems)

    required_gem = required_gem.nne "rubyment"
    load_current &&= "load #{__FILE__.inspect}"

    code =<<-ENDHEREDOC
#!/usr/bin/env ruby
# Autogenerated on #{time__now_strftime_default}
require #{required_gem.inspect}
#{load_current}
require 'base64'
blob_base64 = #{blob_base64.inspect}
system #{memory_exec_function_call} [
  [
    #{temporary_file_path.inspect},
    Base64.decode64(blob_base64),
  ],
  ARGV,
]
    ENDHEREDOC
  end # of ruby_code__from_binary


end # of RubymentInvocationModule


=begin 
  # begin_documentation

  This module offers functions to generate or
  deploy gem packages.

  As of now, there are many similar functions
  directly coded in RubymentModule; they will
  be moved here upon proper maintenance/cleanup

  # end_documentation
=end
module RubymentGemGenerationModule


=begin
  Gem files by default can distribute only Ruby files.
  This function implements the work needed to convert
  and automatize the generation of ruby executables out
  of  non ruby binaries
=end
  def gem_deploy__non_ruby_binaries args
    gem_name,
      gem_non_ruby_executables,
      gem_executables, # same as gem_bin_executables
      reserved = args

    new_executables = gem_non_ruby_executables.map { |gem_non_ruby_executable|

      new_gem_executable = string__recursive_join [
        "/",
        "bin",
        File.basename(gem_non_ruby_executable),
      ]

      new_gem_executable_contents = ruby_code__from_binary(
        [
          nil,
          File.read(gem_non_ruby_executable),
        ],
        [
          gem_name,
        ],
      )

      # write file
      file_string__experimental [
        new_gem_executable,
        new_gem_executable_contents,
      ]

      bled_call {
        require 'fileutils'
        FileUtils.chmod "+x", new_gem_executable
      }

      File.basename(new_gem_executable)

    } # of gem_non_ruby_executables.map

    gem_executables = gem_executables.nne([]).concat new_executables

    [
      gem_executables,
    ]

  end # of gem_deploy_non_ruby_binaries


end # of RubymentGemGenerationModule


=begin
  # begin_documentation
  This module receives functions that are being worked on.
  # end_documentation
=end
module RubymentExperimentModule


=begin
  alias for #bled
=end
  def experiment__bled args=[], &block
    bled args, &block
  end


=begin

  # documentation_begin
  # short_desc => "calls the method #call of an object, or return the object itself",
  @memory[:documentation].push = {
    :function   => :call_or_itself,
    :short_desc => short_desc,
    :description => "",
    :params     => [
      {
        :name             => :args,
        :description      => "list of parameters",
        :duck_type        => Array,
        :default_behavior => [],
        :params           => [
          {
            :name             => :object,
            :duck_type        => Object,
            :default_behavior => :nil,
            :description      => "object to be called, if responds to #call, or to return itself",
          },
          {
            :name             => :return_dont_call,
            :duck_type        => Object,
            :default_behavior => :nil,
            :description      => "forces an object to return itself even when it reponds to #call",
          },
          {
            :name             => :debug,
            :duck_type        => Object,
            :default_behavior => :nil,
            :description      => "prints debug information to the __IO__ specified by __@memory[:stderr]__ (STDERR by default)",
          },
          {
            :name             => :reserved,
            :duck_type        => Object,
            :default_behavior => :nil,
            :description      => "for future use",
          },
        ],
      },
    ],
    :return_value     => [
      {
        :name             => :args,
        :description      => "list of parameters",
        :duck_type        => Array,
        :default_behavior => [],
        :params           => [
          {
            :name             => :reserved,
            :duck_type        => Object,
            :default_behavior => :nil,
            :description      => "for future use",
          },
        ],
      },
    ],
  }
  # documentation_end

=end
  def call_or_itself args=[]
    stderr = @memory[:stderr]
    object,
      return_dont_call,
      debug,
      reserved = args
    debug = debug.nne
    debug && (stderr.puts "{#{__method__} starting")
    debug && (stderr.puts "args=#{args.inspect}")
    will_call = (object.respond_to? :call) && return_dont_call.negate_me
    debug && (stderr.puts "will_call=#{will_call.inspect}")
    will_call && (rv = object.call)
    debug && (stderr.puts "provisory return value: #{rv.inspect}")
    will_call.negate_me && (rv = object)
    debug && (stderr.puts "will return #{rv.inspect}")
    debug && (stderr.puts "#{__method__} returning}")
    rv
  end


=begin
  # documentation_begin
  # short_desc = "tests the function #experiment__whether"
  @memory[:documentation].push = {
    :function   => :experiment__whether,
    :short_desc => short_desc,
    :description => "",
    :params     => [
      {
        :name             => :args,
        :description      => "list of parameters",
        :duck_type        => Array,
        :default_behavior => [],
        :params           => [
          {
            :name             => :condition,
            :duck_type        => :boolean,
            :default_behavior => :nil,
            :description      => "any condition, used to decided which parameter will be run",
          },
          {
            :name             => :run_if_true,
            :duck_type        => Proc,
            :default_behavior => :nil,
            :description      => "block will be called if condition is true",
          },
          {
            :name             => :run_if_false,
            :duck_type        => Proc,
            :default_behavior => :nil,
            :description      => "block will be called if condition is true",
          },
          {
            :name             => :return_dont_run,
            :duck_type        => Array,
            :default_behavior => [],
            :description      => "forces blocks from being called. first element prevents the return_if_true block to be called (so the object return_if_true is returned). the second applies to run_if_false",
          },
          {
            :name             => :debug,
            :duck_type        => Object,
            :default_behavior => :nil,
            :description      => "prints debug information to the __IO__ specified by __@memory[:stderr]__ (STDERR by default)",
          },
          {
            :name             => :reserved,
            :duck_type        => Object,
            :default_behavior => :nil,
            :description      => "for future use",
          },
        ],
      },
    ],
    :return_value     => [
      {
        :name             => :rv,
        :description      => "value returned by the block run",
        :duck_type        => Object,
        :default_behavior => :nil,
      },
    ],
  }
  # documentation_end
=end

  def experiment__whether args=[]
    stderr = @memory[:stderr]
    condition,
      run_if_true,
      run_if_false,
      return_dont_run,
      debug,
      reserved = args
    debug = debug.nne
    debug && (stderr.puts "{#{__method__} starting")
    debug && (stderr.puts "args=#{args.inspect}")
    return_don_run_true  = (containerize return_dont_run)[0]
    return_don_run_false = (containerize return_dont_run)[1]
    debug && (stderr.puts "[return_don_run_true, return_don_run_false]=#{[return_don_run_true, return_don_run_false].inspect}")
    condition && (rv = call_or_itself [run_if_true, return_don_run_true])
    debug && (stderr.puts "provisory return value: #{rv.inspect}")
    condition.negate_me && (rv = call_or_itself [run_if_false, return_don_run_false])
    debug && (stderr.puts "will return #{rv.inspect}")
    debug && (stderr.puts "#{__method__} returning}")
    rv
  end


=begin
  # documentation_begin
  # short_desc = "tests the function #experiment__tester"
  @memory[:documentation].push = {
    :function   => :experiment__tester,
    :short_desc => short_desc,
    :description => "",
    :params     => [
      {
        :name             => :args,
        :description      => "list of parameters",
        :duck_type        => Array,
        :default_behavior => [],
        :params           => [
          {
            :name             => :test_cases,
            :duck_type        => Array,
            :default_behavior => :[],
            :description      => "Array having the fields: __test_id__, __test_expected_value__ and __actual_params__. __actual_params__ is an __Array__ having  as first member __method_name__ to be called, and all its remaining args __method_args__ (a __splat__) will be given to __method_name__",
          },
          {
            :name             => :debug,
            :duck_type        => Object,
            :default_behavior => :nil,
            :description      => "prints debug information to the __IO__ specified by __@memory[:stderr]__ (STDERR by default)",
          },
          {
            :name             => :reserved,
            :duck_type        => Object,
            :default_behavior => :nil,
            :description      => "for future use",
          },
        ],
      },
    ],
    :return_value     => [
      {
        :name             => :args,
        :description      => "__true__ if tests were successful, __false__ otherwise",
        :duck_type        => :boolean,
      },
    ],
  }
  # documentation_end
=end
  def experiment__tester args=[]
    stderr = @memory[:stderr]
    test_cases,
      debug,
      reserved = args

    debug = debug.nne
    debug && (stderr.puts "{#{__method__} starting")
    debug && (stderr.puts "caller=#{caller_label.inspect}")
    debug && (stderr.puts "args=#{args.inspect}")
    rv = tester_with_bled [
      test_cases,
      debug,
      :use_first_of_bled_return.__is(true),
    ]
    debug && (stderr.puts "will return #{rv.inspect}")
    debug && (stderr.puts "#{__method__} returning}")
    rv
  end


=begin
  write the second argument of the array args into the filepath in the first argument
  read it back with #load__file_json_quiet
=end
  def file__json args=[]
    require 'json'
    require 'fileutils'
    file_path,
      enum,
      reserved = args
    FileUtils.mkdir_p File.dirname file_path
    File.write file_path,  JSON.pretty_generate({ :root.to_s => enum })
  end


=begin
c = :c
experiment__input_select [[:a, :b, :c], c ]
=end
  def experiment__input_select args=[]
    alternatives,
      default,
      reserved = args
    stderr = @memory[:stderr]
    caption = alternatives.each_with_index.map {|a, i| "#{i} - #{a.inspect}"}.join("\n")
    stderr.puts "[alternatives: #{caption}][default: #{default.inspect}]"
    alternative = input_single_line
    selection = alternative.nne && alternatives[alternative.to_i] || default
  end


  # these shell_ functions can take only flatten arrays (intended for ARGV):
  def shell_string_split args=[]
    string,
      splitter,
      reserved = args
    string.split Regexp.new splitter
  end


  def shell_array_first a
    a.first
  end


  def shell_array_deepen a
    [ a ]
  end


  def get_self args=[]
    self
  end


=begin
enum = (s.scan /http_[^(]*/).uniq.map
# => #<Enumerator: ...>
# send_enumerator [ enum, :gsub, ["http_", ""] ]
# => ["delete", "get", "head", "post", "put"]

send_enumerator [ ["tinga_http_tinga", "http_catepa"], :gsub, ["http_", ""] ]
#  => ["tinga_tinga", "catepa"]

send_enumerator [ [ [1, 2, 3] ], :map, [], Proc.new {|x| x + 1 } ]  
#  => [[2, 3, 4]]

send_enumerator [ [ {}, {} ], :containerize, [], nil, 0]
# => [[{}], [{}]]


#bug:
send_enumerator [ [ {}, {} ], :method.to_nil, :args.to_nil, Proc.new {}  ]
# ArgumentError: no method name given

# no bug, just not intuitive usage: 

send_enumerator [ [ {}, {} ], Proc.new {|x| x.size }, [].to_nil, :whatever, 0]
# => [0, 0]

=end
  def send_enumerator args=[]
    enum,
      method,
      args_to_method,
      block_to_method,
      replace_at_index,
      debug,
      no_output_exceptions,
      rescuing_exceptions,
      return_not_only_first,
      reserved = args

    stderr = @memory[:stderr]
    debug = debug.nne
    debug && (stderr.puts "{#{__method__} starting")
    debug && (stderr.puts "caller=#{caller_label}")
    debug && (stderr.puts "args=#{args.inspect}")
    args_to_method = args_to_method.nne []
    no_output_exceptions = no_output_exceptions.nne
    rescuing_exceptions = rescuing_exceptions.nne
    return_not_only_first = return_not_only_first.nne

    calling_tuples = enum.map {|e|
      method_name = (!method.respond_to? :call) && method || nil
      method_to_call = (!method_name) && method || (
        (!replace_at_index) && e.method(:send)
      ) || method(:send)
      c_t = args_to_method.dup
      replace_at_index && (c_t[replace_at_index] = e)
      method_name && (c_t.unshift method_name)
      c_t.unshift method_to_call
      debug && (stderr.puts "[e, method_to_call, method_name, replace_at_index]=#{[e, method_name, method_to_call, replace_at_index]}")

      c_t
    }
    debug && (stderr.puts "calling_tuples=#{calling_tuples}")

    rv = calling_tuples.map {|c_t|
      block = bled [
        :nil,
        rescuing_exceptions,
        no_output_exceptions,
      ] {
        method_to_call, *args_to_call = c_t
        method_to_call.call *args_to_call, &block_to_method
      }
      return_not_only_first.negate_me && (lrv = block.first.call.first)
      return_not_only_first && (lrv = block.first.call)
      lrv
    }
    debug && (stderr.puts "will return #{rv.inspect}")
    debug && (stderr.puts "#{__method__} returning}")
    rv
  end


=begin
  given a duck type table, return the entries having
  methods that o responds to in their first entry.

  by default, uses a table useful to determine
  method_name for the call:
  o.map.method_name {|a, b| }
  if o is an Array, it should be each_with_entries:
  experiment__duck_type__hash_array [ []  ]
  => [[:product, :each_with_key, :itself]]

  if o is a Hash, it should be (another) map.
  experiment__duck_type__hash_array [ {}  ]
  => [[:keys, :map, :reversed]]

  note that "reversed" means that the order must
  be |b,a| instead

=end
  def experiment__duck_type__hash_array args=[]
    o,
      duck_type_table,
      reserved = args
    duck_type_table = duck_type_table.nne [
      [ :product, :each_with_index, :itself,   :to_a  ],
      [ :keys,    :map,             :reverse,  :to_h  ],
    ]
    rv = duck_type_table.select { |e|
      responding_method, *r = e
      o.respond_to? responding_method
    }
    rv
  end


=begin
  for each leaf of a (which normally is an Array or Hash),
  calls block_to_send_to_leaf giving the leaf as arg,
  (or return the leaf in the case block_to_send_to_leaf is nil).
  modifies tuples and deep_keys so it contains the results, the
  deep_keys and the tuples at each step.

  direct_cycle_placeholder => object to place when a directed cycled
  (ie, the object is already present in its stack) is found. defaults
  to :direct_cycle_placeholder. undirect cycle: same thing, but searches
  in the visited_nodes.

  Don't use nil, 0, "" as cycleplace holders, use a value v which
  returns itself if called v.nne; it means that the default
  should be used

  BFS: only problem: this uniq should work on object ID
 x[1][:tuples].transpose[2].transpose.flatten.uniq
 => [{:a=>{:b=>:c}, :d=>{:e=>nil}}, {:b=>:c}, {:e=>nil}]


=end
  def experiment__recursive_array__visitor args=[]
    graph_object,
      block_to_send_to_leaf,
      deep_keys,
      duck_type_detector,
      debug,
      duck_type_table,
      tuples,
      stack,
      visited_nodes,
      direct_cycle_placeholder,
      undirect_cycle_placeholder,
      undirected_graph,
      reserved = args
    recursion_args = args.dup

    stderr = @memory[:stderr]
    debug = debug.nne
    debug && (stderr.puts "{#{__method__} starting")
    debug && (stderr.puts "caller=#{caller_label}")
    debug && (stderr.puts "args.each_with_index=#{args.each_with_index.entries.inspect}")
    undirect_cycle_placeholder = undirect_cycle_placeholder.nne ":undirect_cycle_placeholder"
    direct_cycle_placeholder = direct_cycle_placeholder.nne ":direct_cycle_placeholder"
    # structures one per node: nne
    deep_keys  = deep_keys.nne []
    stack = stack.nne []
    # structures shared by all nodes: just ensure exists
    tuples ||= []
    visited_nodes ||= []

    # old_debug = debug
    # debug = (graph_object.keys.index :b) rescue old_debug
    debug && (stderr.puts "=#{}")
    debug && (stderr.puts "graph_object.object_id=#{graph_object.object_id}")
    object_id_method_name = :object_id_method_name


    # cycles detection section
    undirected_cycle = undirected_graph && (
      visited_nodes.map(&:object_id).index graph_object.object_id
    )
    debug && undirected_graph && (stderr.puts "visited_nodes_with_oid=#{visited_nodes.map{|y| [y, y.object_id] }}")
    debug && (stderr.puts "undirected_cycle=#{undirected_cycle.inspect}")

    directed_cycle = stack.map(&:object_id).index graph_object.object_id
    debug && (stderr.puts "stack_with_oid=#{stack.map{|y| [y, y.object_id] }}")
    debug && (stderr.puts "directed_cycle=#{directed_cycle.inspect}")

    cycle_placeholder = (
      directed_cycle   &&   direct_cycle_placeholder ||
      undirected_cycle && undirect_cycle_placeholder
    )
    cycle_placeholder && (a = cycle_placeholder)
    cycle_placeholder.negate_me && (a = graph_object)

    # debug = old_debug
    visited_nodes.push a
    stack.push a

    # detecting the type of object. depending if Hash or Array,
    # methods to call are different.
    duck_type_detector = duck_type_detector.nne :map
    duck_type_def = experiment__duck_type__hash_array(
      [
        a,
        duck_type_table
      ])
    iterating_method = duck_type_def.transpose[1].to_a.first
    final_method     = duck_type_def.transpose[2].to_a.first
    revert_method    = duck_type_def.transpose[3].to_a.first
    leaf = nil
    result = (a.respond_to? duck_type_detector) && a.send(iterating_method).map {|a, b|
        e, i = *([a, b].send(final_method))
        debug && (stderr.puts "e, i=#{[e, i]}")
        recursion_args[0] = e
        deep_keys.push i
        recursion_args[2] = deep_keys.dup
        recursion_args[6] = tuples
        recursion_args[7] = stack.dup
        recursion_args[8] = visited_nodes
        recursion_args[9] = directed_cycle
        recursion_args[10] = undirected_cycle
        debug && (stderr.puts "recursion_args.each_with_index=#{recursion_args.each_with_index.entries.inspect}")
        child_result = send __method__, recursion_args
        deep_keys.pop
        [i, child_result]
      } || (
        block_to_send_to_leaf && (leaf = block_to_send_to_leaf. call a)
        !block_to_send_to_leaf && (leaf = a)
        tuples.push  [
          deep_keys,
          leaf,
          stack,
          [:cycle_to_stack_index, directed_cycle],
          [:cycle_to_visited_nodes_index, undirected_cycle],
        ]
        leaf
      )

     # rebuilding the graph object after visits
     rebuilt_object  = (nil.send revert_method) rescue result
     (result.respond_to? duck_type_detector) && (
        result.map {|i, e|
          rebuilt_object[i] = e[:result]
          # rebuilt_object[i]  = (e[:result] rescue e)
        }
    )
    rv = {
      :visited_nodes => visited_nodes,
      :tuples => tuples,
      :result => rebuilt_object,
    }
    # stack.pop
    debug && (stderr.puts "will return #{rv.inspect}")
    debug && (stderr.puts "#{__method__} returning}")
    rv
  end


  def test__experiment__recursive_array__visitor args=[]
    method_to_test = :experiment__recursive_array__visitor
    direct_cycle_h = {
      :a => {
         :b => [ :c ],
       },
      :d => {
        :e => nil,
      },
    }
    direct_cycle_h[:a][:f] = direct_cycle_h[:a]
    undirect_cycle_h = {
      :a => {
         :b => [ :c ],
       },
      :d => {
        :e => nil,
      },
    }
    undirect_cycle_h[:d][:g] = undirect_cycle_h[:a]
    [
      (send method_to_test, [
        [ 1, [ 2, 3, [ 4 ] ] ],
        lambda {|x| "a{#{x}}a" },
        :deep_keys.to_nil,
        :duck_type_d.to_nil,
        :debug_please.negate_me,
      ]),

      (send method_to_test, [
        {
          :a => {
             :b => :c,
           },
          :d => {
            :e => nil,
          },
        },
        lambda {|x| "h{#{x}}h" },
        :deep_keys.to_nil,
        :duck_type_d.to_nil,
        :debug_please.negate_me,
      ]),

      (send method_to_test, [
        direct_cycle_h,
        lambda {|x| "dch{#{x}}dch" },
        :deep_keys.to_nil,
        :duck_type_d.to_nil,
        :debug_please.negate_me,
      ]),

      (send method_to_test, [
        undirect_cycle_h,
        lambda {|x| "uch{#{x}}uch" },
        :deep_keys.to_nil,
        :duck_type_d.to_nil,
        :debug_please.negate_me,
        :duck_type_table.to_nil,
        :tuples.to_nil,
        :stack.to_nil,
        :visited_nodes.to_nil,
        :direct_cycle_placeholder.to_nil,
        :undirect_cycle_placeholder.to_nil,
        :undirect_graph,
      ]),

      (send method_to_test, [
        undirect_cycle_h,
        lambda {|x| "not_uch{#{x}}not_uch" },
        :deep_keys.to_nil,
        :duck_type_d.to_nil,
        :debug_please.negate_me,
        :duck_type_table.to_nil,
        :tuples.to_nil,
        :stack.to_nil,
        :visited_nodes.to_nil,
        :direct_cycle_placeholder.to_nil,
        :undirect_cycle_placeholder.to_nil,
        :undirect_graph.negate_me,
      ]),

    ]
  end


=begin
trying to get the interface compatible with
# rest_request_or_open_uri_open
# ideally, i would need an equivalent for
# rest_response__request_base

=end
  def http_request_response__curl args=[]
    stderr = @memory[:stderr]
    url,
      payload,
      verify_ssl,
      unimplemented__headers,
      method,
      auth_user,
      password,
      unimplemented__timeout,
      unused__skip_open_uri,
      debug,
      no_rescuing,
      output_exception,
      reserved = args

    debug = debug.nne
    debug && (stderr.puts "{#{__method__} starting")
    debug && (stderr.puts "caller=#{caller_label}")
    debug && (stderr.puts "args.each_with_index=#{args.each_with_index.entries.inspect}")
    no_rescuing = no_rescuing.nne
    output_exception = output_exception.nne
    method = method.nne "get"
    verify_ssl = verify_ssl.nne
    curl_method = "http_#{method.downcase}"
    curl_post_data = payload.nne
    curl_args = [url, curl_post_data].compact
    block = bled [
      :no_answer.to_nil,
      no_rescuing,
      output_exception,
    ] {
        require 'curb'
        c = Curl::Easy.send(curl_method, *curl_args){|c|
          c.http_auth_types = :basic
          c.username = auth_user
          c.password = password
          c.ssl_verify_host = verify_ssl
          c.ssl_verify_peer = verify_ssl
          c.follow_location = true
          debug && (stderr.puts "c.ssl_verify_peer=#{c.ssl_verify_peer?}")
          debug && (stderr.puts "c.ssl_verify_host=#{c.ssl_verify_host?}")
        }
        c.perform
        [ c.body_str, nil, c.http_connect_code]
    }
    rv = block.first.call

    debug && (stderr.puts "#{__method__}  will return #{rv.inspect}")
    debug && (stderr.puts "#{__method__} returning}")
    rv
  end


=begin
   tests #experiment__web_http_https_server, creating two
   servers, one ssl and another plain, redirecting to
   the ssl one. then, opens a client thread with a client
   connecting to the root document of the plain server
   (and in the end being served by the root document of
   the ssl server).
   note that this function, with default values will run
   forever. client_loop_times must be set (to at least 1)
=end
  def test__experiment__web_http_https_server args = ARGV
    stderr = @memory[:stderr]
    tcp_ssl_server_method,
      http_processing_method,
      http_processing_method_args,
      http_server_port,
      http_ip_addr,
      priv_pemfile,
      cert_pem_file,
      extra_cert_pem_files,
      ssl_cert_pkey_chain_method,
      debug_tcp_ssl_server_method,
      happy_with_request,
      io_method,
      io_method_debug,
      domain,
      admit_non_ssl,
      plain_http_processing_method,
      plain_http_processing_method_args,
      plain_http_server_port,
      plain_http_ip_addr,
      no_debug_client,
      client_loop_times,
      reserved = args
    tcp_ssl_server_method = tcp_ssl_server_method.nne :experiment__web_http_https_server
    domain = domain.nne "localhost"
    http_server_port = http_server_port.nne 8003
    plain_http_server_port = plain_http_server_port.nne 8004
    no_debug_client = no_debug_client.nne
    client_loop_times = client_loop_times.nne Float::INFINITY
    servers = send tcp_ssl_server_method,
      [
        http_processing_method,
        http_processing_method_args,
        http_server_port,
        http_ip_addr,
        priv_pemfile,
        cert_pem_file,
        extra_cert_pem_files,
        ssl_cert_pkey_chain_method,
        debug_tcp_ssl_server_method,
        happy_with_request,
        io_method,
        io_method_debug,
        admit_non_ssl,
        plain_http_processing_method,
        plain_http_processing_method_args,
        plain_http_server_port,
        plain_http_ip_addr,
      ]

    thread_client = Thread.new {
      (1..client_loop_times).map { |i|
        response = test__file_read__uri_root [
          domain,
          plain_http_server_port,
          admit_non_ssl,
          no_debug_client.negate_me,
        ]
        sleep 2
      }
    }
    thread_client.join

    true
  end


=begin
  calls a function with the processing arg
  @param [Array] +args+, an +Array+ whose elements are expected to be:
  +processing_arg+:: [Object]
  +method+:: [Method, String]
  +method_args+:: [Array] args to be given to the +transform_method_name+
  +on_object+:: [String, Boolean]
  +debug+:: [Boolean]
  +output_exceptions+:: [Boolean]
  
  @return [String] +processing_arg+
=end
  def transform_call args = ARGV
    processing_arg,
      method,
      method_args,
      on_object,
      debug,
      output_exceptions,
      reserved = args
    stderr = @memory[:stderr]
    debug = debug.nne
    debug && (stderr.puts "{#{__method__} starting")
    debug && (stderr.puts "caller=#{caller_label}")
    debug && (stderr.puts "args.each_with_index=#{args.each_with_index.entries.inspect}")
    object_arg = on_object.nne && processing_arg || nil
    to_method_block = bled [
      nil,
      :no_rescue.negate_me,
      output_exceptions,
    ] {
      to_method(
        [method, object_arg]).call(
          [processing_arg] + method_args
      )
    }
    rv =  to_method_block.first.call
    debug && (stderr.puts "will return first of: #{rv.inspect}")
    debug && (stderr.puts "#{__method__} returning}")
    rv.first
  end


=begin
  # documentation_begin
  # short_desc = "natural improvement of experiment__tester: but protect each case from exception throwing",
  @memory[:documentation].push = {
    :function   => :tester_with_bled,
    :short_desc => short_desc,
    :description => "",
    :params     => [
      {
        :name             => :args,
        :description      => "list of parameters",
        :duck_type        => Array,
        :default_behavior => [],
        :params           => [
          {
            :name             => :test_cases,
            :duck_type        => Array,
            :default_behavior => :[],
            :description      => "Array having the fields: __test_id__, __test_expected_value__ and __actual_params__. __actual_params__ is an __Array__ having  as first member __method_name__ to be called, and all its remaining args __method_args__ (a __splat__) will be given to __method_name__",
          },
          {
            :name             => :debug,
            :duck_type        => Object,
            :default_behavior => :nil,
            :description      => "prints debug information to the __IO__ specified by __@memory[:stderr]__ (STDERR by default)",
          },
          {
            :name             => :use_first_of_bled_return,
            :duck_type        => Object,
            :default_behavior => :nil,
            :description      => "will ignore the exception report information returned by bled, and use only the first value.",
          },
          {
            :name             => :output_exceptions,
            :duck_type        => :boolean,
            :default_behavior => :nil,
            :description      => "exceptions are normally properly handled by inner functions, but setting this to true can be helpful to debug some cases",
            :forwarded        => [
              { :to => :bled, :as => :output_exceptions }
            ],
          },
          {
            :name             => :no_rescue,
            :duck_type        => :boolean,
            :default_behavior => :nil,
            :description      => "don't protect against exceptions happening",
            :forwarded        => [
              { :to => :bled, :as => :dont_rescue }
            ],
          },
          {
            :name             => :reserved,
            :duck_type        => Object,
            :default_behavior => :nil,
            :description      => "for future use",
          },
        ],
      },
    ],
    :return_value     => [
      {
        :name             => :args,
        :description      => "__true__ if tests were successful, __false__ otherwise",
        :duck_type        => :boolean,
      },
    ],
  }
  # documentation_end
=end
  def tester_with_bled args=[]
    stderr = @memory[:stderr]
    test_cases,
      debug,
      use_first_of_bled_return,
      output_exceptions,
      no_rescue,
      reserved = args

    debug = debug.nne
    debug && (stderr.puts "{#{__method__} starting")
    debug && (stderr.puts "caller=#{caller_label.inspect}")
    debug && (stderr.puts "args=#{args.inspect}")
    use_first_of_bled_return = use_first_of_bled_return.nne
    test_cases = test_cases.nne [
     # [ :id, :expectation, :actual_params ],
     # :actual_params: array with :method_name + :method_args
    ]
    expectation = {}
    actual = {}
    debug && (stderr.puts "test_cases.size=#{test_cases.size}")
    test_cases.each_with_index{ |test_case|
      debug && (stderr.puts "test_case=[test_case_id, test_expectation, actual_params]=#{test_case.inspect}")
      test_case_id, test_expectation, actual_params = test_case
      actual_params_method_name,
        *actual_params_method_args = actual_params
      debug && (stderr.puts "will send: #{actual_params_method_name.to_s}(*#{actual_params_method_args.inspect})")

      block = bled [
        nil,
        no_rescue,
        output_exceptions,
      ] {
          send actual_params_method_name, *actual_params_method_args
      }
      result = block.first.call

      expectation[test_case_id] = test_expectation
      use_first_of_bled_return && (actual[test_case_id] = result.first)
      use_first_of_bled_return.negate_me && (actual[test_case_id] = result)
      debug && (stderr.puts "[test_expectation.hash, result.hash]=#{[test_expectation.hash, result.hash].inspect}")
    }
    judgement = actual.keys.map {|test_case|
      [expectation[test_case], actual[test_case] , test_case]
    }.map(&method("expect_equal")).all?

    rv = judgement
    debug && (stderr.puts "will return #{rv.inspect}")
    debug && (stderr.puts "#{__method__} returning}")
    rv
  end


=begin
  returns a timestamp in the format "%Y.%m.%d_%H:%M:%S"
=end
  def time__now_strftime_default
    Time.now.strftime("%Y.%m.%d_%H:%M:%S")
  end


=begin
  # documentation_begin
  # short_desc = "this improves experiment__tester by encapsulating the bled block building, calls experiment__tester too "
  @memory[:documentation].push = {
    :function   => :experiment__tester_with_bled,
    :short_desc => short_desc,
    :description => "",
    :params     => [
      {
        :name             => :args,
        :description      => "list of parameters",
        :duck_type        => Array,
        :default_behavior => [],
        :params           => [
          {
            :name             => :test_cases_method_args,
            :duck_type        => Object,
            :default_behavior => :nil,
            :description      => "for future use",
          },
          {
            :name             => :test_cases_array,
            :duck_type        => Object,
            :default_behavior => :nil,
            :description      => "for future use",
          },
          {
            :name             => :debug,
            :duck_type        => :boolean,
            :default_behavior => :nil,
            :description      => "prints debug information to the __IO__ specified by __@memory[:stderr]__ (STDERR by default)",
          },
          {
            :name             => :debug_experiment__tester,
            :duck_type        => :boolean,
            :default_behavior => :nil,
            :forwarded        => [
              { :to => :experiment__tester, :as => :debug }
            ],
          },
          {
            :name             => :output_exceptions,
            :duck_type        => :boolean,
            :default_behavior => :nil,
            :description      => "exceptions are normally properly handled by inner functions, but setting this to true can be helpful to debug some cases",
          },
          {
            :name             => :to_method_debug,
            :duck_type        => :boolean,
            :default_behavior => :nil,
            :forwarded        => [
              { :to => :to_method , :as => :to_method_debug }
            ],
          },
          {
            :name             => :to_object_method_debug,
            :duck_type        => :boolean,
            :default_behavior => :nil,
            :forwarded        => [
              { :to => :to_method , :as => :to_object_method_debug }
            ],
          },
          {
            :name             => :reserved,
            :duck_type        => Object,
            :default_behavior => :nil,
            :description      => "for future use",
          },
        ],
      },
    ],
    :return_value     => [
      {
        :name             => :args,
        :description      => "list of parameters",
        :duck_type        => Array,
        :default_behavior => [],
        :params           => [
          {
            :name             => :reserved,
            :duck_type        => Object,
            :default_behavior => :nil,
            :description      => "for future use",
          },
        ],
      },
    ],
  }
  # documentation_end
=end
  def experiment__tester_with_bled args=[]
    stderr = @memory[:stderr]
    test_cases_method,
      test_cases_method_args,
      test_cases_array,
      debug,
      debug_experiment__tester,
      output_exceptions,
      to_method_debug,
      to_object_method_debug,
      no_rescue,
      reserved = args
    debug = debug.nne
    debug && (stderr.puts "{#{__method__} starting")
    debug && (stderr.puts "caller=#{caller_label}")
    debug && (stderr.puts "args=#{args.inspect}")
    test_cases_array = test_cases_array.nne []
    test_cases_method_args = test_cases_method_args.nne []
    test_cases_from_method = (to_method [
      test_cases_method,
      to_method_debug,
      to_object_method_debug,
      no_rescue,
    ]).call *test_cases_method_args
    debug && (stderr.puts "test_cases_array.size=#{test_cases_array.size}")
    debug && (stderr.puts "test_cases_from_method.size=#{test_cases_from_method.size}")
    test_cases = test_cases_from_method.to_a + test_cases_array.to_a
    debug && (stderr.puts "test_cases.size=#{test_cases.size}")
    experiment__tester_block = bled [
      nil,
      no_rescue,
      output_exceptions,
    ] {
        experiment__tester [
        test_cases,
        debug_experiment__tester,
      ]
    }
    debug && (stderr.puts "experiment__tester_block=#{experiment__tester_block.inspect}")
    rv = experiment__tester_block.first.call
    debug && (stderr.puts "will return first of #{rv.inspect}")
    !rv.first && (stderr.puts "{#{__method__}: failed with arguments=#{args.inspect}}")
    rv[1] && (stderr.puts "{#{__method__} exception caught:")
    rv[1] && (stderr.puts :exception_output.__is(rv[1][1]))
    rv[1] && (stderr.puts "#{__method__} exception caught}")
    debug && (stderr.puts "#{__method__} returning}")
    rv.first
  end


=begin
  give as first element in args to experiment__tester_with_bled
=end
  def test_cases__send_enumerator args=[]
    testing_method = :send_enumerator
    test_cases ||= [
      [
        :test_case_id.__is("array_base"),
        :expectation.array__is("post", "get"),
        :get_actual_results_with.array__is(
          testing_method,
          :testing_method_args.array__is(
            :enum.array__is("http_post", "http_get"),
            :method_to_each_in_enum.__is(:gsub),
            :args_to_method.array__is("http_", ""),
            :block_to_method.__is(:whatever),
            :insert_iterating_element_at.__is(:ensure.__is(nil)),
            :debug.__is(false),
            :no_output_exceptions.__is(nil),
            :rescuing_exceptions.__is(nil),
            :return_not_only_first.__is(nil),
          ),
        ),
      ].__note("end of array_base"),

      [
        :test_case_id.__is("two_hashes_base"),
        :expectation.array__is(
          [{}], [{}],
        ),
        :get_actual_results_with.array__is(
          testing_method,
          :testing_method_args.array__is(
            [ {}, {} ],
            :containerize,
            [],
            :block_to_method.__is(:whatever),
            :insert_iterating_element_at.__is(0),
            :debug.__is(nil),
            :no_output_exceptions.__is(nil),
            :rescuing_exceptions.__is(nil),
            :return_not_only_first.__is(nil),
          ),
        ),
      ].__note("end of two_hashes_base"),

      [
        :test_case_id.__is("two_hashes_size"),
        :expectation.array__is(0, 0),
        :get_actual_results_with.array__is(
          testing_method,
          :testing_method_args.array__is(
            [ {}, {} ],
            Proc.new {|x| x.size },
            [].to_nil,
            :block_to_method.__is(:whatever),
            :insert_iterating_element_at.__is(0),
            :debug.__is(nil),
            :no_output_exceptions.__is(nil),
            :rescuing_exceptions.__is(nil),
            :return_not_only_first.__is(nil),
          ),
        ),
      ].__note("end of two_hashes_size"),

      [
        :test_case_id.__is("distribute_methods_over_object_v1"),
        :expectation.array__is(
          "Test", "TEST",
        ),
        :get_actual_results_with.array__is(
          testing_method,
          :testing_method_args.array__is(
            ["capitalize", "upcase" ],
            Proc.new {|method| "test".send method },
            nil,
            :block_to_method.__is(:whatever),
            :insert_iterating_element_at.__is(0),
            :debug.__is(nil),
            :no_output_exceptions.__is(nil),
            :rescuing_exceptions.__is(nil),
            :return_not_only_first.__is(nil),
          ),
        ),
      ].__note("end of distribute_methods_over_object_v1"),

      [
        :test_case_id.__is("distribute_methods_over_object_v2"),
        :expectation.array__is(
          "Test", "TEST",
        ),
        :get_actual_results_with.array__is(
          testing_method,
          :testing_method_args.array__is(
            ["capitalize", "upcase" ],
            "test".method(:send),
            :args_to_method.__is(nil),
            :block_to_method.__is(:whatever),
            :insert_iterating_element_at.__is(0),
            :debug.__is(nil),
            :no_output_exceptions.__is(nil),
            :rescuing_exceptions.__is(nil),
            :return_not_only_first.__is(nil),
          ),
        ),
      ].__note("end of distribute_methods_over_object_v2"),

      [
        :test_case_id.__is("array_map"),
        :expectation.array__is(
          [2, 3, 4],
        ),
        :get_actual_results_with.array__is(
          testing_method,
          :testing_method_args.array__is(
            :enum.array__is([1, 2, 3]),
            :method_to_each_in_enum.__is(:map),
            :args_to_method.__is(nil),
            :block_to_method.__is(Proc.new {|x| x + 1 }),
            :insert_iterating_element_at.__is(:ensure.__is(nil)),
            :debug.__is(nil),
            :no_output_exceptions.__is(nil),
            :rescuing_exceptions.__is(nil),
            :return_not_only_first.__is(nil),
          ),
        ),
      ].__note("end of array_map"),

    ]

  end


=begin
  Just alias to
  experiment__tester_with_bled containerize test_cases__send_enumerator
=end
  def test__send_enumerator args=[]
    debug,
      reserved = args
    stderr = @memory[:stderr]
    debug = debug.nne
    debug && (stderr.puts "{#{__method__} starting")
    debug && (stderr.puts "caller=#{caller_label}")
    debug && (stderr.puts "args=#{args.inspect}")
    rv = experiment__tester_with_bled [:test_cases__send_enumerator]
    debug && (stderr.puts "will return #{rv.inspect}")
    debug && (stderr.puts "#{__method__} returning}")
    rv
  end


=begin
  # documentation_begin
  # short_desc = "parses an http request"
  @memory[:documentation].push = {
    :function   => :experiment__http_request_parse,
    :short_desc => short_desc,
    :description => "",
    :params     => [
      {
        :name             => :args,
        :description      => "list of parameters",
        :duck_type        => Array,
        :default_behavior => [],
        :params           => [
          {
            :name             => :request,
            :duck_type        => [String, :array_of_strings],
            :default_behavior => :nil,
            :description      => "for future use",
          },
            :name             => :debug,
            :duck_type        => :boolean,
            :default_behavior => :nil,
            :description      => "prints debug information to the __IO__ specified by __@memory[:stderr]__ (STDERR by default)",
          },
          {
            :name             => :methods_to_call,
            :duck_type        => Array,
            :default_behavior => [
              :path_info,
              :request_uri,
              :body,
              :request_method,
              :ssl?,
            ]
            :description      => "methods/properties to extract from a WEBrick::HTTPRequest object -- it must be a valid method callable without parameters.",
          },
          {
            :name             => :output_exceptions,
            :duck_type        => :boolean,
            :default_behavior => :nil,
            :description      => "exceptions are normally properly handled by inner functions, but setting this to true can be helpful to debug some cases",
          },
          {
            :name             => :reserved,
            :duck_type        => Object,
            :default_behavior => :nil,
            :description      => "for future use",
          },
        ],
      },
    ],
    :return_value     => [
      {
        :name             => :args,
        :description      => "list of parameters",
        :duck_type        => Array,
        :default_behavior => [],
        :params           => [
          {
            :name             => :reserved,
            :duck_type        => Object,
            :default_behavior => :nil,
            :description      => "for future use",
          },
        ],
      },
    ],
  }
  # documentation_end
=end
  def experiment__http_request_parse args=[]
    request,
      debug,
      methods_to_call,
      output_exceptions,
      reserved = args
    stderr = @memory[:stderr]
    debug = debug.nne
    debug && (stderr.puts "{#{__method__} starting")
    debug && (stderr.puts "caller=#{caller_label}")
    debug && (stderr.puts "args.each_with_index=#{args.each_with_index.entries.inspect}")
    # debug && (stderr.puts "backtrace=#{backtrace}")
    output_exceptions = output_exceptions.nne
    methods_to_call = methods_to_call.nne [
      :path_info,
      :request_uri,
      :body,
      :request_method,
      :ssl?,
    ]
    request = (containerize request.nne "").join
    debug && (stderr.puts "=#{}")
    require 'webrick'
    require 'stringio'
    req = WEBrick::HTTPRequest.new(WEBrick::Config::HTTP)
    block = bled [
      :no_answer.to_nil,
      :no_rescue.negate_me,
      output_exceptions,
    ] {
      req.parse(StringIO.new(request))
      req
    }
    parse_return = block.first.call
    methods_result_return = send_enumerator [
      methods_to_call,
      req.method(:send),
      :args_to_method.array__is(nil),
      :block_to_method.__is(:whatever),
      :insert_iterating_element_at.__is(0),
      :debug.__is(nil),
      :no_output_exceptions.__is(output_exceptions.negate_me),
      :rescuing_exceptions.__is(nil),
      :return_not_only_first.__is(true),
    ]
    methods_result = methods_result_return.transpose[0]
    rv = [
      req,
      methods_to_call,
      methods_result,
      parse_return,
      methods_result_return,
    ]
    debug && (stderr.puts "#{__method__}  will return #{rv.inspect}")
    debug && (stderr.puts "#{__method__} returning}")
    rv
  end


=begin
  returns an array having all the valid values for elements
  of methods_to_call parameter of #experiment__http_request_parse
=end
  def callable_methods__http_request_parse args=[]
    methods_to_call = methods_to_call.nne [
      :path_info,
      :request_uri,
      :content_length,
      :body,
      :request_method,
      :ssl?,
      :path,
      :host,
      :attributes,
      :accept,
      :port,
      :query,
      :user,
      :addr,
      :header,
      :body,
      :request_method,
      :content_type,
      :keep_alive,
      :cookies,
      :http_version,
      :accept_charset,
      :query_string,
      :script_name,
      :server_name,
      :accept_encoding,
      :accept_language,
      :peeraddr,
      :raw_header,
      :continue,
      :remote_ip,
      :keep_alive?,
      :fixup,
    ]
  end


=begin
  # short_desc = "creates an http response, after executing the GET "

  @memory[:documentation].push = {
    :function   => :experiment__http_response_invoke,
    :short_desc => short_desc,
    :description => "",
    :params     => [
      {
        :name             => :args,
        :description      => "list of parameters",
        :duck_type        => Array,
        :default_behavior => "interpreted as empty array",
        :params           => [
          {
            :name             => :request,
            :duck_type        => String,
            :default_behavior => :nil
            :description      => "ignored, will redirect whatever request is made. nil is used.",
          },
          {
            :name             => :location,
            :duck_type        => String,
            :default_behavior => "",
            :description      => "Location: field value (the url to redirect to)",
          },
          {
            :name             => :code,
            :duck_type        => String,
            :default_behavior => "200 OK",
            :description      => "Request code",
          },
          {
            :name             => :version,
            :duck_type        => String,
            :default_behavior => "1.1",
            :description      => "HTTP protocol version",
          },
          {
            :name             => :debug,
            :duck_type        => Object,
            :default_behavior => :nil,
            :description      => "prints debug information to the __IO__ specified by __@memory[:stderr]__ (STDERR by default)",
          },
          {
            :name             => :eol,
            :duck_type        => Object,
            :default_behavior => "\r\n",
            :description      => "separator to join each line of the response",
          },
          {
            :name             => :debug_request_parse,
            :duck_type        => :boolean,
            :default_behavior => :nil,
            :forwarded        => [
              { :to => experiment__http_request_parse , :as => :debug }
            ],
          },
          {
            :name             => :output_exceptions,
            :duck_type        => :boolean,
            :default_behavior => :nil,
            :description      => "exceptions are normally properly handled by inner functions, but setting this to true can be helpful to debug some cases",
          },
          {
            :name             => :reserved,
            :duck_type        => Object,
            :default_behavior => "interpreted as nil",
            :description      => "for future use",
          },
        ],
      },
    ],
  }

=end
  def experiment__http_response_invoke args = []
    request,
      location,
      code,
      version,
      debug,
      eol,
      debug_request_parse,
      output_exceptions,
      reserved = args
    stderr = @memory[:stderr]
    stdout = @memory[:stdout]
    debug = debug.nne
    debug && (stderr.puts "{#{__method__} starting")
    debug && (stderr.puts "caller=#{caller_label}")
    debug && (stderr.puts "args.each_with_index=#{args.each_with_index.entries.inspect}")
    request_parse = experiment__http_request_parse [
      request,
      debug_request_parse,
      :methods_to_call.to_nil,
      output_exceptions,
    ]
    debug && (stderr.puts "request_parse[2]=#{request_parse[2]}")
    require "shellwords"
    # request_parse[2][0] is the  the request_uri
    # remove any starting slashes before sending to invoke:
    args_for_rubyment = Shellwords.split(request_parse[2][0].to_s.gsub /\/*/, "")
    debug && (stderr.puts "args_for_rubyment=#{args_for_rubyment}")
    request_stdout = StringIO.new
    request_stderr = StringIO.new
    # not thread-safe:
    @memory[:stdout] = request_stdout
    @memory[:stderr] = request_stderr
    block = bled [
      :no_answer.to_nil,
      :no_rescue.negate_me,
      :output.negate_me,
    ] {
      invoke args_for_rubyment
    }
    invoke_result = block.first.call
    @memory[:stdout] = stdout
    @memory[:stderr] = stderr
    require 'json'
    payload = ({
     "invoke_result"  => invoke_result,
     "request_stdout" => request_stdout.string,
     "request_stderr" => request_stderr.string,
    }).to_json
    debug && (stderr.puts "payload=#{payload}")
    location = location.nne ""
    version = version.nne "1.1"
    code = code.nne "200 OK"
    eol = eol.nne "\r\n"
    rv = http_response_base [
      payload,
      :content_type.to_nil,
      code,
      version,
      :keep_alive.to_nil,
      debug,
      eol,
      location,
    ]
    debug && (stderr.puts "#{__method__} will return #{rv.inspect}")
    debug && (stderr.puts "#{__method__} returning}")
    rv
  end


=begin
  returns an array having all the paths which are ancestors of
  path, and path at the end of that array
=end
  def parent_dirs__from path
    path_parent = File.dirname(path)
    base_case   = (path == path_parent)
    rv = []
    base_case.negate_me && (
      rv =  parent_dirs__from path_parent
    )
    rv.push path
  end


=begin
  will call puts on the stderr
=end
  def stderr_puts *args
    stderr = rubyment_memory__get_key :stderr
    stderr.puts *args
  end


=begin
  will call puts on the stdout
=end
  def stdout_puts *args
    stdout = rubyment_memory__get_key :stdout
    stdout.puts *args
  end


=begin
  force arguments to be given to method
  as an array

=end
  def invoke_as_array *args
    method_to_invoke,
    *args_to_method = args
    send method_to_invoke, args_to_method
  end


=begin
  force arguments to be given to method
  as a splat
=end
  def invoke_as_splat args=[]
    method_to_invoke,
    *args_to_method = args
    send method_to_invoke, *args_to_method
  end


=begin
  # short_desc = "creates an http response, after executing the GET "

  @memory[:documentation].push = {
    :function   => :experiment__http_response_invoke_clone,
    :short_desc => short_desc,
    :description => "",
    :params     => [
      {
        :name             => :args,
        :description      => "list of parameters",
        :duck_type        => Array,
        :default_behavior => "interpreted as empty array",
        :params           => [
          {
            :name             => :request,
            :duck_type        => String,
            :default_behavior => :nil
            :description      => "ignored, will redirect whatever request is made. nil is used.",
          },
          {
            :name             => :location,
            :duck_type        => String,
            :default_behavior => "",
            :description      => "Location: field value (the url to redirect to)",
          },
          {
            :name             => :code,
            :duck_type        => String,
            :default_behavior => "200 OK",
            :description      => "Request code",
          },
          {
            :name             => :version,
            :duck_type        => String,
            :default_behavior => "1.1",
            :description      => "HTTP protocol version",
          },
          {
            :name             => :debug,
            :duck_type        => Object,
            :default_behavior => :nil,
            :description      => "prints debug information to the __IO__ specified by __@memory[:stderr]__ (STDERR by default)",
          },
          {
            :name             => :eol,
            :duck_type        => Object,
            :default_behavior => "\r\n",
            :description      => "separator to join each line of the response",
          },
          {
            :name             => :debug_request_parse,
            :duck_type        => :boolean,
            :default_behavior => :nil,
            :forwarded        => [
              { :to => experiment__http_request_parse , :as => :debug }
            ],
          },
          {
            :name             => :output_exceptions,
            :duck_type        => :boolean,
            :default_behavior => :nil,
            :description      => "exceptions are normally properly handled by inner functions, but setting this to true can be helpful to debug some cases",
          },
          {
            :name             => :reserved,
            :duck_type        => Object,
            :default_behavior => "interpreted as nil",
            :description      => "for future use",
          },
        ],
      },
    ],
  }

=end
  def experiment__http_response_invoke_clone args = []
    request,
      location,
      code,
      version,
      debug,
      eol,
      debug_request_parse,
      output_exceptions,
      reserved = args
    stderr = @memory[:stderr]
    stdout = @memory[:stdout]
    debug = debug.nne
    debug && (stderr.puts "{#{__method__} starting")
    debug && (stderr.puts "caller=#{caller_label}")
    debug && (stderr.puts "args.each_with_index=#{args.each_with_index.entries.inspect}")
    request_parse = experiment__http_request_parse [
      request,
      debug_request_parse,
      :methods_to_call.to_nil,
      output_exceptions,
    ]
    debug && (stderr.puts "request_parse[2]=#{request_parse[2]}")
    require "shellwords"
    # request_parse[2][0] is the  the request_uri
    # remove any starting slashes before sending to invoke:
    args_for_rubyment = Shellwords.split(request_parse[2][0].to_s.gsub /\/*/, "")
    debug && (stderr.puts "args_for_rubyment=#{args_for_rubyment}")
    request_stdout = StringIO.new
    request_stderr = StringIO.new
    # not thread-safe:
    @memory[:stdout] = request_stdout
    @memory[:stderr] = request_stderr
    block = bled [
      :no_answer.to_nil,
      :no_rescue.negate_me,
      :output.negate_me,
    ] {
      invoke args_for_rubyment
    }
    invoke_result = block.first.call
    @memory[:stdout] = stdout
    @memory[:stderr] = stderr
    html_request_stdout = request_stdout.string.split("\n")
    html_request_stderr = request_stderr.string.split("\n")
    require 'json'
    payload = CGI.escapeHTML JSON.pretty_generate({
     "invoke_result"  => invoke_result,
      "request_stdout" => html_request_stdout,
      "request_stderr" => html_request_stderr,
    })

    debug && (stderr.puts "args_for_rubyment.size=#{args_for_rubyment.size}")
    debug && (stderr.puts "args_for_rubyment.size.nne=#{args_for_rubyment.size.nne}")
    debug && (stderr.puts "args_for_rubyment.size.nne.negate_me=#{args_for_rubyment.size.nne.negate_me}")
    args_for_rubyment.size.nne.negate_me && (payload = html_content__basic_shell)
    debug && (stderr.puts "payload=#{payload}")
    location = location.nne ""
    version = version.nne "1.1"
    code = code.nne "200 OK"
    eol = eol.nne "\r\n"
    rv = http_response_base [
      payload,
      :content_type.to_nil,
      code,
      version,
      :keep_alive.to_nil,
      debug,
      eol,
      location,
    ]
    debug && (stderr.puts "will return #{rv.inspect}")
    debug && (stderr.puts "#{__method__} returning}")
    rv
  end


=begin
  inverse of #file__json
=end
  def load__file_json_quiet args=[]
    require 'json'
    file_path,
    debug,
      reserved = args
    debug = debug.nne
    stderr = @memory[:stderr]
    debug && (stderr.puts "{#{__method__} starting")
    debug && (stderr.puts "caller=#{caller_label}")
    debug && (stderr.puts "args=#{args.inspect}")
    file_contents = File.read file_path
    debug && (stderr.puts "file_contents size=#{file_contents.size}")
    loaded = JSON.parse file_contents
    debug && (stderr.puts "loaded size=#{loaded.size}")
    debug && (stderr.puts "loaded=#{loaded.inspect}")
    rv = loaded[:root.to_s]
    # if raises exception before it will be unbalanced :
    debug && (stderr.puts "#{__method__} will return #{rv.inspect}")
    debug && (stderr.puts "#{__method__} returning}")
    rv
  end


=begin

  To generate and execute a code like this:

    arrays.map { |a|
      a.index element
    }

    just give as a code_pattern:

    [
      arrays,
      "map",
      "index",
      element,
    ]

=end
  def pattern_exec__mapping_an_object code_pattern

    iterating_object,         # arrays
      yielding_method_name,   # "map"
      mapping_method_name,    # "index"
      args_to_mapping_method, # element
      reserved = code_pattern

    iterating_object.send(yielding_method_name) { |a|
      a.send mapping_method_name, *args_to_mapping_method
    }

  end


=begin
  Takes a file_string definition as input and output
  a new one.

  A file_string definition is an image of a file on
  a string. Each time this function is called, the
  image is written to the disk (if set), and the previous
  file_contents is loaded into the string.

  The first element of file_string is a file_path, existing
  or not.

  the returned file_string has the same first element, and
  the second is either:
  . unexisting file_path
  . a string having the file path contents, in the case it is a file_path
  . a list of file_strings, one per each file inside a directory, in
  the case file_path is a directory.

  This function, after generating the file_string to be returned,
  will write file_path accordingly to the second parameter. If :
  . a string: will write the string to the file_path (if file_path
  is not a directory, otherwise does nothing).
  . a list of file_strings / nil: will call recursively this function
  for each of the file_string inside, and will create file_path as
  directory (if still does not exist).

  There is yet a third element in a file_string,  mode (as in "rw+",
  and not as in permissions), used as parameter for file write.
  Check https://ruby-doc.org/core-2.3.1/IO.html#method-c-new


  This function does not have semantics to be called from
  the command line in its full interface, because
  it differentiates nil from ""

  Planned improvements: permissions, shallow cat of a dir.

  Examples:

  # -- case: touch (non existing path and empty string)
  file_string__experimental ["non_existing_path", ""]

  # -- case: echo >  (existing or not path (can't be a dir) and non empty string)
  file_string__experimental ["existing_or_not_path__file", "contents of file"]

  # -- case: echo >>  (existing path (no dir) and non empty string, "a" mode)
  file_string__experimental ["existing_or_not_path__file", "contents of file", "a"]

  # -- case: cat (path exists, (dir or file) otherwise becomes mkdir, nil string  -- it is a recursive cat in the case of directories )
  file_string__experimental ["existing_path"]

   # --- case: mkdir (or mkdir -p with only one argument): (non existing filepath, no string)
  file_string__experimental ["non_existing_path"]

   # -- case: mkdir -p  (non existing filepath, no string)
  file_string__experimental ["a/b/c/d"]


=end
  def file_string__experimental file_string
    args = file_string

    file_path,
      string_or_file_strings,
      mode,
      reserved = containerize(args)


    # if file_path is a directory, calls recursively this
    # function, retrieving the file_string representation
    # for each entry in a subdirectory:
    file_strings_entries = File.directory?(file_path) && (
      Dir.new(file_path).entries
    ).nne([]).map { |file_path_entry|
      next_file_path = [file_path, file_path_entry].join("/")
      # To avoid infinite recursion, we need to check if
      # the next file path is not something like the
      # parent with "/./" at the end.
      # It is not simple to normalize file paths:
      # https://stackoverflow.com/a/53884097/533510
      # It makes more difficult the fact that the next
      # may not yet exist (although the parent must exist).
      # But the parent has to exist. And, if the next
      # and the parent are the same, then both exist. In
      # that case, we case compare if both have the
      # same inode.

      inodes = [
        [
          File.stat(file_path).ino,
          File.stat(File.dirname file_path).ino,
        ],
        :index,
        (
          bled_call { File.stat(next_file_path).ino }
        ).first,
      ]

      skip = invoke__basic_sender_array(inodes)
      skip.negate_me &&
        # recursive call
        send(__method__, [next_file_path]) ||
        nil
    }.compact

    # what is considered to be a file_path's contents?
    # this value will be the string_or_file_strings of
    # the returned value
    file_contents =
      # first case: it's a directory, thus its contents.
      file_strings_entries || (
      # second case: plain file, thus its contents as string
        bled_call {
          File.read(file_path)
        }
      # third case: non existing file (nil returned)
      ).first

    string,
     file_strings = object__decompose string_or_file_strings

    # let's just write file_path accordingly
    # to string_or_file_strings, regardless of file_contents

    require 'fileutils'
    bled_call {
      string && (
        # for write matters:
        # if string, then file_path is a file...
        FileUtils.mkdir_p File.dirname file_path
        File.write file_path,  string, mode: mode
      ) || (
        # otherwise file_path is a directory...
        FileUtils.mkdir_p file_path
      )
    }


    # if string_or_file_strings is a a list of file_strings
    # so file_path is interpreted to be written as a
    # directory
    file_strings = file_strings.map { |next_file_string|
      next_file_string = next_file_string.as_container
      # prepend file_path:
      next_file_string[0] = [
        file_path,
        next_file_string[0].to_s,
      ].join("/")

      send __method__, next_file_string # recursive call
    }

    [
      file_path,
      file_contents,
    ]
  end # of file_string__experimental


end # of RubymentExperimentModule


=begin
  # begin_documentation
  This module receives only functions that are maintained.
  Ie, the non-deprecated or not under deprecation functions.
  # end_documentation
=end
module RubymentMaintainedModule


=begin
  # documentation_begin
  # short_desc = "extracts information about a block and return them structurally in an array."
  @memory[:documentation].push = {
    :function   => :block_info_base,
    :short_desc => short_desc,
    :description => "",
    :params     => [
      {
        :name             => :args,
        :description      => "list of parameters",
        :duck_type        => Array,
        :default_behavior => [],
        :params           => [
          {
            :name             => :block,
            :duck_type        => Exception,
            :default_behavior => nil,
            :description      => "block to extract info from",
          },
          {
            :name             => :max_str_index,
            :duck_type        => FixNum,
            :default_behavior => -1,
            :description      => "limit the full string output to this last index",
          },
          {
            :name             => :reserved,
            :duck_type        => Object,
            :default_behavior => nil,
            :description      => "reserved for future use",
          },
        ],
      },
    ],
    :return_value     => [
      {
        :name             => :short,
        :duck_type        => String,
        :default_behavior => "",
        :description      => "a brief about the block; normally a block inspection",
      },
      {
        :name             => :full,
        :duck_type        => String,
        :default_behavior => "",
        :description      => "all the information about the block",
      },
      {
        :name             => :inspection,
        :duck_type        => String,
        :default_behavior => "",
        :description      => "the  block inspection",
      },
      {
        :name             => :source_location,
        :duck_type        => Object,
        :duck_type        => [:_a, Array, :strings],
        :description      => the block location",
      },
      {
        :name             => :source,
        :duck_type        => String,
        :default_behavior => "",
        :description      => "the block source code",
      },
      {
        :name             => :class_,
        :duck_type        => String,
        :default_behavior => "",
        :description      => "the  block class",
      },
      {
        :name             => :comment,
        :duck_type        => String,
        :default_behavior => "",
        :description      => "the  block comment",
      },
      {
        :name             => :reserved,
        :duck_type        => Object,
        :default_behavior => nil,
        :description      => "reserved for future use",
      },
    ],
  }
  # documentation_end
=end
  def block_info_base args=[]
    block,
      max_str_index,
      reserved = args
    inspection = block.inspect
    class_ = block.class
    comment = block.comment rescue [nil, "doesn't respond to :comment"]
    source = block.source rescue [nil, "doesn't respond to :source"]
    source_location = block.source_location rescue [nil, "doesn't respond to :source_location"]
    parameters = block.parameters.inspect rescue [nil, "doesn't respond to :parameters"]
    short = inspection
    full = (
      [
        "inspection{",
        inspection,
        "}",
        "class{",
        class_,
        "}",
        "source_location{",
        source_location,
        "}",
        "source{",
        source,
        "}",
        "comment{",
        comment,
        "}",
        "parameters{",
        parameters,
        "}",
      ]
    ).join "\n"

    full = string_truncate [
      full,
      max_str_index,
    ]
    [short, full, inspection, source_location, source, class_, comment]
  end


=begin 
  # documentation_begin
  # short_desc = "extracts information about an exception and return them structurally in an array."
  @memory[:documentation].push = {
    :function   => :exception_info_base,
    :short_desc => short_desc,
    :description => "",
    :params     => [
      {
        :name             => :args,
        :description      => "list of parameters",
        :duck_type        => Array,
        :default_behavior => [],
        :params           => [
          {
            :name             => :exception,
            :duck_type        => Exception,
            :default_behavior => nil,
            :description      => "exception to extract info from",
          },
          {
            :name             => :max_str_index,
            :duck_type        => FixNum,
            :default_behavior => -1,
            :description      => "limit the full string output to this last index",
          },
          {
            :name             => :reserved,
            :duck_type        => Object,
            :default_behavior => nil,
            :description      => "reserved for future use",
          },
        ],
      },
    ],
    :return_value     => [
      {
        :name             => :short,
        :duck_type        => String,
        :default_behavior => "",
        :description      => "a brief about the exception; normally an exception message",
      },
      {
        :name             => :full,
        :duck_type        => String,
        :default_behavior => "",
        :description      => "all the information about the exception; normally an exception message, backtrace, class and inspection",
      },
      {
        :name             => :inspection,
        :duck_type        => String,
        :default_behavior => "",
        :description      => "the  exception inspection",
      },
      {
        :name             => :backtrace,
        :duck_type        => Object,
        :duck_type        => [:_a, Array, :strings],
        :description      => the exception bactrace",
      },
      {
        :name             => :message,
        :duck_type        => String,
        :default_behavior => "",
        :description      => "the  exception message",
      },
      {
        :name             => :class_,
        :duck_type        => String,
        :default_behavior => "",
        :description      => "the  exception class",
      },
      {
        :name             => :reserved,
        :duck_type        => Object,
        :default_behavior => nil,
        :description      => "reserved for future use",
      },
    ],
  }
  # documentation_end
=end
  def exception_info_base args=[]
    exception,
      max_str_index,
      reserved = args
    inspection = exception.inspect
    backtrace = exception.backtrace
    class_ = exception.class
    message = exception.message,
    short = message
    full = (
      [
        "message{",
        message,
        "}",
        "backtrace{",
      ] +
      backtrace.to_a +
      [
        "}",
        "class{",
        class_,
        "}",
        "}",
        "inspection{",
        inspection,
        "}",
      ]
    ).join "\n"

    full = string_truncate [
      full,
      max_str_index,
    ]
    [short, full, inspection, backtrace, message, class_]
  end


=begin
  # documentation_begin
  # short_desc = "generates a block which may return exceptions instead of raising them."
  examples = [
    "
    (bled [] { :bled_returns }).first.call
    # => [:bled_returns, nil, nil]
    ",
    "
    (bled { :bled_returns }).first.call
    # => [:bled_returns, nil, nil]
    ",
    '
    (bled  { X }).first.call
    => [nil,
     [nil,
     # ...
     #   ["uninitialized constant #<Class:#<Rubyment:0x000000035adcc0>>::X", nil],
     # NameError],
     #    #<NameError: uninitialized constant #<Class:#<Rubyment:0x000000035adcc0>>::X>]
     ',
     '
     (bled ["X is not undefined" ]  { X }).first.call
     # => ["X is not undefined",
     #  [nil,
     #   "message{\
     ',

  ]

  @memory[:documentation].push = {
    :function   => :bled,
    :short_desc => short_desc,
    :description => "",
    :params     => [
      {
        :name             => :args,
        :description      => "list of parameters (splat)",
        :duck_type        => splat,
        :default_behavior => [],
        :params           => [
          {
            :name             => :default_on_exception,
            :duck_type        => Object,
            :default_behavior => :nil,
            :description      => "if an exception happens, this value will be returned in the first element of the return value",
          },
          {
            :name             => :dont_rescue,
            :duck_type        => Object,
            :default_behavior => :nil,
            :description      => "do not rescue exceptions",
          },
          {
            :name             => :output_backtrace,
            :duck_type        => Object,
            :default_behavior => :nil,
            :description      => "debug the block execution (misleading name)",
          },
          {
            :name             => :backtrace_max_str_len,
            :duck_type        => FixNum,
            :default_behavior => :nil,
            :description      => "backtrace outputs can be long, use this to limit it",
          },
          {
            :name             => :debug,
            :duck_type        => Object,
            :default_behavior => :nil,
            :description      => "prints debug information to the __IO__ specified by __@memory[:stderr]__ (STDERR by default)",
          },
          {
            :name             => :reserved,
            :duck_type        => Object,
            :default_behavior => :nil,
            :description      => "for future use",
          },
        ],
      },
    ],
    :return_value     => [
      {
        :name             => :args,
        :description      => "list of parameters",
        :duck_type        => Array,
        :default_behavior => [],
        :params           => [
          {
            :name             => :actual_block_return,
            :duck_type        => Object,
            :default_behavior => :nil,
            :description      => "the actual return value of the block call",
          },
          {
            :name             => :exception_info,
            :duck_type        => Array,
            :default_behavior => [],
            :description      => "exception info if an exception happened, as returned by :exception_information_base",
          },
          {
            :name             => :exception,
            :duck_type        => Exception,
            :default_behavior => :nil,
            :description      => "the exception that happened, if any",
          },
          {
            :name             => :reserved,
            :duck_type        => Object,
            :default_behavior => :nil,
            :description      => "for future use",
          },
        ],
      },
    ],
  }
  # documentation_end
=end
  def bled args=[], &block
    stderr = @memory[:stderr]
    default_on_exception,
      dont_rescue,
      output_backtrace,
      backtrace_max_str_len,
      debug,
      reserved = args
    debug = debug.nne
    debug && (stderr.puts "{#{__method__} starting")
    debug && (stderr.puts "args=#{args.inspect}")
    block ||= lambda {|*block_args|}
    rv = Proc.new { |*block_args|
      (debug || output_backtrace) && (stderr.puts "{#{__method__} block starting")
      (debug || output_backtrace) && (stderr.puts "block_args=#{block_args.inspect}")
      (debug || output_backtrace) && (stderr.puts "block_args.size=#{block_args.size}")
      brv = begin
        local_rv = [ (block.call *block_args), nil, nil]
        (debug || output_backtrace) && (stderr.puts "#{__method__} block: survived exception and returned #{local_rv.inspect}")
        local_rv
      rescue => e
        e_info = exception_info_base [
          e,
          backtrace_max_str_len
        ]
        b_info = block_info_base [
          block,
          backtrace_max_str_len
        ]
        (debug || output_backtrace) && (stderr.puts "#{__method__} block: #{block.inspect}\nfull exception info:\n#{e_info[1]}")
        (debug || output_backtrace) && (stderr.puts "#{__method__} block: info #{b_info[1]} ")
        (debug || output_backtrace) && (dont_rescue) && (stderr.puts "#{__method__} block: dont_rescue=#{dont_rescue.inspect}; will rethrow")
        dont_rescue && (raise e)
        (debug || output_backtrace) && (stderr.puts "#{__method__} block: dont_rescue=#{dont_rescue.inspect}; not rethrowing rethrow")
        [ default_on_exception, e_info, e ]
      end
      (debug || output_backtrace) && (stderr.puts "block #{block.inspect} will return #{brv.inspect}")
      (debug || output_backtrace)  && (stderr.puts "#{__method__} block returning}")
      brv
    }
    rv = [ rv ]
    debug && (stderr.puts "will return #{rv.inspect}")
    debug && (stderr.puts "#{__method__} returning}")
    rv
  end


=begin
  # documentation_begin
  # short_desc = "truncates a string"
  @memory[:documentation].push = {
    :function   => :string_truncate,
    :short_desc => short_desc,
    :description => "",
    :params     => [
      {
        :name             => :args,
        :description      => "list of parameters",
        :duck_type        => Array,
        :default_behavior => [],
        :params           => [
          {
            :name             => :max_str_index,
            :duck_type        => FixNum,
            :default_behavior => -1,
            :description      => "index (not size) where to truncate the string (this is the index of the last char)",
          },
          {
            :name             => :reticenses,
            :duck_type        => String,
            :default_behavior => "...",
            :description      => "string to attach to the result when the resulting string is smaller than the original one (ie, has actually been truncated)",
          },
        ],
      },
    ],
    :return_value     => 
      {
        :name             => :truncated_string,
        :description      => "truncated string",
        :duck_type        => String,
        :default_behavior => :str,
      },
    
  }
  # documentation_end
=end
  def string_truncate args=[]
    str,
      max_str_index,
      reticenses,
      reserved = args
    output_max_str_index = @memory[:output_max_str_index]
    output_max_str_index = output_max_str_index.nne -1
    max_str_index = max_str_index.nne output_max_str_index
    max_str_index = max_str_index.to_i
    reticenses = reticenses.nne "..."
    sliced_str = str.slice(0..max_str_index)
    reticenses = (sliced_str.size < str.size ) && reticenses || ""
    "#{sliced_str}#{reticenses}"
  end



end


=begin
  # begin_documentation
  This module receives only functions that are deprecated.
  They are still kept in Rubyment, but they won't receive
  more updates, because there is a different more modern
  way of achieving the same results.
  The functions here are also not used by any function in
  #RubymentMaintainedModule.
  # end_documentation
=end
module RubymentDeprecatedModule


=begin
  # documentation_begin
  # short_desc = "tests the function #exception_information_base"
  @memory[:documentation].push = {
    :function   => :exception_information_base,
    :short_desc => short_desc,
    :description => "",
    :params     => [
      {
        :name             => :args,
        :description      => "list of parameters",
        :duck_type        => Array,
        :default_behavior => [],
        :params           => [
          {
            :name             => :exception,
            :duck_type        => Exception,
            :default_behavior => nil,
            :description      => "exception to extract info from",
          },
          {
            :name             => :max_str_index,
            :duck_type        => FixNum,
            :default_behavior => -1,
            :description      => "limit the full string output to this last index",
          },
          {
            :name             => :reserved,
            :duck_type        => Object,
            :default_behavior => nil,
            :description      => "reserved for future use",
          },
        ],
      },
    ],
    :return_value     => [
      {
        :name             => :short,
        :duck_type        => String,
        :default_behavior => "",
        :description      => "a brief about the exception; normally an exception inspection",
      },
      {
        :name             => :full,
        :duck_type        => String,
        :default_behavior => "",
        :description      => "all the information about the exception; normally an exception inspection and bactrace",
      },
      {
        :name             => :inspection,
        :duck_type        => String,
        :default_behavior => "",
        :description      => "the  exception inspection",
      },
      {
        :name             => :backtrace,
        :duck_type        => Object,
        :duck_type        => [:_a, Array, :strings],
        :description      => the exception bactrace",
      },
      {
        :name             => :reserved,
        :duck_type        => Object,
        :default_behavior => nil,
        :description      => "reserved for future use",
      },
    ],
  }
  # documentation_end
=end
  def exception_information_base args=[]
    exception,
      max_str_index,
      reserved = args
    inspection = exception.inspect
    backtrace = exception.backtrace
    short = inspection
    full = (
      [
        "inspection (message):",
        inspect,
        "",
        "backtrace:",
        "",
      ] +
      backtrace.to_a
    ).join "\n"

    full = string_truncate [
      full,
      max_str_index,
    ]
    [short, full, inspection, backtrace]
  end


  # calls a function with the processing arg
  # @param [Array] +args+, an +Array+ whose elements are expected to be:
  # +processing_arg+:: [Object]
  # +method+:: [Method, String]
  # +method_args+:: [Array] args to be given to the +transform_method_name+
  # +on_object+:: [String, Boolean]
  #
  # @return [String] +processing_arg+
  def test__transform_call args = ARGV
    processing_arg, method, method_args, on_object = args
    object_arg = on_object.nne && processing_arg || nil
    p args
    to_method(
      [method, object_arg]).call(
        [processing_arg] + method_args
    )
  end


  # use #tcp_ssl_server
  # opens one or more TCP and/or SSL server accepting connections.
  # @param [Array] +args+, an +Array+ whose elements are expected to be:
  # +listening_port+:: [String, Integer] port to listen
  # +ip_addr+:: [String, nil] ip (no hostname) to bind the server. 0, nil, false, empty string will bind to all addresses possible.  0.0.0.0 => binds to all ipv4 . ::0 to all ipv4 and ipv6
  # +admit_plain+:: [Boolean] if +true+, tries to create a normal +TCPServer+, if not possible to create +SSLServer+ (default: +false+, for preventing unadvertnt non-SSL server creation)
  # +debug+:: [Object] for future use
  # +callback_method+:: [String, Method] method to call when a client connects. The method must accept a socket as parameter.
  # +callback_method_args+:: [Array] args to be given to the call_back_method. Note that the type differs from #tcp_server_plain (which takes splat)
  #
  # @return [Array] returns a , an +Array+ whose elements are:
  # +threads+:: [Array of Thread] returns an Array of Thread object looping for accepting  incoming connections (call join on those object for waiting for its completion).
  def tcp_ssl_servers args = ARGV
    stderr = @memory[:stderr]
    listening_port,
      ip_addr,
      debug,
      admit_plain,
      callback_method,
      callback_method_args,
      priv_pemfile,
      cert_pem_file,
      extra_cert_pem_files,
      output_exception,
      reserved = args

    server = (ssl_make_servers [
      listening_port,
      ip_addr,
      debug,
      admit_plain,
      priv_pemfile,
      cert_pem_file,
      extra_cert_pem_files,
      output_exception,
    ]).first.first
    debug.nne && (stderr.puts server)
    Thread.start {
      loop {
        client = runea ["yes, rescue",
          "yes, output exception",
          "nil on exception"
        ] {
          server.accept
        }
        Thread.start(client) { |client|
          debug.nne && (stderr.puts Thread.current)
          debug.nne && (stderr.puts client)
          runoe {
            to_method([callback_method])
              .call([client] + callback_method_args)
          }
        }
      }
    }
  end


  def test_cases_template args=[]
    # testing_method = :send_enumerator
    test_cases ||= [
      # [ :id, :expectation, :actual_params ],
      # actual_params can be an array with method_name + args to that method.
    ]
  end


  def test__file_read___http_request_response__curl args=[]
    # these tests depend on internet connection, so it may be difficult
    # to automate them.
    url_1 = "https://www.google.com/"
    url_1 = "http://www.google.com/"
    url_1 = "https://localhost:8003/"
    url_1 = "https://localhost:8003/"
    url_1 = "http://localhost:8004/tinga"
    p file_read [url_1, nil, nil, nil, nil, :skip_open_uri, :payload.to_nil, false, nil, nil, nil, nil, :http_request_response__curl]
  end


=begin
  inverse of #file__json
  note that, contrary to the common convention,
  the debug output is on for this function
  (due to a mistake, and to respect API-backwards-compatibility)
=end
  def load__file_json args=[]
    require 'json'
    file_path,
    quiet,
      reserved = args
    debug = quiet.nne.negate_me
    stderr = @memory[:stderr]
    debug && (stderr.puts "{#{__method__} starting")
    debug && (stderr.puts "caller=#{caller_label}")
    debug && (stderr.puts "args=#{args.inspect}")
    file_contents = File.read file_path
    debug && (stderr.puts "file_contents size=#{file_contents.size}")
    loaded = JSON.parse file_contents
    debug && (stderr.puts "loaded size=#{loaded.size}")
    debug && (stderr.puts "loaded=#{loaded.inspect}")
    rv = loaded[:root.to_s]
    # if raises exception before it will be unbalanced :
    debug && (stderr.puts "#{__method__} will return #{rv.inspect}")
    debug && (stderr.puts "#{__method__} returning}")
    rv
  end


end # of RubymentDeprecatedModule


=begin
  # begin_documentation
  Group of functions under deprecation

  to be included by #RubymentUnderDeprecationModule
  # end_documentation
=end
module RubymentUnderDeprecationRuneFunctionsModule


  # generic function for test__ functions
  def test__tester args=[]
    expectation = {}
    actual = {}
    test_cases = args
    test_cases ||= [
     # [ :id, :expectation, :actual_params ],
    ]
    test_cases.each_with_index{ |test_case|
      test_case_id, test_expectation, actual_params = test_case
      result = send actual_params[0], actual_params[1]
      expectation[test_case_id] = test_expectation
      actual[test_case_id] = result
    }
    judgement = actual.keys.map {|test_case|
      [expectation[test_case], actual[test_case] , test_case]
    }.map(&method("expect_equal")).all?
  end


  # creates a Proc out of a block
  def bl *args, &block
    block ||= lambda {}
    # Proc.new &block
    Proc.new { block.call  *args }
  end


  # creates a Proc out of a block,
  # will capture all exceptions
  # inside that block and ignore it
  # returns nil
  def blef *args, &block
    # bl exception free
    block ||= lambda {}
    bl {
      begin
        block.call *args
      rescue => e
      end
    }
  end


  # creates a Proc out of a block,
  # will capture all exceptions
  # inside that block and ignore it
  # will return an array having
  # the backtrace (as String) as
  # the first member and the
  # the exception as the second.
  def bloe *args, &block
    block ||= lambda {}
    bl {
      begin
        block.call *args
      rescue => e
        stderr = @memory[:stderr]
        rv = [e.backtrace.join("\n"), e]
        stderr.puts "#{__method__} exception backtrace:"
        stderr.puts rv[0]
        stderr.puts "#{__method__} exception inspection:"
        stderr.puts rv[1].inspect
        stderr.puts "#{__method__} exception message:"
        stderr.puts rv[1]
        rv
      end
    }
  end


  # creates a +Proc+ out of a block,
  # where exceptions may be admissible
  # or not, and to be printed or not.
  # it is an interface for the bl*
  # methods above
  # @param [splat] +args+, an splat whose elements are expected to be +blea_args+ and +blocks_args+:
  # +blea_args+:: [Array] args to be used internally, which are expected to be:
  # +exception_admitted+:: [Boolean]
  # +output_exception+:: [Boolean] note that this only makes sense if exception is admitted -- otherwise an exception will be normally thrown.
  # +ret_nil_on_exception+:: [Boolean] enforces that +nil+ will be returned on exception
  # +blocks_args+:: [splat] args to be forwarded to the block call
  # @return [Proc]
  def blea *args, &block
    blea_args, *block_args = args
    blea_args ||= blea_args.nne []
    exception_admitted, output_exception, ret_nil_on_exception = blea_args
    exception_admitted = exception_admitted.nne
    output_exception   =  output_exception.nne
    bloe_method = ret_nil_on_exception && :bloef || :bloe
    ble_method = output_exception && bloe_method || :blef
    bl_to_call = exception_admitted && ble_method || :bl
    send bl_to_call, *block_args, &block
  end


  # creates a Proc out of a block,
  # will capture all exceptions
  # inside that block and ignore it
  # will return nil
  def bloef *args, &block
    block ||= lambda {}
    bl {
      begin
        block.call *args
      rescue => e
        stderr = @memory[:stderr]
        rv = [e.backtrace.join("\n"), e]
        stderr.puts "#{__method__} exception backtrace:"
        stderr.puts rv[0]
        stderr.puts "#{__method__} exception inspection:"
        stderr.puts rv[1].inspect
        stderr.puts "#{__method__} exception message:"
        stderr.puts rv[1]
      end
    }
  end


  #  runs a block error free
  # (returns nil if exception happens)
  def runef *args, &block
    (blef &block).call *args
  end


  #  runs a block error free, in
  # a different Thread. the Thread object
  #  is returned (call .join on it to
  # wait for its completion)
  # (the Thread itself returns nil if exception happens)
  def runef_threaded *args, &block
    Thread.start(*args) {|*args|
      runef *args, &block
    }
  end


  # runs a block error free
  # (if exception happens,
  # will return an array having
  # the backtrace (as String) as
  # the first member and the
  # the Exception object as the second).
  def runoe *args, &block
    (bloe &block).call *args
  end


  # runs a block error free, in
  # a different Thread. the Thread object
  # is returned (call .join on it to
  # wait for its completion)
  # (if exception happens, the thread
  # itself will return an array having
  # the backtrace (as String) as
  # the first member and the
  # the Exception object as the second).
  def runoe_threaded *args, &block
    Thread.start(*args) {|*args|
      runoe *args, &block
    }
  end


  # creates and runs a +Proc+ out of a block,
  # where exceptions may be admissible
  # or not, and to be printed or not.
  # it is an interface for the run*
  # methods above
  # in this right moment it is not
  # yet possible to return the exception
  # without printing (planned improvement)
  # another desirable case is to output
  # the exception, but don't return it;
  # not yet possible.
  # a third desirable case would be  not to
  # rescue and print the exception, which is
  # also not yet possible.
  # @param [splat] +args+, an splat whose elements are expected to be +blea_args+ and +blocks_args+:
  # +blea_args+:: [Array] args to be used internally, which are expected to be:
  # +exception_admitted+:: [Boolean]
  # +output_exception+:: [Boolean]
  # +blocks_args+:: [splat] args to be forwarded to the block call
  # @return the value returned by the block
  def runea *args, &block
    (blea *args, &block).call
  end


end



=begin
  # begin_documentation
  This module receives only functions that are deprecated.
  They are still kept in Rubyment, but they won't receive
  more updates, because there is a different more modern
  way of achieving the same results.
  However, functions here are still under active use by
  some official functions in #RubymentMaintainedModule,
  which were not yet updated with the new modern way of
  achieving the same results.
  # end_documentation
=end
module RubymentUnderDeprecationModule


  include RubymentUnderDeprecationRuneFunctionsModule


  # experimental stuff coming. usage example:
  # ./rubyment.rb  invoke_double p test__shell_send_array__main  "tinga" "" sub in EN 
  # ["tENga"]
  #  will be deprecated by send_array_base
  # ./rubyment.rb  invoke_double p experiment__send_array_base 300 "bytes"
  # [[51, 48, 48], nil, nil]
  # only works with strings by now
  def test__shell_send_array__main args=[]
    p args
    object_to_send,
      reserved,
      method_to_send,
      *args_to_send = args
    object_to_send = object_to_send.nne
    method_to_send = method_to_send.nne :main
    object_to_send && (
      object_to_send.send method_to_send, *args_to_send
    ) || (!object_to_send) && (
      send method_to_send, args_to_send
    )
  end


end


=begin
  # begin_documentation
  This module receives functions that are supposed to test
  other functions.
  Eventually, these functions may be run automatically.
  They must return false if it fails.
  Eventually a timeouting standard will be set for function
  doing IO.
  # end_documentation
=end
module RubymentTestModule


=begin
  test for #bled
=end
  def test__bled args=[]
    test___experiment__bled :bled
  end


=begin
  test for #experiment__bled
=end
  def test___experiment__bled args=[]
    bled_method_name,
     reserved = args
    bled_method_name = bled_method_name.nne :experiment__bled
    p0 =  send bled_method_name
    y0 = p0.first.call 2, 3
    p1 = send bled_method_name, [] {|x| x}
    y1 = p1.first.call 2, 3
    y1_2 = p1.first.call
    p2 =  send bled_method_name, [
      :default,
      :no_rescue.negate_me,
      :yes_output.negate_me,
    ] {|x| y}
    y2 = p2.first.call 2, 3
    p3 =  send bled_method_name, [
      :default,
      :no_rescue,
      :yes_output.negate_me,
    ] {|x| y}
    y3 = begin
      p3.first.call 2, 3
    rescue => e
      e_info = exception_info_base [e]
      [:default, e_info, e]
    end

    judgement =
      [
        [y0[0], nil, "no params: return value"],
        [y0[1].to_a, [], "no params: e_info"],
        [y0[2], nil, "no params: no exception"],

        [y1[0], 2, "{|x| x}: return value"],
        [y1[1].to_a, [], "{|x| x}: e_info"],
        [y1[2], nil, "{|x| x}: no exception"],

        [y1_2[0], nil, "{|x| x}: return value"],
        [y1_2[1].to_a, [], "{|x| x}: e_info"],
        [y1_2[2], nil, "{|x| x}: no exception"],

        [y2[0], :default, "default on exception"],
        [y3[0], y2[0], "exceptions must be the same"],
        [y3[2].to_s, y2[2].to_s, "exceptions must be the same"],
      ].map(&method("expect_equal")).all?

  end


=begin
  test for #call_or_itself
=end
  def test__call_or_itself args=[]
    method_to_test,
      reserved = args
    method_to_test = method_to_test.nne :call_or_itself
    method_to_send = :array_first_remainder
    args_to_send = [:arg_to_send_1, :arg_to_send_2, :arg_to_send_3]
    args_to_bled = []

    send_block = bled(args_to_bled) {
      self.send method_to_send, args_to_send
    }.first

    default_block = bled(args_to_bled) {
      args_to_send
    }.first

    a1 = (send method_to_test, [send_block, :return_dont_call.negate_me]).first
    e1 = [:arg_to_send_1, [:arg_to_send_2, :arg_to_send_3]]
    a2 = (send method_to_test, [default_block, :return_dont_call.negate_me]).first
    e2 = [:arg_to_send_1, :arg_to_send_2, :arg_to_send_3]

    a3 = send method_to_test, [send_block, :return_dont_call ]
    e3 = send_block
    a4 = send method_to_test, [default_block, :return_dont_call ]
    e4 = default_block

    judgement =
      [
        [e1, a1, "#{method_to_test}[send_block, :return_dont_call.negate_me]"],
        [e2, a2, "#{method_to_test}[default_block, :return_dont_call.negate_me]"],
        [e3, a3, "#{method_to_test}[send_block, :return_dont_call]"],
        [e4, a4, "#{method_to_test}[default_block, :return_dont_call]"],
      ].map(&method("expect_equal")).all?
  end


=begin
  test for #experiment__whether
=end
  def test__experiment__whether args=[]
    method_to_test,
      reserved = args
    method_to_test = method_to_test.nne :experiment__whether

    method_to_send = :array_first_remainder
    args_to_send = [:arg_to_send_1, :arg_to_send_2, :arg_to_send_3]
    args_to_bled = []

    send_block = bled(args_to_bled) {
      self.send method_to_send, args_to_send
    }.first

    default_block = bled(args_to_bled) {
      args_to_send
    }.first

    t1 = "two blocks, condition true"
    a1 = send method_to_test, [
      method_to_send,
      send_block,
      default_block,
    ]
    e1 = [[:arg_to_send_1, [:arg_to_send_2, :arg_to_send_3]], nil, nil]

    t2 = "two blocks, condition false"
    a2 = send method_to_test, [
      method_to_send.to_nil,
      send_block,
      default_block,
    ]
    e2 = [[ :arg_to_send_1, :arg_to_send_2, :arg_to_send_3], nil, nil]

    judgement =
      [
        [e1, a1, "#{t1}"],
        [e2, a2, "#{t2}"],
      ].map(&method("expect_equal")).all?
  end


  def test_cases__template args=[]
    # current best example: test_cases__send_enumerator, but it
    # still doesn't use the tester_with_bled.
    # testing_method = :send_enumerator
    test_cases ||= [
      # [ :id, :expectation, :actual_params ],
      # actual_params can be an array with method_name + [args] to that method.
    ]
  end


end


=begin 
  # begin_documentation
  This module receives functions that change other
  Ruby classes, by adding or changing their classes.

  The purpose is normally achieve a more functional
  approach to some classes.

  Some classes will be changed just by including
  this file or requiring rubyment, which is not the
  best approach, but kept to respect the open/closed
  principle, but new functions should be added here.
  # end_documentation
=end
module RubymentClassInjectorModule


end



=begin
  # begin_documentation
  This module receives all the Rubyment functions.

  Rubyment functions are helper functions to achieve general
  repetitive programming tasks, including:
  - Encryption of files or user input with default proper parameters
  - HTTP/HTTPS server ready-to-go
  - gem package generation and submission.
  - tree parsing.
  - graph visitor.
  - some advanced patterns, like reloading the implementation of
  this module from a file without stopping the process (#autoreload).
  - some function to redesign part of Ruby API arguably misdesigned,
  like #arrays__zip
  - functional exception handling (#bled_call and #bled)
  - certain programming patterns, like turning any ruby object in
  an effective composite pattern (#as_container, #object__decompose)
  - ... or a imaging of two system resources, like a file and a
  memory chunk (string), in a simplified interface that can
  abstract away many functions (file_string__experimental).
  - some functions to run a binary directly from a binary blob/memory
  chunk, or to convert that memory chunk in to an executable ruby
  script (#system_command__exec_via_file, #ruby_code__from_binary), so
  it can be deployed as a binary in a gem package
  (#gem_deploy__non_ruby_binaries).


  Rubyment functions must respect the open/closed principle
  (which ensures also "backwards compatibility").

  Rubyment functions rely on a common bus called @memory[:stderr],
  per process. Any global (or statics, or singleton, or whatever
  you call it) must be stored there. Any function has complete
  read-write access to it.

  Rubyment functions normally output debug information to
  @memory[:stderr] this output
  is subject to change (ie, not supposed to be parsed, or the
  parsing may stop working after the function receives maintenance).
  There is a @memory[;debug] which is no longer much used, nowadays
  functions are mostly getting a debug parameter to enable locally.

  Output to @memory[:stdout] should be treated as trustworthy, and
  respect scripts that might parse it. However, if that output comes
  from a third party command, that output can't be guaranteed
  (but surely effort will be taken to ensure it won't break consumers).

  README.md contains more standards adopted by Rubyment.

  # end_documentation
=end

module RubymentModule

  Object.class_eval { include RubymentModifierForClassObjectModule }
  include RubymentCodeGenerationModule
  include RubymentHTMLModule
  include RubymentStringsModule
  include RubymentArraysModule
  include RubymentInternalModule
  include RubymentPatternsModule
  include RubymentInvocationModule
  include RubymentGemGenerationModule
  include RubymentExperimentModule
  include RubymentMaintainedModule
  include RubymentDeprecatedModule
  include RubymentUnderDeprecationModule
  include RubymentTestModule


  # this class very often needs to split
  # first argument and remaining elements.
  # args:
  # args
  # default:
  # ARGV
  # returns:
  # [ args[0], args[1..-1] ]
  def array_first_remainder args=ARGV
    [ args[0], args[1..-1] ]
  end


  # invoke first arg with following args
  # used by initialize
  def invoke args=ARGV
    stderr = @memory[:stderr]
    method_name, arg_list = array_first_remainder args
    !method_name && (return true)
    begin
      # this condition could become ambiguous only when
      # a function has only one argument (if it has
      # more, the rescue case would fail anyway. if
      # it has zero, both are equally OK).
      # In only one argument case, it is better not to
      # splat -- because most of the functions takes
      # an array as argument. the drawback is that
      # functions taking only one argument can't be
      # called from the command line (an array will
      # be given to them)
      self.method(method_name).call (arg_list)
    rescue ArgumentError => e
      begin
        self.method(method_name).call *(arg_list)
      rescue ArgumentError => e2
        # it didn't work -- the arguments given can't
        # be fit. better just try to let the caller
        # figure out when it first called the function.
        stderr.puts e2
        raise e
      end
    end
  end

  def initialize memory = {}
    @memory = {
      :invoke => [],
      :stderr => STDERR,
      :stdout => STDOUT,
      :stdin  => STDIN,
      :time   => Time.now,
      :major_version => "0.7",
      :basic_version => (Time.now.to_i  / 60), # new one every minute
      :filepath => __FILE__,
      :running_dir => Dir.pwd,
      :home_dir => Dir.home,
      :system_user => ENV['USER'] || ENV['USERNAME'],
      :system_user_is_super => ENV['USER']  == "root",
      :static_separator_key => "strings_having_this"  +  "_string_not_guaranteed_to_work",
      :static_end_key => "strings_havinng_this_string" + "_also_not_guaranteed_to_work",
      :static_separator_key_per_execution => "strings_having_this"  +  "_string_not_guaranteed_to_work" + (Proc.new {}).to_s + Time.now.to_s,
      :threads => [Thread.current],
      :memory_json_file_default => "memory.rubyment.json",
      :closure_keys => [
        :stdin,
        :stderr,
        :stdout,
        :threads,
      ],
    }
    @memory.update memory.to_h
    invoke @memory[:invoke].to_a
  end


  # returns a version number comprised
  # of a major and a minor number
  # args:
  # [major_version (String or nil), minor_version (String or nil) ]
  # defaults:
  #  [@memory[:major_version]], @memory[:basic_version]]
  # returns:
  # "#{major}.#{minor}"
  def version args=ARGV
    memory = @memory
    major_version = memory[:major_version]
    basic_version = memory[:basic_version]
    major, minor, debug = args
    stderr = @memory[:stderr]
    debug = debug.nne
    debug && (stderr.puts "{#{__method__} starting")
    debug && (stderr.puts "caller=#{caller_label}")
    debug && (stderr.puts "args=#{args.inspect}")
    debug && (stderr.puts "args.each_with_index=#{args.each_with_index.entries.inspect}")
    debug && (stderr.puts "major_version=#{major_version}")
    debug && (stderr.puts "basic_version=#{basic_version}")
    major ||= major_version
    minor ||= basic_version
    rv = "#{major}.#{minor}"
    debug && (stderr.puts "#{__method__} will return #{rv.inspect}")
    debug && (stderr.puts "#{__method__} returning}")
    rv
  end


  # compares the version of current rubyment with a given version.
  # so users of rubyment can test if their code will run with
  # the rubyment installed on the system.
  # @param [splat] args, a list of object whose elements are expected to be:
  # +major_version+:: [String]
  # +minor_version+:: [String]
  #
  # @return [Bool] +true+ if rubyment (+self+) version is at least the version give as parameter, +false+ otherwise
  def version_at_least *args
    Gem::Version.new(version []) >= Gem::Version.new(version args)
  end


  # enables the possibility to inkove a second method with
  # the results of a first one. eg, the results of a method
  #  called file_permissions_octal which returns without output
  # can be output as:
  # [ "puts", "file_permissions_octal", "/"]
  # TODO; flawed example
  def invoke_double args=ARGV
    second_invokation, first_invokation = [args[0], args[1..-1]]
    first_invokation_result = (invoke first_invokation)
    invoke [second_invokation] + [first_invokation_result].flatten(1)
  end


  # returns a Class object out of class_name (or itself if it is already
  # a class)
  def containerize args=ARGV
    [args].flatten 1
  end


  # returns an enumeration of +method_name+ for each element in
  # the enumeration +a+. Useful for heterogeneous arrays
  # (like arrays of Strings, of Hashes, of Arrays and so on
  def array_map a, method_name, method_args = nil
    a.map {|e| e.method(method_name).call  *method_args }
  end


  # the same as #array_map (but takes all arguments at once)
  def array_maps args=ARGV
    a, method_name, method_args = args
    array_map a, method_name, method_args
  end


  # reads a uri (if 'rest-client' or 'open-uri' available and they don't throw any exception, otherwise, just do a normal File.read)
  # @param [Array] args, an +Array+ whose elements are expected to be:
  # +uri+:: [String, nil] uri or path of the file (empty string is assumed in the case of +nil+ given)
  # +username+:: [String] basic http authentication username
  # +password+:: [String] basic http authentication password
  # +return_on_rescue+:: [Object] a default to return in the case of exceptions raised
  # +return_on_directory_given+:: [Object] a default to return in the case uri is a directory. Defaults to true
  # +skip_open_uri+:: [Boolean] don't bother trying to use 'open-uri' (but still tries to open an uri with 'rest-client'). Defaults to +false+ for open-closed principle respect, but advised to be set to +true+
  # +payload+:: [String] 
  # +verify_ssl+:: [Boolean] defaults to +false+
  # +headers+:: [Hash] +"Authorization"+ key will be added to it if +auth_user+ is given. Defaults to +{}+
  # +method+:: [HTTP method] one of +:get+, +:method+, +:post+ or +:delete+. defaults to +:get+
  # +timeout+:: [Fixnum, nil] defaults to +nil+
  # +debug+:: [Object] if calling the object +nne+ method returns a +false+ value, won't print debug information
  # +request_method+:: [Method name] if given, won't call open-uri's or 'rest-client' , and will use this method instead. It has to have the same signature as #rest_request_or_open_uri_open. By default is +false+ to respect open-closed principle, but it is advised to be set to http_request_response__curl (which depends on 'curb') -- since, for some kind of responses, as redirects, a full featured http client is needed.
  # +output_exceptions+:: [bool] output exceptions, for the methods supporting it.
  #
  # @return [String, Object] read data (or +return_on_rescue+)
  def file_read args=ARGV
    stderr = @memory[:stderr]
    uri,
      username,
      password,
      return_on_rescue,
      return_on_directory_given,
      skip_open_uri,
      payload,
      verify_ssl,
      headers,
      method,
      timeout,
      debug,
      request_method,
      output_exceptions,
      reserved = args
    debug = debug.nne
    output_request_method_exceptions = output_request_method_exceptions.nne
    debug && (stderr.puts "{#{__method__} starting")
    debug && (stderr.puts "args=#{args.inspect}")
    request_method = request_method.nne :rest_request_or_open_uri_open
    uri = uri.nne ""
    file_is_directory = File.directory?(uri)
    must_return_on_rescue = false
    return_on_directory_given ||= true
    contents = !(file_is_directory) && (
      begin
        url_response = (send request_method, [
            uri,
            payload,
            verify_ssl,
            headers,
            method,
            username,
            password,
            timeout,
            skip_open_uri,
            :debug_request_method.to_nil,
            :no_rescue_i_catch_exceptions,
            output_exceptions,
          ]).first
        debug && (stderr.puts "url_response=#{url_response.inspect}")
        url_response
      rescue => e1
        begin
          e_info = exception_info_base [e1]
          debug && (stderr.puts "exception e1=#{e_info[1]} ")
          File.read uri
        rescue  => e2
          e_info = exception_info_base [e2]
          debug && (stderr.puts "exception e2=#{e_info[2]}")
          debug && (stderr.puts "return_on_rescue=#{return_on_rescue.inspect}")
          must_return_on_rescue = true
          return_on_rescue
        end
      end
    ) || (file_is_directory) && (return_on_directory_given)
    rv = contents
    (rv = return_on_rescue) if must_return_on_rescue
    debug && (stderr.puts "will return #{rv.inspect}")
    # if raises exception before it will be unbalanced :
    debug && (stderr.puts "#{__method__} returning}")
    rv
  end


  # reads the contents of a file. if the file
  # doesn't exist, writes to the file.
  # note: the file may get overwritten with the
  # same contents in some situations (not if
  # +contents+ is +nil+).
  # @param [splat] +args+::, an splat whose elements are expected to be:
  # +filepath+:: [String] uri (if +'open-uri'+ installed) or local path to a file
  # +username+:: [String] basic http authentication username
  # +password+:: [String] basic http authentication password
  # @return [String] file contents at the end of the process.
  def file_read_or_write *args
    filepath, contents, username, password = args
    existing_file = file_read [
      filepath,
      username,
      password,
      "return on rescue".to_nil,
      "return on dir".to_nil,
    ]
    file_contents ||=  existing_file || contents
    contents && (File.write filepath, file_contents)
    file_contents
  end


  # if file is a nonexisting filepath, or by any reason
  # throws any exception, it will be treated as contents
  # instead, and the filename will treated as ""
  # file can be a url, if 'open-uri' is available.
  # extension: before file couldn't be a directory. now it can.
  # planned improvement: use file_read instead
  # @param [Array] args, an +Array+ whose elements are expected to be:
  # +file+:: [String] uri or path of the file
  # +dir+:: [String] dir where to backup file
  # +append+:: [String] append this string to the end of file
  # +prepend+:: [String] append this string to the beginning of file
  # +permissions+:: [Integer, nil] writes the file with this mode  (preserves if nil)
  # @return [String] file contents
  def file_backup file = __FILE__ , dir = '/tmp/', append = ('-' + Time.now.hash.abs.to_s), prepend='/', permissions = nil
  default_permissions = 0755
    stderr = @memory[:stderr]
    debug  = @memory[:debug]
    (require 'open-uri') && open_uri = true
    require 'fileutils'
    file_is_filename = true
    file_is_directory = File.directory?(file)
    open_uri && (!file_is_directory) && (
      contents = open(file).read rescue  (file_is_filename = false) || file
    ) || (!file_is_directory) && (
      contents = File.read file rescue  (file_is_filename = false) || file
    )
    debug && (stderr.puts "location = dir:#{dir} + prepend:#{prepend} + (#{file_is_filename} && #{file} || '' ) + #{append}")
    location = dir + prepend + (file_is_filename && file || '' ) + append
    debug && (stderr.puts "FileUtils.mkdir_p File.dirname #{location}")
    FileUtils.mkdir_p File.dirname location # note "~" doesn't work
    file_is_directory && FileUtils.mkdir_p(location) || (
      File.write location, contents
    )
    permissions ||= file_permissions_octal file
    permissions && ( File.chmod permissions, location )
    contents
  end


  # same interface as file_backup, but append and prepend defaults are empty.
  def  file_copy file = __FILE__, dir = '/tmp/', append = '', prepend='', permissions = nil
    file_backup file, dir, append, prepend, default_permissions
  end


  def files_in_paths paths, reject_dirs=false
    require 'find'
    paths = paths.map {|path| Find.find(path).entries  rescue [] }.flatten 1
    reject_dirs && paths.reject{|path| File.directory? path} || paths
  end


  def files_in_paths_reject_dirs paths
     files_in_paths paths, true
  end


  def files_call_in_paths paths, method, reject_dirs=false
    paths =  reject_dirs && (files_in_paths_reject_dirs paths) || paths
    (files_in_paths paths).map {|path|  method.call path }
  end


  def files_dirnames_in_paths paths, reject_dirs=false
   # (files_in_paths paths).map {|path|  File.dirname path }
    files_call_in_paths paths, File.method(:dirname), reject_dirs
  end


  def files_basenames_in_paths paths, reject_dirs=false
    files_call_in_paths paths, File.method(:basename), reject_dirs
  end


  def filename_replacer
    [/[^0-9A-Za-z\-\.\/]/,  "_" ]
  end


  # returns a string having the current backtrace, for debugging.
  def backtrace
    Thread.current.backtrace.join("\n")
  end


  # returns a string having the current backtrace, for debugging.
  def backtrace__reversed
    Thread.current.backtrace.reverse.join("\n")
  end


  def caller_labels begin_range=1, range_size=1
     caller_locations(begin_range, range_size).map(&:label)
  end

  # return the last_called function
  def caller_label *args
    default, reserved = *args
    default ||= 3
    caller_labels(default, 1)[0]
  end


  # returns a Class object out of class_name (or itself if it is already
  # a class)
  def to_class args=ARGV
    class_name, future_arg = containerize args
    begin
      class_object = ( class_name.is_a? Class ) && class_name || (Object.const_get class_name.to_s)
    rescue NameError => nameErrorE
      nil
    end
  end


  # returns a Method (object.method if object is
  # given) matching the name. Give +self+ as object
  # to look up  at the current context
  # @param [Array] args, whose elements are:
  # +name+:: [String, nil]
  # +object+:: [Object]
  # @returns:
  #  method_object (Method)
  def to_object_method args=ARGV
    stderr = @memory[:stderr]
    name,
      object,
      debug,
      reserved = containerize args

    debug = debug.nne
    debug && (stderr.puts "{#{__method__} starting")
    debug && (stderr.puts "caller=#{caller_label}")
    debug && (stderr.puts "args=#{args.inspect}")
    debug && (stderr.puts "args.each_with_index=#{args.each_with_index.entries.inspect}")
    rv = begin
      object.method("method").call(name.to_s)
    rescue NameError => nameError
      # every object (even nil) has :method,
      # and every Method has :call: exception
      # is thrown in call
      debug && (stderr.puts nameError)
      nil
    end
    debug && (stderr.puts "will return #{rv.inspect}")
    debug && (stderr.puts "#{__method__} returning}")
    rv
  end

  # calls object.method call_args
  # note: function closed for extension.
  # a new extension if ever made, will 
  # be created with a new function.
  # args:
  # [method (Method or String), object (Object), call_args (Array)]
  # returns:
  #
  def object_method_args_call args=ARGV
    stderr = @memory[:stderr]
    debug = @memory[:debug]
    debug && (stderr.puts "{#{__method__} starting")
    debug && (stderr.puts "caller=#{caller_label}")
    debug && (stderr.puts "args=#{args.inspect}")
    debug && (stderr.puts "args.each_with_index=#{args.each_with_index.entries.inspect}")
    method, object, *call_args = containerize args
    object ||= self
    method = to_object_method [method, object]
    call_args = call_args && (containerize call_args)
    rv = begin
      call_args && (method.call *call_args) || method.call
    rescue NameError => nameError
      # every object (even nil) has :method,
      # and every Method has :call: exception
      # is thrown in call
      stderr.puts nameError
      nil
    end
    debug && (stderr.puts "#{__method__} will return #{rv.inspect}")
    # if raises exception before it will be unbalanced :
    debug && (stderr.puts "#{__method__} returning}")
    rv
  end


  # args:
  # path (String)
  # returns:
  # file_permissions_octal (Integer, ready to go to chmod, or nil,
  # if file doesn't exist)
  def file_permissions_octal path
    File.stat(path).mode.to_s(8).split("")[-4..-1].join.to_i(8) rescue nil
  end


  # save url contents to a local file location
  # url can be a uri to a local file
  # args:
  # url (String), location (String), wtime (Integer)
  # more (Hash)
  # details:
  # more[:username], more[:password] for http_basic_authentication
  # returns
  #  contents of url (String)
  def save_file url, location, wtime=0, more = {}
    require 'open-uri'
    require 'fileutils'
    FileUtils.mkdir_p File.dirname location # note "~" doesn't work
    user = more[:username]
    pw = more[:password]
    contents = open(url, :http_basic_authentication => [user, pw]).read
    r = File.write location, contents
    sleep wtime
    contents
  end


  # returns url contents
  def url_to_str url, rescue_value=nil
  require 'open-uri'
    contents = open(url).read rescue rescue_value
  end


  # returns the contents of file.
  # file can be a url, if 'open-uri' is available.
  # can throw exceptions
  def file_or_url_contents file
    contents = nil
    stderr = @memory[:stderr]
    (require 'open-uri') && open_uri = true
    require 'fileutils'
    file = file.to_s
    file_is_filename = true
    open_uri && (
      contents = open(file).read
    ) || (
      contents = File.read
    )
    contents
  end

  # returns the contents of file (or empty, or a default
  # if a second parameter is given).
  # if file is a nonexisting filepath, or by any reason
  # throws any exception, it will be treated as contents
  # instead
  # file can be a url, if 'open-uri' is available.
  def filepath_or_contents file, contents = ""
    stderr = @memory[:stderr]
    (require 'open-uri') && open_uri = true
    require 'fileutils'
    file = file.to_s
    file_is_filename = true
    open_uri && (
      contents = open(file).read rescue  (file_is_filename = false) || file
    ) || (
      contents = File.read file rescue  (file_is_filename = false) || file
    )
    contents
  end

  # returns the first value of args if it is a non empty
  # string, or prompt for a multi line string.
  # useful for reading file contents, e.g.
  def input_non_empty_string_or_multiline_prompt args=ARGV
    stderr = @memory[:stderr]
    stderr.print "multiline[enter + control-D to stop]:"
    args.shift.to_s.split("\0").first ||  readlines.join
  end


  # returns the filepath_or_contents of the first value of args
  # if it is a non empty string,
  # or prompt for a multi line string.
  # useful for reading file contents, e.g.
  def input_non_empty_filepath_or_contents_or_multiline_prompt args=ARGV
    stderr = @memory[:stderr]
    stderr.print "multiline[enter + control-D to stop]:"
    (filepath_or_contents args.shift).to_s.split("\0").first ||  readlines.join
  end


  # opens an echoing prompt, if arg1 is nil or empty
  # not prepared to work with binary input (which can contain \0)
  # closed for extensions
  # args:
  # [ arg1 (String or nil)]
  def input_single_line args=ARGV
    stderr = @memory[:stderr]
    stdin  = @memory[:stdin]
    stderr.print "single line:"
    args.shift.to_s.split("\0").first || stdin.gets.chomp
  end


  # opens a non-echoing prompt, if arg1 is nil or empty
  # not prepared to work with binary input (which can contain \0)
  # closed for extensions
  # args:
  # [ arg1 (String or nil)]
  def input_single_line_non_echo args=ARGV
    stderr = @memory[:stderr]
    stdin  = @memory[:stdin]
    require "io/console"
    stderr.print "non echo single line:"
    args.shift.to_s.split("\0").first || stdin.noecho{ stdin.gets}.chomp
  end


  # opens an echoing multiline prompt, if arg1 is nil or empty
  # not prepared to work with binary input (which can contain \0)
  # closed for extensions
  # args:
  # [ arg1 (String or nil)]
  def input_multi_line args=ARGV
    stderr = @memory[:stderr]
    stdin  = @memory[:stdin]
    stderr.print "multiline[enter + control-D to stop]:"
    args.shift.to_s.split("\0").first || stdin.readlines.join
  end


  # opens a non-echoing multiline prompt, if arg1 is nil or empty
  # not prepared to work with binary input (which can contain \0)
  # closed for extensions
  # args:
  # [ arg1 (String or nil)]
  def input_multi_line_non_echo args=ARGV
    stderr = @memory[:stderr]
    stdin  = @memory[:stdin]
    require "io/console"
    stderr.print "multiline[enter + control-D to stop]:"
    args.shift.to_s.split("\0").first || stdin.noecho{ stdin.readlines}.join.chomp
  end


  # opens an echoing prompt, if arg1 is nil or empty
  # better prepared to work with binary input
  # args:
  # [ arg1 (String or nil)]
  def binary_input_single_line args=ARGV
    stderr = @memory[:stderr]
    stdin  = @memory[:stdin]
    stderr.print "single line:"
    static_separator_key_per_execution = @memory[:static_separator_key_per_execution]
    args.shift.to_s.b.split(static_separator_key_per_execution).first || stdin.gets.chomp
  end


  # opens a non-echoing prompt, if arg1 is nil or empty
  # better prepared to work with binary input (which can contain \0)
  # args:
  # [ arg1 (String or nil)]
  def binary_input_single_line_non_echo args=ARGV
    stderr = @memory[:stderr]
    stdin  = @memory[:stdin]
    static_separator_key_per_execution = @memory[:static_separator_key_per_execution]
    require "io/console"
    stderr.print "non echo single line:"
    args.shift.to_s.b.split(static_separator_key_per_execution).first || stdin.noecho{ stdin.gets}.chomp
  end


  # opens an echoing multiline prompt, if arg1 is nil or empty
  # better prepared to work with binary input
  # args:
  # [ arg1 (String or nil)]
  def binary_input_multi_line args=ARGV
    stderr = @memory[:stderr]
    stdin  = @memory[:stdin]
    static_separator_key_per_execution = @memory[:static_separator_key_per_execution]
    stderr.print "multiline[enter + control-D to stop]:"
    args.shift.to_s.b.split(static_separator_key_per_execution).first || stdin.readlines.join
  end


  # opens a non-echoing multiline prompt, if arg1 is nil or empty
  # better prepared to work with binary input (which can contain \0)
  # args:
  # [ arg1 (String or nil)]
  def binary_input_multi_line_non_echo args=ARGV
    stderr = @memory[:stderr]
    stdin  = @memory[:stdin]
    static_separator_key_per_execution = @memory[:static_separator_key_per_execution]
    require "io/console"
    stderr.print "multiline[enter + control-D to stop]:"
    args.shift.to_s.b.split(static_separator_key_per_execution).first || stdin.noecho{ stdin.readlines}.join.chomp
  end


  def input_shift_or_empty_string args=ARGV, default = ''
    args.shift || default
  end

  def input_shift args=ARGV
    args.shift
  end


  # outputs in such a way that it can be given
  # as an array of parameters via bash shell
  # not fully tested, use with caution.
  def output_array_to_shell args=ARGV
    args.map {|arg|
      "\"" << (arg && arg.to_s || "") << "\""
    }.join " "
  end

  # place a \n at every max_column chars
  # approximately (a word can be bigger
  # than max_column, and some other
  # situations)
  def string_in_columns s, max_column=80
    max_column = max_column.to_i
    as = 0 ; ln = 0 ; t =  s.split.chunk {|l| ((l.size + as) <= max_column ) && (as += l.size ) && ln || (as = l.size; ln += 1)  }.entries.map {|a| a.last.join(" ") }.join("\n")
  t
  end


  # planned changes:
  # use stdin from memory instead
  def shell_string_in_columns args=ARGV
    stderr = @memory[:stderr]
    time   = @memory[:time]
    number_of_columns = input_shift args
    text = input_non_empty_filepath_or_contents_or_multiline_prompt args
    puts (string_in_columns text, number_of_columns)
  end


  # print arguments given
  def main args=ARGV
    stderr = @memory[:stderr]
    time   = @memory[:time]
    puts args.join " "
  end


  # makes a rest request
  # @param [Array] +args+, an +Array+ whose elements are expected to be:
  # +url+:: [String] 
  # +payload+:: [String] 
  # +verify_ssl+:: [Boolean] 
  # +headers+:: [Hash] +"Authorization"+ key will be added to it if +auth_user+ is given.
  # +method+:: [HTTP method] one of +:get+, +:method+, +:post+ or +:delete+
  # +auth_user+:: [String, nil] username for basic authentication method
  # +password+:: [String, nil] password for basic authentication method. Will prompt without echo if +nil+ and +auth_user+ is not +nil+
  # +timeout+:: [Fixnum] 
  # +debug+:: [Object] if calling the object +nne+ method returns a +false+ value, won't print debug information
  # @return [Array] returns an +Array+ whose elements are :
  # +response+:: [String] 
  # +response+:: [Object] as returned by +RestClient::Request.execute+. Note that this is a dangerous object for printing, be aware.
  # +http_response_object+:: [Net::HTTPResponse] 
  # +http_response_object.code+:: [String] 
  def rest_response__request_base args=ARGV
    require 'base64'
    require 'rest-client'

    stderr = @memory[:stderr]
    time   = @memory[:time]
    url,
      payload,
      verify_ssl,
      headers,
      method,
      auth_user,
      password,
      timeout,
      debug,
      reserved = args

    debug = debug.nne
    debug.nne && (stderr.puts "{#{__method__} starting")
    debug && (stderr.puts "args=#{args.inspect}")

    auth_user = auth_user.nne
    password  = password.nne
    method    = method.nne :get
    headers   = headers.nne({})
    base64_auth = Base64.encode64 [
      auth_user,
      auth_user && (input_single_line_non_echo [password])
    ].join ":"
    auth_user && (headers["Authorization"] = "Basic #{base64_auth}")
    response,
      request,
      http_response_object = RestClient::Request.execute(
      :method => method,
      :url => url,
      :payload => payload,
      :headers => headers,
      :verify_ssl => verify_ssl,
      :timeout => timeout
    ) {|*args| args}
    rv = [
      response.to_s,
      request,
      http_response_object,
      http_response_object.code,
    ]
    debug && (stderr.puts "will return #{rv.map(&:to_s)}")
    debug && (stderr.puts "#{__method__} returning}")
    rv
  end


  # makes a rest request.
  # @param [Array] +args+, an +Array+ whose elements are expected to be:
  # +url+:: [String] 
  # +payload+:: [String] 
  # +verify_ssl+:: [Boolean] 
  # +headers+:: [Hash] +"Authorization"+ key will be added to it if +auth_user+ is given.
  # +method+:: [HTTP method] one of +:get+, +:method+, +:post+ or +:delete+
  # +auth_user+:: [String, nil] username for basic authentication method
  # +password+:: [String, nil] password for basic authentication method. Will prompt without echo if +nil+ and +auth_user+ is not +nil+
  # +timeout+:: [Fixnum] 
  # @return [String] the response
  def rest_request args=ARGV
    (rest_response__request_base args).first
  end


  # calls #rest_request (which depends on +'rest-client'+ gem)
  # in the case it throws an exception, tries to call
  # +'open-uri'+'s #open.
  # note that not the arguments below refer to the #rest_request
  # for #open, only  +auth_user+ and +password+ will be
  # forwarded, as they come to this function.
  # @param [Array] +args+, an +Array+ whose elements are expected to be:
  # +url+:: [String] 
  # +payload+:: [String] 
  # +verify_ssl+:: [Boolean] defaults to +false+
  # +headers+:: [Hash] +"Authorization"+ key will be added to it if +auth_user+ is given. Defaults to +{}+
  # +method+:: [HTTP method] one of +:get+, +:method+, +:post+ or +:delete+. defaults to +:get+
  # +auth_user+:: [String, nil] username for basic authentication method
  # +password+:: [String, nil] password for basic authentication method. Will prompt without echo if +nil+ and +auth_user+ is not +nil+
  # +timeout+:: [Fixnum, nil] defaults to +nil+
  # +skip_open_uri+:: [Boolean] don't bother trying with #open
    # +debug+:: [Object] if calling the object +nne+ method returns a +false+ value, won't print debug information
  # @return [Array] the response
  def rest_request_or_open_uri_open args=ARGV
    stderr = @memory[:stderr]
    url,
      payload,
      verify_ssl,
      headers,
      method,
      auth_user,
      password,
      timeout,
      skip_open_uri,
      debug,
      reserved = args

    debug = debug.nne
    debug && (stderr.puts "{#{__method__} starting")
    debug && (stderr.puts "args=#{args.inspect}")
    skip_open_uri = skip_open_uri.nne

    response = runea ["yes, rescue".negate_me,
      "already not rescuing, forget about output".to_nil,
      "already not rescuing, forget about return control".to_nil,
    ] {
      !skip_open_uri && send(
        :open,
        url,
        :http_basic_authentication => [auth_user, password],
      ).read
    }
    response ||= runea ["yes, rescue",
      "output exception".negate_me,
      "nil on exception"
    ] {
      send :rest_request, [
        url,
        payload,
        verify_ssl,
        headers,
        method,
        auth_user,
        password,
        timeout,
      ]
    }
    rv = [response]
    debug && (stderr.puts "#{__method__}  will return #{rv.inspect}")
    # if raises exception before it will be unbalanced :
    debug && (stderr.puts "#{__method__} returning}")
    rv
  end


  # test #rest_request
  # for now, the parameters must still be hardcoded.
  def test__rest_request args=ARGV
    require 'json'
    stderr = @memory[:stderr]

    atlasian_account="my_atlasian_account"
    jira_host = "https://mydomain.atlassian.net/"
    issue = "JIRAISSUE-6517"
    url = "#{jira_host}/rest/api/2/issue/#{issue}/comment"

    json =<<-ENDHEREDOC
    {
        "body" : "my comment"
    }
    ENDHEREDOC
    payload = "#{json}"

    auth_user = nil
    password = nil
    method = :get
    method = :post
    timeout = 2000
    verify_ssl = false
    payload = "#{json}"
    headers = ""
    request_execution = send :rest_request, [
      url,
      payload,
      verify_ssl,
      headers,
      method,
      auth_user,
      password,
      timeout,
    ]
    parsed_json = JSON.parse request_execution.to_s
    stderr.puts parsed_json
    [parsed_json]
  end


  # generates (by default) a 128 bit key for a Cipher (e.g. AES)
  # args:
  # [ password, salt, iter, key_len ]
  # returns:
  # [key, password, salt, iter, key_len]
  #
  # planned changes:
  #  ensure that random_bytes == key_len
  def generate_pbkdf2_key args=ARGV
    require 'openssl'
    password, salt, iter, key_len = args
    iter = (iter.to_i > 0) && iter.to_i || 20000
    key_len = (salt.to_s.split("\0").first && salt.to_s.size > 0 && salt.size || 16)
    salt = salt.to_s.split("\0").first || OpenSSL::Random.random_bytes(key_len)
    key = OpenSSL::PKCS5.pbkdf2_hmac_sha1(password.to_s, salt.to_s, iter.to_i, key_len.to_i)
    [key, password, salt, iter, key_len]
  end


  # decipher the data encoded by enc
  #
  # @param [Array] args, an +Array+ whose elements are expected to be:
  # +password+:: [String, nil] password to be used to encryption.
  # +base64_iv+:: [String, nil] initialization vectors encoded with Base64
  # +base64_encrypted+:: [String, nil] ciphered data (without metadata) encoded with Base64
  # +ending+:: [nil] deprecated
  # +base64_salt+:: [String, nil] #generate_pbkdf2_key salt encoded with Base64
  # +base64_iter+:: [String, nil] #generate_pbkdf2_key iterations encoded with Base64
  # +data_not_base64+:: [true, false, nil] don't return base64 data -- the same +data_not_base64+ given for enc should be used.
  #
  # @return [String] decoded data
  def dec args=ARGV
    require 'openssl'
    require 'base64'
    memory = @memory
    static_end_key = memory[:static_end_key]
    password, base64_iv, base64_encrypted, ending, base64_salt, base64_iter, data_not_base64 = args
    salt = Base64.decode64 base64_salt
    iter = Base64.decode64 base64_iter
    ending = ending.to_s.split("\0").first || static_end_key
    key, password, salt, iter =  (
      generate_pbkdf2_key [password, salt, iter]
    )|| [nil, password, salt, iter]

    decipher = OpenSSL::Cipher.new('aes-128-cbc')
    decipher.decrypt
    decipher.padding = 0

    decipher.key = key || (Digest::SHA256.hexdigest password)
    decipher.iv = Base64.decode64 base64_iv
    base64_plain = decipher.update(Base64.decode64 base64_encrypted) + decipher.final
    plain = data_not_base64 && (Base64.decode64 base64_plain) || base64_plain
    # split is not the ideal, if ever ending is duplicated it won't
    # work. also may be innefficient.
    (plain.split ending).first

  end


  # prompts for arguments to dec function
  # args:
  # [ iv, encrypted, password ] (all Strings)
  # returns:
  #  [password, encrypted, iv] (all Strings)
  # planned changes:
  # call separate functions.
  #
  def shell_dec_input args=ARGV
    require 'stringio'
    require "io/console"
    memory = @memory
    debug  = memory[:debug]
    stderr = memory[:stderr]
    stdout = memory[:stdout]
    stdin  = memory[:stdin]

    stderr.print "iv:"
    # basically => any string other than "" or the default one:
    iv = args.shift.to_s.split("\0").first
    iv = (url_to_str iv) || iv.to_s.split("\0").first || (url_to_str 'out.enc.iv.base64')
    debug && (stderr.puts iv)
    stderr.puts
    stderr.print "encrypted:"
    # basically => any string other than "" or the default one:
    encrypted = args.shift.to_s.split("\0").first
    encrypted = (url_to_str encrypted) || encrypted.to_s.split("\0").first  || (url_to_str 'out.enc.encrypted.base64')
    debug && (stderr.puts "#{encrypted}")
    stderr.puts
    stderr.print "password:"
    password = args.shift.to_s.split("\0").first || begin stdin.noecho{ stdin.gets}.chomp rescue gets.chomp end
    stderr.puts
    [password, encrypted, iv]
 end


  # and output the decrypted data to stdout.
  #
  # planned changes:
  # stop argument shifting.
  # call separate functions.
  #
  def shell_dec_output args=ARGV
    memory = @memory
    stdout = memory[:stdout]
    pw_plain, reserved_for_future = args
    stdout.puts pw_plain
  end


  # prompts for arguments to dec, calls dec,
  # and output the decrypted data to stdout.
  # args:
  # (forwarded to shell_dec_input, as of now:
  # returns:
  # nil
  #
  # planned changes:
  # stop argument shifting.
  # call separate functions.
  #
  def shell_dec args=ARGV
    require 'json'
    require 'base64'
    memory = @memory
    stderr = memory[:stderr]
    password, base64_json_serialized_data, iv_deprecated = shell_dec_input args
    metadata = JSON.parse Base64.decode64 base64_json_serialized_data
    base64_iv = metadata["base64_iv"]
    base64_encrypted = metadata["base64_encrypted"]
    base64_salt = metadata["base64_salt"]
    base64_iter = metadata["base64_iter"]
    base64_key  = metadata["base64_key" ]
    ending = nil
    pw_plain = dec [password, base64_iv, base64_encrypted, ending, base64_salt, base64_iter]
    shell_dec_output [pw_plain]
  end


  # encode data into aes-128-cbc cipher protected by a key generated
  # by #generate_pbkdf2_key, using given +password+, +salt+, +iter+
  # By default, may not work with binary data. Set +data_not_base64+ to
  # true (or give data already as base64) to make it work.
  #
  # @param [Array] args, an +Array+ whose elements are expected to be:
  # +password+:: [String, nil] password to be used to encryption.
  # +data+:: [String, nil] data to be encoded data
  # +ending+:: [nil] deprecated
  # +salt+:: [String, nil] #generate_pbkdf2_key salt argument
  # +iter+:: [String, nil] #generate_pbkdf2_key iterations argument
  # +data_not_base64+:: [true, false, nil] data not yet in base64
  #
  # @return @param [Array] an +Array+ whose elements are expected to be:
  # +base64_encrypted+:: [String, nil] ciphered data (without metadata) encoded with Base64
  # +base64_iv+:: [String] initialization vectors encoded with Base64
  # +base64_salt+:: [String] #generate_pbkdf2_key salt encoded with Base64
  # +base64_iter+:: [String] #generate_pbkdf2_key iterations encoded with Base64
  # +base64_key+::  [String] #generate_pbkdf2_key return value
  #
  def enc args=ARGV
    require 'openssl'
    require 'base64'
    memory = @memory
    static_end_key = memory[:static_end_key]
    password, data, ending, salt, iter, data_not_base64 = args
    ending ||= static_end_key
    key, password, salt, iter = (
      generate_pbkdf2_key [password, salt, iter]
    )|| [nil, password, salt, iter]

    cipher = OpenSSL::Cipher.new('aes-128-cbc')
    cipher.encrypt

    cipher.key = key || (Digest::SHA256.hexdigest password)
    iv = cipher.random_iv
    base64_data = data_not_base64 && (Base64.encode64 data) || data
    encrypted = cipher.update(base64_data + ending) + cipher.final

    base64_iv = Base64.encode64 iv
    base64_encrypted = Base64.encode64  encrypted
    base64_salt = Base64.encode64 salt.to_s
    base64_iter = Base64.encode64 iter.to_s
    base64_key = Base64.encode64 key.to_s

    [base64_encrypted, base64_iv,  base64_salt, base64_iter, base64_key]
  end


  # prompts for arguments to dec
  # args:
  # [ multiline_data, data_file, single_line_data, password, encrypted_base64_filename, enc_iv_base64_filename_deprecated] (all Strings)
  # returns:
  #   [password, data, encrypted_base64_filename, enc_iv_base64_filename_deprecated]
  #
  # planned changes:
  # call separate functions.
  # stop argument shifting.
  #
  def shell_enc_input args=ARGV
    memory = @memory
    stderr = @memory[:stderr]
    stdout = @memory[:stdout]
    stdin  = @memory[:stdin]
    debug = memory[:debug]
    require 'stringio'
    require "io/console"

    data = ""
    stderr.print "multi_line_data[ data 1/3, echoing, enter + control-D to stop]:"
    data += args.shift ||  (stdin.readlines.join rescue readlines.join)
    stderr.puts
    stderr.print "data_file [data 2/3]:"
    data_file = args.shift ||  (stdin.gets.chomp rescue gets.chomp)
    data  += url_to_str data_file, ""
    stderr.puts
    stderr.print "single_line_data[data 3/3, no echo part]:"
    data += args.shift || begin stdin.noecho{ stdin.gets}.chomp rescue gets.chomp end
    stderr.puts
    stderr.print "password:"
    password = args.shift.to_s.split("\0").first || begin stdin.noecho{ stdin.gets}.chomp rescue gets.chomp end
    stderr.puts
    stderr.print "encrypted_base64_filename[default=out.enc.encrypted.base64]:"
    # basically => any string other than "" or the default one:
    encrypted_base64_filename = args.shift.to_s.split("\0").first || "out.enc.encrypted.base64"
    stderr.puts encrypted_base64_filename
    stderr.puts
    stderr.print "enc_iv_base64_filename[DEPRECATED]:"
    # basically => any string other than "" or the default one:
    enc_iv_base64_filename_deprecated = args.shift.to_s.split("\0").first || "out.enc.iv.base64"
    stderr.puts enc_iv_base64_filename_deprecated

    [password, data, encrypted_base64_filename, enc_iv_base64_filename_deprecated]
  end


  # outputs the results from enc
  def shell_enc_output args=ARGV
    memory = @memory
    stderr = memory[:stderr]
    base64_encrypted, base64_iv, encrypted_base64_filename, enc_iv_base64_filename_deprecated = args
    puts base64_iv
    puts base64_encrypted
    File.write  encrypted_base64_filename, base64_encrypted
    stderr.puts
  end


  # shell_enc
  # args
  # [password, data, encrypted_base64_filename, enc_iv_base64_filename_deprecated] (all Strings)
  # encrypts data using password and stores to encrypted_base64_filename
  # returns
  # nil
  #
  # planned changes:
  # encrypted_base64_filename
  def shell_enc args=ARGV
    require 'json'
    require 'base64'
    require 'openssl'
    password, data, encrypted_base64_filename, enc_iv_base64_filename_deprecated  = shell_enc_input args
    salt = nil
    iter = nil
    ending = nil
    base64_encrypted, base64_iv, base64_salt, base64_iter, base64_key = enc [password, data, ending, salt, iter]
    metadata = {
      "metadata"  => "Metadata",
      "base64_iv" => base64_iv,
      "base64_encrypted" => base64_encrypted,
      "base64_salt" => base64_salt,
      "base64_iter" => base64_iter,
    }
    base64_json_serialized_data =  Base64.encode64 JSON.pretty_generate metadata
    shell_enc_output [base64_json_serialized_data, base64_iv, encrypted_base64_filename ]
  end


  # serialize_json_metadata
  # args:
  # [payload (String), metadata (Hash), separator (String)]
  # prepends a JSON dump of metadata followed by separator
  # to a copy of payload, and returns it.
  def serialize_json_metadata args=ARGV
    require 'json'
    memory = @memory
    static_separator = memory[:static_separator_key]
    payload, metadata, separator = args
    metadata ||= { }
    separator ||= static_separator
    serialized_string = (JSON.pretty_generate metadata) + separator + payload
  end


  # deserialize_json_metadata
  # args:
  # [serialized_string (String), separator (String)]
  # undo what serialize_json_metadata
  # returns array:
  # [payload (String), metadata (Hash or String), separator (String)]
  # metadata is returned as Hash after a  JSON.parse, but in case
  # of any failure, it returns the String itself.
  def deserialize_json_metadata args=ARGV
    require 'json'
    memory = @memory
    static_separator = memory[:static_separator_key]
    serialized_string, separator = args
    separator ||= static_separator
    metadata_json, payload  = serialized_string.to_s.split separator
    metadata = (JSON.parse metadata_json) rescue metadata_json
    [payload, metadata, separator]
  end


  # test__json_metadata_serialization
  # sanity test for serialize_json_metadata and deserialize_json_metadata
  def test__json_metadata_serialization args=ARGV
    judgement = true
    payload = "Payload"
    # note: keys with : instead can't be recovered, because
    # they aren't described in JSON files
    metadata = { "metadata"  => "Metadata" }
    serialized = (serialize_json_metadata [payload, metadata ])
    new_payload, new_metadata = deserialize_json_metadata [serialized]
    judgement =
      [ [payload, new_payload, "payload"], [metadata, new_metadata, "metadata"]]
        .map(&method("expect_equal")).all?
  end


  # format strings for  expect_format_string
  def expect_format_string args=ARGV
    memory = @memory
    debug = memory[:debug]
    prepend_text, value_before, value_after, value_label, comparison_text = args
    "#{prepend_text} #{value_label}: #{value_before} #{comparison_text} #{value_after}"
  end


  # expect_equal
  # args:
  # [ value_before (Object), value_after (Object), value_label (String) ]
  # returns the value of testing value_before == value_after, printing to
  # stderr upon failure
  def expect_equal args=ARGV
    memory = @memory
    stderr = memory[:stderr]
    value_before, value_after, value_label = args
    judgement = (value_before == value_after)
    (!judgement) && (stderr.puts  expect_format_string ["unexpected", value_before, value_after, value_label, "!="])
    judgement
  end


  # test__shell_enc_dec
  # sanity test for shell_enc and shell_dec
  # planned changes:
  # don't output to stdout
  def test__shell_enc_dec args=ARGV
    shell_enc ["my secret",  "", "",  "tijolo22", "", ""]
    judgement = ( shell_dec ["", "", "tijolo22"] || true) rescue false
  end


  # an alternative interface to dec -- reads password if
  # nil or empty.
  #
  # @param [Array] args Defaults to +ARGV+. Elements:
  # * +data+ [String, nil] data to be encrypted, If empty or nil, read (without
  # echo) from @memory[:stdin], which defaults to STDIN
  # * +password+ [String, nil] password to be used to encryption.
  # If empty or nil, read (without echo) from @memory[:stdin], which defaults to STDIN
  # +data_not_base64+:: [true, false, nil] don't return base64 data -- the same +data_not_base64+ given for enc should be used.
  #
  # @return [TrueClass, FalseClass] depending on whether test succeeds.
  def dec_interactive args=ARGV
    stderr = @memory[:stderr]
    iv, encrypted, base64_salt, base64_iter, password, data_not_base64  = args
    stderr.print "[password]"
    password = (input_single_line_non_echo [password])
    stderr.puts
    dec [password, iv, encrypted, nil, base64_salt, base64_iter, data_not_base64]
  end


  # test for enc and dec.
  # "" and nil are expected to be treated
  # as the same.
  def test__enc_dec_nil args=ARGV
    nil_case = dec [nil, "ltUQIxgRAeUNXPNTTps8FQ==\n", "xyeqxw/TzkyXtOxpDqAl58SNAvXPyNZ89B5JGtwDkcbjo0vObgPsh5FrgZJs\nHPjofsyXnljnTrHpDoQeDVezo9wBZ74NU+TSi/GssX605oE=\n", nil, "TU4o3IKiFWki3rZ3lMchLQ==\n", "MjAwMDA=\n"]
    empty = dec ["", "ltUQIxgRAeUNXPNTTps8FQ==\n", "xyeqxw/TzkyXtOxpDqAl58SNAvXPyNZ89B5JGtwDkcbjo0vObgPsh5FrgZJs\nHPjofsyXnljnTrHpDoQeDVezo9wBZ74NU+TSi/GssX605oE=\n", "", "TU4o3IKiFWki3rZ3lMchLQ==\n", "MjAwMDA=\n"]
    judgement =
      [
        [nil_case, empty, "empty_nil_equality"]
      ].map(&method("expect_equal")).all?
  end


  # test for enc and dec and output_array_to_shell.
  # output_array_to_shell should create proper arguments
  #  to dec
  # TODO: invalid test -- that can't yet be ensured
  def test__enc_dec_shell_programatically args=ARGV
    stderr = @memory[:stderr]
    stderr.puts "test invalid; skip"
    shell = nil
    programatically = nil
    judgement =
      [
        [shell, programatically, "shell_programatically_equality"]
      ].map(&method("expect_equal")).all?
  end


  # test for enc and dec.
  #
  # @param [Array] args, an +Array+ whose elements are expected to be:
  # +data+:: [String, nil] data to be encrypted.
  # If empty or nil, read (without echo) from @memory[:stdin], which defaults to STDIN
  # +password+:: [String, nil] password to be used to encryption.
  # If empty or nil, read (without echo) from @memory[:stdin], which defaults to STDIN
  #
  # @return [TrueClass, FalseClass] depending on whether test succeeds.
  def test__enc_dec args=ARGV
    stderr = @memory[:stderr]
    data, password = args
    stderr.print "[data]"
    data = input_multi_line_non_echo [data]
    stderr.print "[password]"
    password = input_single_line_non_echo [password]
    base64_encrypted, base64_iv, base64_salt, base64_iter, base64_key = enc [password, data]
    dec_args = [password, base64_iv, base64_encrypted, nil, base64_salt, base64_iter]
    stderr.puts "# WARNING: secrets, including password are printed here. Storing them may be a major security incident."
    stderr.puts "# programmatically:"
    stderr.puts "dec " + dec_args.to_s
    stderr.puts "# shell: "
    stderr.puts "#{$0} invoke_double p dec " + (output_array_to_shell dec_args).to_s
    data_plain = dec [password, base64_iv, base64_encrypted, nil, base64_salt, base64_iter]
    judgement =
      [
        [data, data_plain, "data"]
      ].map(&method("expect_equal")).all?
  end


  # output encrypted data (and data required to
  # decrypt) into encrypted_base64_filename
  def output_enc_file args=ARGV
    stderr = @memory[:stderr]
    require 'json'
    require 'base64'
    base64_iv, base64_encrypted, base64_salt, base64_iter, encrypted_base64_filename = args
    metadata = {
      "metadata"  => "Metadata",
      "base64_iv" => base64_iv,
      "base64_encrypted" => base64_encrypted,
      "base64_salt" => base64_salt,
      "base64_iter" => base64_iter,
    }
    base64_json_serialized_data =  Base64.encode64 JSON.pretty_generate metadata
    File.write encrypted_base64_filename, base64_json_serialized_data
    stderr.puts "# File written: \n# #{encrypted_base64_filename}"
  end


  # output encrypted data (and data required to
  # decrypt) into encrypted_base64_filename
  def output_dec_file args=ARGV
    stderr = @memory[:stderr]
    require 'json'
    require 'base64'
    enc_filename_or_url, out_filename, password, data_is_base64 = args
    base64_json_serialized_data = file_or_url_contents enc_filename_or_url

    metadata = JSON.parse Base64.decode64 base64_json_serialized_data
    base64_iv = metadata["base64_iv"]
    base64_encrypted = metadata["base64_encrypted"]
    base64_salt = metadata["base64_salt"]
    base64_iter = metadata["base64_iter"]
    base64_key  = metadata["base64_key" ]
    ending = nil
    pw_plain = binary_dec [password, base64_iv, base64_encrypted, ending, base64_salt, base64_iter, data_is_base64]
    File.write out_filename, pw_plain
    stderr.puts "# File written: \n# #{out_filename}"
  end


  # test for enc and dec_interactive.
  # good idea is to use this function once with the desired
  # data, password, and use the stderr output
  def test__enc_dec_interactive args=ARGV
    stderr = @memory[:stderr]
    data, password, encrypted_base64_filename, data_not_base64 = args
    stderr.print "[data]"
    data = input_multi_line_non_echo [data]
    stderr.print "[password]"
    password = input_single_line_non_echo [password]
    stderr.puts
    base64_encrypted, base64_iv, base64_salt, base64_iter, base64_key = enc [password, data, nil, nil, nil, data_not_base64 ]
    # the output is supposed to be safe to store,
    # so password is not placed in from dec_interactive_args:
    dec_interactive_args = [base64_iv, base64_encrypted, base64_salt, base64_iter]
    stderr.puts "# programmatically:"
    stderr.puts "dec_interactive " + dec_interactive_args.to_s
    stderr.puts "# shell: "
    stderr.puts "#{$0} invoke_double puts dec_interactive " + (output_array_to_shell dec_interactive_args).to_s
    stderr.puts "#or shell var:"
    stderr.puts "my_secret=$(#{$0} invoke_double puts dec_interactive " + (output_array_to_shell dec_interactive_args).to_s + ")\necho $my_secret\nunset mysecret"
    encrypted_base64_filename && output_enc_file(dec_interactive_args  + [encrypted_base64_filename])
    data_plain = dec_interactive(dec_interactive_args + [password, data_not_base64])
    judgement =
      [
        [data, data_plain, "data"]
      ].map(&method("expect_equal")).all?
  end


  # similar to
  # test__enc_dec_interactive,
  # just that the data is ready from a file instead
  # note that there is an extra argument between
  # the args, the enc_out_filename.
  def test__enc_dec_file_interactive args=ARGV
    stderr = @memory[:stderr]
    filename_or_url, enc_out_filename, password, data_not_base64 = args
    stderr.print "[filename_or_url]"
    filename_or_url = input_multi_line_non_echo [filename_or_url]
    stderr.print "[output_filename_encrypted_data]"
    enc_out_filename = input_multi_line_non_echo [enc_out_filename ]
    data =  file_or_url_contents filename_or_url
    test__enc_dec_interactive [ data, password, enc_out_filename, data_not_base64 ]
  end


  # basically the reverse of test__enc_dec_file_interactive
  # planned improvements: still outputs to stdout
  def test__dec_file_interactive args=ARGV
    stderr = @memory[:stderr]
    enc_filename_or_url, out_filename, password, data_not_base64 = args
    stderr.print "[enc_filename_or_url]"
    enc_filename_or_url = input_multi_line_non_echo [enc_filename_or_url]
    stderr.print "[output_filename_plain_data]"
    out_filename = input_multi_line_non_echo [out_filename ]
    stderr.print "[password]"
    password = input_single_line_non_echo [password]
    data =  file_or_url_contents enc_filename_or_url
    require 'json'
    require 'base64'
    base64_json_serialized_data = data
    metadata = JSON.parse Base64.decode64 base64_json_serialized_data
    base64_iv = metadata["base64_iv"]
    base64_encrypted = metadata["base64_encrypted"]
    base64_salt = metadata["base64_salt"]
    base64_iter = metadata["base64_iter"]
    base64_key  = metadata["base64_key" ]
    ending = nil
    pw_plain = dec [password, base64_iv, base64_encrypted, ending, base64_salt, base64_iter, data_not_base64]
    shell_dec_output [pw_plain]
  end


  # encode data into aes-128-cbc cipher protected by a key generated
  # by #generate_pbkdf2_key, using given +password+, +salt+, +iter+
  # By default, must work with binary data. Set +data_is_base64+ to
  # true (or give data already as base64) to achieve the original
  # behavior of enc(), and avoid one encoding operation on data.
  #
  # @param [Array] args, an +Array+ whose elements are expected to be:
  # +password+:: [String, nil] password to be used to encryption.
  # +data+:: [String, nil] data to be encoded data
  # +ending+:: [nil] deprecated
  # +salt+:: [String, nil] #generate_pbkdf2_key salt argument
  # +iter+:: [String, nil] #generate_pbkdf2_key iterations argument
  # +data_is_base64+:: [true, false, nil] data already in base64 
  # 
  #
  # @return @param [Array] an +Array+ whose elements are expected to be:
  # +base64_encrypted+:: [String, nil] ciphered data (without metadata) encoded with Base64
  # +base64_iv+:: [String] initialization vectors encoded with Base64
  # +base64_salt+:: [String] #generate_pbkdf2_key salt encoded with Base64
  # +base64_iter+:: [String] #generate_pbkdf2_key iterations encoded with Base64
  # +base64_key+::  [String] #generate_pbkdf2_key return value
  #
  def binary_enc args=ARGV
    require 'openssl'
    require 'base64'
    memory = @memory
    static_end_key = memory[:static_end_key] + "_binary"
    password, data, ending, salt, iter, data_is_base64 = args
    ending ||= static_end_key
    key, password, salt, iter = (
      generate_pbkdf2_key [password, salt, iter]
    )|| [nil, password, salt, iter]

    cipher = OpenSSL::Cipher.new('aes-128-cbc')
    cipher.encrypt

    cipher.key = key || (Digest::SHA256.hexdigest password)
    iv = cipher.random_iv
    base64_data = data_is_base64 && (Base64.encode64 data) || data
    encrypted = cipher.update(base64_data + ending) + cipher.final

    base64_iv = Base64.encode64 iv
    base64_encrypted = Base64.encode64  encrypted
    base64_salt = Base64.encode64 salt.to_s
    base64_iter = Base64.encode64 iter.to_s
    base64_key = Base64.encode64 key.to_s

    [base64_encrypted, base64_iv,  base64_salt, base64_iter, base64_key]
  end


  # decipher the data encoded by binary_enc
  #
  # @param [Array] args, an +Array+ whose elements are expected to be:
  # +password+:: [String, nil] password to be used to encryption.
  # +base64_iv+:: [String, nil] initialization vectors encoded with Base64
  # +base64_encrypted+:: [String, nil] ciphered data (without metadata) encoded with Base64
  # +ending+:: [nil] deprecated
  # +base64_salt+:: [String, nil] #generate_pbkdf2_key salt encoded with Base64
  # +base64_iter+:: [String, nil] #generate_pbkdf2_key iterations encoded with Base64
  # +data_is_base64+:: [true, false, nil] return base64 data -- the same +data_is_base64+ given for enc should be used.
  #
  # @return [String] decoded data
  def binary_dec args=ARGV
    require 'openssl'
    require 'base64'
    memory = @memory
    static_end_key = memory[:static_end_key] + "_binary"
    password, base64_iv, base64_encrypted, ending, base64_salt, base64_iter, data_is_base64 = args
    salt = Base64.decode64 base64_salt
    iter = Base64.decode64 base64_iter
    # FIXME: don't split on \0
    ending = ending.to_s.split("\0").first || static_end_key
    key, password, salt, iter =  (
      generate_pbkdf2_key [password, salt, iter]
    )|| [nil, password, salt, iter]

    decipher = OpenSSL::Cipher.new('aes-128-cbc')
    decipher.decrypt
    decipher.padding = 0

    decipher.key = key || (Digest::SHA256.hexdigest password)
    decipher.iv = Base64.decode64 base64_iv
    base64_plain = decipher.update(Base64.decode64 base64_encrypted) + decipher.final
    plain = data_is_base64 && (Base64.decode64 base64_plain) || base64_plain
    # split is not the ideal, if ever ending is duplicated it won't
    # work. also may be innefficient.
    (plain.split ending).first

  end


  # an alternative interface to binary_dec -- reads password if
  # nil or empty.
  #
  # @param [Array] args Defaults to +ARGV+. Elements:
  # * +data+ [String, nil] data to be encrypted, If empty or nil, read (without
  # echo) from @memory[:stdin], which defaults to STDIN
  # * +password+ [String, nil] password to be used to encryption.
  # If empty or nil, read (without echo) from @memory[:stdin], which defaults to STDIN
  # +data_is_base64+:: [true, false, nil] return base64 data -- the same +data_is_base64+ given for enc should be used.
  #
  # @return [TrueClass, FalseClass] depending on whether test succeeds.
  def binary_dec_interactive args=ARGV
    stderr = @memory[:stderr]
    iv, encrypted, base64_salt, base64_iter, password, data_is_base64  = args
    stderr.print "[password]"
    password = (input_single_line_non_echo [password])
    stderr.puts
    binary_dec [password, iv, encrypted, nil, base64_salt, base64_iter, data_is_base64]
  end


  # test for binary_enc and binary_dec.
  # "" and nil are expected to be treated
  # as the same.
  def test__binary_enc_dec_nil args=ARGV
    nil_case = binary_dec [nil, "ltUQIxgRAeUNXPNTTps8FQ==\n", "xyeqxw/TzkyXtOxpDqAl58SNAvXPyNZ89B5JGtwDkcbjo0vObgPsh5FrgZJs\nHPjofsyXnljnTrHpDoQeDVezo9wBZ74NU+TSi/GssX605oE=\n", nil, "TU4o3IKiFWki3rZ3lMchLQ==\n", "MjAwMDA=\n"]
    empty = binary_dec ["", "ltUQIxgRAeUNXPNTTps8FQ==\n", "xyeqxw/TzkyXtOxpDqAl58SNAvXPyNZ89B5JGtwDkcbjo0vObgPsh5FrgZJs\nHPjofsyXnljnTrHpDoQeDVezo9wBZ74NU+TSi/GssX605oE=\n", "", "TU4o3IKiFWki3rZ3lMchLQ==\n", "MjAwMDA=\n"]
    judgement =
      [
        [nil_case, empty, "empty_nil_equality"]
      ].map(&method("expect_equal")).all?
  end


  # test for binary_enc and binary_dec.
  #
  # @param [Array] args, an +Array+ whose elements are expected to be:
  # +data+:: [String, nil] data to be encrypted.
  # If empty or nil, read (without echo) from @memory[:stdin], which defaults to STDIN
  # +password+:: [String, nil] password to be used to encryption.
  # If empty or nil, read (without echo) from @memory[:stdin], which defaults to STDIN
  #
  # @return [TrueClass, FalseClass] depending on whether test succeeds.
  def test__binary_enc_dec args=ARGV
    stderr = @memory[:stderr]
    data, password = args
    stderr.print "[data]"
    data = binary_input_multi_line_non_echo [data]
    stderr.print "[password]"
    password = binary_input_single_line_non_echo [password]
    base64_encrypted, base64_iv, base64_salt, base64_iter, base64_key = binary_enc [password, data]
    dec_args = [password, base64_iv, base64_encrypted, nil, base64_salt, base64_iter]
    stderr.puts "# WARNING: secrets, including password are printed here. Storing them may be a major security incident."
    stderr.puts "# programmatically:"
    stderr.puts "binary_dec " + dec_args.to_s
    stderr.puts "# shell: "
    stderr.puts "#{$0} invoke_double p binary_dec " + (output_array_to_shell dec_args).to_s
    data_plain = binary_dec [password, base64_iv, base64_encrypted, nil, base64_salt, base64_iter]
    judgement =
      [
        [data, data_plain, "data"]
      ].map(&method("expect_equal")).all?
  end


  # test for binary_enc and binary_dec_interactive.
  # good idea is to use this function once with the desired
  # data, password, and use the stderr output
  def test__binary_enc_dec_interactive args=ARGV
    stderr = @memory[:stderr]
    data, password, encrypted_base64_filename, data_is_base64 = args
    stderr.print "[data]"
    data =  binary_input_multi_line_non_echo [data]
    stderr.print "[password]"
    password = binary_input_single_line_non_echo [password]
    stderr.puts
    base64_encrypted, base64_iv, base64_salt, base64_iter, base64_key = binary_enc [password, data, nil, nil, nil, data_is_base64 ]
    # the output is supposed to be safe to store,
    # so password is not placed in from binary_dec_interactive_args:
    dec_interactive_args = [base64_iv, base64_encrypted, base64_salt, base64_iter]
    stderr.puts "# programmatically:"
    stderr.puts "dec_interactive " + dec_interactive_args.to_s
    stderr.puts "# shell: "
    stderr.puts "#{$0} invoke_double puts binary_dec_interactive " + (output_array_to_shell dec_interactive_args).to_s
    stderr.puts "#or shell var:"
    stderr.puts "my_secret=$(#{$0} invoke_double puts binary_dec_interactive " + (output_array_to_shell dec_interactive_args).to_s + ")\necho $my_secret\nunset mysecret"
    encrypted_base64_filename && output_enc_file(dec_interactive_args  + [encrypted_base64_filename])
    data_plain = binary_dec_interactive(dec_interactive_args + [password, data_is_base64])
    judgement =
      [
        [data.size, data_plain.size, "data.size"],
        [data, data_plain, "data"],
      ].map(&method("expect_equal")).all?
  end


  # similar to
  # test__binary_enc_dec_interactive,
  # just that the data is ready from a file instead
  # note that there is an extra argument between
  # the args, the enc_out_filename.
  def test__binary_enc_dec_file_interactive args=ARGV
    stderr = @memory[:stderr]
    filename_or_url, enc_out_filename, password, data_is_base64 = args
    stderr.print "[filename_or_url]"
    filename_or_url = binary_input_multi_line_non_echo [filename_or_url]
    stderr.print "[output_filename_encrypted_data]"
    enc_out_filename = binary_input_multi_line_non_echo [enc_out_filename ]
    data =  file_or_url_contents filename_or_url
    test__binary_enc_dec_interactive [ data, password, enc_out_filename, data_is_base64 ]
  end


  # basically the reverse of test__binary_enc_dec_file_interactive
  # planned improvements: still outputs to stdout
  def test__binary_dec_file_interactive args=ARGV
    stderr = @memory[:stderr]
    stdout = @memory[:stdout]
    enc_filename_or_url, out_filename, password, data_is_base64 = args
    stderr.print "[enc_filename_or_url]"
    enc_filename_or_url = binary_input_multi_line_non_echo [enc_filename_or_url]
    stderr.print "[output_filename_plain_data]"
    out_filename = binary_input_multi_line_non_echo [out_filename ]
    stderr.print "[password]"
    password = binary_input_single_line_non_echo [password]

    output_dec_file [enc_filename_or_url, out_filename, password, data_is_base64]
  end


  # gem_spec
  # args (Array like the one returned by rubyment_gem_defaults)
  # returns: a gem spec string accordingly to args
  def gem_spec args=ARGV
    memory = @memory
    gem_name,
    gem_version,
    gem_dir,
    gem_ext,
    gem_hifen,
    gem_date,
    gem_summary,
    gem_description,
    gem_authors,
    gem_email,
    gem_files,
    gem_homepage,
    gem_license,
    gem_validate_class,
    gem_validate_class_args,
    gem_validate_class_method,
    gem_is_current_file,
    gem_bin_generate,
    gem_bin_contents,
    gem_bin_executables,
    gem_dependencies,
      gem_non_ruby_executables,
    reserved = args

    debug = @memory[:debug]
    stderr = @memory[:stderr]
    debug = debug.nne
    debug && (stderr.puts "{#{__method__} starting")
    debug && (stderr.puts "caller=#{caller_label}")
    debug && (stderr.puts "args=#{args.inspect}")
    debug && (stderr.puts "args.each_with_index=#{args.each_with_index.entries.inspect}")

    gem_dependencies  = gem_dependencies.nne []
    gem_dependencies_str = gem_dependencies.map{ |d|
      "s.add_dependency *#{d.to_s}"
    }.join "\n  "
    debug && (stderr.puts "gem_dependencies=#{gem_dependencies}")
    debug && (stderr.puts "gem_dependencies_str=#{gem_dependencies_str.inspect}")

    gem_bin_executables,
      reserved = gem_deploy__non_ruby_binaries [
        gem_name,
        gem_non_ruby_executables,
        gem_bin_executables,
      ]
    #

    contents =<<-ENDHEREDOC
Gem::Specification.new do |s|
  s.name        = '#{gem_name}'
  s.version     = '#{gem_version}'
  s.date        = '#{gem_date}'
  s.summary     = '#{gem_summary}'
  s.description = '#{gem_description}'
  s.authors     = #{gem_authors.inspect}
  s.email       = '#{gem_email}'
  s.files       = #{gem_files.inspect}
  s.homepage    = '#{gem_homepage}'
  s.license     = '#{gem_license}'
  s.executables += [#{gem_bin_executables}].flatten
  #{gem_dependencies_str}
end
    ENDHEREDOC
    rv = contents
    debug && (stderr.puts "#{__method__} will return #{rv.inspect}")
    # if raises exception before it will be unbalanced :
    debug && (stderr.puts "#{__method__} returning}")
    rv
  end


  # rubyment_gem_spec
  # args (Array, forwarded and transfomed by rubyment_gem_defaults)
  # returns: a gem spec string for Rubyment
  def rubyment_gem_spec args=ARGV
    memory = @memory
    gem_spec rubyment_gem_defaults args
  end


  # test for rubyment_gem_spec. outputs the contents
  # returned by that function.
  # args: none
  # returns: none
  def test__rubyment_gem_spec args=ARGV
    puts rubyment_gem_spec
  end



  # defaults for the rubyment gem
  # args:
  # [gem_name, gem_version, gem_dir, gem_ext, gem_hifen]
  # all Strings.
  # defaults:
  # ["rubyment", version [], memory[:running_dir],
  # ".gem", "-"]
  # returns:
  # [gem_name, gem_version, gem_dir, gem_ext, gem_hifen]
  #
  def rubyment_gem_defaults args=ARGV
    memory = @memory
    running_dir   = memory[:running_dir]
    basic_version = memory[:basic_version]
    major_version = memory[:major_version]

    gem_name,
      gem_version,
      gem_dir,
      gem_ext,
      gem_hifen,
      gem_date,
      gem_summary,
      gem_description,
      gem_authors,
      gem_email,
      gem_files,
      gem_homepage,
      gem_license,
      gem_validate_class,
      gem_validate_class_args,
      gem_validate_class_method,
      gem_is_current_file,
      gem_bin_generate,
      gem_bin_contents,
      gem_executables,
      gem_dependencies,
      gem_non_ruby_executables,
      reserved = args

    gem_name ||= "rubyment"
    gem_version ||= (version [])
    gem_dir ||= running_dir
    gem_ext ||= ".gem"
    gem_hifen ||= "-"
    gem_ext ||= "date"
    gem_date ||=  Time.now.strftime("%Y-%m-%d")
    gem_summary     ||= "a set of ruby helpers"
    gem_description ||= "a gem for keeping Rubyment, a set of ruby helpers"
    gem_authors     ||= ["Ribamar Santarosa"]
    gem_email       ||= 'ribamar@gmail.com'
    gem_files       ||= ["lib/#{gem_name}.rb"]
    gem_homepage    ||=
      "http://rubygems.org/gems/#{gem_name}"
    gem_license     ||= 'GPL-3.0'
    gem_validate_class ||= self.class.to_s
    gem_validate_class_args ||= {:invoke => ["p", "installed and validated"] }
    gem_validate_class_method ||= "new"
    gem_is_current_file ||= __FILE__ # this enables the possibility of building
    #  a gem for the calling file itself, but be aware that lib/gem_file.rb
    # is supposed to be overriden later.
    gem_bin_generate ||= "bin/#{gem_name}" # generate a bin file
    gem_bin_contents ||=<<-ENDHEREDOC
#!/usr/bin/env ruby
require '#{gem_name}'
#{gem_validate_class}.new({:invoke => ARGV})
    ENDHEREDOC
    gem_executables ||= [ gem_bin_generate && "#{gem_name}" ]
    gem_dependencies ||= [
      #  use the format, for gems with semantic versioning
      # ["gems", "~> 0"],
    ]
    gem_non_ruby_executables ||= [
      # gem normally can only deploy non_ruby execs.
      # each file in this array will be escapsulated
      # as a ruby script that calls that file instead.
      # that ruby script will be placed in the
      # bin/ dir, and added to gem_executables

    ]

    [
       gem_name,
       gem_version,
       gem_dir,
       gem_ext,
       gem_hifen,
       gem_date,
       gem_summary,
       gem_description,
       gem_authors,
       gem_email,
       gem_files,
       gem_homepage,
       gem_license,
       gem_validate_class,
       gem_validate_class_args,
       gem_validate_class_method,
       gem_is_current_file,
       gem_bin_generate,
       gem_bin_contents,
       gem_executables,
       gem_dependencies,
       gem_non_ruby_executables,
   ]
  end


  # returns the gem path given the params.
  # args:
  # [gem_name, gem_version, gem_dir, gem_ext, gem_hifen]
  # all Strings.
  # defaults:
  # ["rubyment", version [], memory[:running_dir],
  # ".gem", "-"]
  def gem_path args=ARGV
    gem_name, gem_version, gem_dir, gem_ext, gem_hifen = rubyment_gem_defaults args
    "#{gem_dir}/#{gem_name}#{gem_hifen}#{gem_version}#{gem_ext}"
  end


  # forces the uninstallation of a gem in all the ways we can
  # mostly for internal tests that needs to ensure a gem wasn't
  # installed before a test.
  def test__gem_uninstall_extreme_force args=ARGV
    stderr = @memory[:stderr]
    gem_spec, user_install, quiet = args
    quiet = quiet.nne
    debug = quiet.negate_me
    command="gem uninstall -a -x  #{gem_spec}"
    debug && (stderr.puts "command=#{command}")
    `#{command}`
    command="gem uninstall -a -x --user-install  #{gem_spec}"
    debug && (stderr.puts "command=#{command}")
    `#{command}`
    command="sudo gem uninstall -a -x  #{gem_spec}"
    debug && (stderr.puts "command=#{command}")
    `#{command}`
    command="sudo gem uninstall -a -x --user-install  #{gem_spec}"
    debug && (stderr.puts "command=#{command}")
    `#{command}`

    command="gem uninstall -x  #{gem_spec}"
    debug && (stderr.puts "command=#{command}")
    `#{command}`
    command="gem uninstall -x --user-install  #{gem_spec}"
    debug && (stderr.puts "command=#{command}")
    `#{command}`
    command="sudo gem uninstall -x  #{gem_spec}"
    debug && (stderr.puts "command=#{command}")
    `#{command}`
    command="sudo gem uninstall -x --user-install  #{gem_spec}"
    debug && (stderr.puts "command=#{command}")
    `#{command}`
    []
  end

  # gem_build
  # args:
  # [gem_spec_path (String), gem_spec_contents (String), gem_is_current_file, gem_name]
  # returns:
  # console output of gem build (String)
  def gem_build args=ARGV
    stderr = @memory[:stderr]
    gem_spec_path,
    gem_spec_contents,
    gem_is_current_file,
    gem_name,
    gem_bin_generate,
    gem_bin_contents,
      quiet,
      reserved = args
    quiet = quiet.nne
    debug = quiet.negate_me
    require 'fileutils'

    # this supposes that  the current file is listed by the
    # s.files
    # field of the specification. it is not currently checked.
    gem_is_current_file && (
      FileUtils.mkdir_p 'lib'
      file_backup "lib/#{gem_name}.rb", "lib/"
      # quick hack for backwards compatibility
      gem_is_current_file = gem_is_current_file.kind_of?(TrueClass) && __FILE__ || gem_is_current_file
      save_file gem_is_current_file, "lib/#{gem_name}.rb"
    )

    # this supposes that  the current file is listed by the
    # s.files
    # field of the specification. it is not currently checked.
    gem_bin_generate && (
      FileUtils.mkdir_p File.dirname gem_bin_generate
      file_backup gem_bin_generate, (File.dirname gem_bin_generate)
      File.write gem_bin_generate, gem_bin_contents
      (File.chmod 0755, gem_bin_generate)
    )

    FileUtils.mkdir_p File.dirname gem_spec_path
    File.write gem_spec_path, gem_spec_contents || (File.read gem_spec_path)
    command="gem build #{gem_spec_path}"
    debug && (stderr.puts "command=#{command}")
    `#{command}`
  end


  # test for gem_build: builds gem for this rubyment file
  # after it, these commands will install/uninstall it:
  # sudo gem install $PWD/rubyment-0.0.#{@memory[:basic_version]} ; gem list  | grep -i rubyment ; sudo gem uninstall  rubyment
  # dependee:
  #  test__gem_install_validate_uninstall
  # args:
  # [gem_spec_path (String), gem_spec_contents (String)]
  # returns: none
  # outputs of gem build (String)
  def test__gem_build args=ARGV
    require 'fileutils'
    FileUtils.mkdir_p 'lib'
    save_file __FILE__, 'lib/rubyment.rb'
    puts gem_build ["rubyment.spec", rubyment_gem_spec(args) ]
  end

  # gem_install
  # args:
  # [gem_spec (String)]
  # returns:
  # console output of gem install (String)
  def gem_install args=ARGV
    stderr = @memory[:stderr]
    system_user_is_super = @memory[:system_user_is_super]
    gem_spec, user_install, quiet = args
    quiet = quiet.nne
    debug = quiet.negate_me
    user_install ||= (!system_user_is_super) && "--user-install" || ""
    command="gem install #{user_install}  #{gem_spec}"
    debug && (stderr.puts "command=#{command}")
    `#{command}`
  end

  # gem_install_force_from_remote
  def gem_install_remote args=[]
    stderr = @memory[:stderr]
    system_user_is_super = @memory[:system_user_is_super]
    gem_spec, user_install, quiet = args
    quiet = quiet.nne
    debug = quiet.negate_me
    user_install ||= (!system_user_is_super) && "--user-install" || ""
    command="gem install -r #{user_install}  #{gem_spec}"
    debug && (stderr.puts "command=#{command}")
    `#{command}`
  end

  # gem_push
  # args:
  # [gem_spec (String)]
  # returns:
  # console output of gem push (String)
  def gem_push args=ARGV
    stderr = @memory[:stderr]
    gem_spec, future_arg, quiet = args
    quiet = quiet.nne
    debug = quiet.negate_me
    command="gem push #{gem_spec}"
    debug && (stderr.puts "command=#{command}")
    `#{command}`
  end


  # uninstall all versions of a specific gem
  # @param [Array] +args+, an +Array+ whose elements are expected to be:
  # +gem_spect+:: [String] 
  # +user_install+:: [Object]
  # +quiet+:: [Object] if calling the object +nne+ method returns a +false+ value, will print debug information
  # +ignored+:: [Object] ignored parameter
  # +gem_version+:: [Object]
  # @return [String] console output of gem uninstall
  def gem_uninstall_all args=[]
    stderr = @memory[:stderr]
    gem_spec, user_install, quiet, all, gem_version = args
    all = "-a"
    gem_uninstall [gem_spec, user_install, quiet, all, gem_version]
  end


  # gem_uninstall
  # args:
  # @param [Array] +args+, an +Array+ whose elements are expected to be:
  # +gem_spect+:: [String] 
  # +user_install+:: [Object]
  # +quiet+:: [Object] if calling the object +nne+ method returns a +false+ value, will print debug information
  # +ignored+:: [Object] ignored parameter
  # +gem_version+:: [Object]
  # @return [String] console output of gem uninstall
  def gem_uninstall args=ARGV
    stderr = @memory[:stderr]
    system_user_is_super = @memory[:system_user_is_super]
    gem_spec, user_install, quiet, all, gem_version = args
    quiet = quiet.nne
    debug = quiet.negate_me
    all = all.nne ""
    gem_version = gem_version && ("--version #{gem_version}") || ""
    user_install ||= (!system_user_is_super) && "--user-install" || ""
    command="gem uninstall #{all} -x #{user_install}  #{gem_spec} #{gem_version}"
    debug && (stderr.puts "command=#{command}")
    `#{command}`
  end

  # gem_list
  # args:
  # [gem_spec (String)]
  # returns:
  # console output of gem install (String)
  def gem_list args=ARGV
    stderr = @memory[:stderr]
    gem_spec,
      quiet,
      reserved = args
    quiet = quiet.nne
    debug = quiet.negate_me
    effective_command="gem list | grep #{gem_spec}"
    command="gem list"
    debug && (stderr.puts "command=#{effective_command}")
    command_output = shell_popen3_command([command])[0]
    grep_command_output = command_output.select { |l|
      l.match /#{gem_spec}/
    }
    spec_grep_output = grep_command_output.join("\n")
    puts spec_grep_output
    spec_grep_output
  end

  # validate_require
  # requires a file/gem in the system
  # returns nil if not found
  # args:
  # [requirement (String), validator_class (Class or String or nil),
  #  validator_args (Array), validator_method (Method or String),
  #  file_to_load_instead (String)]
  # returns:
  # Rubyment, true or false
  def validate_require args=ARGV
    stderr = @memory[:stderr]
    debug = @memory[:debug]
    debug && (stderr.puts "{#{__method__} starting")
    debug && (stderr.puts "caller=#{caller_label}")
    debug && (stderr.puts "args=#{args.inspect}")
    debug && (stderr.puts "args.each_with_index=#{args.each_with_index.entries.inspect}")
    requirement,
      validator_class,
      validator_args,
      validator_method,
      file_to_load_instead,
      reserved = containerize args
    validate_call = validator_class && true
    validator_class = to_class validator_class
    validator_method ||=  "new"
    rv = begin
      debug  && (file_to_load_instead.nne.negate_me) && (stderr.puts "will require #{requirement}")
      (file_to_load_instead.nne.negate_me) && (require requirement)
      debug  && (file_to_load_instead) && (stderr.puts "will load #{file_to_load_instead}")
      (file_to_load_instead) && (load file_to_load_instead)
      validate_call && (object_method_args_call [validator_method, validator_class, validator_args]) || (!validate_call) && true
    rescue LoadError => e
      stderr.puts e
      nil
    end

    debug && (stderr.puts "#{__method__} will return #{rv.inspect}")
    debug && (stderr.puts "#{__method__} returning}")
    rv
  end

  # system_rubyment
  # requires a system's Rubyment and invoke it using args
  # args:
  # args (Array)
  # returns:
  # Rubyment or false
  def system_rubyment args=ARGV
    validate_require ['rubyment', 'Rubyment', {:invoke => args }]
  end


  # extract only the arguments referring to the
  # bin file generation from args
  def gem_bin_args args=ARGV
    gem_name,
    gem_version,
    gem_dir,
    gem_ext,
    gem_hifen,
    gem_date,
    gem_summary,
    gem_description,
    gem_authors,
    gem_email,
    gem_files,
    gem_homepage,
    gem_license,
    gem_validate_class,
    gem_validate_class_args,
    gem_validate_class_method,
    gem_is_current_file,
    gem_bin_generate,
    gem_bin_contents,
    gem_bin_executables = args
    [
        gem_bin_generate,
        gem_bin_contents,
        gem_bin_executables,
    ]
  end


  #  extract only the arguments referring to files
  # from args
  def gem_files_args args=ARGV
    gem_name,
    gem_version,
    gem_dir,
    gem_ext,
    gem_hifen,
    gem_date,
    gem_summary,
    gem_description,
    gem_authors,
    gem_email,
    gem_files,
    gem_homepage,
    gem_license,
    gem_validate_class,
    gem_validate_class_args,
    gem_validate_class_method,
    gem_is_current_file = args
    [
        gem_files,
        gem_is_current_file,
    ]
  end


  #  extract only the arguments for validation
  # from args
  def gem_validate_args args=ARGV
    gem_name,
    gem_version,
    gem_dir,
    gem_ext,
    gem_hifen,
    gem_date,
    gem_summary,
    gem_description,
    gem_authors,
    gem_email,
    gem_files,
    gem_homepage,
    gem_license,
    gem_validate_class,
    gem_validate_class_args,
    gem_validate_class_method,
    gem_is_current_file = args
    [
        gem_name,
        gem_validate_class,
        gem_validate_class_args,
        gem_validate_class_method,
        gem_is_current_file,
    ]
  end


  # test for system_rubyment
  # dependee:
  #  test__gem_install_validate_uninstall
  # args:
  # args (Array or nil)
  # returns:
  # Rubyment or false
  def test__system_rubyment args=ARGV
    rubyment_args = (args.to_a.size > 0 && args) || ["main", "tested system_rubyment"]
    p validate_require ['rubyment', 'Rubyment', {:invoke => rubyment_args }]
  end


  # validate the installation of a gem
  # args rubyment_gem_defaults
  # but planned to change.
  # bug detected: require x won't reload the gem.
  # args (Array just like the one
  # returned by rubyment_gem_defaults)
  # returns:
  # true or false
  def gem_validate args=ARGV
    memory = @memory
    debug = @memory[:debug]
    stderr = @memory[:stderr]

    debug = debug.nne
    debug && (stderr.puts "{#{__method__} starting")
    debug && (stderr.puts "caller=#{caller_label}")
    debug && (stderr.puts "args=#{args.inspect}")
    debug && (stderr.puts "args.each_with_index=#{args.each_with_index.entries.inspect}")
    gem_defaults = rubyment_gem_defaults args
    gem_name, gem_version = gem_defaults
    gem_files, gem_is_current_file = gem_files_args gem_defaults
    gem_bin_generate, gem_bin_contents = gem_bin_args gem_defaults

    puts gem_build [
      "#{gem_name}.spec",
      gem_spec(gem_defaults),
      gem_is_current_file,
      gem_name,
      gem_bin_generate,
      gem_bin_contents,
    ]
    p (gem_path [gem_name, gem_version])
    gem_install [(gem_path [gem_name, gem_version])]
    listing = gem_list [gem_name]
    v = listing.index version([])
    debug && v && (stderr.puts "gem installed(#{v})")
    debug && v.negate_me && (stderr.puts "gem not installed(#{v})")
    v &&= (
      validate_require gem_validate_args gem_defaults
    )
    gem_uninstall [
      gem_name,
      :user_install.to_nil,
      :quiet.to_nil,
      :all.to_nil,
      gem_version,
    ]
    v
    rv = v
    debug && (stderr.puts "#{__method__} will return #{rv.inspect}")
    # if raises exception before it will be unbalanced :
    debug && (stderr.puts "#{__method__} returning}")
    rv
  end


  # test for gem_build, gem_install, gem_list
  # system_rubyment, gem_uninstall
  # note that, if there is a "rubyment" gem
  # already installed, it will be temporarily
  # unavailable.
  # args:
  # args (Array or nil)
  # returns:
  # Rubyment or false
  def test__gem_build_install_validate_uninstall args=ARGV
    memory = @memory
    basic_version = memory[:basic_version]
    major_version = memory[:major_version]
    running_dir = memory[:running_dir]
    test__gem_build []
    already_installed = (system_rubyment ["p", "already installed"])
    sleep 1
    gem_uninstall ["rubyment"]
    puts gem_list ["rubyment"]
    gem_install ["#{running_dir}/rubyment-#{major_version}.#{basic_version}.gem"]
    puts gem_list ["rubyment"]
    v = test__system_rubyment []
    gem_uninstall ["rubyment"]
    already_installed && (gem_install ["rubyment"])
    v
  end


  # gets the api key needed to push gems to rubygems.
  # prompts for arguments when username or password
  # not provided.
  # args:
  # [username (String or nil), password (String or nil),
  # file_destination (String, "/dev/null" if empty/nil given)]
  # returns
  # key_contents (String)
  def gem_get_api_key args=ARGV
    stderr = @memory[:stderr]
    require 'fileutils'
    username, password, file_destination = args
    stderr.print "username - "
    username = input_single_line [username]
    stderr.print "password - "
    password = input_single_line_non_echo [password]
    file_destination = file_destination.to_s.split("\0").first || "/dev/null"
    FileUtils.mkdir_p File.dirname file_destination
    key_contents = save_file "https://rubygems.org/api/v1/api_key.yaml",
      file_destination, 0, {:username => username, :password => password }
    (File.chmod 0600, file_destination)
    key_contents
  end


  # test for test__gem_get_api_key
  # args:
  # (Array - forwarded to gem_get_api_key)
  # returns:
  # nil
  def test__gem_get_api_key args=ARGV
    puts gem_get_api_key args
  end


  # builds, validates and push a gem accordingly
  # to the arguments. if arguments not given,
  # will do for the defaults (see rubyment_gem_defaults)
  # args:
  # args (Array or nil)
  # returns:
  # ignore (will change)
  def gem_build_push args=ARGV
    memory = @memory
    running_dir      = memory[:running_dir]
    home_dir         = memory[:home_dir]
    gem_username, gem_password, gem_api_key_file, gem_defaults = args
    gem_password = gem_password.to_s.split("\0").first
    gem_defaults ||=  rubyment_gem_defaults []
    gem_api_key_file ||= "#{home_dir}/.gem/credentials"
    permissions = file_permissions_octal gem_api_key_file
    credentials_contents = url_to_str gem_api_key_file, ""
    (gem_get_api_key [gem_username, gem_password, gem_api_key_file]) rescue nil
    validated = (
      gem_validate gem_defaults
    )
    puts validated && (gem_push gem_path gem_defaults )
    File.write gem_api_key_file, credentials_contents
    File.chmod permissions, gem_api_key_file
  end


  # test for gem_build, gem_install, gem_list
  # system_rubyment, gem_uninstall
  # args:
  # args (Array or nil)
  # returns:
  # ignore
  def test__gem_complete_flow args=ARGV
    memory = @memory
    gem_build_push args
  end


  # test file_backup when file is a dir
  def test__file_backup__when_file_is_dir args=ARGV
    require 'fileutils'
    dest_dir, filename, append, prepend, keep_new = args
    filename ||= "testing-" + Time.now.hash.abs.to_s + ""
    dest_dir ||= "/tmp/"
    append ||= ""
    prepend ||= ""
    filename  += "/"
    expected_new_dir = dest_dir + filename
    existing_dir = (file_read [filename, nil, nil, nil])
    FileUtils.mkdir_p filename
    file_backup filename, dest_dir, append, prepend
    filename_test = File.directory? filename
    expected_new_dir_test = File.directory? expected_new_dir
    original_permissions = file_permissions_octal filename
    new_permissions = file_permissions_octal expected_new_dir
    judgement =
      [
        [filename_test, expected_new_dir_test, "File.directory?"],
        [original_permissions, new_permissions, "file_permissions"],
      ].map(&method("expect_equal")).all?
    (!existing_dir) && (FileUtils.rmdir filename)
    (!keep_new) && (FileUtils.rmdir expected_new_dir)
  end


  # test file_backup (just like a copy)
  def test__file_backup args=ARGV
    require 'fileutils'
    dest_dir, filename, append, prepend, file_contents, user, pw, keep_new  = args
    filename ||= "testing-" + Time.now.hash.abs.to_s + ""
    dest_dir ||= "/tmp/"
    append ||= ""
    prepend ||= ""
    expected_new_filename = dest_dir + filename
    existing_file = (file_read [filename, nil, user, pw])
    file_contents = file_read_or_write filename, "contents_of:#{filename}", user, pw
    file_backup filename, dest_dir, append, prepend
    new_file_contents = File.read expected_new_filename
    original_permissions = file_permissions_octal filename
    new_permissions = file_permissions_octal expected_new_filename
    judgement =
      [
        [file_contents, new_file_contents, "file_contents"],
        [original_permissions, new_permissions, "file_permissions"],
      ].map(&method("expect_equal")).all?
    (!existing_file) && (FileUtils.rm filename)
    (!keep_new) && (FileUtils.rm expected_new_filename)
    judgement
  end


  # same as test__file_backup__when_file_is_dir, but backup is not removed.
  def test__file_backup__when_file_is_dir__but_keep args=ARGV
    dest_dir, filename, append, prepend, dont_keep_new = args
    test__file_backup__when_file_is_dir [dest_dir, filename, append, prepend, !dont_keep_new]
  end


  # same as test__file_backup, but backup is not removed.
  def test__file_backup__but_keep args=ARGV
    dest_dir, filename, append, prepend, file_contents, user, pw, dont_keep_new  = args
    test__file_backup [dest_dir, filename, append, prepend, file_contents, user, pw, !dont_keep_new]
  end


  # returns a method object out of a string or a method object,
  # in a polymorphic style.
  # @param [Array] +args+, an +Array+ whose elements are expected to be:
  # +method_name_or_method+:: [String, Method] method name or method object
  # +debug+::
  # +to_object_method_debug+:: debug to_object_method call
  # +output_exceptions+::
  # +no_rescue+::
  # +default_method+:: in the case no method can be derived from the args, this one is returned. Suggested Proc.new {|*args| } (not done for API respect)
  #
  # @return [Method] a method
  def to_method args = ARGV
    method_name_or_method,
      object,
      debug,
      to_object_method_debug,
      output_exceptions,
      no_rescue,
      default_method,
      reserved = args

    stderr = @memory[:stderr]
    debug && (stderr.puts "{#{__method__} starting")
    debug && (stderr.puts "caller=#{caller_label}")
    debug && (stderr.puts "args.each_with_index=#{args.each_with_index.entries.inspect}")
    default_method = default_method.nne # ideally Proc.new {|*args| }, but we can't change the API
    to_method_block = bled [
      nil,
      no_rescue,
      output_exceptions,
    ] {
      (
        to_object_method [object, method_name_or_method, to_object_method_debug ]
      ) || (
        method_name_or_method.respond_to?(:call) && method_name_or_method
      ) ||
        method(method_name_or_method) || default_method
    }
    rv = to_method_block.first.call
    debug && (stderr.puts "will return first of: #{rv.inspect}")
    debug && (stderr.puts "#{__method__} returning}")
    rv.first
  end


  # echoes the processing arg
  # @param [Array] +args+, an +Array+ whose elements are expected to be:
  # +processing_arg+:: [String]
  #
  # @return [String] +processing_arg+
  def echo args = ARGV
    args.first
  end


  # returns an HTTP response
  # @param [Array] +args+, an +Array+ whose elements are expected to be:
  # +response+:: [String, nil] response payload
  # +content_type+:: [String, nil] mime type of payload
  # +version+:: [String, nil] http protocol version
  # +code+:: [String, nil] response code
  # +keep_alive+:: [Boolean] right not unsupported, always close the connection
  # +debug+:: [Object] if calling the object +nne+ method returns a +false+ value, won't print debug information
  # +eol+:: [String, nil] string to attach to the end of each line in the response
  # +location+:: [String, nil]
  #
  # @return [String] response with headers
  def http_response_base args = []
    payload,
      content_type,
      code,
      version,
      keep_alive,
      debug,
      eol,
      location,
      reserved = args
    stderr = @memory[:stderr]
    debug.nne && (stderr.puts "#{__method__} starting")
    debug.nne && (stderr.puts args.inspect)
    rv = [
      "HTTP/#{version} #{code}",
      content_type && "Content-Type: #{content_type};" +
        " charset=#{payload.encoding.name.downcase}",
      payload && "Content-Length: #{payload.bytesize}",
      location && "Location: #{location.to_s}",
      keep_alive.negate_me && "Connection: close",
      "",
      "#{payload}"
    ].compact.join eol
    debug.nne && (stderr.puts "#{__method__} will return \"#{rv}\"")
    debug.nne && (stderr.puts "#{__method__} returning")
    rv
  end


=begin
  # short_desc = "tests function to create an http redirect response "

  @memory[:documentation].push = {
    :function   => :test__http_response__redirect,
    :short_desc => short_desc,
    :description => "",
    :params     => [
      {
        :name             => :args,
        :description      => "list of parameters",
        :duck_type        => Array,
        :default_behavior => "interpreted as empty array",
        :params           => [
          {
            :name             => :request,
            :duck_type        => String,
            :default_behavior => :nil
            :description      => "ignored, will redirect whatever request is made. nil is used.",
          },
          {
            :name             => :location,
            :duck_type        => String,
            :default_behavior => "",
            :description      => "Location: field value (the url to redirect to)",
          },
          {
            :name             => :code,
            :duck_type        => String,
            :default_behavior => "302 Found",
            :description      => "Error code. Note that there are many redirect codes specified by the HTTP protocol.",
          },
          {
            :name             => :version,
            :duck_type        => String,
            :default_behavior => "1.1",
            :description      => "HTTP protocol version",
          },
          {
            :name             => :debug,
            :duck_type        => Object,
            :default_behavior => :nil,
            :description      => "prints debug information to the __IO__ specified by __@memory[:stderr]__ (STDERR by default)",
          },
          {
            :name             => :eol,
            :duck_type        => Object,
            :default_behavior => "\r\n",
            :description      => "separator to join each line of the response",
          },
          {
            :name             => :reserved,
            :duck_type        => Object,
            :default_behavior => "interpreted as nil",
            :description      => "for future use",
          },
        ],
      },
    ],
  }

=end
  def test__http_response__redirect args = []
    request,
      location,
      code,
      version,
      debug,
      eol,
      reserved = args
    stderr = @memory[:stderr]
    debug = debug.nne
    debug.nne && (stderr.puts "#{__method__} starting")
    debug.nne && (stderr.puts args.inspect)
    location = location.nne ""
    version = version.nne "1.1"
    code = code.nne "302 Found"
    eol = eol.nne "\r\n"
    rv = http_response_base [
      :payload.to_nil,
      :content_type.to_nil,
      code,
      version,
      :keep_alive.to_nil,
      debug,
      eol,
      location,
    ]
    debug.nne && (stderr.puts "#{__method__} returning")
    rv
  end



  # returns an HTTP response (1.1 200 OK by default)
  # @param [Array] +args+, an +Array+ whose elements are expected to be:
  # +response+:: [String, nil] response payload (default empty)
  # +content_type+:: [String, nil] mime type of payload (default +text/plain+)
  # +version+:: [String, nil] http protocol version (+1.1+ by default)
  # +code+:: [String, nil] response code (+"200 OK"+ by default)
  # +keep_alive+:: [Boolean] right not unsupported, always close the connection
  # +debug+:: [Object] if calling the object +nne+ method returns a +false+ value, won't print debug information
  # +eol+:: [String, nil] response code (+"\r\n"+ by default/on +nil+)
  #
  # @return [Array] response with proper headers in an array where each element is a response line
  def http_OK_response args = ARGV
    payload, content_type, code, version, keep_alive, debug, eol = args
    stderr = @memory[:stderr]
    debug.nne && (stderr.puts "#{__method__} starting")
    debug.nne && (stderr.puts args.inspect)
    payload ||= ""
    payload  = payload.to_s
    content_type ||= "text/plain"
    version ||= "1.1"
    code ||= "200 OK"
    eol ||= "\r\n"
    rv = http_response_base [
      payload,
      content_type,
      code,
      version,
      keep_alive,
      debug,
      eol,
    ]
    debug.nne && (stderr.puts "#{__method__} returning")
    rv
  end


  # will call #gets on  +io+ until line starts with +happy_with_request+
  # @param [Array] +args+, an +Array+ whose elements are expected to be:
  # +io+:: [IO] any +IO+, like a +Socket+, returned by #TCPServer::accept
  # +debug+:: [Object] if evals to false (or empty string), won't print debug information
  # +happy_with_request+:: [String, nil] if nil, +eol+ is used.
  # +eol+:: [String] end of line
  #
  # @return [Array] array of strings having the lines read from the IO.
  def io_gets args = ARGV
    io, debug, happy_with_request = args
    happy_with_request ||= "\r\n"
    stderr = @memory[:stderr]
    debug.nne && (stderr.puts "#{__method__} starting")
    debug.nne && (stderr.puts args.inspect)
    lines = []
    (1..Float::INFINITY).
      lazy.map {|i|
        r = lines.push(io.gets).last
        debug.nne && (stderr.puts r)
        r.index(happy_with_request.to_s).to_i.nne && r
      }.find {|x| !x }
    debug.nne && (stderr.puts lines.inspect)
    debug.nne && (stderr.puts "#{__method__} returning")
    lines
  end


  # gets an input from +io+ and writes it back to the same +io+
  # supports an optional +replace+ and +replacement+ parameter
  # that can be used to make simple changes to the echoing output
  # @param [Array] +args+, an +Array+ whose elements are expected to be:
  # +io+:: [IO] any +IO+, like a +Socket+, returned by #TCPServer::accept
  # +debug+:: [Object] if evals to false (or empty string), won't print debug information
  # +transform_method_name+:: [String]
  # +transform_method_args+:: [Array] args to be given to the ++transform_method_name+
  # +happy_with_request+:: [String, nil] if nil, +eol+ is used.
  # +io_forward_debug+:: [boolean] will forward this argument to io_forward
  # +transform_call_debug+:: [boolean] will forward this argument to  transform_call
  # +to_method_debug+:: [boolean] will forward this argument to  to_method
  # +to_object_method_debug+:: [boolean] will forward this argument to to_object_method
  # +output_exceptions+:: [boolean]
  #
  # @return [nil]
  def io_transform args = ARGV
    io,
      debug,
      happy_with_request,
      transform_method_name,
      transform_method_args,
      io_forward_debug,
      transform_call_debug,
      to_method_debug,
      to_object_method_debug,
      output_exceptions,
      reserved = args
    stderr = @memory[:stderr]
    debug.nne && (stderr.puts "#{__method__} starting{")
    debug && (stderr.puts "caller=#{caller_label}")
    debug && (stderr.puts "args.each_with_index=#{args.each_with_index.entries.inspect}")
    debug.nne && (stderr.puts "transform_method_name: #{transform_method_name}")
    debug.nne && (stderr.puts "transform_method_args: #{transform_method_args.inspect}")
    io_forward [[io], io, io_forward_debug, happy_with_request, reserved,
      :transform_call, [
        transform_method_name,
        transform_method_args,
        "on_object:true",
        transform_call_debug,
        output_exceptions,
      ],
      to_method_debug,
      to_object_method_debug,
    ]
    debug.nne && (stderr.puts "#{__method__} returning}")
    nil
  end


  # gets and forwards the input from one IO to a list of IOs
  # @param [Array] +args+, an +Array+ whose elements are expected to be:
  # +ios_out+:: [Array] array of +IO+, where data will be written to.
  # +io_in+:: [IO] any +IO+, like a +Socket+, returned by #TCPServer::accept, where data will be read from.
  # +debug+:: [Object] if evals to false (or empty string), won't print debug information
  # +happy_with_request+:: [String, nil] if nil, +eol+ is used.
  # +to_method_debug+:: [boolean] will forward this argument to  to_method
  # +to_object_method_debug+:: [boolean] will forward this argument to to_object_method
  # +output_exceptions+:: [boolean]
  #
  # @return [nil]
  def io_forward args = ARGV

    ios_out,
      io_in,
      debug,
      happy_with_request,
      reserved,
      processing_method,
      processing_method_args,
      to_method_debug,
      to_object_method_debug,
      output_exceptions,
      reserved = args
    stderr = @memory[:stderr]
    debug.nne && (stderr.puts "{#{__method__} starting")
    debug && (stderr.puts "caller=#{caller_label}")
    debug.nne && (stderr.puts args.inspect)
    io_gets_args = [io_in, debug, happy_with_request]
    input = io_gets io_gets_args
    debug.nne && (stderr.puts input.inspect)
    debug.nne && (stderr.puts ios_out.class.inspect)
    processing_method ||= :echo
    debug && (stderr.puts "processing_method=#{processing_method}")
    processing_method_args ||= []
    processed_input = to_method(
      [
        processing_method,
        :object.to_nil,
        to_method_debug,
        to_object_method_debug,
      ]
    ).call(
        [input] + processing_method_args
    )
    threads = ios_out.map{ |shared_io_out|
      runoe_threaded(shared_io_out) {|io_out|
        io_out = shared_io_out
        io_out.print processed_input
        debug && (
          stderr.puts "#{io_out}: processed_input.class=#{processed_input.class}"
        )
        debug && processed_input && (
          stderr.puts "#{io_out}: #{processed_input.size} bytes: response writen."
        )
        io_out.close
        debug.nne && (
          stderr.puts "#{io_out}: IO closed."
        )

      }
    }
    threads.map { |thread|
      runoe_threaded() {
        thread.join
      }
    }
    debug.nne && (stderr.puts "#{__method__} returning}")
    nil
  end


  # gets an input from +io+ and writes it back to the same +io+
  # supports an optional +replace+ and +replacement+ parameter
  # that can be used to make simple changes to the echoing output
  # @param [Array] +args+, an +Array+ whose elements are expected to be:
  # +io+:: [IO] any +IO+, like a +Socket+, returned by #TCPServer::accept
  # +debug+:: [Object] if evals to false (or empty string), won't print debug information
  # +replace+:: [String]
  # +replacement+:: [String]
  # +happy_with_request+:: [String, nil] if nil, +eol+ is used.
  #
  # @return [nil]
  def io_echo args = ARGV
    io, debug, happy_with_request, replace, replacement, reserved = args
    # this is an inefficient replacement:
    replace ||= " "
    replacement ||= " "
    stderr = @memory[:stderr]
    debug.nne && (stderr.puts "#{__method__} starting")
    io_transform [
      io,
      debug,
      happy_with_request,
      :array_maps,
      [
        :gsub!, [replace, replacement]
      ],
    ]

    debug.nne && (stderr.puts "#{__method__} returning")
    nil
  end


  # writes a response to an IO (e.g.: socket)
  # @param [Array] +args+, an +Array+ whose elements are expected to be:
  # +debug+:: [Object] if evals to false (or empty string), won't print debug information
  # +reserved+:: [Object] for future use
  # +args_for_http_OK_response+:: [splat] args to be forwarded to #http_OK_response (check it for specification)
  #
  # @return [nil]
  def io_http_OK_response args = ARGV
    io, debug, reserved, *args_for_http_OK_response = args
    stderr = @memory[:stderr]
    debug.nne && (stderr.puts "#{__method__} starting")
    debug.nne && (stderr.puts args.inspect)
    response = http_OK_response args_for_http_OK_response
    debug.nne && (
      stderr.puts response.inspect
    )
    io.puts response
    debug.nne && (stderr.puts "response writen.")
    io.close
    debug.nne && (stderr.puts "IO closed.")
    debug.nne && (stderr.puts "#{__method__} returning")
    nil
  end


  # opens a TCP server accepting connections.
  # @param [Array] +args+, an +Array+ whose elements are expected to be:
  # +listening_port+:: [String, Integer] port to listen
  # +ip_addr+:: [String, nil] ip (no hostname) to bind the server. 0, nil, false, empty string will bind to all addresses possible.  0.0.0.0 => binds to all ipv4 . ::0 to all ipv4 and ipv6
  # +reserved+:: [Object] for future use
  # +debug+:: [Object] for future use
  # +callback_method+:: [String, Method] method to call when a client connects. The method must accept a socket as parameter.
  # +callback_method_args+:: [splat] args to be given to the call_back_method
  #
  # @return [Thread] returns a Thread object looping for accepting
  # incoming connections (call join on that object for waiting for its
  # completion).
  def tcp_server_plain args = ARGV
    stderr = @memory[:stderr]
    listening_port,
      ip_addr,
      reserved,
      debug,
      callback_method,
      *callback_method_args = args

    tcp_ssl_server [
      listening_port,
      ip_addr,
      debug,
      "admit non ssl server",
      callback_method,
      callback_method_args
      ]
  end


  # makes one or more OpenSSL server
  # @param [Array] +args+, an +Array+ whose elements are expected to be:
  # +listening_port+:: [String, Integer] port to listen
  # +ip_addr+:: [String, nil] ip (no hostname) to bind the server. 0, nil, false, empty string will bind to all addresses possible.  0.0.0.0 => binds to all ipv4 . ::0 to all ipv4 and ipv6
  # +admit_plain+:: [Boolean] if +true+, tries to create a normal +TCPServer+, if not possible to create +SSLServer+ (default: +false+, for preventing unadvertnt non-SSL server creation)
  # +debug+:: [Object] for future use
  # +priv_pemfile+:: [String] argument to be given to +OpenSSL::SSL::SSLContext.key+ method, after calling +OpenSSL::PKey::RSA.new+ with it. It's the private key file. letsencrypt example: +"/etc/letsencrypt/live/#{domain}/privkey.pem"+ (now it's accepted to pass the file contents instead, both must work).
  # +cert_pem_file+:: [String] argument to be given to +OpenSSL::SSL::SSLContext.cert+ method, after calling +OpenSSL::X509::Certificate+.  It's the "Context certificate" accordingly to its ruby-doc page. letsencrypt example: +"/etc/letsencrypt/live/#{domain}/fullchain.pem"+ (now it's accepted to pass the file contents instead, both must work).
  # +extra_cert_pem_files+:: [Array] array of strings. Each string will be mapped with +OpenSSL::SSL::SSLContext.new+, and the resulting array is given to +OpenSSL::SSL::SSLContext.extra_chain_cert+. "An Array of extra X509 certificates to be added to the certificate chain" accordingly to its ruby-doc. letsencryptexample: +["/etc/letsencrypt/live/#{domain}/chain.pem"]+ (now it's accepted to pass the file contents instead, both must work).
  # +output_exception+:: [Bool] output exceptions even if they are admitted?
  # +plain_servers+:: [TCPServer, Array of TCPServer] if given, ignores +listening_port+ and +ip_addr+, does not create a +TCPServer+ and just creates an +SSLServer+ out of this one. If an +Array+ of +TCPServer+ is provided instead, it will create one +SSLServer+ to each of those +TCPServer+.
  #
  # @return [Array] returns an  #Array whose elements are:
  # +servers+:: [Array of OpenSSL::SSL::SSLServer or of TCPServer] depending on +admit_plain+ and in the success of the creation of +SSLServers+.
  def ssl_make_servers args=ARGV
    stderr = @memory[:stderr]
    listening_port,
      ip_addr,
      debug,
      admit_plain,
      priv_pemfile,
      cert_pem_file,
      extra_cert_pem_files,
      output_exception,
      plain_servers,
      reserved = args
    debug = debug.nne
    extra_cert_pem_files = extra_cert_pem_files.nne []
    admit_plain = admit_plain.nne
    output_exception = (
      output_exception.nne || admit_plain.negate_me
    )
    debug && (stderr.puts "#{__method__} starting{")
    debug && (stderr.puts "args.each_with_index=#{args.each_with_index.entries.inspect}")
    # openssl functions want contents, not filenames:
    extra_cert_pem_files =  extra_cert_pem_files
      .map! { |extra_cert_pem_file|
        file_read [
          extra_cert_pem_file,
          nil,
          nil,
          extra_cert_pem_file
        ]
      }
    cert_pem_file = file_read [cert_pem_file, nil, nil, cert_pem_file]
    priv_pemfile  = file_read [priv_pemfile, nil, nil, priv_pemfile]
    require 'socket'
    plain_servers ||= TCPServer.new ip_addr, listening_port
    plain_servers = containerize plain_servers

    servers = plain_servers.map { |plain_server|
      ssl_server = runea [
        admit_plain,
        output_exception,
        "nil on exception"] {
          require 'openssl'
          ssl_context = OpenSSL::SSL::SSLContext.new
          ssl_context.extra_chain_cert =
            extra_cert_pem_files
              .map(&OpenSSL::X509::Certificate.method(:new))
          ssl_context.cert = OpenSSL::X509::Certificate
            .new cert_pem_file
          ssl_context.key = OpenSSL::PKey::RSA
            .new priv_pemfile
          ssl_server = OpenSSL::SSL::SSLServer
            .new plain_server, ssl_context
          ssl_server
      }
      server = ssl_server || admit_plain && plain_server
    }
    debug && (stderr.puts "will return #{[servers]}")
    debug && (stderr.puts "#{__method__} returning}")
    [servers]
  end


  # makes an OpenSSL server 
  # just an interface to the more powerful
  # recommended #ssl_make_servers
  # (kept for respecting open-closed principle)
  # @param [splat] +args+, an splat whose elements are expected to be:
  # +listening_port+:: [String, Integer] port to listen
  # +ip_addr+:: [String, nil] ip (no hostname) to bind the server. 0, nil, false, empty string will bind to all addresses possible.  0.0.0.0 => binds to all ipv4 . ::0 to all ipv4 and ipv6
  # +admit_plain+:: [Boolean] if +true+, tries to create a normal +TCPServer+, if not possible to create +SSLServer+ (default: +false+, for preventing unadvertnt non-SSL server creation)
  # +debug+:: [Object] for future use
  # +priv_pemfile+:: [String] argument to be given to +OpenSSL::SSL::SSLContext.key+ method, after calling +OpenSSL::PKey::RSA.new+ with it. It's the private key file. letsencrypt example: +"/etc/letsencrypt/live/#{domain}/privkey.pem"+ (now it's accepted to pass the file contents instead, both must work).
  # +cert_pem_file+:: [String] argument to be given to +OpenSSL::SSL::SSLContext.cert+ method, after calling +OpenSSL::X509::Certificate+.  It's the "Context certificate" accordingly to its ruby-doc page. letsencrypt example: +"/etc/letsencrypt/live/#{domain}/fullchain.pem"+ (now it's accepted to pass the file contents instead, both must work).
  # +extra_cert_pem_files+:: [Array] array of strings. Each string will be mapped with +OpenSSL::SSL::SSLContext.new+, and the resulting array is given to +OpenSSL::SSL::SSLContext.extra_chain_cert+. "An Array of extra X509 certificates to be added to the certificate chain" accordingly to its ruby-doc. letsencryptexample: +["/etc/letsencrypt/live/#{domain}/chain.pem"]+ (now it's accepted to pass the file contents instead, both must work).
  # +output_exception+:: [Bool] output exceptions even if they are admitted?
  # +plain_server+:: [TCPServer] if given, ignores +listening_port+ and +ip_addr+, does not create a +TCPServer+ and just creates an +SSLServer+ out of this one.
  #
  # @return [OpenSSL::SSL::SSLServer] returns an ssl server, which can be used to accept connections.
  def ssl_make_server *args
    stderr = @memory[:stderr]
    listening_port,
      ip_addr,
      debug,
      admit_plain,
      priv_pemfile,
      cert_pem_file,
      extra_cert_pem_files,
      output_exception,
      plain_server,
      reserved = args
    debug = debug.nne
    debug && (stderr.puts "#{__method__} starting")
    rv = (ssl_make_servers [
      listening_port,
      ip_addr,
      debug,
      admit_plain,
      priv_pemfile,
      cert_pem_file,
      extra_cert_pem_files,
      output_exception,
      plain_server,
    ]).first.first
    debug && (stderr.puts "will return #{rv}")
    debug && (stderr.puts "#{__method__} returning")
    rv
  end


  # opens an SSL server accepting connections.
  # @param [Array] +args+, an +Array+ whose elements are expected to be:
  # +listening_port+:: [String, Integer] port to listen
  # +ip_addr+:: [String, nil] ip (no hostname) to bind the server. 0, nil, false, empty string will bind to all addresses possible.  0.0.0.0 => binds to all ipv4 . ::0 to all ipv4 and ipv6
  # +admit_plain+:: [Boolean] if +true+, tries to create a normal +TCPServer+, if not possible to create +SSLServer+ (default: +false+, for preventing unadvertnt non-SSL server creation)
  # +debug+:: [Object] for future use
  # +callback_method+:: [String, Method] method to call when a client connects. The method must accept a socket as parameter.
  # +callback_method_args+:: [Array] args to be given to the call_back_method. Note that the type differs from #tcp_server_plain (which takes splat)
  #
  # @return [Thread] returns a Thread object looping for accepting
  # incoming connections (call join on that object for waiting for its
  # completion).
  def tcp_ssl_server args = ARGV
    stderr = @memory[:stderr]
    listening_port,
      ip_addr,
      debug,
      admit_plain,
      callback_method,
      callback_method_args,
      priv_pemfile,
      cert_pem_file,
      extra_cert_pem_files,
      output_exception,
      debug_client,
      reserved = args

    debug = debug.nne
    debug && (stderr.puts "{#{__method__} starting")
    debug && (stderr.puts "caller=#{caller_label}")
    debug && (stderr.puts "args.each_with_index=#{args.each_with_index.entries.inspect}")
    server = (ssl_make_servers [
      listening_port,
      ip_addr,
      debug,
      admit_plain,
      priv_pemfile,
      cert_pem_file,
      extra_cert_pem_files,
      output_exception,
    ]).first.first
    debug_client = debug_client.nne || debug
    debug && (stderr.puts "server=#{server}")
    rv = Thread.start {
      loop {
        client = runea [
          "yes, rescue",
          "yes, output exception",
          "nil on exception"
        ] {
          server.accept
        }
        Thread.start(client) { |client|
          debug_client && (stderr.puts "{client #{client} starting")
          debug_client && (stderr.puts Thread.current)
          block = bled [
            nil,
            :no_rescue.negate_me,
            output_exception,
          ] {
            to_method([callback_method])
              .call([client] + callback_method_args)
          }
          rv  = block.first.call
          debug_client && (stderr.puts "client will return #{rv}")
          debug_client && (stderr.puts "client #{client} finishing}")
          rv
        }
      }
    }
    debug && (stderr.puts "will return #{rv.inspect}")
    debug && (stderr.puts "#{__method__} returning}")
    rv
  end


  # test for tcp_server_plain
  def test__tcp_server_plain args = ARGV
   thread = tcp_server_plain [8003,
     "0",
     "reserved".to_nil,
     "debug",
     "io_echo",
     "debug_io_echo",
     "default happy_with_request".to_nil,
     " ", #replace
     "__", #replacement -- will replace empty spaces
     ]
   thread.join
   true
  end

  # test for tcp_server_plain (call io_transform)
  def test__tcp_server_plain__with_io_transform args = ARGV
   thread = tcp_server_plain [
     8003,
     "0",
     "",
     "debug",
     "io_transform",
     "debug_io_transform",
     "default happy_with_request".to_nil,
     :array_maps,
     [
        :gsub!, [" ", "_____"]
     ]
   ]
   thread.join
   true
  end

  # test for tcp_server_plain
  def test__tcp_server_plain__with_io_http_response args = ARGV
   thread = tcp_server_plain [
     8003, # listening_port
     "0",  # ip_addr: all possible
     "reserved".to_nil,
     "debug_tcp_server_plain_arg",
     "io_http_OK_response",
     "debug_io_http_OK_response_arg",
     "reserved_io_http_OK_response_arg".to_nil,
     "This is the response payload",
     "dont_keep_alive".to_nil,
   ]
   thread.join
   true
  end


  # test for tcp_server_plain (call #io_transform with
  # a function that processes an http request and returns
  # an http_response, by default #http_OK_response)
  def test__tcp_server_plain__with_http_OK_response args = ARGV
   http_processing_method,
     http_processing_method_args,
     http_server_port,
     http_ip_addr,
     reserved = args
   http_processing_method = http_processing_method.nne :http_OK_response
   http_processing_method_args = http_processing_method_args.nne []
   http_server_port = http_server_port.nne  8003
   http_ip_addr = http_ip_addr.nne "0"
   thread = tcp_server_plain [
     http_server_port,
     http_ip_addr,
     "reserved".to_nil,
     "debug",
     "io_transform",
     "debug_io_transform",
     "default happy_with_request".to_nil,
     http_processing_method,
     http_processing_method_args
   ]
   thread.join
   true
  end


  # test for tcp_ssl_server (call #io_transform with
  # a function that processes an http request and returns
  # an http_response, by default #http_OK_response)
  # just like #test__tcp_server_plain__with_http_OK_response
  # but calling directly #tcp_ssl_server
  def test__tcp_ssl_server__non_ssl args = ARGV
   http_processing_method,
     http_processing_method_args,
     http_server_port,
     http_ip_addr,
     reserved = args
   http_processing_method = http_processing_method.nne :http_OK_response
   http_processing_method_args = http_processing_method_args.nne []
   http_server_port = http_server_port.nne  8003
   http_ip_addr = http_ip_addr.nne "0"
   thread =  tcp_ssl_server [
     http_server_port,
     http_ip_addr,
     "debug",
     "admit non ssl server",
     "io_transform",
     [
       "debug_io_transform",
       "default happy_with_request".to_nil,
       http_processing_method,
       http_processing_method_args
     ],
   ]
   thread.join
   true
  end


  # generates a hash string based on current time
  # @return [String] +Time.now.hash.abs.to_s+
  def time_now_hash *args
    Time.now.hash.abs.to_s
  end


  # returns a sample self signed certificate-private key pair
  # that once was created with the command (no password, no
  # expire date):
  # + openssl req -x509 -nodes -newkey rsa:1024 -keyout pkey.pem -out cert.crt+
  # @param [splat] +args+::, an splat whose elements are expected to be:
  # +reserved+:: [splat] reserved for future use
  # @return [Array] where the first element is a certificate (suitable to be the contents of +cert_pem_file+  in #ssl_make_server) and the second a private key (suitable to be the contents of +priv_pemfile+ in #ssl_make_server)
  def ssl_sample_self_signed_cert *args
    self_signed_certificate = <<-ENDHEREDOC
-----BEGIN CERTIFICATE-----
MIICWDCCAcGgAwIBAgIJAPa0EXsH2MwsMA0GCSqGSIb3DQEBCwUAMEUxCzAJBgNV
BAYTAkFVMRMwEQYDVQQIDApTb21lLVN0YXRlMSEwHwYDVQQKDBhJbnRlcm5ldCBX
aWRnaXRzIFB0eSBMdGQwHhcNMTgwNjI3MDkzMTEyWhcNMTgwNzI3MDkzMTEyWjBF
MQswCQYDVQQGEwJBVTETMBEGA1UECAwKU29tZS1TdGF0ZTEhMB8GA1UECgwYSW50
ZXJuZXQgV2lkZ2l0cyBQdHkgTHRkMIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKB
gQCplOo6dvbM1650qMYLQ8tRycYlHEZH95kUR5E5EEA8yqgimBtx6InpGQi/PejK
tk+IXbDrxinXMXqjZxAhCjd7+frSUFwUTZ669PuRaptlkjV1KojXBW5kRERAgYId
H7z7QRuK/gWHqTt9zl3WpW2spfWjHY+cnkYdZIWqDBOggwIDAQABo1AwTjAdBgNV
HQ4EFgQUAIq0u116/WmTFQ8HC7/XrKl6wB8wHwYDVR0jBBgwFoAUAIq0u116/WmT
FQ8HC7/XrKl6wB8wDAYDVR0TBAUwAwEB/zANBgkqhkiG9w0BAQsFAAOBgQBgA9ID
JcreAgjYLxiaAd7fCfLQ1/RYM8YdP9R4Lzg2cu0dCjXoLZqzAEwUg424rPOvf0Pj
wnZ3DFJkg1CoN2fH3yLXQ75mhfM7PJXeWoWLTS2wIG/+VIVI+nKJU0RPOM87Mdlq
+b6TI5LsGxlJhaxTmzPtkHZLIRdW6iCJTwP+5Q==
-----END CERTIFICATE-----
   ENDHEREDOC
   private_key = <<-ENDHEREDOC
-----BEGIN PRIVATE KEY-----
MIICdQIBADANBgkqhkiG9w0BAQEFAASCAl8wggJbAgEAAoGBAKmU6jp29szXrnSo
xgtDy1HJxiUcRkf3mRRHkTkQQDzKqCKYG3HoiekZCL896Mq2T4hdsOvGKdcxeqNn
ECEKN3v5+tJQXBRNnrr0+5Fqm2WSNXUqiNcFbmRERECBgh0fvPtBG4r+BYepO33O
Xdalbayl9aMdj5yeRh1khaoME6CDAgMBAAECgYB+Z80spU6UJFUbCk8NSIx+u6ui
L/BHZs1Ja4tZgL6RUfKATuduQgrCoPF/NBOZPsoL+OKO7Nh1WqFyubkxF5+A6BlI
BRe/E4K3cChBWyR5ZQyldYUNVV1HBrAhpurW/OX7FInPGo0I5TkR/CJt6xZPgK1n
4lNXFV29gz/LPTJN4QJBANxnUn2xbtBH0xaTX4iIGEH2keLaUftg0b29Ou/MIPn3
+z7Ln9K6eknf/OGXAvBP2cnWkTGXAOBmB95s9XDrORMCQQDE+FcWTlSKFywFaxhp
nVkDOL+k7Vpn/rKvqKB3JQOrPkovPSo/CHsUVe/r2NEsdJt1SKOs0/xzNe7wSXBa
1tjRAkAHVbTsE+yRJ+LBfJQQUh8kitUeDI/v4q/4NYTxmAR87SDCXTprY+NP9BFR
XJovbyjbS7W3RcQ0s5CNeWjNojZbAkA5u3SDJDhhNUOA3xALvMPfTt3VMICkJKIp
HGrUITQ/GAXUbMAaM5knr7yfyzAcMJ10NfNLb+L5veAn686TwY9RAkArqoX6cWrd
GflH+FhUggqgVrr9XaXkpPUxcpNqAQH/3Yl5pt9jV2VE7eD3chijMGzGJrMUsqFG
n8mFEtUKobsK
-----END PRIVATE KEY-----
   ENDHEREDOC
   [self_signed_certificate, private_key]
  end


  # has the same functionality as
  # #ssl_sample_self_signed_cert.
  # this one is left as an example on how
  # safely place a certificate/private key
  # pair inside this code, instead of leaving
  # it in plain or somewhere in your filesystem.
  # @param [splat] +args+::, an splat whose elements are expected to be:
  # +reserved+:: [splat] reserved for future use
  # @return [Array] where the first element is a certificate (suitable to be the contents of +cert_pem_file+  in #ssl_make_server) and the second a private key (suitable to be the contents of +priv_pemfile+ in #ssl_make_server)
  def ssl_sample_self_signed_cert_encrypted *args
    password = "onlyNSAknows"
    # generated with:
    # test__enc_dec_interactive [
    #   ssl_sample_self_signed_cert[0],
    #   password,
    # ]:
     self_signed_certificate = dec_interactive [
      "owdfr76MvIhPb05PLsPiTw==\n",
      "R1QSJSUmfXVB4ET2r5C2MN3MZC75V9Pi7nWl8+lTZ363IJOYK4/DJkKL0Y58\nMo8fp1mvoq0fjhCSdHqld6IMWxFXW3kzXGyuVScfbRbvYV83AAhmq+HTscUE\nYJLsfnUqTzGKN/AB/Kr1x3kIsZsb9oNSQMk3dFHV89AM9Z1d30ZMgtW8mn/c\nTHmxsLaFgKvg8bT9t+ERBr85bmJuphkDBlAc4hP2KS/xTFeKB1QL/lJ/oF9j\ncUmb5uWdmZ0REzLyYu9F1MfHv0lwENi+oJYW50lo7DUTYHnyKxYRo+rlUsDF\n0nyS4wcPQVxvY1vDrC34pFdMtcXLQTzzbAiyJx73fT7WfY40MNNKRZfz/zlG\nl/d4ILNlW43/fVnOwg4yZ1tGT1PovrDs1c8Mxu7zm0QCT7+Dp+nN0zes5K8A\n2aYIsR7Nvm+3OeKrRf2JXHv8J/10NEcPfuYocmitlzrr6yM3+4xMXM94Zt/7\n4+vONht+xOhOxUmJufC4HNOmqszX1480dL96qfhc9zXlvxpbD4DGkgU0AR17\nt1C6XNqI0jQxxDMQa0jn0HsX5C9dmtqunLIz8ZkgfSNJbsOtVYVS11YuXk+k\nbEdVimP6DT1x0KZ+UxpxOFJcuvtM6eBe3aMWRjlIf/xjobJ2GP9OlDq1hPJe\n+zz1lhUxobFZiqSIrVbYz8u6ZuvVSEa8NfQJ+GpE1poExzBAsM5RjSMWK0Yr\nLnasLNQwJkYoDlmZBNOX30pCaZPmLl9xLaJphIeHOcmNL0e209hST4H5s1oZ\np/k+sk/jgqtc6jVBeMVwSEDHLl4F4hiNHqeqW72bim7XlkbVjaZ8Q66hUCK/\nKBlJ9YH4QCm3zN4ZQtoTOwu7G8+GeO46ahShzE9+6uoj8DCN31zcbDA5sKgJ\nc6SkA1KG83cDq2rP9zKAMn8V1O/NMnV/09gqPiowl/60CVuepkpNmVehhBVi\noamQ5r1g2l/PaUr7hmwygLBjnMHYD2eu5M0gMLYtZxCQSiXTxryp8Xd7vBzs\n0oWO2km/RjVedhxIBMGxcL2O17lWvumcr8AQYOuuiciPqNj0p/KxDYUHvIqx\nW3vPHknUzug5gSwfYZF7t5HCAc8dyRyC/b5M7Mvl9OsWdRPpcv25Dr+x/i/r\nrRMyvBLd8cujRh532fuyDZVL8NwPqwkKoBSU/+hkSOfW6WEdwYWp8xHDFmrQ\nD/YTNSSVPhGNSxR4I/niEksgH43zp5MdowcVuVsIxQBI/ExGcloRJ3hVa1I=\n",
      "IxDTD59cryQjCnFpYQTudw==\n",
      "MjAwMDA=\n",
      password,
    ]
    # generated with:
    # test__enc_dec_interactive [
    #   ssl_sample_self_signed_cert[1],
    #   "onlyNSAknows",
    # ]
    private_key = dec_interactive [
      "mxoZrTsIelpVmTAdSMQJaw==\n",
      "ebsMBtAoESJAOrmffbRsNdjv3FUqyTetrKlw6WGCNLre8uChpt38ZRmi1XAr\nab2PxiNyz7OJ8PWwCnd/TjIOhvid3Zt7LbqUpR2ixRmVf/mEFoWrdwdXnOMz\nzQErlSok1dY2cAvGqBihP26yC9N4IGJU5Jrt4wivahnnvWZoC1gvsEZVPC+Q\nxLF69gu8fn4gUgFvzpjuhgcCXk6QyhW916pZxJrtwBRMEQWu9dGEcRqSPqNt\nLfw6cXyGHDNV1320Je2BRjzMrhIfiwkv88oWEjnHcbOzboxhGdvYG8oYNMgQ\nf9qouABXlQyOEnBIFfl2lKoJaizERs1ShsdNCAcyZZPgNdxWNawdcF3AawYh\nqlX+uOlxCsWQLV3AaSDPy9mDthF3IuMLLe/BlY3gkGLCvD4szZIsQhk6047+\n9euOuJxxu8X3r8TZDHQK9esm5O6YeNFIlGko6PXA2OwcdUWO9Umwr7Lu8Mgk\n/yldW0G/6dMZ6qKSSSLTvEnzZChz91GabcntxT2TrOR2b1zHJhfOUUxcHxWe\nkuqZZ6GmGFIPju22cCsstXDZ0Q1J19VnGBsrySR0AHDxS3sLgeihf8SjP1bn\n3B1nRR+1gHyKPthKiuzibJj+j6xcIgYBynyaNIeT0Wfcf7WXyBTZ+Idd7Z+R\nkiy9jnZPqCIEE5aebuVvAUXksPE2OvEgsCIiLSEylXXrHEdcEnfra7wvo0qb\n1G/vRNlOIYJiOsKLOqcg6KZVJ+QHHYPrir33g4N02Q64WEw4/eIzR5o4MV9c\n7tho/VLQBE1T3z8HPlhe8XOXvVIDJ/cDVJhTre6KbKBsA+Ow47Z1uNXAchAO\n2bwl1sN1iH+SNBsEjRiXpjbrk95I/H66+LZoz85kRBcoQIhfXU97qbskBUwX\nK//3HdYluo/xx5QSVNqQUzybQnRdNV7gy6xNIgpot9ZtPB2K00HulWW1dnRQ\nBMCWb5h3eUob826icleZ/bEFfcfY8FjNTh9zhyWra3wJOTGS4zhmnlfhBRFZ\njRUcKGX/zgfIrCKXum+2m7Cku3bez+mKpEMRWIBPweGzjq3DSdtY+qlKOgeV\nBxOOh0QoMw1kzRfqF0D0Nqn785lvcXjH28v1efHf6SgFrOXjFNl0ihXXxhMG\nivsoIGIblspGIddR6wbarq1L8xMBTCAorNo0OrWPYACz4ek2CmQUuLhwiNx/\nWsFmaElfdtNL/WM06D5zehAYnCfg02zVr4bIgrHkFaq+jsI+u7/3GhtAmnAC\nkUT9CQvGNXwki3jIHOJQL1X8vLA2T25lg9I7wU4EXA==\n",
      "IBBcvvM2/h7bW+tBcBbXeQ==\n",
      "MjAwMDA=\n",
      password,
      ]
    [self_signed_certificate, private_key]
  end


  # test for ssl_sample_self_signed_cert_encrypted
  # note: function name out of standard. kept for
  # open-closed commitment.
  # call #test__enc_dec_interactive__ssl_sample_self_signed_cert
  # instead
  def test_enc_dec_interactive__ssl_sample_self_signed_cert args=ARGV
    expectation = {
      :self_signed_certificate => ssl_sample_self_signed_cert[0],
      :private_key => ssl_sample_self_signed_cert[1],
    }
    actual = {
      :self_signed_certificate => ssl_sample_self_signed_cert_encrypted[0],
      :private_key => ssl_sample_self_signed_cert_encrypted[1],
    }
    judgement = actual.keys.map {|test_case|
      [expectation[test_case], actual[test_case] , test_case]
    }.map(&method("expect_equal")).all?
  end


  # #test_enc_dec_interactive__ssl_sample_self_signed_cert
  # function name out of standard.
  # this one should be called instead instead
  def test__enc_dec_interactive__ssl_sample_self_signed_cert *args
    test_enc_dec_interactive__ssl_sample_self_signed_cert *args
  end


  # test for tcp_ssl_server (call #io_transform with
  # a function that processes an http request and returns
  # an http_response, by default #http_OK_response)
  # just like #test__tcp_ssl_server__non_ssl,
  # calling directly #tcp_ssl_server, but making
  # mandatory the server to be ssl one.
  # requires, by default that the certificate and its
  #  private key are found in the current dir, which
  #  can be achieved with:
  #  +openssl req -x509 -nodes -days 365 -newkey rsa:1024 -keyout pkey.pem -out cert.crt+
  # but if the files don't exist, they will be created
  # with a sample self signed certificate.
  def test__tcp_ssl_server__io_transform args = ARGV
   http_processing_method,
     http_processing_method_args,
     http_server_port,
     http_ip_addr,
     priv_pemfile,
     cert_pem_file,
     extra_cert_pem_files,
     ssl_cert_pkey_chain_method,
     reserved = args
   http_processing_method = http_processing_method.nne :http_OK_response
   http_processing_method_args = http_processing_method_args.nne []
   http_server_port = http_server_port.nne  8003
   http_ip_addr = http_ip_addr.nne "0"
   ssl_cert_pkey_chain_method =
     ssl_cert_pkey_chain_method.nne :ssl_sample_self_signed_cert_encrypted
   ssl_cert_pkey_chain = send ssl_cert_pkey_chain_method
   priv_pemfile  =   priv_pemfile.nne ssl_cert_pkey_chain[1]
   cert_pem_file =  cert_pem_file.nne ssl_cert_pkey_chain[0]
   extra_cert_pem_files =  extra_cert_pem_files.nne ssl_cert_pkey_chain[2]
   thread =  tcp_ssl_server [
     http_server_port,
     http_ip_addr,
     "debug",
     "admit non ssl server".negate_me,
     "io_transform",
     [
       "debug_io_transform",
       "default happy_with_request".to_nil,
       http_processing_method,
       http_processing_method_args
     ],
     priv_pemfile,
     cert_pem_file,
     extra_cert_pem_files,
     "yes, output exceptions",
   ]
   thread.join
   true
  end


  # tests #file_read_or_write and #file_read
  # specially its +return_on_rescue+ parameter.
  # attention that files given by parameter
  # will be mercilessly overwritten.
  # writes the contents returned by 
  # #ssl_sample_self_signed_cert
  # to 2 files. then reads then.
  # after it tries to give the contents of
  # those files instead of the filenames.
  # the idea behind is that, no matter if
  # contents or filename were given, it
  # should always return the contents of
  # the file.
  def test__file_read__return_on_rescue args=ARGV
    priv_pemfile, cert_pem_file = args
    priv_pemfile  =  priv_pemfile.nne "/tmp/pkey.pem"
    cert_pem_file = cert_pem_file.nne "/tmp/cert.crt"
    runef { 
     File.delete priv_pemfile
     File.delete cert_pem_file
    }
    cert_contents, pkey_contents = ssl_sample_self_signed_cert
    # asserting that file_read_or_write is correct
    read_or_write_cert_contents = file_read_or_write cert_pem_file, cert_contents
    read_or_write_pkey_contents = file_read_or_write priv_pemfile,  pkey_contents
    file_dot_read_cert_contents = File.read cert_pem_file
    file_dot_read_pkey_contents = File.read priv_pemfile
    # files exist case (will return the contents of 1st parameter filename):
    existing_cert_contents = file_read [cert_pem_file, nil, nil, cert_pem_file]
    existing_pkey_contents = file_read [priv_pemfile,  nil, nil, priv_pemfile ]
    # files don't exist case (will return the 4th parameter):
    rescue_cert_contents = file_read [cert_contents, nil, nil, cert_contents]
    rescue_pkey_contents = file_read [pkey_contents, nil, nil, pkey_contents]
    judgement =
      [
        [read_or_write_cert_contents, cert_contents, "read_or_write_cert_contents"],
        [read_or_write_pkey_contents, pkey_contents, "read_or_write_pkey_contents"],
        [file_dot_read_cert_contents, cert_contents, "file_dot_read_cert_contents"],
        [file_dot_read_pkey_contents, pkey_contents, "file_dot_read_pkey_contents"],
        [existing_cert_contents, cert_contents, "existing_cert_contents"],
        [existing_pkey_contents, pkey_contents, "existing_pkey_contents"],
        [rescue_cert_contents,   cert_contents, "rescue_cert_contents"],
        [rescue_pkey_contents,   pkey_contents, "rescue_pkey_contents"],
      ].map(&method("expect_equal")).all?
  end


  # test for tcp_ssl_server (call #io_transform with
  # a function that processes an http request and returns
  # an http_response, by default #http_OK_response)
  # just like #test__tcp_ssl_server__non_ssl,
  # calling directly #tcp_ssl_server, but making
  # mandatory the server to be ssl one.
  # requires, by default that the certificate and its
  #  private key are found in the current dir, which
  #  can be achieved with:
  #  +openssl req -x509 -nodes -days 365 -newkey rsa:1024 -keyout pkey.pem -out cert.crt+
  # but if the files don't exist, they will be created
  # with a sample self signed certificate.
  def test__tcp_ssl_server__ssl_self_signed args = ARGV
   http_processing_method,
     http_processing_method_args,
     http_server_port,
     http_ip_addr,
     priv_pemfile,
     cert_pem_file,
     extra_cert_pem_files,
     reserved = args
   ssl_cert_pkey_chain_method = :ssl_sample_self_signed_cert_encrypted
   test__tcp_ssl_server__io_transform [
   http_processing_method,
     http_processing_method_args,
     http_server_port,
     http_ip_addr,
     priv_pemfile,
     cert_pem_file,
     extra_cert_pem_files,
     ssl_cert_pkey_chain_method,
   ]
   true
  end


=begin
  # short_desc = "this functions creates an https (or http server) and a second http server, which always redirect to the first server."

  @memory[:documentation].push = {
    :function   => :experiment__web_http_https_server,
    :short_desc => short_desc,
    :description => "",
    :params     => [
      {
        :name             => :args,
        :description      => "list of parameters",
        :duck_type        => Array,
        :default_behavior => [],
        :params           => [
          {
            :name             => :http_processing_method,
            :duck_type        => [:_a, String, :method_name],
            :default_behavior => :http_OK_response
            :description      => "method name of the method that returns an http request string (used by the first server)",
          },
          {
            :name             => :http_processing_method_args,
            :duck_type        => Array,
            :default_behavior => [],
            :description      => "arguments for the method that returns an http request string (used by the first server). http_processing_method is fully controlled throught these arguments -- internally, io_forward will only prepend an argument having the request this list.
            ",
          },
          {
            :name             => :http_server_port,
            :duck_type        => FixNum,
            :default_behavior => 8003,
            :description      => " server port (used by the first server)",
          },
          {
            :name             => :http_ip_addr,
            :duck_type        => String,
            :default_behavior => "0",
            :description      => "ip address (used by the first server)",
          },
          {
            :name             => :priv_pemfile,
            :duck_type        => String,
            :default_behavior => ssl_cert_pkey_chain_method[1],
            :description      => "argument to be given to __OpenSSL::SSL::SSLContext.key__ method, after calling __OpenSSL::PKey::RSA.new__ with it. It's the private key file. letsencrypt example: __'/etc/letsencrypt/live/#{domain}/privkey.pem'__ (now it's accepted to pass the file contents instead, both must work).",
          },
          {
            :name             => :cert_pem_file,
            :duck_type        => String,
            :default_behavior => ssl_cert_pkey_chain_method[0],
            :description      => "argument to be given to __OpenSSL::SSL::SSLContext.cert__ method, after calling __OpenSSL::X509::Certificate__.  It's the 'Context certificate' accordingly to its ruby-doc page. letsencrypt example: __'/etc/letsencrypt/live/#{domain}/fullchain.pem'__ (now it's accepted to pass the file contents instead, both must work).",
          },
          {
            :name             => :extra_cert_pem_files,
            :duck_type        => Object,
            :duck_type        => [:_a, Array, :strings],
            :default_behavior => ssl_cert_pkey_chain_method[2],
            :description      => "Each string will be mapped with __OpenSSL::SSL::SSLContext.new__, and the resulting array is given to __OpenSSL::SSL::SSLContext.extra_chain_cert__. 'An Array of extra X509 certificates to be added to the certificate chain' accordingly to its ruby-doc. letsencrypt example: __['/etc/letsencrypt/live/#{domain}/chain.pem']__ (now it's accepted to pass the file contents instead, both must work)."
          },
          {
            :name             => :ssl_cert_pkey_chain_method,
            :duck_type        => [:_a, String, :method_name],
            :default_behavior => :ssl_sample_self_signed_cert_encrypted,
            :description      => "method name of the method that returns the certificates (used by the first server)",
          },
          {
            :name             => :debug,
            :duck_type        => Object,
            :default_behavior => :nil,
            :description      => "prints debug information to the __IO__ specified by __@memory[:stderr]__ (STDERR by default)",
          },
          {
            :name             => :happy_with_request,
            :duck_type        => String,
            :default_behavior => nil,
            :description      => "A socket never ends returning data. This variable sets an end to a socket -- after such string is found the socket may be closed. As of this writing, underlying functions will use \r\n if nil is found; this function trusts :io_method to do its best.",
          },
          {
            :name             => :io_method,
            :duck_type        => [:_a, String, :method_name],
            :default_behavior => :io_transform,
            :description      => "method name of the method that reads a socket and forwards the call to a processing method  (used both by the first and the redirecting server)",
          },
          {
            :name             => :io_method_debug,
            :duck_type        => Object,
            :default_behavior => :nil,
            :description      => "debug option to the :io_method",
          },
          {
            :name             => :admit_non_ssl,
            :duck_type        => Object,
            :default_behavior => :nil,
            :description      => "if anything fails with the creation of an ssl server, will try to create a plain one (used by the first server)",
          },
          {
            :name             => :plain_http_processing_method,
            :duck_type        => [:_a, String, :method_name],
            :default_behavior => :http_OK_response
            :description      => "method name of the method that returns an http request string (used by the redirecting server)",
          },
          {
            :name             => :plain_http_processing_method_args,
            :duck_type        => Array,
            :default_behavior => [],
            :description      => "arguments for the method that returns an http request string (used by the redirecting server)",
          },
          {
            :name             => :plain_http_server_port,
            :duck_type        => FixNum,
            :default_behavior => 8003,
            :description      => " server port (used by the redirecting server)",
          },
          {
            :name             => :plain_http_ip_addr,
            :duck_type        => String,
            :default_behavior => "0",
            :description      => "ip address (used by the redirect server)",
          },
          {
            :name             => :output_exceptions,
            :duck_type        => :boolean,
            :default_behavior => :nil,
            :description      => "exceptions are normally properly handled by inner functions, but setting this to true can be helpful to debug some cases",
          },
          {
            :name             => :io_forward_debug,
            :duck_type        => :boolean,
            :default_behavior => :nil,
            :description      => "will be forwarded as debug argument to io_forward, somehow",
          },
          {
            :name             => :transform_call_debug,
            :duck_type        => :boolean,
            :default_behavior => :nil,
            :description      => "will be forwarded as debug argument to transform_call, somehow",
          },
          {
            :name             => :to_method_debug,
            :duck_type        => :boolean,
            :default_behavior => :nil,
            :description      => "will be forwarded as debug argument to to_method, somehow",
          },
          {
            :name             => :to_object_method_debug,
            :duck_type        => :boolean,
            :default_behavior => :nil,
            :description      => "will be forwarded as debug argument to to_method_method, somehow",
          },
          {
            :name             => :debug_accept,
            :duck_type        => :boolean,
            :default_behavior => :nil,
            :description      => "will be forwarded as __debug_client__ argument to tcp_ssl_server, somehow",
          },
          {
            :name             => :reserved,
            :duck_type        => Object,
            :default_behavior => :nil,
            :description      => "for future use",
          },
        ],
      },
    ],
  }
=end

  def experiment__web_http_https_server args = []
    stderr = @memory[:stderr]
    http_processing_method,
      http_processing_method_args,
      http_server_port,
      http_ip_addr,
      priv_pemfile,
      cert_pem_file,
      extra_cert_pem_files,
      ssl_cert_pkey_chain_method,
      debug,
      happy_with_request,
      io_method,
      io_method_debug,
      admit_non_ssl,
      plain_http_processing_method,
      plain_http_processing_method_args,
      plain_http_server_port,
      plain_http_ip_addr,
      output_exceptions,
      io_forward_debug,
      transform_call_debug,
      to_method_debug,
      to_object_method_debug,
      debug_accept,
      reserved = args

    debug = debug.nne
    output_exceptions = output_exceptions.nne
    debug.nne && (stderr.puts "{#{__method__} starting")
    debug && (stderr.puts "args=#{args.inspect}")
    # http_OK_response is completely controlled by here -- io_forward
    # will only prepend an argument having the request to it.
    http_processing_method = http_processing_method.nne :http_OK_response
    http_processing_method_args = http_processing_method_args.nne []
    http_server_port = http_server_port.nne  8003
    redirect_location_host = http_ip_addr.nne "localhost"
    http_ip_addr = http_ip_addr.nne "0"
    ssl_cert_pkey_chain_method =
      ssl_cert_pkey_chain_method.nne :ssl_sample_self_signed_cert_encrypted
    ssl_cert_pkey_chain = send ssl_cert_pkey_chain_method
    priv_pemfile  =   priv_pemfile.nne ssl_cert_pkey_chain[1]
    cert_pem_file =  cert_pem_file.nne ssl_cert_pkey_chain[0]
    extra_cert_pemiles =  extra_cert_pem_files.nne ssl_cert_pkey_chain[2]
    io_method =  io_method.nne "io_transform"
    io_method_debug = io_method_debug.nne
    happy_with_request = happy_with_request.nne
    admit_non_ssl = admit_non_ssl.nne
    plain_http_processing_method =  plain_http_processing_method.nne :test__http_response__redirect
    plain_http_processing_method_args =  plain_http_processing_method_args.nne [
      "https://#{redirect_location_host}:#{http_server_port}/#redirect"
    ]
    plain_http_server_port =  plain_http_server_port.nne 8004
    plain_http_ip_addr = plain_http_ip_addr.nne "0"

    tcp_ssl_server_args = [
      http_server_port,
      http_ip_addr,
      debug,
      admit_non_ssl,
      io_method,
      [
        io_method_debug,
        happy_with_request,
        http_processing_method,
        http_processing_method_args,
        io_forward_debug,
        transform_call_debug,
        to_method_debug,
        to_object_method_debug,
        output_exceptions,
      ],
      priv_pemfile,
      cert_pem_file,
      extra_cert_pem_files,
      output_exceptions,
      debug_accept,
    ]
    tcp_ssl_server_thread   =  send :tcp_ssl_server, tcp_ssl_server_args
    tcp_plain_server_args = [
      plain_http_server_port,
      plain_http_ip_addr,
      debug,
      :admit_non_ssl,
      io_method,
      [
        io_method_debug,
        happy_with_request,
        plain_http_processing_method,
        plain_http_processing_method_args,
        io_forward_debug,
        transform_call_debug,
        to_method_debug,
        to_object_method_debug,
      ],
      :priv_pemfile.to_nil,
      :cert_pem_file.to_nil,
      :extra_cert_pem_files.to_nil,
      output_exceptions,
    ]
    tcp_plain_server_thread =  send :tcp_ssl_server, tcp_plain_server_args

    rv = [
      tcp_ssl_server_thread,
      tcp_ssl_server_args,
      :tcp_ssl_server_reserved.to_nil,
      tcp_plain_server_thread,
      tcp_plain_server_args,
      :tcp_ssl_server_reserved.to_nil,
    ]
    debug && (stderr.puts "will return #{rv}")
    debug && (stderr.puts "#{__method__} returning}")
    rv
  end


  # test for tcp_ssl_server (calling an +io_method+,
  # by default #io_transform, with
  # a function that processes an http request and returns
  # an http_response, by default #http_OK_response)
  # just like #test__tcp_ssl_server__non_ssl,
  # calling directly #tcp_ssl_server, but making
  # mandatory the server to be ssl one.
  # requires, by default that the certificate and its
  #  private key are found in the current dir, which
  #  can be achieved with:
  #  +openssl req -x509 -nodes -days 365 -newkey rsa:1024 -keyout pkey.pem -out cert.crt+
  # but if the files don't exist, they will be created
  # with a sample self signed certificate.
  def test__tcp_ssl_server__io_method args = ARGV
    http_processing_method,
      http_processing_method_args,
      http_server_port,
      http_ip_addr,
      priv_pemfile,
      cert_pem_file,
      extra_cert_pem_files,
      ssl_cert_pkey_chain_method,
      debug,
      happy_with_request,
      io_method,
      io_method_debug,
      admit_non_ssl,
      reserved = args
    http_processing_method = http_processing_method.nne :http_OK_response
    http_processing_method_args = http_processing_method_args.nne []
    http_server_port = http_server_port.nne  8003
    http_ip_addr = http_ip_addr.nne "0"
    ssl_cert_pkey_chain_method =
      ssl_cert_pkey_chain_method.nne :ssl_sample_self_signed_cert_encrypted
    ssl_cert_pkey_chain = send ssl_cert_pkey_chain_method
    priv_pemfile  =   priv_pemfile.nne ssl_cert_pkey_chain[1]
    cert_pem_file =  cert_pem_file.nne ssl_cert_pkey_chain[0]
    extra_cert_pemiles =  extra_cert_pem_files.nne ssl_cert_pkey_chain[2]
    debug =  debug.nne "yes, debug"
    io_method =  io_method.nne "io_transform"
    io_method_debug =  io_method_debug.nne debug
    happy_with_request = happy_with_request.nne
    admit_non_ssl = admit_non_ssl.nne
    tcp_ssl_server_args = [
      http_server_port,
      http_ip_addr,
      debug,
      admit_non_ssl,
      io_method,
      [
        io_method_debug,
        happy_with_request,
        http_processing_method,
        http_processing_method_args
      ],
      priv_pemfile,
      cert_pem_file,
      extra_cert_pem_files,
      "yes, output exceptions",
    ]
    thread =  tcp_ssl_server tcp_ssl_server_args
    [ thread ] + tcp_ssl_server_args
  end


=begin
 generalization of #test__file_read__uri_root
=end
  def test__file_read__uri args = []
    stderr = @memory[:stderr]
    domain,
      http_server_port,
      admit_non_ssl,
      debug,
      path,
      reserved = args
    debug = debug.nne
    debug && (stderr.puts "{#{__method__} starting")
    debug && (stderr.puts "args=#{args.inspect}")

    domain = domain.nne "localhost"
    path = path.nne ""
    http_server_port = http_server_port.nne 8003
    admit_non_ssl = admit_non_ssl.nne true
    http_file_read_attempt = (
      debug && (stderr.puts "file_read \"https://#{domain}:#{http_server_port}/#{path}\"")
      file_read ["https://#{domain}:#{http_server_port}/#{path}", nil, nil, nil, nil, :skip_open_uri, nil, nil, nil, nil, nil, nil, :http_request_response__curl]
    )
    debug && (stderr.puts "#{admit_non_ssl.inspect} && file_read \"http://#{domain}:#{http_server_port}/#{path}\"")
    response = http_file_read_attempt ||
      admit_non_ssl && (
        file_read ["http://#{domain}:#{http_server_port}/#{path}", nil, nil, nil, nil, :skip_open_uri, nil, nil, nil, nil, nil, nil, :http_request_response__curl]
      )
    rv = [response, http_file_read_attempt]
    debug && (stderr.puts  "#{__method__} will return [response, http_file_read_attempt]=#{rv.inspect}")
    debug && (stderr.puts "#{__method__} returning}")
    rv
  end


  # tests file_read against a uri.
  # created to test a client for servers
  # created with
  # #test__tcp_ssl_server__io_method
  def test__file_read__uri_root args = ARGV
    test__file_read__uri args
  end


  # tests test__tcp_ssl_server__io_method and opens
  # another thread for the client
  def test__tcp_ssl_server__get_root args = ARGV
    stderr = @memory[:stderr]
    tcp_ssl_server_method,
      http_processing_method,
      http_processing_method_args,
      http_server_port,
      http_ip_addr,
      priv_pemfile,
      cert_pem_file,
      extra_cert_pem_files,
      ssl_cert_pkey_chain_method,
      debug_tcp_ssl_server_method,
      happy_with_request,
      io_method,
      io_method_debug,
      domain,
      admit_non_ssl,
      no_debug_client,
      reserved = args
    tcp_ssl_server_method = tcp_ssl_server_method.nne :test__tcp_ssl_server__io_method
    domain = domain.nne "localhost"
    http_server_port = http_server_port.nne 8003
    no_debug_client = no_debug_client.nne
    server_thread = send tcp_ssl_server_method,
      [
        http_processing_method,
        http_processing_method_args,
        http_server_port,
        http_ip_addr,
        priv_pemfile,
        cert_pem_file,
        extra_cert_pem_files,
        ssl_cert_pkey_chain_method,
        debug_tcp_ssl_server_method,
        happy_with_request,
        io_method,
        io_method_debug,
        admit_non_ssl,
      ]

    thread_2 = Thread.new {
      loop {
        response = test__file_read__uri_root [
          domain,
          http_server_port,
          admit_non_ssl,
          no_debug_client.negate_me,
        ]
        sleep 2
      }
    }
    server_thread.first.join

    true
  end


  # test for Object::nne
  def test__object_nne args = ARGV
    string_neutral = ""
    string_non_neutral = "xxx"
    fixnum_neutral = 0
    fixnum_non_neutral = 1
    array_neutral = []
    array_non_neutral = [1, 2]
    hash_neutral = {}
    hash_non_neutral = { 1 => 2 }
    judgement =
      [
        [string_neutral.nne, nil, "string_neutral.nne"],
        [string_non_neutral.nne, string_non_neutral, "string_non_neutral.nne"],
        [fixnum_neutral.nne, nil, "fixnum_neutral.nne"],
        [fixnum_non_neutral.nne, fixnum_non_neutral, "fixnum_non_neutral.nne"],
        [array_neutral.nne, nil, "array_neutral.nne"],
        [array_non_neutral.nne, array_non_neutral, "array_non_neutral.nne"],
        [hash_neutral.nne, nil, "hash_neutral.nne"],
        [hash_non_neutral.nne, hash_non_neutral, "hash_non_neutral.nne"],
      ].map(&method("expect_equal")).all?
  end


  # runs a command in a shell (requires 'open3')
  # returns stdout and stderr output mixed
  # @param [Array] +args+, an +Array+ whose elements are expected to be:
  # +command+:: [String] command to be executed
  # @return [Array] returns an  #Array whose elements are:
  # +stdoutanderr+:: [Array of Strings] mix of stdout and stderr output
  # +stdin+:: [IO]
  # +wait_thr+:: [Thread]
  # +success?+:: [TrueClass, FalseClass]
  def shell_popen2e_command args=[]
    command,
      reserved = args
    require "open3"
      stdin, stdoutanderr, wait_thr = Open3.popen2e(":;" + command)
      [ stdoutanderr.entries, stdin, wait_thr, wait_thr.value.success? ]
    end


  # runs a command in a shell (requires 'open3')
  # returns stdout and stderr output separated
  # @param [Array] +args+, an +Array+ whose elements are expected to be:
  # +command+:: [String] command to be executed
  # @return [Array] returns an  #Array whose elements are:
  # +stdout+:: [Array of Strings] stdout output
  # +stderr+:: [Array of Strings] stderr output
  # +stdin+:: [IO]
  # +wait_thr+:: [Thread]
  # +success?+:: [TrueClass, FalseClass]
  def shell_popen3_command args=[]
    command,
      reserved = args
    require "open3"
      stdin, stdout, stderr, wait_thr = Open3.popen3(":;" + command)
      [ stdout.entries, stderr.entries, stdin, wait_thr, wait_thr.value.success? ]
    end


  # test for functions that adds syntatic sugar to
  # exceptions.
  def test__rune_functions args = ARGV
    do_rescue = "rescue"
    do_output = "output"
    no_rescue = "no rescue"
    no_output = "no output"
    actual = {}
    expectation = {}

    #working case
    expected_return = [1, 2, 3]
    test_case = :rescue_and_output_work
    actual[test_case] = runea([do_rescue, do_output], expected_return ) {|args| puts "test_case=#{test_case}";  p args  }
    expectation[test_case] = expected_return
    test_case = :rescue_but_no_output_work
    actual[test_case] = runea([do_rescue, no_output.to_nil], expected_return ) {|args| puts "test_case=#{test_case}";  p args  }
    expectation[test_case] = expected_return
    test_case = :effectless_output_but_no_rescue_work
    actual[test_case] = runea([no_rescue.to_nil, do_output], expected_return ) {|args| puts "test_case=#{test_case}";  p args  }
    expectation[test_case] = expected_return
    test_case = :no_output_and_no_rescue_work
    actual[test_case] = runea([no_rescue.to_nil, no_output.to_nil], expected_return ) {|args| puts "test_case=#{test_case}";  p args  }
    expectation[test_case] = expected_return

    # failure cases
    expected_return = "no_such_method"
    test_case = :rescue_and_output_fail
    actual[test_case] = runea([do_rescue, do_output], [1, 2, 3] ) {|args| puts "test_case=#{test_case}";  p args;  args.to_nil.no_such_method  }[1].name.to_s
    expectation[test_case] = expected_return
    test_case = :rescue_but_no_output_fail
    actual[test_case] = runea([do_rescue, no_output.to_nil], [1, 2, 3] ) {|args| puts "test_case=#{test_case}"; p args ; args.to_nil.no_such_method  }.nil? && expected_return
    expectation[test_case] = expected_return
    test_case = :effectless_output_but_no_rescue_fail
    actual[test_case] = begin
      runea([no_rescue.to_nil, do_output], [1, 2, 3] ) {|args| puts "test_case=#{test_case}"; p args ; args.to_nil.no_such_method  }
    rescue NoMethodError => noMethodError
      noMethodError.name.to_s
    end
    expectation[test_case] = expected_return
    test_case = :no_output_and_no_rescue_fail
    actual[test_case] = begin
      runea([no_rescue.to_nil, no_output.to_nil], [1, 2, 3] ) {|args| puts "test_case=#{test_case}"; p args ; args.to_nil.no_such_method  }
    rescue NoMethodError => noMethodError
      noMethodError.name.to_s
    end
    expectation[test_case] = expected_return

    judgement = actual.keys.map {|test_case|
      [expectation[test_case], actual[test_case] , test_case]
    }.map(&method("expect_equal")).all?
  end


  # tests if  +operand_1+ is only
  # composed by a repetition of +operand_2+
  # @param [Array] +args+, an +Array+ whose elements are expected to be:
  # +operand_1+:: [String]
  # +operand_2+:: [String] 
  # +min_repetitions+:: [FixNum] minimum of times +operand_2+ is required to appear in +operand_1+ (default: +0+). Note that in +args=["", "X", 0]+, +operand_1=""+ will be returned, because "" is a composition of +0+ times "X". 
  # @return [String, FalseClass] returns +operand_1+ if it is only
  # composed by a repetition of +operand_2+, otherwise +false+
  def string_repetition  args=[]
    stderr = @memory[:stderr]
    operand_1,
    operand_2,
    min_repetitions,
      reserved = args
    debug = debug.nne
    debug.nne && (stderr.puts "#{__method__} starting")
    debug && (stderr.puts "args=#{args.inspect}")
    matches  = (operand_1.scan operand_2) rescue []
    amout_of_matches = matches.size
    min_repetitions = min_repetitions.nne 0
    is_string_repetition = (
      debug && (stderr.puts '(#{amout_of_matches} >= #{min_repetitions}) && (#{operand_2.size} * #{amout_of_matches} == #{operand_1.size})')
      debug && (stderr.puts "(#{amout_of_matches} >= #{min_repetitions}) && (#{operand_2.size} * #{amout_of_matches} == #{operand_1.size})")
      # if operand_2 was matched N times, and the sum
      # of those N matched sizes is the same
      (amout_of_matches >= min_repetitions) && (operand_2.size * amout_of_matches == operand_1.size) || false
    ) && operand_1
    debug && (stderr.puts "will return #{is_string_repetition}")
    debug && (stderr.puts "#{__method__} returning")
    is_string_repetition
  end


  # operates and/or returns a structure similar to an pushdown automaton.
  # @param [Array] +args+, an +Array+ whose elements are expected to be:
  # +pd+:: [Array] an +Array+ whose elements are :
  # +pd.operand+:: [Array] current state
  # +pd.stack+:: [Array] state stack
  # +operation_plan+:: [Array, Object] +false+ object is interpreted as no operation (only creates a pd). Otherwise, it is an +Array+ whose elements are :
  #     reserved_token, reservation_type, token = operation_plan.to_a
  # +operation_plan.reserved_token+:: [Object] operates stack if +true+, otherwise, operate +state+
  # +operation_plan.reservation_type+:: [Object] pushes stack if +true+ into state, otherwise, pops.
  # +operation_plan.token+:: [Object] state operand (element that will be pushed into the current state, when operating +state+)
  # +operation_plan.bulk+:: [Object] if calling the object +nne+ method returns a +true+ value, will operate as +operation_plan.token+ is a container of tokens instead. If the object is an +Array+, it will prepend the first element and append to +pd.operand+ after the bulk insertion is done.
  # +debug+:: [Object] +debug.nne+ will be used to determine whether to output or not debug information.
  # +pd+:: [Array] 
  # @return [Array] returns the operated (or a new, when no operation) +pd+
  def pushdown_operate args=[]
    stderr = @memory[:stderr]
    pd,
      operation_plan,
      debug,
      reserved = args

    pd = pd.nne []
    array_operand,
      array_operands_stack,
      reserved = pd

    operation_plan = operation_plan.nne

    debug = debug.nne
    debug.nne && (stderr.puts "{#{__method__} starting")
    debug && (stderr.puts "args=#{args.inspect}")
    debug && (stderr.puts "operation_plan=#{operation_plan.inspect}")

    array_operands_stack = array_operands_stack.nne []
    array_operand = array_operand.nne []

    reserved_token,
      reservation_type,
      token,
      reserved_token_symbol,
      bulk = operation_plan.to_a
    bulk = bulk.nne
    debug && (stderr.puts "reserved_token=#{reserved_token.inspect}")
    debug && (stderr.puts "reservation_type=#{reservation_type.inspect}")
    debug && (stderr.puts "token=#{token.inspect}")
    debug && (stderr.puts "bulk=#{bulk.inspect}")
    operation_plan && reserved_token && (
      reservation_type && (
        debug && (stderr.puts "case is_up_token: #{token.inspect}")
        array_operands_stack.push array_operand
        array_operand = Array.new
        true
      ) || (
        debug && (stderr.puts "case is_down_token: #{token.inspect}")
        # this approach:
        #  array_operand = array_operands_stack.pop.push array_operand
        # won't accept pops when the stack is empty.
        # this approach:
        #  array_operand = array_operands_stack.pop.to_a.push array_operand
        # will work as a "push" was added to the beginning
        # another approach (not coded here) would be stop accept
        # pushes to *array_operand* (at least when a new
        # stack push/token up is done). To keep simplicity,
        # the reset approach is done (past is forgotten),
        # but the other options are left for the case of a
        # future option implementation
        array_operand = (array_operands_stack.pop.push array_operand) rescue []
        true
      )
    ) || operation_plan && (
        debug && (stderr.puts "case is_no_token: #{token.inspect}")

        bulk_token_duck_type_method = :map
        bulk_token_push = bulk && token.respond_to?(bulk_token_duck_type_method)
        debug && (stderr.puts "[bulk, bulk_token_duck_type_method, bulk_token_push]=#{[bulk, bulk_token_duck_type_method, bulk_token_push].inspect}")
        bulk_token_push.negate_me && (array_operand.push token)
        prepend, append, reserved = bulk.to_a
        bulk_token_push && (token = [prepend, token, append].flatten(1))
        bulk_token_push && (token.map &array_operand.method(:push))
        true
    )
    pd = [array_operand, array_operands_stack]
    debug && (stderr.puts "will return #{pd.inspect}")
    debug && (stderr.puts "#{__method__} returning}")
    pd
  end


  # will take a flatten array and makes it deeper, starting a new array
  # everytime it finds the string +"["+. +"]"+ stops the array (and
  # return to the upper one). To reserve the possibility of
  # representing "[" or "]", everytime a string contains only those
  # chars, repeteaded any number of times, starting from 2, one of
  # them will be removed. So +"[["+ will be left as +"["+ and
  # +"]]]"+ will be left as +"]]"+.
  # if the provided array is not flatten, it has an undefined
  # behaviour (it will either a - transverse the sub-arrays
  # or b - don't transverse it, leaving it untouched. while
  # the a is the planned effect, initially only a may will
  # be implemented) (currently this behaviour is easily configurable
  # by the value +deep+, hardcoded in the function. soon, new
  # functions will come to clarify and specify the proper behaviours)
  # @param [Array] +args+, an +Array+ whose elements are expected to be:
  # +flatten_array+:: [Array] the array to be operated.
  # +debug+:: [Object] if evals to false (or empty string), won't print debug information
  # +shallow+:: [Object] if evals to false (or empty string), will traverse recursively +flatten_array+ and apply the rules, in the case it is not flatten.
  # +reserved_tokens+:: [Array of Arrays]
  # +inverse+:: [Object] if calling the object +nne+ method returns a +false+ value, will operate this function inversely: will take a unflatten array and flatten it, applying the inverse escaping rules (note that any object responding to +:map+ will be considered an array in +flatten_array+).
  # +debug_pushdown+:: [Object] if evals to false (or empty string), won't print debug information about the call #pushdown_operated
# +inversion_envelope+::  [Array, nil], if +nil+, the first colum of +reserved_tokens+ will be used. if an +Array+ whose elements are expected to be:
  # +inversion_envelope.prepend+::  [Object] when an inversion occurrs, this element will be prepended when a new object responding to +:map+, like +Array+ is found.
  # +inversion_envelope.append+::  [Object] when an inversion occurrs, this element will be prepended when a new object responding to +:map+, like +Array+ is found.
  # @return [Array] returns the modified, deep, #Array
  def array_unflatten_base args=[]
    stderr = @memory[:stderr]
    flatten_array,
      shallow,
      debug,
      reserved_tokens,
      inverse,
      debug_pushdown,
      inversion_envelope,
      reserved = args
    reserved_tokens = reserved_tokens.nne [
      [ "[", :up],
      [ "]", :up.negate_me],
    ]
    inversion_envelope = inversion_envelope.nne(
      reserved_tokens.transpose.first
    )
    inverse = inverse.nne
    shallow = shallow.nne
    debug_pushdown = debug_pushdown.nne
    debug = debug.nne
    debug.nne && (stderr.puts "{#{__method__} starting")
    debug && (stderr.puts "args=#{args.inspect}")
    pd = pushdown_operate
    flatten_array.each_with_index {|e, index|
      debug && (stderr.puts "-------------------")
      debug && (stderr.puts "[e, index]=#{[e, index].inspect}")
      shallow.negate_me && (
        debug && (stderr.puts "e.hash=#{e.hash}")
        args_recursion = args.clone
        args_recursion[0] = e
        e = (send __method__, args_recursion) rescue ( debug && (stderr.puts "#{__method__} finished with exception }" ) ; e)
        debug && (stderr.puts "e.hash=#{e.hash}")
      )
      operations = reserved_tokens.map { |reserved_token|
        debug && (stderr.puts "reserved_token=#{reserved_token.inspect}")
        debug && (stderr.puts "array_operands_stack=#{pd[1].inspect}")
        debug && (stderr.puts "array_operand=#{pd.first.inspect}")
        rtoken, is_up_token = reserved_token

        repetition_test = string_repetition [e, rtoken, 1]
        (
	  # case A: e is exactly the reserved token.
	  # start or finish an array
	  # note: if rtoken is false, it will succeed this
	  # test.
          (repetition_test == rtoken) && (
	    inverse  && (e = (e.sub! "", rtoken) rescue e)
            is_up_token && (
              debug && (stderr.puts "case is_up_token")
	      [:reserved_token.negate_me(inverse), :up, e, rtoken, false ]
	    ) || (
              debug && (stderr.puts "case is_down_token")
	      [:reserved_token.negate_me(inverse), :up.negate_me, e, rtoken, false ]
	    )
	  )
        ) || (
	  # case B: is a a repetition with at least 2
	  # occurrences of the reserved token. remove one.
	  # (and add it to the current array)
          repetition_test && (
            debug && (stderr.puts "case escape")
	    # room for improvement: and if array had sub! ?
	    !inverse && (escaped_e = (e.sub! rtoken, "") rescue e)
	    [:reserved_token.negate_me, nil, escaped_e, rtoken, false ]
          )
        ) || (
	  # case C: no repetition. (just add e to
	  # the current array.)
            debug && (stderr.puts "case just add")
	    [:reserved_token.negate_me, nil, e, rtoken, inverse && inversion_envelope ]
	)
      }
      # now operations has |reserved_tokens| operations.
      # but only one will be applied: either the first
      # one which is a reserved token (:first), or the
      # last operation, in case of no reserved tokens.
      operation = operations.lazy.find(&:first) || (
        operations[-1].to_a
      )
      reserved_token, reservation_type, token = operation
      pd = pushdown_operate [pd, operation, debug_pushdown]
    }
    debug && (stderr.puts "will return #{pd.first}")
    debug && (stderr.puts "#{__method__} returning}")
    pd.first
  end


  # takes a flatten array and makes it deeper, starting a new array
  # everytime it finds the string +"["+. +"]"+ stops the array (and
  # return to the upper one). To reserve the possibility of
  # representing "[" or "]", everytime a string contains only those
  # chars, repeteaded any number of times, starting from 2, one of
  # them will be removed. So +"[["+ will be left as +"["+ and
  # +"]]]"+ will be left as +"]]"+.
  # if the provided array is not flatten, it won't be transversed.
  # @param [Array] +args+, the array to be operadated
  # @return [Array] returns the modified, deep, #Array
  def array_unflatten_base_shallow args=[]
    stderr = @memory[:stderr]
    deep = false
    reserved_tokens = [
      [ "[", :up],
      [ "]", :up.negate_me],
    ]
    # debug = 1
    debug = debug.nne
    debug.nne && (stderr.puts "#{__method__} starting")
    debug && (stderr.puts "args=#{args.inspect}")

    rv = array_unflatten_base [
      args,
      deep.negate_me,
      debug,
      reserved_tokens,
    ]

    debug && (stderr.puts "will return #{rv}")
    debug && (stderr.puts "#{__method__} returning")
    rv
  end


  # test for #array_unflatten_base_shallow
  def test__array_unflatten_base_shallow args=[]
    test_cases ||= [
      # [ :id, :expectation, :actual_params ],
      [
        "base_case", [ :a, [ :b ], :c], [
           :array_unflatten_base_shallow, [
             :a, "[", :b, "]", :c
           ]
        ],
      ],

      [
        "base_escape_case", [ :a, "[", :b, "]", :c], [
           :array_unflatten_base_shallow, [
             :a, "[[", :b, "]]", :c
           ]
        ],
      ],

      [
        "base_open_right_case", [ :c], [
           :array_unflatten_base_shallow, [
             :a, :b, "[", :c
           ]
        ],
      ],

      [
        "base_open_left_case", [ :b, :c], [
           :array_unflatten_base_shallow, [
             :a, "]", :b, :c
           ]
        ],
      ],

      [
        "base_case_double", [ :a, [ [ :b ] ], :c], [
           :array_unflatten_base_shallow, [
             :a, "[", "[",  :b, "]", "]", :c
           ]
        ],
      ],

      [
        "base_case_inverted", [ :c], [
           :array_unflatten_base_shallow, [
             :a, "]",  :b, "[", :c
           ]
        ],
      ],


      [
        "base_nested_case", [ :a, [ [ :b ] ], :c], [
           :array_unflatten_base_shallow, [
             :a, "[", [ :b ], "]", :c
           ]
        ],
      ],


      [
        "base_mixed_nested_case", [ :a, [ [ "[", :b, "]",  ] ], :c], [
           :array_unflatten_base_shallow, [
             :a, "[", [ "[", :b, "]", ], "]", :c
           ]
        ],
      ],


    ]
    # test__array_unflatten_base_shallow is finishing:
    experiment__tester [ test_cases ]
  end


  # test for #array_unflatten_base
  def test__array_unflatten_base args=[]
    test_cases ||= [
      # [ :id, :expectation, :actual_params ],
      [
        "base_case", [ :a, [ :b ], :c], [
           :array_unflatten_base, [
             [:a, "[", :b, "]", :c],
             :shallow,
             :debug.negate_me,
             :reserved_tokens.to_nil,
             :inverse.negate_me,
           ]
        ],
      ],

      [
        "base_escape_case", [ :a, "[", :b, "]", :c], [
           :array_unflatten_base, [
             [:a, "[[", :b, "]]", :c],
             :shallow,
             :debug.negate_me,
             :reserved_tokens.to_nil,
             :inverse.negate_me,
           ]
        ],
      ],

      [
        "base_open_right_case", [ :c], [
           :array_unflatten_base, [
             [:a, :b, "[", :c],
             :shallow,
             :debug.negate_me,
             :reserved_tokens.to_nil,
             :inverse.negate_me,
           ]
        ],
      ],

      [
        "base_open_left_case", [ :b, :c], [
           :array_unflatten_base, [
             [:a, "]", :b, :c],
             :shallow,
             :debug.negate_me,
             :reserved_tokens.to_nil,
             :inverse.negate_me,
           ]
        ],
      ],

      [
        "base_case_double", [ :a, [ [ :b ] ], :c], [
           :array_unflatten_base, [
             [:a, "[", "[",  :b, "]", "]", :c],
             :shallow,
             :debug.negate_me,
             :reserved_tokens.to_nil,
             :inverse.negate_me,
           ]
        ],
      ],

      [
        "base_case_inverted", [ :c], [
           :array_unflatten_base, [
             [:a, "]",  :b, "[", :c],
             :shallow,
             :debug.negate_me,
             :reserved_tokens.to_nil,
             :inverse.negate_me,
           ]
        ],
      ],


      [
        "base_nested_case", [ :a, [ [ :b ] ], :c], [
           :array_unflatten_base, [
             [:a, "[", [ :b ], "]", :c],
             :shallow,
             :debug.negate_me,
             :reserved_tokens.to_nil,
             :inverse.negate_me,
           ]
        ],
      ],


      [
        "base_mixed_nested_case_deep", [ :a, [ [ [ :b, ] ] ], :c], [
           :array_unflatten_base, [
             [:a, "[", [ "[", :b, "]", ], "]", :c],
             :shallow.negate_me,
             :debug.negate_me,
             :reserved_tokens.to_nil,
             :inverse.negate_me,
           ]
        ],
      ],


      [
        "base_mixed_nested_case_shallow", [ :a, [ [ "[", :b, "]",  ] ], :c], [
           :array_unflatten_base, [
             [ :a, "[", [ "[", :b, "]", ], "]", :c ],
             :shallow,
             :debug.negate_me,
             :reserved_tokens.to_nil,
             :inverse.negate_me,
           ]
        ],
      ],

      [
        "base_case_inverse", [ :a, "[", :b, "]", :c], [
           :array_unflatten_base, [
             [:a, [ :b, ], :c],
             :shallow.negate_me,
             :debug.negate_me,
             :reserved_tokens.to_nil,
             :inverse,
           ]
        ],
      ],

      [
        "base_case_double_inverse", [ :a, "[", "[", :b, "]", "]", :c], [
           :array_unflatten_base, [
             [:a, [[ :b, ]], :c],
             :shallow.negate_me,
             :debug.negate_me,
             :reserved_tokens.to_nil,
             :inverse,
           ]
        ],
      ],

      [
        "base_escape_case_inverse", [ :a, "[[", :b, "]]", :c], [
           :array_unflatten_base, [
             [:a, "[", :b, "]", :c],
             :shallow.negate_me,
             :debug.negate_me,
             :reserved_tokens.to_nil,
             :inverse,
           ]
        ],
      ],

      [
        "base_mixed_case_inverse", [ :a, "[[", "[", :b, "]", "]]", :c], [
           :array_unflatten_base, [
             [:a, "[", [ :b ], "]", :c],
             :shallow.negate_me,
             :debug.negate_me,
             :reserved_tokens.to_nil,
             :inverse,
           ]
        ],
      ],


      [
        "open_left_base_mixed_case_inverse", [ :a, "]]", "[[", "[", :b, "]", "]]", :c], [
           :array_unflatten_base, [
             [:a, "]", "[", [ :b ], "]", :c],
             :shallow.negate_me,
             :debug.negate_me,
             :reserved_tokens.to_nil,
             :inverse,
           ]
        ],
      ],

    ]
    # test__array_unflatten_base is finishing
    experiment__tester [ test_cases ]
  end


=begin
  # begin_documentation
  # short_desc = "tests the function #string_repetition"

  @memory[:documentation].push = {
    :function    => :test__string_repetition,
    :short_desc  => short_desc,
    :description => "",
    :params      => [
      {
        :name             => :args,
        :description      => "list of parameters",
        :duck_type        => Array,
        :default_behavior => "interpreted as empty array",
        :params           => [
          {
            :name             => :reserved,
            :duck_type        => Object,
            :default_behavior => "interpreted as nil",
            :description      => "for future use",
          },
        ],
      },
    ],
  }
  # end_documentation


=end
  def test__string_repetition args=[]
    expectation = {}
    actual = {}
    test_case = 1
    operand_1 = "XXX"
    operand_2 = "X"
    # expectation and actual inverted.
    actual[test_case] = string_repetition [operand_1, operand_2]
    expectation[test_case] = operand_1

    test_case = 2
    operand_1 = "X"
    operand_2 = "X"
    actual[test_case] = string_repetition [operand_1, operand_2]
    expectation[test_case] = operand_1

    test_case = 3
    operand_1 = "XyXy"
    operand_2 = "XyXy"
    actual[test_case] = string_repetition [operand_1, operand_2]
    expectation[test_case] = operand_1

    test_case = 4
    operand_1 = "XyXy"
    operand_2 = "XXyy"
    actual[test_case] = string_repetition [operand_1, operand_2]
    expectation[test_case] = false

    test_case = 6
    operand_1 = ""
    operand_2 = ""
    actual[test_case] = string_repetition [operand_1, operand_2, 0]
    expectation[test_case] = operand_1

    test_case = 7
    operand_1 = ""
    operand_2 = ""
    actual[test_case] = string_repetition [operand_1, operand_2, 1]
    expectation[test_case] = operand_1

    test_case = 7
    operand_1 = ""
    operand_2 = "X"
    actual[test_case] = string_repetition [operand_1, operand_2, 0]
    # "X"*0 = ""
    expectation[test_case] = operand_1

    test_case = 8
    operand_1 = ""
    operand_2 = "X"
    actual[test_case] = string_repetition [operand_1, operand_2, 1]
    # "X"*0 = "", but minimum is set to 1
    expectation[test_case] = false

    test_case = 9
    operand_1 = "XyXy"
    operand_2 = "Xy"
    actual[test_case] = string_repetition [operand_1, operand_2]
    expectation[test_case] = operand_1

    test_case = 10
    operand_1 = "XyXy"
    operand_2 = ""
    actual[test_case] = string_repetition [operand_1, operand_2]
    # clearly "" appears in "XyXy" infinity times, but "XyXy" is no
    # repetition of ""
    expectation[test_case] = false

    test_case = 11
    operand_1 = "XyXy"
    operand_2 = "Xy"
    actual[test_case] = string_repetition [operand_1, operand_2]
    expectation[test_case] = operand_1

    test_case = 12
    operand_1 = "X"
    operand_2 = "XXX"
    actual[test_case] = string_repetition [operand_1, operand_2]
    expectation[test_case] = false

    test_case = 13
    operand_1 = [:b]
    operand_2 = "]"
    actual[test_case] = string_repetition [operand_1, operand_2]
    expectation[test_case] = false

    test_case = 14
    operand_1 = "[:b]"
    operand_2 = "]"
    actual[test_case] = string_repetition [operand_1, operand_2]
    expectation[test_case] = false

    judgement = actual.keys.map {|test_case|
      [expectation[test_case], actual[test_case] , test_case]
    }.map(&method("expect_equal")).all?
  end



end


class Rubyment
   include RubymentModule
end

(__FILE__ == $0) && Rubyment.new({:invoke => ARGV})

