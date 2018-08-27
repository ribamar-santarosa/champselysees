#!/usr/bin/env ruby


=begin
  # begin_documentation
  TrueClass will be changed just by including
  this file or requiring rubyment, which is not the
  best approach, but kept to respect the open/closed
  principle, but new functions should be added here.
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
  principle, but new functions should be added here.

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
end


=begin
  # begin_documentation
  This module receives functions that are being worked on.
  # end_documentation
=end
module RubymentExperimentModule


=begin
  # documentation_begin
  # short_desc = "tests the function #experiment__bled"
  @memory[:documentation].push = {
    :function   => :experiment__bled,
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
            :description      => "output when an exception happens",
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
  def experiment__bled args=[], &block
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
      debug && (stderr.puts "{#{__method__} block starting")
      debug && (stderr.puts "block_args=#{block_args.inspect}")
      brv = begin
        [ (block.call *block_args), nil, nil]
      rescue => e
        e_info = exception_information_base [
          e,
          backtrace_max_str_len
        ]
        (debug || output_backtrace) && (stderr.puts "{#{__method__} block #{block.inspect} backtrace: #{e_info[1]}")
        dont_rescue && (raise e)
        [ default_on_exception, e_info, e ]
      end
      debug && (stderr.puts "block #{block.inspect} will return #{brv.inspect}")
      debug && (stderr.puts "#{__method__} block returning}")
      brv
    }
    rv = [ rv ]
    debug && (stderr.puts "will return #{rv.inspect}")
    debug && (stderr.puts "#{__method__} returning}")
    rv
  end



end


=begin
  # begin_documentation
  This module receives only functions that are maintained.
  Ie, the non-deprecated or not under deprecation functions.
  # end_documentation
=end
module RubymentMaintainedModule


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


=begin
  # documentation_begin
  # short_desc = "tests the function #string_truncate"
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


  def test_cases_template args=[]
    test_cases ||= [
      # [ :id, :expectation, :actual_params ],
      # actual_params can be an array with method_name + args to that method.
    ]
  end


=begin

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
      e_info = exception_information_base [e]
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

  include RubymentClassInjectorModule
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
      :major_version => "0.6",
      :basic_version => (Time.now.to_i  / 60), # new one every minute
      :filepath => __FILE__,
      :running_dir => Dir.pwd,
      :home_dir => Dir.home,
      :system_user => ENV['USER'] || ENV['USERNAME'],
      :system_user_is_super => ENV['USER']  == "root", # changed plan: platform indenpend.
      :static_separator_key => "strings_having_this"  +  "_string_not_guaranteed_to_work",
      :static_end_key => "strings_havinng_this_string" + "_also_not_guaranteed_to_work",
      :static_separator_key_per_execution => "strings_having_this"  +  "_string_not_guaranteed_to_work" + (Proc.new {}).to_s + Time.now.to_s,
      :threads => [Thread.current]
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
    major, minor = args
    major ||= major_version
    minor ||= basic_version
    "#{major}.#{minor}"
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
      reserved = args
    debug = debug.nne
    debug && (stderr.puts "{#{__method__} starting")
    debug && (stderr.puts "args=#{args.inspect}")
    uri = uri.nne ""
    file_is_directory = File.directory?(uri)
    must_return_on_rescue = false
    return_on_directory_given ||= true
    contents = !(file_is_directory) && (
      begin
        url_response = (send :rest_request_or_open_uri_open, [
            uri,
            payload,
            verify_ssl,
            headers,
            method,
            username,
            password,
            timeout,
            skip_open_uri,
          ]).first
        debug && (stderr.puts "url_response=#{url_response.inspect}")
        url_response
      rescue => e1
        begin
          debug && (stderr.puts "exception e1=#{e1.inspect}")
          File.read uri
        rescue  => e2
          debug && (stderr.puts "exception e2=#{e2.inspect}")
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
    name, object = containerize args
    begin
      object.method("method").call(name.to_s)
    rescue NameError => nameError
      # every object (even nil) has :method,
      # and every Method has :call: exception
      # is thrown in call
      stderr.puts nameError
      nil
    end
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
    method, object, *call_args = containerize args
    object ||= self
    method = to_object_method [method, object]
    call_args = call_args && (containerize call_args)
    begin
      call_args && (method.call *call_args) || method.call
    rescue NameError => nameError
      # every object (even nil) has :method,
      # and every Method has :call: exception
      # is thrown in call
      stderr.puts nameError
      nil
    end
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
    debug && (stderr.puts "will return #{rv.inspect}")
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
    gem_bin_executables = args

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
end
    ENDHEREDOC
    contents
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
    gem_is_current_file = args

    gem_name ||= "rubyment"
    gem_version ||= (version [])
    gem_dir ||= running_dir
    gem_ext ||= ".gem"
    gem_hifen ||= "-"
    gem_ext ||= "date"
    gem_date ||= "2018-04-23"
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
    gem_is_current_file = __FILE__ # this enables the possibility of building
    #  a gem for the calling file itself, but be aware that lib/gem_file.rb
    # is supposed to be overriden later.
    gem_bin_generate = "bin/#{gem_name}" # generate a bin file
    gem_bin_contents =<<-ENDHEREDOC
#!/usr/bin/env ruby
require '#{gem_name}'
#{gem_validate_class}.new({:invoke => ARGV})
    ENDHEREDOC
    gem_executables = [ gem_bin_generate && "#{gem_name}" ]

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
  # @return [String] console output of gem uninstall
  def gem_uninstall_all args=[]
    stderr = @memory[:stderr]
    gem_spec, user_install, quiet, all = args
    all = "-a"
    gem_uninstall [gem_spec, user_install, quiet, all]
  end


  # gem_uninstall
  # args:
  # [gem_spec (String)]
  # returns:
  # console output of gem uninstall (String)
  def gem_uninstall args=ARGV
    stderr = @memory[:stderr]
    system_user_is_super = @memory[:system_user_is_super]
    gem_spec, user_install, quiet, all = args
    quiet = quiet.nne
    debug = quiet.negate_me
    all = all.nne ""
    user_install ||= (!system_user_is_super) && "--user-install" || ""
    command="gem uninstall #{all} -x #{user_install}  #{gem_spec}"
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
    command="gem list | grep #{gem_spec}"
    debug && (stderr.puts "command=#{command}")
    `#{command}`
  end

  # validate_require
  # requires a file/gem in the system
  # returns nil if not found
  # args:
  # [requirement (String), validator_class (Class or String or nil),
  #  validator_args (Array), validator_method (Method or String)]
  # returns:
  # Rubyment, true or false
  def validate_require args=ARGV
    stderr = @memory[:stderr]
    requirement, validator_class, validator_args, validator_method = containerize args
    validate_call = validator_class && true
    validator_class = to_class validator_class
    validator_method ||=  "new"
    begin
      require requirement
      validate_call && (object_method_args_call [validator_method, validator_class, validator_args]) || (!validate_call) && true
    rescue LoadError => e
      stderr.puts e
      nil
    end
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
    already_installed = (
      validate_require gem_validate_args gem_defaults
    )
    sleep 1
    already_installed && (gem_uninstall_all [gem_name])
    puts gem_list [gem_name]
    p (gem_path [gem_name, gem_version])
    gem_install [(gem_path [gem_name, gem_version])]
    puts gem_list [gem_name]
    v = (
      validate_require gem_validate_args gem_defaults
    )
    gem_uninstall_all [gem_name]
    already_installed && (gem_install [gem_name])
    v
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
  #
  # @return [Method] a method
  def to_method args = ARGV
    method_name_or_method, object, reserved = args
    (
      to_object_method [object, method_name_or_method]
    ) || (
      method_name_or_method.respond_to?(:call) && method_name_or_method
    ) ||
      method(method_name_or_method)
  end


  # echoes the processing arg
  # @param [Array] +args+, an +Array+ whose elements are expected to be:
  # +processing_arg+:: [String]
  #
  # @return [String] +processing_arg+
  def echo args = ARGV
    args.first
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
  #
  # @return [nil]
  def io_transform args = ARGV
    io,
      debug,
      happy_with_request,
      transform_method_name,
      transform_method_args,
      reserved = args
    stderr = @memory[:stderr]
    debug.nne && (stderr.puts "#{__method__} starting")
    debug.nne && (stderr.puts "transform_method_name: #{transform_method_name}")
    debug.nne && (stderr.puts "transform_method_args: #{transform_method_args.inspect}")
    io_forward [[io], io, debug, happy_with_request, reserved,
      :test__transform_call, [
        transform_method_name,
	transform_method_args,
	"on_object:true",
      ]
    ]
    debug.nne && (stderr.puts "#{__method__} returning")
    nil
  end


  # gets and forwards the input from one IO to a list of IOs
  # @param [Array] +args+, an +Array+ whose elements are expected to be:
  # +ios_out+:: [Array] array of +IO+, where data will be written to.
  # +io_in+:: [IO] any +IO+, like a +Socket+, returned by #TCPServer::accept, where data will be read from.
  # +debug+:: [Object] if evals to false (or empty string), won't print debug information
  # +happy_with_request+:: [String, nil] if nil, +eol+ is used.
  #
  # @return [nil]
  def io_forward args = ARGV

    ios_out,
      io_in,
      debug,
      happy_with_request,
      reserved,
      processing_method,
      processing_method_args = args
    io_gets_args = [io_in, debug, happy_with_request]
    stderr = @memory[:stderr]
    debug.nne && (stderr.puts "#{__method__} starting")
    debug.nne && (stderr.puts args.inspect)
    input = io_gets io_gets_args
    debug.nne && (stderr.puts input.inspect)
    debug.nne && (stderr.puts ios_out.class.inspect)
    processing_method ||= :echo
    processing_method_args ||= []
    processed_input = to_method(
      [processing_method]).call(
        [input] + processing_method_args
    )
    ios_out.map{ |shared_io_out|
      runoe_threaded(shared_io_out) {|io_out|
	io_out = shared_io_out
        io_out.print processed_input
        debug.nne && (
          stderr.puts "#{io_out}: #{processed_input.size} bytes: response writen."
        )
        io_out.close
        debug.nne && (
          stderr.puts "#{io_out}: IO closed."
        )

      }
    }
    debug.nne && (stderr.puts "#{__method__} returning")
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
    debug && (stderr.puts "#{__method__} starting")
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
    debug && (stderr.puts "#{__method__} returning")
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
            :description      => "arguments for the method that returns an http request string (used by the first server)",
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
      reserved = args

    debug = debug.nne
    debug.nne && (stderr.puts "{#{__method__} starting")
    debug && (stderr.puts "args=#{args.inspect}")
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
    debug =  debug.nne "yes, debug"
    io_method =  io_method.nne "io_transform"
    io_method_debug =  io_method_debug.nne debug
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
        http_processing_method_args
      ],
      priv_pemfile,
      cert_pem_file,
      extra_cert_pem_files,
      "yes, output exceptions",
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
      ],
      :priv_pemfile.to_nil,
      :cert_pem_file.to_nil,
      :extra_cert_pem_files.to_nil,
      "yes, output exceptions",
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
      file_read ["https://#{domain}:#{http_server_port}/#{path}"]
    )
    debug && (stderr.puts "#{admit_non_ssl.inspect} && file_read \"http://#{domain}:#{http_server_port}/#{path}\"")
    response = http_file_read_attempt ||
      admit_non_ssl && (file_read ["http://#{domain}:#{http_server_port}/#{path}"])
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


  # experimental stuff coming. usage example:
  # ./rubyment.rb  invoke_double p test__shell_send_array__main  "tinga" "" sub in EN 
  # ["tENga"]
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
    test__tester test_cases
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
    test__tester test_cases
  end


=begin
  # documentation_begin
  # short_desc = "tests the function #string_repetion"
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
  # documentation_end


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

