require 'puppet'
require 'puppet/parser/ast/branch'
require 'puppet/parser/collector'

# An object that collects stored objects from the central cache and returns
# them to the current host, yo.
class Puppet::Parser::AST
class CollExpr < AST::Branch
  attr_accessor :test1, :test2, :oper, :form, :type, :parens

  def evaluate(scope)
    if Puppet.future_parser?
      evaluate4x(scope)
    else
      evaluate3x(scope)
    end
  end

  # We return an object that does a late-binding evaluation.
  def evaluate3x(scope)
    # Make sure our contained expressions have all the info they need.
    [@test1, @test2].each do |t|
      if t.is_a?(self.class)
        t.form ||= self.form
        t.type ||= self.type
      end
    end

    # The code is only used for virtual lookups
    match1, code1 = @test1.safeevaluate scope
    match2, code2 = @test2.safeevaluate scope

    # First build up the virtual code.
    # If we're a conjunction operator, then we're calling code.  I did
    # some speed comparisons, and it's at least twice as fast doing these
    # case statements as doing an eval here.
    code = proc do |resource|
      case @oper
      when "and"; code1.call(resource) and code2.call(resource)
      when "or"; code1.call(resource) or code2.call(resource)
      when "=="
        if match1 == "tag"
          resource.tagged?(match2)
        else
          if resource[match1].is_a?(Array)
            resource[match1].include?(match2)
          else
            resource[match1] == match2
          end
        end
      when "!="; resource[match1] != match2
      end
    end

    match = [match1, @oper, match2]
    return match, code
  end

  # Late binding evaluation of a collect expression (as done in 3x), but with proper Puppet Language
  # semantics for equals and include
  #
  def evaluate4x(scope)
    # Make sure our contained expressions have all the info they need.
    [@test1, @test2].each do |t|
      if t.is_a?(self.class)
        t.form ||= self.form
        t.type ||= self.type
      end
    end

    # The code is only used for virtual lookups
    match1, code1 = @test1.safeevaluate scope
    match2, code2 = @test2.safeevaluate scope

    # First build up the virtual code.
    # If we're a conjunction operator, then we're calling code.  I did
    # some speed comparisons, and it's at least twice as fast doing these
    # case statements as doing an eval here.
    code = proc do |resource|
      case @oper
      when "and"; code1.call(resource) and code2.call(resource)
      when "or"; code1.call(resource) or code2.call(resource)
      when "=="
        if match1 == "tag"
          resource.tagged?(match2)
        else
          if resource[match1].is_a?(Array)
            @@compare_operator.include?(resource[match1], match2, scope)
          else
            @@compare_operator.equals(resource[match1], match2)
          end
        end
      when "!="; ! @@compare_operator.equals(resource[match1], match2)
      end
    end

    match = [match1, @oper, match2]
    return match, code
  end

  def initialize(hash = {})
    super
    if Puppet[:parser] == "future"
      @@compare_operator ||= Puppet::Pops::Evaluator::CompareOperator.new
    end
    raise ArgumentError, "Invalid operator #{@oper}" unless %w{== != and or}.include?(@oper)
  end
end
end
