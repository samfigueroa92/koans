# frozen string literal

require File.expand_path(File.dirname(__FILE__) + '/neo')

# require 'java'

include Java

# Concepts
# * Pull in a java class
# * calling a method, Camel vs snake
# * Resolving module/class name conflicts
# * Showing what gets returned
# * Ruby Strings  VS Java Strings
# * Calling custom java class
# * Calling Ruby from java???

class AboutJavaInterop < Neo::Koan
  def test_using_a_java_library_class
    java_array = java.util.ArrayList.new
    assert_equal Java::JavaUtil::ArrayList, java_array.class
  end

  def test_java_class_can_be_referenced_using_both_ruby_and_java_like_syntax
    assert_equal true, Java::JavaUtil::ArrayList == java.util.ArrayList
  end

  def test_include_class_includes_class_in_module_scope
    assert_nil defined?(TreeSet)
    include_class "java.util.TreeSet"
    assert_equal "constant", defined?(TreeSet)
  end

  # THINK ABOUT IT:
  #
  # What if we use:
  #
  #   include_class "java.lang.String"
  #
  # What would be the value of the String constant after this
  # include_class is run?  Would it be useful to provide a way of
  # aliasing java classes to different names?

  JString = java.lang.String
  def test_also_java_class_can_be_given_ruby_aliases
    java_string = JString.new("A Java String")
    assert_equal java.lang.String, java_string.class
    assert_equal java.lang.String, JString
  end

  def test_can_directly_call_java_methods_on_java_objects
    java_string = JString.new("A Java String")
    assert_equal "a java string", java_string.toLowerCase
  end

  def test_jruby_provides_snake_case_versions_of_java_methods
    java_string = JString.new("A Java String")
    assert_equal "a java string", java_string.to_lower_case
  end

  def test_jruby_provides_question_mark_versions_of_boolean_methods
    java_string = JString.new("A Java String")
    assert_equal true, java_string.endsWith("String")
    assert_equal true, java_string.ends_with("String")
    assert_equal true, java_string.ends_with?("String")
  end

  def test_java_string_are_not_ruby_strings
    ruby_string = "A Java String"
    java_string = java.lang.String.new(ruby_string)
    assert_equal true, java_string.is_a?(java.lang.String)
    assert_equal false, java_string.is_a?(String)
  end

  def test_java_strings_can_be_compared_to_ruby_strings_maybe
    ruby_string = "A Java String"
    java_string = java.lang.String.new(ruby_string)
    assert_equal false, ruby_string == java_string
    assert_equal true, java_string == ruby_string
      # Even though they represent the same sequence of characters, 
      # they are still different objects in memory. However, JRuby 
      # provides an implementation that allows this comparison to 
      # evaluate to true. JRuby internally converts the Ruby string 
      # to a Java string and then performs the comparison, which 
      # evaluates to true.

    # THINK ABOUT IT:
    #
    # Is there any possible way for this to be more wrong?
    #
    # SERIOUSLY, THINK ABOUT IT:
    #
    # Why do you suppose that Ruby and Java strings compare like that?
      # This behavior is a consequence of JRuby's design and the implementation 
      # of its Java interop features. JRuby attempts to provide seamless interoperability 
      # between Ruby and Java, and one aspect of this is allowing comparison between Ruby 
      # and Java objects. It's important to note that this behavior is specific to JRuby 
      # and may not apply to other Ruby implementations.
    # 
    # ADVANCED THINK ABOUT IT:
    #
    # Is there a way to make Ruby/Java string comparisons commutative?
    # How would you do it?
      # Making string comparisons commutative (i.e., ensuring that 
      # ruby_string == java_string and java_string == ruby_string 
      # both return true) would involve implementing custom equality 
      # checks or conversions between Ruby and Java strings. This 
      # could be achieved by defining custom equality methods or 
      # conversion methods in Ruby or Java, respectively. However, 
      # modifying the behavior of language primitives like string 
      # comparison can have significant implications and may not be 
      # advisable in most cases.
  end

  def test_however_most_methods_returning_strings_return_ruby_strings
    java_array = java.util.ArrayList.new
    assert_equal "[]", java_array.toString
    assert_equal true, java_array.toString.is_a?(String)
    assert_equal false, java_array.toString.is_a?(java.lang.String)
  end

  def test_some_ruby_objects_can_be_coerced_to_java
    assert_equal Java::JavaLang::String, "ruby string".to_java.class
    assert_equal Java::JavaLang::Long, 1.to_java.class
    assert_equal Java::JavaLang::Double, 9.32.to_java.class
    assert_equal Java::JavaLang::Boolean, false.to_java.class
  end

  def test_some_ruby_objects_are_not_coerced_to_what_you_might_expect
    assert_equal false, [].to_java.class == Java::JavaUtil::ArrayList
    assert_equal false, {}.to_java.class == Java::JavaUtil::HashMap
    assert_equal false, Object.new.to_java.class == Java::JavaLang::Object
  end

  def test_java_collections_are_enumerable
    java_array = java.util.ArrayList.new
    java_array << "one" << "two" << "three"
    assert_equal ["ONE", "TWO", "THREE"], java_array.map { |item| item.upcase }
  end

  # ------------------------------------------------------------------

  # Open the Java ArrayList class and add a new method.
  class Java::JavaUtil::ArrayList
    def multiply_all
      result = 1
      each do |item|
        result *= item
      end
      result
    end
  end

  def test_java_class_are_open_from_ruby
    java_array = java.util.ArrayList.new
    java_array.add_all([1,2,3,4,5])

    assert_equal 120, java_array.multiply_all
  end

end
