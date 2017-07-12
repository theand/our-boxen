require 'spec_helper'
require 'puppet/pops'

describe 'The type calculator' do
  let(:calculator) {  Puppet::Pops::Types::TypeCalculator.new() }

  def range_t(from, to)
   t = Puppet::Pops::Types::PIntegerType.new
   t.from = from
   t.to = to
   t
  end
  def constrained_t(t, from, to)
    Puppet::Pops::Types::TypeFactory.constrain_size(t, from, to)
  end

  def pattern_t(*patterns)
    Puppet::Pops::Types::TypeFactory.pattern(*patterns)
  end

  def regexp_t(pattern)
    Puppet::Pops::Types::TypeFactory.regexp(pattern)
  end

  def string_t(*strings)
    Puppet::Pops::Types::TypeFactory.string(*strings)
  end

  def callable_t(*params)
    Puppet::Pops::Types::TypeFactory.callable(*params)
  end
  def all_callables_t(*params)
    Puppet::Pops::Types::TypeFactory.all_callables()
  end

  def with_block_t(callable_t, *params)
    Puppet::Pops::Types::TypeFactory.with_block(callable_t, *params)
  end

  def with_optional_block_t(callable_t, *params)
    Puppet::Pops::Types::TypeFactory.with_optional_block(callable_t, *params)
  end

  def enum_t(*strings)
    Puppet::Pops::Types::TypeFactory.enum(*strings)
  end

  def variant_t(*types)
    Puppet::Pops::Types::TypeFactory.variant(*types)
  end

  def integer_t()
    Puppet::Pops::Types::TypeFactory.integer()
  end

  def array_t(t)
    Puppet::Pops::Types::TypeFactory.array_of(t)
  end

  def hash_t(k,v)
    Puppet::Pops::Types::TypeFactory.hash_of(v, k)
  end

  def data_t()
    Puppet::Pops::Types::TypeFactory.data()
  end

  def factory()
    Puppet::Pops::Types::TypeFactory
  end

  def collection_t()
    Puppet::Pops::Types::TypeFactory.collection()
  end

  def tuple_t(*types)
    Puppet::Pops::Types::TypeFactory.tuple(*types)
  end

  def struct_t(type_hash)
    Puppet::Pops::Types::TypeFactory.struct(type_hash)
  end

  def object_t
    Puppet::Pops::Types::TypeFactory.any()
  end

  def optional_t(t)
    Puppet::Pops::Types::TypeFactory.optional(t)
  end

  def not_undef_t(t = nil)
    Puppet::Pops::Types::TypeFactory.not_undef(t)
  end

  def undef_t
    Puppet::Pops::Types::TypeFactory.undef
  end

  def unit_t
    # Cannot be created via factory, the type is private to the type system
    Puppet::Pops::Types::PUnitType.new
  end

  def types
    Puppet::Pops::Types
  end

  shared_context "types_setup" do

    # Do not include the special type Unit in this list
    def all_types
      [ Puppet::Pops::Types::PAnyType,
        Puppet::Pops::Types::PUndefType,
        Puppet::Pops::Types::PNotUndefType,
        Puppet::Pops::Types::PDataType,
        Puppet::Pops::Types::PScalarType,
        Puppet::Pops::Types::PStringType,
        Puppet::Pops::Types::PNumericType,
        Puppet::Pops::Types::PIntegerType,
        Puppet::Pops::Types::PFloatType,
        Puppet::Pops::Types::PRegexpType,
        Puppet::Pops::Types::PBooleanType,
        Puppet::Pops::Types::PCollectionType,
        Puppet::Pops::Types::PArrayType,
        Puppet::Pops::Types::PHashType,
        Puppet::Pops::Types::PRuntimeType,
        Puppet::Pops::Types::PHostClassType,
        Puppet::Pops::Types::PResourceType,
        Puppet::Pops::Types::PPatternType,
        Puppet::Pops::Types::PEnumType,
        Puppet::Pops::Types::PVariantType,
        Puppet::Pops::Types::PStructType,
        Puppet::Pops::Types::PTupleType,
        Puppet::Pops::Types::PCallableType,
        Puppet::Pops::Types::PType,
        Puppet::Pops::Types::POptionalType,
        Puppet::Pops::Types::PDefaultType,
      ]
    end

    def scalar_types
      # PVariantType is also scalar, if its types are all Scalar
      [
        Puppet::Pops::Types::PScalarType,
        Puppet::Pops::Types::PStringType,
        Puppet::Pops::Types::PNumericType,
        Puppet::Pops::Types::PIntegerType,
        Puppet::Pops::Types::PFloatType,
        Puppet::Pops::Types::PRegexpType,
        Puppet::Pops::Types::PBooleanType,
        Puppet::Pops::Types::PPatternType,
        Puppet::Pops::Types::PEnumType,
      ]
    end

    def numeric_types
      # PVariantType is also numeric, if its types are all numeric
      [
        Puppet::Pops::Types::PNumericType,
        Puppet::Pops::Types::PIntegerType,
        Puppet::Pops::Types::PFloatType,
      ]
    end

    def string_types
      # PVariantType is also string type, if its types are all compatible
      [
        Puppet::Pops::Types::PStringType,
        Puppet::Pops::Types::PPatternType,
        Puppet::Pops::Types::PEnumType,
      ]
    end

    def collection_types
      # PVariantType is also string type, if its types are all compatible
      [
        Puppet::Pops::Types::PCollectionType,
        Puppet::Pops::Types::PHashType,
        Puppet::Pops::Types::PArrayType,
        Puppet::Pops::Types::PStructType,
        Puppet::Pops::Types::PTupleType,
      ]
    end

    def data_compatible_types
      result = scalar_types
      result << Puppet::Pops::Types::PDataType
      result << array_t(types::PDataType.new)
      result << types::TypeFactory.hash_of_data
      result << Puppet::Pops::Types::PUndefType
      result << not_undef_t(types::PDataType.new)
      tmp = tuple_t(types::PDataType.new)
      result << (tmp)
      tmp.size_type = range_t(0, nil)
      result
    end

    def type_from_class(c)
      c.is_a?(Class) ? c.new : c
    end
  end

  context 'when inferring ruby' do

    it 'fixnum translates to PIntegerType' do
      calculator.infer(1).class.should == Puppet::Pops::Types::PIntegerType
    end

    it 'large fixnum (or bignum depending on architecture) translates to PIntegerType' do
      calculator.infer(2**33).class.should == Puppet::Pops::Types::PIntegerType
    end

    it 'float translates to PFloatType' do
      calculator.infer(1.3).class.should == Puppet::Pops::Types::PFloatType
    end

    it 'string translates to PStringType' do
      calculator.infer('foo').class.should == Puppet::Pops::Types::PStringType
    end

    it 'inferred string type knows the string value' do
      t = calculator.infer('foo')
      t.class.should == Puppet::Pops::Types::PStringType
      t.values.should == ['foo']
    end

    it 'boolean true translates to PBooleanType' do
      calculator.infer(true).class.should == Puppet::Pops::Types::PBooleanType
    end

    it 'boolean false translates to PBooleanType' do
      calculator.infer(false).class.should == Puppet::Pops::Types::PBooleanType
    end

    it 'regexp translates to PRegexpType' do
      calculator.infer(/^a regular expression$/).class.should == Puppet::Pops::Types::PRegexpType
    end

    it 'nil translates to PUndefType' do
      calculator.infer(nil).class.should == Puppet::Pops::Types::PUndefType
    end

    it ':undef translates to PUndefType' do
      calculator.infer(:undef).class.should == Puppet::Pops::Types::PUndefType
    end

    it 'an instance of class Foo translates to PRuntimeType[ruby, Foo]' do
      class Foo
      end

      t = calculator.infer(Foo.new)
      t.class.should == Puppet::Pops::Types::PRuntimeType
      t.runtime.should == :ruby
      t.runtime_type_name.should == 'Foo'
    end

    context 'array' do
      it 'translates to PArrayType' do
        calculator.infer([1,2]).class.should == Puppet::Pops::Types::PArrayType
      end

      it 'with fixnum values translates to PArrayType[PIntegerType]' do
        calculator.infer([1,2]).element_type.class.should == Puppet::Pops::Types::PIntegerType
      end

      it 'with 32 and 64 bit integer values translates to PArrayType[PIntegerType]' do
        calculator.infer([1,2**33]).element_type.class.should == Puppet::Pops::Types::PIntegerType
      end

      it 'Range of integer values are computed' do
        t = calculator.infer([-3,0,42]).element_type
        t.class.should == Puppet::Pops::Types::PIntegerType
        t.from.should == -3
        t.to.should == 42
      end

      it "Compound string values are computed" do
        t = calculator.infer(['a','b', 'c']).element_type
        t.class.should == Puppet::Pops::Types::PStringType
        t.values.should == ['a', 'b', 'c']
      end

      it 'with fixnum and float values translates to PArrayType[PNumericType]' do
        calculator.infer([1,2.0]).element_type.class.should == Puppet::Pops::Types::PNumericType
      end

      it 'with fixnum and string values translates to PArrayType[PScalarType]' do
        calculator.infer([1,'two']).element_type.class.should == Puppet::Pops::Types::PScalarType
      end

      it 'with float and string values translates to PArrayType[PScalarType]' do
        calculator.infer([1.0,'two']).element_type.class.should == Puppet::Pops::Types::PScalarType
      end

      it 'with fixnum, float, and string values translates to PArrayType[PScalarType]' do
        calculator.infer([1, 2.0,'two']).element_type.class.should == Puppet::Pops::Types::PScalarType
      end

      it 'with fixnum and regexp values translates to PArrayType[PScalarType]' do
        calculator.infer([1, /two/]).element_type.class.should == Puppet::Pops::Types::PScalarType
      end

      it 'with string and regexp values translates to PArrayType[PScalarType]' do
        calculator.infer(['one', /two/]).element_type.class.should == Puppet::Pops::Types::PScalarType
      end

      it 'with string and symbol values translates to PArrayType[PAnyType]' do
        calculator.infer(['one', :two]).element_type.class.should == Puppet::Pops::Types::PAnyType
      end

      it 'with fixnum and nil values translates to PArrayType[PIntegerType]' do
        calculator.infer([1, nil]).element_type.class.should == Puppet::Pops::Types::PIntegerType
      end

      it 'with arrays of string values translates to PArrayType[PArrayType[PStringType]]' do
        et = calculator.infer([['first' 'array'], ['second','array']])
        et.class.should == Puppet::Pops::Types::PArrayType
        et = et.element_type
        et.class.should == Puppet::Pops::Types::PArrayType
        et = et.element_type
        et.class.should == Puppet::Pops::Types::PStringType
      end

      it 'with array of string values and array of fixnums translates to PArrayType[PArrayType[PScalarType]]' do
        et = calculator.infer([['first' 'array'], [1,2]])
        et.class.should == Puppet::Pops::Types::PArrayType
        et = et.element_type
        et.class.should == Puppet::Pops::Types::PArrayType
        et = et.element_type
        et.class.should == Puppet::Pops::Types::PScalarType
      end

      it 'with hashes of string values translates to PArrayType[PHashType[PStringType]]' do
        et = calculator.infer([{:first => 'first', :second => 'second' }, {:first => 'first', :second => 'second' }])
        et.class.should == Puppet::Pops::Types::PArrayType
        et = et.element_type
        et.class.should == Puppet::Pops::Types::PHashType
        et = et.element_type
        et.class.should == Puppet::Pops::Types::PStringType
      end

      it 'with hash of string values and hash of fixnums translates to PArrayType[PHashType[PScalarType]]' do
        et = calculator.infer([{:first => 'first', :second => 'second' }, {:first => 1, :second => 2 }])
        et.class.should == Puppet::Pops::Types::PArrayType
        et = et.element_type
        et.class.should == Puppet::Pops::Types::PHashType
        et = et.element_type
        et.class.should == Puppet::Pops::Types::PScalarType
      end
    end

    context 'hash' do
      it 'translates to PHashType' do
        calculator.infer({:first => 1, :second => 2}).class.should == Puppet::Pops::Types::PHashType
      end

      it 'with symbolic keys translates to PHashType[PRuntimeType[ruby, Symbol], value]' do
        k = calculator.infer({:first => 1, :second => 2}).key_type
        k.class.should == Puppet::Pops::Types::PRuntimeType
        k.runtime.should == :ruby
        k.runtime_type_name.should == 'Symbol'
      end

      it 'with string keys translates to PHashType[PStringType, value]' do
        calculator.infer({'first' => 1, 'second' => 2}).key_type.class.should == Puppet::Pops::Types::PStringType
      end

      it 'with fixnum values translates to PHashType[key, PIntegerType]' do
        calculator.infer({:first => 1, :second => 2}).element_type.class.should == Puppet::Pops::Types::PIntegerType
      end

      it 'when empty infers a type that answers true to is_the_empty_hash?' do
        expect(calculator.infer({}).is_the_empty_hash?).to be_true
        expect(calculator.infer_set({}).is_the_empty_hash?).to be_true
      end

      it 'when empty is assignable to any PHashType' do
        expect(calculator.assignable?(hash_t(string_t, string_t), calculator.infer({}))).to be_true
      end

      it 'when empty is not assignable to a PHashType with from size > 0' do
        expect(calculator.assignable?(constrained_t(hash_t(string_t,string_t), 1, 1), calculator.infer({}))).to be_false
      end

      context 'using infer_set' do
        it "with 'first' and 'second' keys translates to PStructType[{first=>value,second=>value}]" do
          t = calculator.infer_set({'first' => 1, 'second' => 2})
          expect(t.class).to eq(Puppet::Pops::Types::PStructType)
          expect(t.elements.size).to eq(2)
          expect(t.elements.map { |e| e.name }.sort).to eq(['first', 'second'])
        end

        it 'with string keys and string and array values translates to PStructType[{key1=>PStringType,key2=>PTupleType}]' do
          t = calculator.infer_set({ 'mode' => 'read', 'path' => ['foo', 'fee' ] })
          expect(t.class).to eq(Puppet::Pops::Types::PStructType)
          expect(t.elements.size).to eq(2)
          els = t.elements.map { |e| e.value_type }.sort {|a,b| a.to_s <=> b.to_s }
          els[0].class.should == Puppet::Pops::Types::PStringType
          els[1].class.should == Puppet::Pops::Types::PTupleType
        end

        it 'with mixed string and non-string keys translates to PHashType' do
          t = calculator.infer_set({ 1 => 'first', 'second' => 'second' })
          expect(t.class).to eq(Puppet::Pops::Types::PHashType)
        end

        it 'with empty string keys translates to PHashType' do
          t = calculator.infer_set({ '' => 'first', 'second' => 'second' })
          expect(t.class).to eq(Puppet::Pops::Types::PHashType)
        end
      end
    end
  end

  context 'patterns' do
    it "constructs a PPatternType" do
      t = pattern_t('a(b)c')
      t.class.should == Puppet::Pops::Types::PPatternType
      t.patterns.size.should == 1
      t.patterns[0].class.should == Puppet::Pops::Types::PRegexpType
      t.patterns[0].pattern.should == 'a(b)c'
      t.patterns[0].regexp.match('abc')[1].should == 'b'
    end

    it "constructs a PStringType with multiple strings" do
      t = string_t('a', 'b', 'c', 'abc')
      t.values.should == ['a', 'b', 'c', 'abc']
    end
  end

  # Deal with cases not covered by computing common type
  context 'when computing common type' do
    it 'computes given resource type commonality' do
      r1 = Puppet::Pops::Types::PResourceType.new()
      r1.type_name = 'File'
      r2 = Puppet::Pops::Types::PResourceType.new()
      r2.type_name = 'File'
      calculator.string(calculator.common_type(r1, r2)).should == "File"

      r2 = Puppet::Pops::Types::PResourceType.new()
      r2.type_name = 'File'
      r2.title = '/tmp/foo'
      calculator.string(calculator.common_type(r1, r2)).should == "File"

      r1 = Puppet::Pops::Types::PResourceType.new()
      r1.type_name = 'File'
      r1.title = '/tmp/foo'
      calculator.string(calculator.common_type(r1, r2)).should == "File['/tmp/foo']"

      r1 = Puppet::Pops::Types::PResourceType.new()
      r1.type_name = 'File'
      r1.title = '/tmp/bar'
      calculator.string(calculator.common_type(r1, r2)).should == "File"

      r2 = Puppet::Pops::Types::PResourceType.new()
      r2.type_name = 'Package'
      r2.title = 'apache'
      calculator.string(calculator.common_type(r1, r2)).should == "Resource"
    end

    it 'computes given hostclass type commonality' do
      r1 = Puppet::Pops::Types::PHostClassType.new()
      r1.class_name = 'foo'
      r2 = Puppet::Pops::Types::PHostClassType.new()
      r2.class_name = 'foo'
      calculator.string(calculator.common_type(r1, r2)).should == "Class[foo]"

      r2 = Puppet::Pops::Types::PHostClassType.new()
      r2.class_name = 'bar'
      calculator.string(calculator.common_type(r1, r2)).should == "Class"

      r2 = Puppet::Pops::Types::PHostClassType.new()
      calculator.string(calculator.common_type(r1, r2)).should == "Class"

      r1 = Puppet::Pops::Types::PHostClassType.new()
      calculator.string(calculator.common_type(r1, r2)).should == "Class"
    end

    context 'of strings' do
      it 'computes commonality' do
        t1 = string_t('abc')
        t2 = string_t('xyz')
        common_t = calculator.common_type(t1,t2)
        expect(common_t.class).to eq(Puppet::Pops::Types::PStringType)
        expect(common_t.values).to eq(['abc', 'xyz'])
      end

      it 'computes common size_type' do
        t1 = string_t
        t1.size_type = range_t(3,6)
        t2 = string_t
        t2.size_type = range_t(2,4)
        common_t = calculator.common_type(t1,t2)
        expect(common_t.class).to eq(Puppet::Pops::Types::PStringType)
        expect(common_t.size_type).to eq(range_t(2,6))
      end

      it 'computes common size_type to be undef when one of the types has no size_type' do
        t1 = string_t
        t2 = string_t
        t2.size_type = range_t(2,4)
        common_t = calculator.common_type(t1,t2)
        expect(common_t.class).to eq(Puppet::Pops::Types::PStringType)
        expect(common_t.size_type).to be_nil
      end

      it 'computes values to be empty if the one has empty values' do
        t1 = string_t('apa')
        t1.size_type = range_t(3,6)
        t2 = string_t
        t2.size_type = range_t(2,4)
        common_t = calculator.common_type(t1,t2)
        expect(common_t.class).to eq(Puppet::Pops::Types::PStringType)
        expect(common_t.values).to be_empty
      end
    end

    it 'computes pattern commonality' do
      t1 = pattern_t('abc')
      t2 = pattern_t('xyz')
      common_t = calculator.common_type(t1,t2)
      common_t.class.should == Puppet::Pops::Types::PPatternType
      common_t.patterns.map { |pr| pr.pattern }.should == ['abc', 'xyz']
      calculator.string(common_t).should == "Pattern[/abc/, /xyz/]"
    end

    it 'computes enum commonality to value set sum' do
      t1 = enum_t('a', 'b', 'c')
      t2 = enum_t('x', 'y', 'z')
      common_t = calculator.common_type(t1, t2)
      common_t.should == enum_t('a', 'b', 'c', 'x', 'y', 'z')
    end

    it 'computed variant commonality to type union where added types are not sub-types' do
      a_t1 = integer_t()
      a_t2 = enum_t('b')
      v_a = variant_t(a_t1, a_t2)
      b_t1 = enum_t('a')
      v_b = variant_t(b_t1)
      common_t = calculator.common_type(v_a, v_b)
      common_t.class.should == Puppet::Pops::Types::PVariantType
      Set.new(common_t.types).should  == Set.new([a_t1, a_t2, b_t1])
    end

    it 'computed variant commonality to type union where added types are sub-types' do
      a_t1 = integer_t()
      a_t2 = string_t()
      v_a = variant_t(a_t1, a_t2)
      b_t1 = enum_t('a')
      v_b = variant_t(b_t1)
      common_t = calculator.common_type(v_a, v_b)
      common_t.class.should == Puppet::Pops::Types::PVariantType
      Set.new(common_t.types).should  == Set.new([a_t1, a_t2])
    end

    context "of callables" do
      it 'incompatible instances => generic callable' do
        t1 = callable_t(String)
        t2 = callable_t(Integer)
        common_t = calculator.common_type(t1, t2)
        expect(common_t.class).to be(Puppet::Pops::Types::PCallableType)
        expect(common_t.param_types).to be_nil
        expect(common_t.block_type).to be_nil
      end

      it 'compatible instances => the most specific' do
        t1 = callable_t(String)
        scalar_t = Puppet::Pops::Types::PScalarType.new
        t2 = callable_t(scalar_t)
        common_t = calculator.common_type(t1, t2)
        expect(common_t.class).to be(Puppet::Pops::Types::PCallableType)
        expect(common_t.param_types.class).to be(Puppet::Pops::Types::PTupleType)
        expect(common_t.param_types.types).to eql([string_t])
        expect(common_t.block_type).to be_nil
      end

      it 'block_type is included in the check (incompatible block)' do
        t1 = with_block_t(callable_t(String), String)
        t2 = with_block_t(callable_t(String), Integer)
        common_t = calculator.common_type(t1, t2)
        expect(common_t.class).to be(Puppet::Pops::Types::PCallableType)
        expect(common_t.param_types).to be_nil
        expect(common_t.block_type).to be_nil
      end

      it 'block_type is included in the check (compatible block)' do
        t1 = with_block_t(callable_t(String), String)
        scalar_t = Puppet::Pops::Types::PScalarType.new
        t2 = with_block_t(callable_t(String), scalar_t)
        common_t = calculator.common_type(t1, t2)
        expect(common_t.param_types.class).to be(Puppet::Pops::Types::PTupleType)
        expect(common_t.block_type).to eql(callable_t(scalar_t))
      end
    end
  end

  context 'computes assignability' do
    include_context "types_setup"

    it 'such that all types are assignable to themselves' do
      all_types.each do |tc|
        t = tc.new
        expect(t).to be_assignable_to(t)
      end
    end

    context 'for Unit, such that' do
      it 'all types are assignable to Unit' do
        t = Puppet::Pops::Types::PUnitType.new()
        all_types.each { |t2| t2.new.should be_assignable_to(t) }
      end

      it 'Unit is assignable to all other types' do
        t = Puppet::Pops::Types::PUnitType.new()
        all_types.each { |t2| t.should be_assignable_to(t2.new) }
      end

      it 'Unit is assignable to Unit' do
        t = Puppet::Pops::Types::PUnitType.new()
        t2 = Puppet::Pops::Types::PUnitType.new()
        t.should be_assignable_to(t2)
      end
    end

    context "for Any, such that" do
      it 'all types are assignable to Any' do
        t = Puppet::Pops::Types::PAnyType.new()
        all_types.each { |t2| t2.new.should be_assignable_to(t) }
      end

      it 'Any is not assignable to anything but Any and Optional (implied Optional[Any])' do
        tested_types = all_types() - [Puppet::Pops::Types::PAnyType, Puppet::Pops::Types::POptionalType]
        t = Puppet::Pops::Types::PAnyType.new()
        tested_types.each { |t2| t.should_not be_assignable_to(t2.new) }
      end
    end

    context "for NotUndef, such that" do
      it 'all types except types assignable from Undef are assignable to NotUndef' do
        t = not_undef_t
        tc = Puppet::Pops::Types::TypeCalculator.singleton
        undef_t = Puppet::Pops::Types::PUndefType.new()
        all_types().each do |c|
          t2 = c.new
          if tc.assignable?(t2, undef_t)
            expect(t2).not_to be_assignable_to(t)
          else
            expect(t2).to be_assignable_to(t)
          end
        end
      end

      it 'type NotUndef[T] is assignable from T unless T is assignable from Undef ' do
        tc = Puppet::Pops::Types::TypeCalculator.singleton
        undef_t = Puppet::Pops::Types::PUndefType.new()
        all_types().select do |c|
          t2 = c.new
          not_undef_t = not_undef_t(t2)
          if tc.assignable?(t2, undef_t)
            expect(t2).not_to be_assignable_to(not_undef_t)
          else
            expect(t2).to be_assignable_to(not_undef_t)
          end
        end
      end

      it 'type T is assignable from NotUndef[T] unless T is assignable from Undef' do
        tc = Puppet::Pops::Types::TypeCalculator.singleton
        undef_t = Puppet::Pops::Types::PUndefType.new()
        all_types().select do |c|
          t2 = c.new
          not_undef_t = not_undef_t(t2)
          unless tc.assignable?(t2, undef_t)
            expect(not_undef_t).to be_assignable_to(t2)
          end
        end
      end
    end

    context "for Data, such that" do
      it 'all scalars + array and hash are assignable to Data' do
        t = Puppet::Pops::Types::PDataType.new()
        data_compatible_types.each { |t2|
          type_from_class(t2).should be_assignable_to(t)
        }
      end

      it 'a Variant of scalar, hash, or array is assignable to Data' do
        t = Puppet::Pops::Types::PDataType.new()
        data_compatible_types.each { |t2| variant_t(type_from_class(t2)).should be_assignable_to(t) }
      end

      it 'Data is not assignable to any of its subtypes' do
        t = Puppet::Pops::Types::PDataType.new()
        types_to_test = data_compatible_types- [Puppet::Pops::Types::PDataType]
        types_to_test.each {|t2| t.should_not be_assignable_to(type_from_class(t2)) }
      end

      it 'Data is not assignable to a Variant of Data subtype' do
        t = Puppet::Pops::Types::PDataType.new()
        types_to_test = data_compatible_types- [Puppet::Pops::Types::PDataType]
        types_to_test.each { |t2| t.should_not be_assignable_to(variant_t(type_from_class(t2))) }
      end

      it 'Data is not assignable to any disjunct type' do
        tested_types = all_types - [Puppet::Pops::Types::PAnyType, Puppet::Pops::Types::POptionalType, Puppet::Pops::Types::PDataType] - scalar_types
        t = Puppet::Pops::Types::PDataType.new()
        tested_types.each {|t2| t.should_not be_assignable_to(t2.new) }
      end
    end

    context 'for Variant, such that' do
      it 'it is assignable to a type if all contained types are assignable to that type' do
        v = variant_t(range_t(10, 12),range_t(14, 20))
        v.should be_assignable_to(integer_t)
        v.should be_assignable_to(range_t(10, 20))

        # test that both types are assignable to one of the variants OK
        v.should be_assignable_to(variant_t(range_t(10, 20), range_t(30, 40)))

        # test where each type is assignable to different types in a variant is OK
        v.should be_assignable_to(variant_t(range_t(10, 13), range_t(14, 40)))

        # not acceptable
        v.should_not be_assignable_to(range_t(0, 4))
        v.should_not be_assignable_to(string_t)
      end
    end

    context "for Scalar, such that" do
      it "all scalars are assignable to Scalar" do
        t = Puppet::Pops::Types::PScalarType.new()
        scalar_types.each {|t2| t2.new.should be_assignable_to(t) }
      end

      it 'Scalar is not assignable to any of its subtypes' do
        t = Puppet::Pops::Types::PScalarType.new() 
        types_to_test = scalar_types - [Puppet::Pops::Types::PScalarType]
        types_to_test.each {|t2| t.should_not be_assignable_to(t2.new) }
      end

      it 'Scalar is not assignable to any disjunct type' do
        tested_types = all_types - [Puppet::Pops::Types::PAnyType, Puppet::Pops::Types::POptionalType, Puppet::Pops::Types::PNotUndefType, Puppet::Pops::Types::PDataType] - scalar_types
        t = Puppet::Pops::Types::PScalarType.new()
        tested_types.each {|t2| t.should_not be_assignable_to(t2.new) }
      end
    end

    context "for Numeric, such that" do
      it "all numerics are assignable to Numeric" do
        t = Puppet::Pops::Types::PNumericType.new()
        numeric_types.each {|t2| t2.new.should be_assignable_to(t) }
      end

      it 'Numeric is not assignable to any of its subtypes' do
        t = Puppet::Pops::Types::PNumericType.new()
        types_to_test = numeric_types - [Puppet::Pops::Types::PNumericType]
        types_to_test.each {|t2| t.should_not be_assignable_to(t2.new) }
      end

      it 'Numeric is not assignable to any disjunct type' do
        tested_types = all_types - [
          Puppet::Pops::Types::PAnyType,
          Puppet::Pops::Types::POptionalType,
          Puppet::Pops::Types::PNotUndefType,
          Puppet::Pops::Types::PDataType,
          Puppet::Pops::Types::PScalarType,
          ] - numeric_types
        t = Puppet::Pops::Types::PNumericType.new()
        tested_types.each {|t2| t.should_not be_assignable_to(t2.new) }
      end
    end

    context "for Collection, such that" do
      it "all collections are assignable to Collection" do
        t = Puppet::Pops::Types::PCollectionType.new()
        collection_types.each {|t2| t2.new.should be_assignable_to(t) }
      end

      it 'Collection is not assignable to any of its subtypes' do
        t = Puppet::Pops::Types::PCollectionType.new()
        types_to_test = collection_types - [Puppet::Pops::Types::PCollectionType]
        types_to_test.each {|t2| t.should_not be_assignable_to(t2.new) }
      end

      it 'Collection is not assignable to any disjunct type' do
        tested_types = all_types - [Puppet::Pops::Types::PAnyType, Puppet::Pops::Types::POptionalType, Puppet::Pops::Types::PNotUndefType] - collection_types
        t = Puppet::Pops::Types::PCollectionType.new()
        tested_types.each {|t2| t.should_not be_assignable_to(t2.new) }
      end
    end

    context "for Array, such that" do
      it "Array is not assignable to non Array based Collection type" do
        t = Puppet::Pops::Types::PArrayType.new()
        tested_types = collection_types - [
          Puppet::Pops::Types::PCollectionType,
          Puppet::Pops::Types::PNotUndefType,
          Puppet::Pops::Types::PArrayType,
          Puppet::Pops::Types::PTupleType]
        tested_types.each {|t2| t.should_not be_assignable_to(t2.new) }
      end

      it 'Array is not assignable to any disjunct type' do
        tested_types = all_types - [
          Puppet::Pops::Types::PAnyType,
          Puppet::Pops::Types::POptionalType,
          Puppet::Pops::Types::PNotUndefType,
          Puppet::Pops::Types::PDataType] - collection_types
        t = Puppet::Pops::Types::PArrayType.new()
        tested_types.each {|t2| t.should_not be_assignable_to(t2.new) }
      end
    end

    context "for Hash, such that" do
      it "Hash is not assignable to any other Collection type" do
        t = Puppet::Pops::Types::PHashType.new()
        tested_types = collection_types - [
          Puppet::Pops::Types::PCollectionType,
          Puppet::Pops::Types::PStructType,
          Puppet::Pops::Types::PHashType]
        tested_types.each {|t2| t.should_not be_assignable_to(t2.new) }
      end

      it 'Hash is not assignable to any disjunct type' do
        tested_types = all_types - [
          Puppet::Pops::Types::PAnyType,
          Puppet::Pops::Types::POptionalType,
          Puppet::Pops::Types::PNotUndefType,
          Puppet::Pops::Types::PDataType] - collection_types
        t = Puppet::Pops::Types::PHashType.new()
        tested_types.each {|t2| t.should_not be_assignable_to(t2.new) }
      end

      it 'Struct is assignable to Hash with Pattern that matches all keys' do
        struct_t({'x' => integer_t, 'y' => integer_t}).should be_assignable_to(hash_t(pattern_t(/^\w+$/), factory.any))
      end

      it 'Struct is assignable to Hash with Enum that matches all keys' do
        struct_t({'x' => integer_t, 'y' => integer_t}).should be_assignable_to(hash_t(enum_t('x', 'y', 'z'), factory.any))
      end

      it 'Struct is not assignable to Hash with Pattern unless all keys match' do
        struct_t({'a' => integer_t, 'A' => integer_t}).should_not be_assignable_to(hash_t(pattern_t(/^[A-Z]+$/), factory.any))
      end

      it 'Struct is not assignable to Hash with Enum unless all keys match' do
        struct_t({'a' => integer_t, 'y' => integer_t}).should_not be_assignable_to(hash_t(enum_t('x', 'y', 'z'), factory.any))
      end
    end

    context "for Tuple, such that" do
      it "Tuple is not assignable to any other non Array based Collection type" do
        t = Puppet::Pops::Types::PTupleType.new()
        tested_types = collection_types - [
          Puppet::Pops::Types::PCollectionType,
          Puppet::Pops::Types::PTupleType,
          Puppet::Pops::Types::PArrayType]
        tested_types.each {|t2| t.should_not be_assignable_to(t2.new) }
      end

      it 'Tuple is not assignable to any disjunct type' do
        tested_types = all_types - [
          Puppet::Pops::Types::PAnyType,
          Puppet::Pops::Types::POptionalType,
          Puppet::Pops::Types::PNotUndefType,
          Puppet::Pops::Types::PDataType] - collection_types
        t = Puppet::Pops::Types::PTupleType.new()
        tested_types.each {|t2| t.should_not be_assignable_to(t2.new) }
      end
    end

    context "for Struct, such that" do
      it "Struct is not assignable to any other non Hashed based Collection type" do
        t = Puppet::Pops::Types::PStructType.new()
        tested_types = collection_types - [
          Puppet::Pops::Types::PCollectionType,
          Puppet::Pops::Types::PStructType,
          Puppet::Pops::Types::PHashType]
        tested_types.each {|t2| t.should_not be_assignable_to(t2.new) }
      end

      it 'Struct is not assignable to any disjunct type' do
        tested_types = all_types - [
          Puppet::Pops::Types::PAnyType,
          Puppet::Pops::Types::POptionalType,
          Puppet::Pops::Types::PNotUndefType,
          Puppet::Pops::Types::PDataType] - collection_types
        t = Puppet::Pops::Types::PStructType.new()
        tested_types.each {|t2| t.should_not be_assignable_to(t2.new) }
      end

      it 'Default key optionality is controlled by value assignability to undef' do
        t1 = struct_t({'member' => string_t})
        expect(t1.elements[0].key_type).to eq(string_t('member'))
        t1 = struct_t({'member' => object_t})
        expect(t1.elements[0].key_type).to eq(optional_t(string_t('member')))
      end

      it "NotUndef['key'] becomes String['key'] (since its implied that String is required)" do
        t1 = struct_t({not_undef_t('member') => string_t})
        expect(t1.elements[0].key_type).to eq(string_t('member'))
      end

      it "Optional['key'] becomes Optional[String['key']]" do
        t1 = struct_t({optional_t('member') => string_t})
        expect(t1.elements[0].key_type).to eq(optional_t(string_t('member')))
      end

      it 'Optional members are not required' do
        t1 = struct_t({optional_t('optional_member') => string_t, not_undef_t('other_member') => string_t})
        t2 = struct_t({not_undef_t('other_member') => string_t})
        expect(t2).to be_assignable_to(t1)
      end

      it 'Required members not optional even when value is' do
        t1 = struct_t({not_undef_t('required_member') => object_t, not_undef_t('other_member') => string_t})
        t2 = struct_t({not_undef_t('other_member') => string_t})
        expect(t2).not_to be_assignable_to(t1)
      end
    end

    context "for Callable, such that" do
      it "Callable is not assignable to any disjunct type" do
        t = Puppet::Pops::Types::PCallableType.new()
        tested_types = all_types - [
          Puppet::Pops::Types::PCallableType,
          Puppet::Pops::Types::PAnyType,
          Puppet::Pops::Types::POptionalType,
          Puppet::Pops::Types::PNotUndefType]
        tested_types.each {|t2| t.should_not be_assignable_to(t2.new) }
      end
    end

    it 'should recognize mapped ruby types' do
      { Integer    => Puppet::Pops::Types::PIntegerType.new,
        Fixnum     => Puppet::Pops::Types::PIntegerType.new,
        Bignum     => Puppet::Pops::Types::PIntegerType.new,
        Float      => Puppet::Pops::Types::PFloatType.new,
        Numeric    => Puppet::Pops::Types::PNumericType.new,
        NilClass   => Puppet::Pops::Types::PUndefType.new,
        TrueClass  => Puppet::Pops::Types::PBooleanType.new,
        FalseClass => Puppet::Pops::Types::PBooleanType.new,
        String     => Puppet::Pops::Types::PStringType.new,
        Regexp     => Puppet::Pops::Types::PRegexpType.new,
        Regexp     => Puppet::Pops::Types::PRegexpType.new,
        Array      => Puppet::Pops::Types::TypeFactory.array_of_data(),
        Hash       => Puppet::Pops::Types::TypeFactory.hash_of_data()
      }.each do |ruby_type, puppet_type |
          ruby_type.should be_assignable_to(puppet_type)
      end
    end

    context 'when dealing with integer ranges' do
      it 'should accept an equal range' do
        calculator.assignable?(range_t(2,5), range_t(2,5)).should == true
      end

      it 'should accept an equal reverse range' do
        calculator.assignable?(range_t(2,5), range_t(5,2)).should == true
      end

      it 'should accept a narrower range' do
        calculator.assignable?(range_t(2,10), range_t(3,5)).should == true
      end

      it 'should accept a narrower reverse range' do
        calculator.assignable?(range_t(2,10), range_t(5,3)).should == true
      end

      it 'should reject a wider range' do
        calculator.assignable?(range_t(3,5), range_t(2,10)).should == false
      end

      it 'should reject a wider reverse range' do
        calculator.assignable?(range_t(3,5), range_t(10,2)).should == false
      end

      it 'should reject a partially overlapping range' do
        calculator.assignable?(range_t(3,5), range_t(2,4)).should == false
        calculator.assignable?(range_t(3,5), range_t(4,6)).should == false
      end

      it 'should reject a partially overlapping reverse range' do
        calculator.assignable?(range_t(3,5), range_t(4,2)).should == false
        calculator.assignable?(range_t(3,5), range_t(6,4)).should == false
      end
    end

    context 'when dealing with patterns' do
      it 'should accept a string matching a pattern' do
        p_t = pattern_t('abc')
        p_s = string_t('XabcY')
        calculator.assignable?(p_t, p_s).should == true
      end

      it 'should accept a regexp matching a pattern' do
        p_t = pattern_t(/abc/)
        p_s = string_t('XabcY')
        calculator.assignable?(p_t, p_s).should == true
      end

      it 'should accept a pattern matching a pattern' do
        p_t = pattern_t(pattern_t('abc'))
        p_s = string_t('XabcY')
        calculator.assignable?(p_t, p_s).should == true
      end

      it 'should accept a regexp matching a pattern' do
        p_t = pattern_t(regexp_t('abc'))
        p_s = string_t('XabcY')
        calculator.assignable?(p_t, p_s).should == true
      end

      it 'should accept a string matching all patterns' do
        p_t = pattern_t('abc', 'ab', 'c')
        p_s = string_t('XabcY')
        calculator.assignable?(p_t, p_s).should == true
      end

      it 'should accept multiple strings if they all match any patterns' do
        p_t = pattern_t('X', 'Y', 'abc')
        p_s = string_t('Xa', 'aY', 'abc')
        calculator.assignable?(p_t, p_s).should == true
      end

      it 'should reject a string not matching any patterns' do
        p_t = pattern_t('abc', 'ab', 'c')
        p_s = string_t('XqqqY')
        calculator.assignable?(p_t, p_s).should == false
      end

      it 'should reject multiple strings if not all match any patterns' do
        p_t = pattern_t('abc', 'ab', 'c', 'q')
        p_s = string_t('X', 'Y', 'Z')
        calculator.assignable?(p_t, p_s).should == false
      end

      it 'should accept enum matching patterns as instanceof' do
        enum = enum_t('XS', 'S', 'M', 'L' 'XL', 'XXL')
        pattern = pattern_t('S', 'M', 'L')
        calculator.assignable?(pattern, enum).should  == true
      end

      it 'pattern should accept a variant where all variants are acceptable' do
        pattern = pattern_t(/^\w+$/)
        calculator.assignable?(pattern, variant_t(string_t('a'), string_t('b'))).should == true
      end

      it 'pattern representing all patterns should accept any pattern' do
        calculator.assignable?(pattern_t(), pattern_t('a')).should == true
        calculator.assignable?(pattern_t(), pattern_t()).should == true
      end

      it 'pattern representing all patterns should accept any enum' do
        calculator.assignable?(pattern_t(), enum_t('a')).should == true
        calculator.assignable?(pattern_t(), enum_t()).should == true
      end

      it 'pattern representing all patterns should accept any string' do
        calculator.assignable?(pattern_t(), string_t('a')).should == true
        calculator.assignable?(pattern_t(), string_t()).should == true
      end

    end

    context 'when dealing with enums' do
      it 'should accept a string with matching content' do
        calculator.assignable?(enum_t('a', 'b'), string_t('a')).should == true
        calculator.assignable?(enum_t('a', 'b'), string_t('b')).should == true
        calculator.assignable?(enum_t('a', 'b'), string_t('c')).should == false
      end

      it 'should accept an enum with matching enum' do
        calculator.assignable?(enum_t('a', 'b'), enum_t('a', 'b')).should == true
        calculator.assignable?(enum_t('a', 'b'), enum_t('a')).should == true
        calculator.assignable?(enum_t('a', 'b'), enum_t('c')).should == false
      end

      it 'non parameterized enum accepts any other enum but not the reverse' do
        calculator.assignable?(enum_t(), enum_t('a')).should == true
        calculator.assignable?(enum_t('a'), enum_t()).should == false
      end

      it 'enum should accept a variant where all variants are acceptable' do
        enum = enum_t('a', 'b')
        calculator.assignable?(enum, variant_t(string_t('a'), string_t('b'))).should == true
      end
    end

    context 'when dealing with string and enum combinations' do
      it 'should accept assigning any enum to unrestricted string' do
        calculator.assignable?(string_t(), enum_t('blue')).should == true
        calculator.assignable?(string_t(), enum_t('blue', 'red')).should == true
      end

      it 'should not accept assigning longer enum value to size restricted string' do
        calculator.assignable?(constrained_t(string_t(),2,2), enum_t('a','blue')).should == false
      end

      it 'should accept assigning any string to empty enum' do
        calculator.assignable?(enum_t(), string_t()).should == true
      end

      it 'should accept assigning empty enum to any string' do
        calculator.assignable?(string_t(), enum_t()).should == true
      end

      it 'should not accept assigning empty enum to size constrained string' do
        calculator.assignable?(constrained_t(string_t(),2,2), enum_t()).should == false
      end
    end

    context 'when dealing with string/pattern/enum combinations' do
      it 'any string is equal to any enum is equal to any pattern' do
        calculator.assignable?(string_t(), enum_t()).should == true
        calculator.assignable?(string_t(), pattern_t()).should == true
        calculator.assignable?(enum_t(), string_t()).should == true
        calculator.assignable?(enum_t(), pattern_t()).should == true
        calculator.assignable?(pattern_t(), string_t()).should == true
        calculator.assignable?(pattern_t(), enum_t()).should == true
      end
    end

    context 'when dealing with tuples' do
      it 'matches empty tuples' do
        tuple1 = tuple_t()
        tuple2 = tuple_t()

        calculator.assignable?(tuple1, tuple2).should == true
        calculator.assignable?(tuple2, tuple1).should == true
      end

      it 'accepts an empty tuple as assignable to a tuple with a min size of 0' do
        tuple1 = tuple_t(Object)
        factory.constrain_size(tuple1, 0, :default)
        tuple2 = tuple_t()

        calculator.assignable?(tuple1, tuple2).should == true
        calculator.assignable?(tuple2, tuple1).should == false
      end

      it 'should accept matching tuples' do
        tuple1 = tuple_t(1,2)
        tuple2 = tuple_t(Integer,Integer)
        calculator.assignable?(tuple1, tuple2).should == true
        calculator.assignable?(tuple2, tuple1).should == true
      end

      it 'should accept matching tuples where one is more general than the other' do
        tuple1 = tuple_t(1,2)
        tuple2 = tuple_t(Numeric,Numeric)
        calculator.assignable?(tuple1, tuple2).should == false
        calculator.assignable?(tuple2, tuple1).should == true
      end

      it 'should accept ranged tuples' do
        tuple1 = tuple_t(1)
        factory.constrain_size(tuple1, 5, 5)
        tuple2 = tuple_t(Integer,Integer, Integer, Integer, Integer)
        calculator.assignable?(tuple1, tuple2).should == true
        calculator.assignable?(tuple2, tuple1).should == true
      end

      it 'should reject ranged tuples when ranges does not match' do
        tuple1 = tuple_t(1)
        factory.constrain_size(tuple1, 4, 5)
        tuple2 = tuple_t(Integer,Integer, Integer, Integer, Integer)
        calculator.assignable?(tuple1, tuple2).should == true
        calculator.assignable?(tuple2, tuple1).should == false
      end

      it 'should reject ranged tuples when ranges does not match (using infinite upper bound)' do
        tuple1 = tuple_t(1)
        factory.constrain_size(tuple1, 4, :default)
        tuple2 = tuple_t(Integer,Integer, Integer, Integer, Integer)
        calculator.assignable?(tuple1, tuple2).should == true
        calculator.assignable?(tuple2, tuple1).should == false
      end

      it 'should accept matching tuples with optional entries by repeating last' do
        tuple1 = tuple_t(1,2)
        factory.constrain_size(tuple1, 0, :default)
        tuple2 = tuple_t(Numeric,Numeric)
        factory.constrain_size(tuple2, 0, :default)
        calculator.assignable?(tuple1, tuple2).should == false
        calculator.assignable?(tuple2, tuple1).should == true
      end

      it 'should accept matching tuples with optional entries' do
        tuple1 = tuple_t(Integer, Integer, String)
        factory.constrain_size(tuple1, 1, 3)
        array2 = factory.constrain_size(array_t(Integer),2,2)
        calculator.assignable?(tuple1, array2).should == true
        factory.constrain_size(tuple1, 3, 3)
        calculator.assignable?(tuple1, array2).should == false
      end

      it 'should accept matching array' do
        tuple1 = tuple_t(1,2)
        array = array_t(Integer)
        factory.constrain_size(array, 2, 2)
        calculator.assignable?(tuple1, array).should == true
        calculator.assignable?(array, tuple1).should == true
      end

      it 'should accept empty array when tuple allows min of 0' do
        tuple1 = tuple_t(Integer)
        factory.constrain_size(tuple1, 0, 1)

        array = array_t(Integer)
        factory.constrain_size(array, 0, 0)

        calculator.assignable?(tuple1, array).should == true
        calculator.assignable?(array, tuple1).should == false
      end
    end

    context 'when dealing with structs' do
      it 'should accept matching structs' do
        struct1 = struct_t({'a'=>Integer, 'b'=>Integer})
        struct2 = struct_t({'a'=>Integer, 'b'=>Integer})
        calculator.assignable?(struct1, struct2).should == true
        calculator.assignable?(struct2, struct1).should == true
      end

      it 'should accept matching structs with less elements when unmatched elements are optional' do
        struct1 = struct_t({'a'=>Integer, 'b'=>Integer, 'c'=>optional_t(Integer)})
        struct2 = struct_t({'a'=>Integer, 'b'=>Integer})
        calculator.assignable?(struct1, struct2).should == true
      end

      it 'should reject matching structs with more elements even if excess elements are optional' do
        struct1 = struct_t({'a'=>Integer, 'b'=>Integer})
        struct2 = struct_t({'a'=>Integer, 'b'=>Integer, 'c'=>optional_t(Integer)})
        calculator.assignable?(struct1, struct2).should == false
      end

      it 'should accept matching structs where one is more general than the other with respect to optional' do
        struct1 = struct_t({'a'=>Integer, 'b'=>Integer, 'c'=>optional_t(Integer)})
        struct2 = struct_t({'a'=>Integer, 'b'=>Integer, 'c'=>Integer})
        calculator.assignable?(struct1, struct2).should == true
      end

      it 'should reject matching structs where one is more special than the other with respect to optional' do
        struct1 = struct_t({'a'=>Integer, 'b'=>Integer, 'c'=>Integer})
        struct2 = struct_t({'a'=>Integer, 'b'=>Integer, 'c'=>optional_t(Integer)})
        calculator.assignable?(struct1, struct2).should == false
      end

      it 'should accept matching structs where one is more general than the other' do
        struct1 = struct_t({'a'=>Integer, 'b'=>Integer})
        struct2 = struct_t({'a'=>Numeric, 'b'=>Numeric})
        calculator.assignable?(struct1, struct2).should == false
        calculator.assignable?(struct2, struct1).should == true
      end

      it 'should accept matching hash' do
        struct1 = struct_t({'a'=>Integer, 'b'=>Integer})
        non_empty_string = string_t()
        non_empty_string.size_type = range_t(1, nil)
        hsh = hash_t(non_empty_string, Integer)
        factory.constrain_size(hsh, 2, 2)
        calculator.assignable?(struct1, hsh).should == true
        calculator.assignable?(hsh, struct1).should == true
      end

      it 'should accept empty hash with key_type undef' do
        struct1 = struct_t({'a'=>optional_t(Integer)})
        hsh = hash_t(undef_t, undef_t)
        factory.constrain_size(hsh, 0, 0)
        calculator.assignable?(struct1, hsh).should == true
      end
    end

    it 'should recognize ruby type inheritance' do
      class Foo
      end

      class Bar < Foo
      end

      fooType = calculator.infer(Foo.new)
      barType = calculator.infer(Bar.new)

      calculator.assignable?(fooType, fooType).should == true
      calculator.assignable?(Foo, fooType).should == true

      calculator.assignable?(fooType, barType).should == true
      calculator.assignable?(Foo, barType).should == true

      calculator.assignable?(barType, fooType).should == false
      calculator.assignable?(Bar, fooType).should == false
    end

    it "should allow host class with same name" do
      hc1 = Puppet::Pops::Types::TypeFactory.host_class('the_name')
      hc2 = Puppet::Pops::Types::TypeFactory.host_class('the_name')
      calculator.assignable?(hc1, hc2).should == true
    end

    it "should allow host class with name assigned to hostclass without name" do
      hc1 = Puppet::Pops::Types::TypeFactory.host_class()
      hc2 = Puppet::Pops::Types::TypeFactory.host_class('the_name')
      calculator.assignable?(hc1, hc2).should == true
    end

    it "should reject host classes with different names" do
      hc1 = Puppet::Pops::Types::TypeFactory.host_class('the_name')
      hc2 = Puppet::Pops::Types::TypeFactory.host_class('another_name')
      calculator.assignable?(hc1, hc2).should == false
    end

    it "should reject host classes without name assigned to host class with name" do
      hc1 = Puppet::Pops::Types::TypeFactory.host_class('the_name')
      hc2 = Puppet::Pops::Types::TypeFactory.host_class()
      calculator.assignable?(hc1, hc2).should == false
    end

    it "should allow resource with same type_name and title" do
      r1 = Puppet::Pops::Types::TypeFactory.resource('file', 'foo')
      r2 = Puppet::Pops::Types::TypeFactory.resource('file', 'foo')
      calculator.assignable?(r1, r2).should == true
    end

    it "should allow more specific resource assignment" do
      r1 = Puppet::Pops::Types::TypeFactory.resource()
      r2 = Puppet::Pops::Types::TypeFactory.resource('file')
      calculator.assignable?(r1, r2).should == true
      r2 = Puppet::Pops::Types::TypeFactory.resource('file', '/tmp/foo')
      calculator.assignable?(r1, r2).should == true
      r1 = Puppet::Pops::Types::TypeFactory.resource('file')
      calculator.assignable?(r1, r2).should == true
    end

    it "should reject less specific resource assignment" do
      r1 = Puppet::Pops::Types::TypeFactory.resource('file', '/tmp/foo')
      r2 = Puppet::Pops::Types::TypeFactory.resource('file')
      calculator.assignable?(r1, r2).should == false
      r2 = Puppet::Pops::Types::TypeFactory.resource()
      calculator.assignable?(r1, r2).should == false
    end

  end

  context 'when testing if x is instance of type t' do
    include_context "types_setup"

    it 'should consider undef to be instance of Any, NilType, and optional' do
      calculator.instance?(Puppet::Pops::Types::PUndefType.new(), nil).should    == true
      calculator.instance?(Puppet::Pops::Types::PAnyType.new(), nil).should == true
      calculator.instance?(Puppet::Pops::Types::POptionalType.new(), nil).should == true
    end

    it 'all types should be (ruby) instance of PAnyType' do
      all_types.each do |t|
        t.new.is_a?(Puppet::Pops::Types::PAnyType).should == true
      end
    end

    it "should consider :undef to be instance of Undef" do
      calculator.instance?(Puppet::Pops::Types::PUndefType.new(), :undef).should == true
    end

    it "should consider :undef to be instance of an Optional type" do
      calculator.instance?(Puppet::Pops::Types::POptionalType.new(), :undef).should == true
    end

    it 'should not consider undef to be an instance of any other type than Any, UndefType and Data' do
      types_to_test = all_types - [
        Puppet::Pops::Types::PAnyType,
        Puppet::Pops::Types::PUndefType,
        Puppet::Pops::Types::PDataType,
        Puppet::Pops::Types::POptionalType,
        ]

      types_to_test.each {|t| calculator.instance?(t.new, nil).should == false }
      types_to_test.each {|t| calculator.instance?(t.new, :undef).should == false }
    end

    it 'should consider default to be instance of Default and Any' do
      calculator.instance?(Puppet::Pops::Types::PDefaultType.new(), :default).should == true
      calculator.instance?(Puppet::Pops::Types::PAnyType.new(), :default).should == true
    end

    it 'should not consider "default" to be an instance of anything but Default, NotUndef, and Any' do
      types_to_test = all_types - [
        Puppet::Pops::Types::PAnyType,
        Puppet::Pops::Types::PNotUndefType,
        Puppet::Pops::Types::PDefaultType,
        ]

      types_to_test.each {|t| calculator.instance?(t.new, :default).should == false }
    end

    it 'should consider fixnum instanceof PIntegerType' do
      calculator.instance?(Puppet::Pops::Types::PIntegerType.new(), 1).should == true
    end

    it 'should consider fixnum instanceof Fixnum' do
      calculator.instance?(Fixnum, 1).should == true
    end

    it 'should consider integer in range' do
      range = range_t(0,10)
      calculator.instance?(range, 1).should == true
      calculator.instance?(range, 10).should == true
      calculator.instance?(range, -1).should == false
      calculator.instance?(range, 11).should == false
    end

    it 'should consider string in length range' do
      range = factory.constrain_size(string_t, 1,3)
      calculator.instance?(range, 'a').should    == true
      calculator.instance?(range, 'abc').should  == true
      calculator.instance?(range, '').should     == false
      calculator.instance?(range, 'abcd').should == false
    end

    it 'should consider string values' do
      string = string_t('a', 'b')
      expect(calculator.instance?(string, 'a')).to eq(true)
      expect(calculator.instance?(string, 'b')).to eq(true)
      expect(calculator.instance?(string, 'c')).to eq(false)
    end

    it 'should consider array in length range' do
      range = factory.constrain_size(array_t(integer_t), 1,3)
      calculator.instance?(range, [1]).should    == true
      calculator.instance?(range, [1,2,3]).should  == true
      calculator.instance?(range, []).should     == false
      calculator.instance?(range, [1,2,3,4]).should == false
    end

    it 'should consider hash in length range' do
      range = factory.constrain_size(hash_t(integer_t, integer_t), 1,2)
      calculator.instance?(range, {1=>1}).should             == true
      calculator.instance?(range, {1=>1, 2=>2}).should       == true
      calculator.instance?(range, {}).should                 == false
      calculator.instance?(range, {1=>1, 2=>2, 3=>3}).should == false
    end

    it 'should consider collection in length range for array ' do
      range = factory.constrain_size(collection_t, 1,3)
      calculator.instance?(range, [1]).should    == true
      calculator.instance?(range, [1,2,3]).should  == true
      calculator.instance?(range, []).should     == false
      calculator.instance?(range, [1,2,3,4]).should == false
    end

    it 'should consider collection in length range for hash' do
      range = factory.constrain_size(collection_t, 1,2)
      calculator.instance?(range, {1=>1}).should             == true
      calculator.instance?(range, {1=>1, 2=>2}).should       == true
      calculator.instance?(range, {}).should                 == false
      calculator.instance?(range, {1=>1, 2=>2, 3=>3}).should == false
    end

    it 'should consider string matching enum as instanceof' do
      enum = enum_t('XS', 'S', 'M', 'L', 'XL', '0')
      calculator.instance?(enum, 'XS').should  == true
      calculator.instance?(enum, 'S').should   == true
      calculator.instance?(enum, 'XXL').should == false
      calculator.instance?(enum, '').should    == false
      calculator.instance?(enum, '0').should   == true
      calculator.instance?(enum, 0).should     == false
    end

    it 'should consider array[string] as instance of Array[Enum] when strings are instance of Enum' do
      enum = enum_t('XS', 'S', 'M', 'L', 'XL', '0')
      array = array_t(enum)
      calculator.instance?(array, ['XS', 'S', 'XL']).should  == true
      calculator.instance?(array, ['XS', 'S', 'XXL']).should == false
    end

    it 'should consider array[mixed] as instance of Variant[mixed] when mixed types are listed in Variant' do
      enum = enum_t('XS', 'S', 'M', 'L', 'XL')
      sizes = range_t(30, 50)
      array = array_t(variant_t(enum, sizes))
      calculator.instance?(array, ['XS', 'S', 30, 50]).should  == true
      calculator.instance?(array, ['XS', 'S', 'XXL']).should   == false
      calculator.instance?(array, ['XS', 'S', 29]).should      == false
    end

    it 'should consider array[seq] as instance of Tuple[seq] when elements of seq are instance of' do
      tuple = tuple_t(Integer, String, Float)
      calculator.instance?(tuple, [1, 'a', 3.14]).should       == true
      calculator.instance?(tuple, [1.2, 'a', 3.14]).should     == false
      calculator.instance?(tuple, [1, 1, 3.14]).should         == false
      calculator.instance?(tuple, [1, 'a', 1]).should          == false
    end

    context 'and t is Struct' do
      it 'should consider hash[cont] as instance of Struct[cont-t]' do
        struct = struct_t({'a'=>Integer, 'b'=>String, 'c'=>Float})
        calculator.instance?(struct, {'a'=>1, 'b'=>'a', 'c'=>3.14}).should       == true
        calculator.instance?(struct, {'a'=>1.2, 'b'=>'a', 'c'=>3.14}).should     == false
        calculator.instance?(struct, {'a'=>1, 'b'=>1, 'c'=>3.14}).should         == false
        calculator.instance?(struct, {'a'=>1, 'b'=>'a', 'c'=>1}).should          == false
      end

      it 'should consider empty hash as instance of Struct[x=>Optional[String]]' do
        struct = struct_t({'a'=>optional_t(String)})
        calculator.instance?(struct, {}).should == true
      end

      it 'should consider hash[cont] as instance of Struct[cont-t,optionals]' do
        struct = struct_t({'a'=>Integer, 'b'=>String, 'c'=>optional_t(Float)})
        calculator.instance?(struct, {'a'=>1, 'b'=>'a'}).should == true
      end

      it 'should consider hash[cont] as instance of Struct[cont-t,variants with optionals]' do
        struct = struct_t({'a'=>Integer, 'b'=>String, 'c'=>variant_t(String, optional_t(Float))})
        calculator.instance?(struct, {'a'=>1, 'b'=>'a'}).should == true
      end

      it 'should not consider hash[cont,cont2] as instance of Struct[cont-t]' do
        struct = struct_t({'a'=>Integer, 'b'=>String})
        calculator.instance?(struct, {'a'=>1, 'b'=>'a', 'c'=>'x'}).should == false
      end

      it 'should not consider hash[cont,cont2] as instance of Struct[cont-t,optional[cont3-t]' do
        struct = struct_t({'a'=>Integer, 'b'=>String, 'c'=>optional_t(Float)})
        calculator.instance?(struct, {'a'=>1, 'b'=>'a', 'c'=>'x'}).should == false
      end

      it 'should consider nil to be a valid element value' do
        struct = struct_t({not_undef_t('a') => object_t, 'b'=>String})
        expect(calculator.instance?(struct, {'a'=>nil , 'b'=>'a'})).to eq(true)
      end

      it 'should consider nil to be a valid element value but subject to value type' do
        struct = struct_t({not_undef_t('a') => String, 'b'=>String})
        expect(calculator.instance?(struct, {'a'=>nil , 'b'=>'a'})).to eq(false)
      end

      it 'should consider nil to be a valid element value but subject to value type even when key is optional' do
        struct = struct_t({optional_t('a') => String, 'b'=>String})
        expect(calculator.instance?(struct, {'a'=>nil , 'b'=>'a'})).to eq(false)
      end

      it 'should consider a hash where optional key is missing as assignable even if value of optional key is required' do
        struct = struct_t({optional_t('a') => String, 'b'=>String})
        expect(calculator.instance?(struct, {'b'=>'a'})).to eq(true)
      end
    end

    context 'and t is Data' do
      it 'undef should be considered instance of Data' do
        calculator.instance?(data_t, nil).should == true
      end

      it 'other symbols should not be considered instance of Data' do
        calculator.instance?(data_t, :love).should == false
      end

      it 'an empty array should be considered instance of Data' do
        calculator.instance?(data_t, []).should == true
      end

      it 'an empty hash should be considered instance of Data' do
        calculator.instance?(data_t, {}).should == true
      end

      it 'a hash with nil/undef data should be considered instance of Data' do
        calculator.instance?(data_t, {'a' => nil}).should == true
      end

      it 'a hash with nil/default key should not considered instance of Data' do
        calculator.instance?(data_t, {nil => 10}).should == false
        calculator.instance?(data_t, {:default => 10}).should == false
      end

      it 'an array with nil entries should be considered instance of Data' do
        calculator.instance?(data_t, [nil]).should == true
      end

      it 'an array with nil + data entries should be considered instance of Data' do
        calculator.instance?(data_t, [1, nil, 'a']).should == true
      end
    end

    context "and t is something Callable" do

      it 'a Closure should be considered a Callable' do
        factory = Puppet::Pops::Model::Factory
        params = [factory.PARAM('a')]
        the_block = factory.LAMBDA(params,factory.literal(42))
        the_closure = Puppet::Pops::Evaluator::Closure.new(:fake_evaluator, the_block, :fake_scope)
        expect(calculator.instance?(all_callables_t, the_closure)).to be_true
        expect(calculator.instance?(callable_t(object_t), the_closure)).to be_true
        expect(calculator.instance?(callable_t(object_t, object_t), the_closure)).to be_false
      end

      it 'a Function instance should be considered a Callable' do
        fc = Puppet::Functions.create_function(:foo) do
          dispatch :foo do
            param 'String', 'a'
          end

          def foo(a)
            a
          end
        end
        f = fc.new(:closure_scope, :loader)
        # Any callable
        expect(calculator.instance?(all_callables_t, f)).to be_true
        # Callable[String]
        expect(calculator.instance?(callable_t(String), f)).to be_true
      end
    end
  end

  context 'when converting a ruby class' do
    it 'should yield \'PIntegerType\' for Integer, Fixnum, and Bignum' do
      [Integer,Fixnum,Bignum].each do |c|
        calculator.type(c).class.should == Puppet::Pops::Types::PIntegerType
      end
    end

    it 'should yield \'PFloatType\' for Float' do
      calculator.type(Float).class.should == Puppet::Pops::Types::PFloatType
    end

    it 'should yield \'PBooleanType\' for FalseClass and TrueClass' do
      [FalseClass,TrueClass].each do |c|
        calculator.type(c).class.should == Puppet::Pops::Types::PBooleanType
      end
    end

    it 'should yield \'PUndefType\' for NilClass' do
      calculator.type(NilClass).class.should == Puppet::Pops::Types::PUndefType
    end

    it 'should yield \'PStringType\' for String' do
      calculator.type(String).class.should == Puppet::Pops::Types::PStringType
    end

    it 'should yield \'PRegexpType\' for Regexp' do
      calculator.type(Regexp).class.should == Puppet::Pops::Types::PRegexpType
    end

    it 'should yield \'PArrayType[PDataType]\' for Array' do
      t = calculator.type(Array)
      t.class.should == Puppet::Pops::Types::PArrayType
      t.element_type.class.should == Puppet::Pops::Types::PDataType
    end

    it 'should yield \'PHashType[PScalarType,PDataType]\' for Hash' do
      t = calculator.type(Hash)
      t.class.should == Puppet::Pops::Types::PHashType
      t.key_type.class.should == Puppet::Pops::Types::PScalarType
      t.element_type.class.should == Puppet::Pops::Types::PDataType
    end
  end

  context 'when representing the type as string' do
    it 'should yield \'Type\' for PType' do
      calculator.string(Puppet::Pops::Types::PType.new()).should == 'Type'
    end

    it 'should yield \'Object\' for PAnyType' do
      calculator.string(Puppet::Pops::Types::PAnyType.new()).should == 'Any'
    end

    it 'should yield \'Scalar\' for PScalarType' do
      calculator.string(Puppet::Pops::Types::PScalarType.new()).should == 'Scalar'
    end

    it 'should yield \'Boolean\' for PBooleanType' do
      calculator.string(Puppet::Pops::Types::PBooleanType.new()).should == 'Boolean'
    end

    it 'should yield \'Data\' for PDataType' do
      calculator.string(Puppet::Pops::Types::PDataType.new()).should == 'Data'
    end

    it 'should yield \'Numeric\' for PNumericType' do
      calculator.string(Puppet::Pops::Types::PNumericType.new()).should == 'Numeric'
    end

    it 'should yield \'Integer\' and from/to for PIntegerType' do
      int_T = Puppet::Pops::Types::PIntegerType
      calculator.string(int_T.new()).should == 'Integer'
      int = int_T.new()
      int.from = 1
      int.to = 1
      calculator.string(int).should == 'Integer[1, 1]'
      int = int_T.new()
      int.from = 1
      int.to = 2
      calculator.string(int).should == 'Integer[1, 2]'
      int = int_T.new()
      int.from = nil
      int.to = 2
      calculator.string(int).should == 'Integer[default, 2]'
      int = int_T.new()
      int.from = 2
      int.to = nil
      calculator.string(int).should == 'Integer[2, default]'
    end

    it 'should yield \'Float\' for PFloatType' do
      calculator.string(Puppet::Pops::Types::PFloatType.new()).should == 'Float'
    end

    it 'should yield \'Regexp\' for PRegexpType' do
      calculator.string(Puppet::Pops::Types::PRegexpType.new()).should == 'Regexp'
    end

    it 'should yield \'Regexp[/pat/]\' for parameterized PRegexpType' do
      t = Puppet::Pops::Types::PRegexpType.new()
      t.pattern = ('a/b')
      calculator.string(Puppet::Pops::Types::PRegexpType.new()).should == 'Regexp'
    end

    it 'should yield \'String\' for PStringType' do
      calculator.string(Puppet::Pops::Types::PStringType.new()).should == 'String'
    end

    it 'should yield \'String\' for PStringType with multiple values' do
      calculator.string(string_t('a', 'b', 'c')).should == 'String'
    end

    it 'should yield \'String\' and from/to for PStringType' do
      string_T = Puppet::Pops::Types::PStringType
      calculator.string(factory.constrain_size(string_T.new(), 1,1)).should == 'String[1, 1]'
      calculator.string(factory.constrain_size(string_T.new(), 1,2)).should == 'String[1, 2]'
      calculator.string(factory.constrain_size(string_T.new(), :default, 2)).should == 'String[default, 2]'
      calculator.string(factory.constrain_size(string_T.new(), 2, :default)).should == 'String[2, default]'
    end

    it 'should yield \'Array[Integer]\' for PArrayType[PIntegerType]' do
      t = Puppet::Pops::Types::PArrayType.new()
      t.element_type = Puppet::Pops::Types::PIntegerType.new()
      calculator.string(t).should == 'Array[Integer]'
    end

    it 'should yield \'Collection\' and from/to for PCollectionType' do
      col = collection_t()
      calculator.string(factory.constrain_size(col.copy, 1,1)).should == 'Collection[1, 1]'
      calculator.string(factory.constrain_size(col.copy, 1,2)).should == 'Collection[1, 2]'
      calculator.string(factory.constrain_size(col.copy, :default, 2)).should == 'Collection[default, 2]'
      calculator.string(factory.constrain_size(col.copy, 2, :default)).should == 'Collection[2, default]'
    end

    it 'should yield \'Array\' and from/to for PArrayType' do
      arr = array_t(string_t)
      calculator.string(factory.constrain_size(arr.copy, 1,1)).should == 'Array[String, 1, 1]'
      calculator.string(factory.constrain_size(arr.copy, 1,2)).should == 'Array[String, 1, 2]'
      calculator.string(factory.constrain_size(arr.copy, :default, 2)).should == 'Array[String, default, 2]'
      calculator.string(factory.constrain_size(arr.copy, 2, :default)).should == 'Array[String, 2, default]'
    end

    it 'should yield \'Tuple[Integer]\' for PTupleType[PIntegerType]' do
      t = Puppet::Pops::Types::PTupleType.new()
      t.addTypes(Puppet::Pops::Types::PIntegerType.new())
      calculator.string(t).should == 'Tuple[Integer]'
    end

    it 'should yield \'Tuple[T, T,..]\' for PTupleType[T, T, ...]' do
      t = Puppet::Pops::Types::PTupleType.new()
      t.addTypes(Puppet::Pops::Types::PIntegerType.new())
      t.addTypes(Puppet::Pops::Types::PIntegerType.new())
      t.addTypes(Puppet::Pops::Types::PStringType.new())
      calculator.string(t).should == 'Tuple[Integer, Integer, String]'
    end

    it 'should yield \'Tuple\' and from/to for PTupleType' do
      tuple_t = tuple_t(string_t)
      calculator.string(factory.constrain_size(tuple_t.copy, 1,1)).should == 'Tuple[String, 1, 1]'
      calculator.string(factory.constrain_size(tuple_t.copy, 1,2)).should == 'Tuple[String, 1, 2]'
      calculator.string(factory.constrain_size(tuple_t.copy, :default, 2)).should == 'Tuple[String, default, 2]'
      calculator.string(factory.constrain_size(tuple_t.copy, 2, :default)).should == 'Tuple[String, 2, default]'
    end

    it 'should yield \'Struct\' and details for PStructType' do
      struct_t = struct_t({'a'=>Integer, 'b'=>String})
      s = calculator.string(struct_t)
      # Ruby 1.8.7 - noone likes you...
      (s == "Struct[{'a'=>Integer, 'b'=>String}]" || s == "Struct[{'b'=>String, 'a'=>Integer}]").should == true
      struct_t = struct_t({})
      calculator.string(struct_t).should == "Struct"
    end

    it 'should yield \'Hash[String, Integer]\' for PHashType[PStringType, PIntegerType]' do
      t = Puppet::Pops::Types::PHashType.new()
      t.key_type = Puppet::Pops::Types::PStringType.new()
      t.element_type = Puppet::Pops::Types::PIntegerType.new()
      calculator.string(t).should == 'Hash[String, Integer]'
    end

    it 'should yield \'Hash\' and from/to for PHashType' do
      hsh = hash_t(string_t, string_t)
      calculator.string(factory.constrain_size(hsh.copy, 1,1)).should == 'Hash[String, String, 1, 1]'
      calculator.string(factory.constrain_size(hsh.copy, 1,2)).should == 'Hash[String, String, 1, 2]'
      calculator.string(factory.constrain_size(hsh.copy, :default, 2)).should == 'Hash[String, String, default, 2]'
      calculator.string(factory.constrain_size(hsh.copy, 2, :default)).should == 'Hash[String, String, 2, default]'
    end

    it "should yield 'Class' for a PHostClassType" do
      t = Puppet::Pops::Types::PHostClassType.new()
      calculator.string(t).should == 'Class'
    end

    it "should yield 'Class[x]' for a PHostClassType[x]" do
      t = Puppet::Pops::Types::PHostClassType.new()
      t.class_name = 'x'
      calculator.string(t).should == 'Class[x]'
    end

    it "should yield 'Resource' for a PResourceType" do
      t = Puppet::Pops::Types::PResourceType.new()
      calculator.string(t).should == 'Resource'
    end

    it 'should yield \'File\' for a PResourceType[\'File\']' do
      t = Puppet::Pops::Types::PResourceType.new()
      t.type_name = 'File'
      calculator.string(t).should == 'File'
    end

    it "should yield 'File['/tmp/foo']' for a PResourceType['File', '/tmp/foo']" do
      t = Puppet::Pops::Types::PResourceType.new()
      t.type_name = 'File'
      t.title = '/tmp/foo'
      calculator.string(t).should == "File['/tmp/foo']"
    end

    it "should yield 'Enum[s,...]' for a PEnumType[s,...]" do
      t = enum_t('a', 'b', 'c')
      calculator.string(t).should == "Enum['a', 'b', 'c']"
    end

    it "should yield 'Pattern[/pat/,...]' for a PPatternType['pat',...]" do
      t = pattern_t('a')
      t2 = pattern_t('a', 'b', 'c')
      calculator.string(t).should == "Pattern[/a/]"
      calculator.string(t2).should == "Pattern[/a/, /b/, /c/]"
    end

    it "should escape special characters in the string for a PPatternType['pat',...]" do
      t = pattern_t('a/b')
      calculator.string(t).should == "Pattern[/a\\/b/]"
    end

    it "should yield 'Variant[t1,t2,...]' for a PVariantType[t1, t2,...]" do
      t1 = string_t()
      t2 = integer_t()
      t3 = pattern_t('a')
      t = variant_t(t1, t2, t3)
      calculator.string(t).should == "Variant[String, Integer, Pattern[/a/]]"
    end

    it "should yield 'Callable' for generic callable" do
      expect(calculator.string(all_callables_t)).to eql("Callable")
    end

    it "should yield 'Callable[0,0]' for callable without params" do
      expect(calculator.string(callable_t)).to eql("Callable[0, 0]")
    end

    it "should yield 'Callable[t,t]' for callable with typed parameters" do
      expect(calculator.string(callable_t(String, Integer))).to eql("Callable[String, Integer]")
    end

    it "should yield 'Callable[t,min,max]' for callable with size constraint (infinite max)" do
      expect(calculator.string(callable_t(String, 0))).to eql("Callable[String, 0, default]")
    end

    it "should yield 'Callable[t,min,max]' for callable with size constraint (capped max)" do
      expect(calculator.string(callable_t(String, 0, 3))).to eql("Callable[String, 0, 3]")
    end

    it "should yield 'Callable[min,max]' callable with size > 0" do
      expect(calculator.string(callable_t(0, 0))).to eql("Callable[0, 0]")
      expect(calculator.string(callable_t(0, 1))).to eql("Callable[0, 1]")
      expect(calculator.string(callable_t(0, :default))).to eql("Callable[0, default]")
    end

    it "should yield 'Callable[Callable]' for callable with block" do
      expect(calculator.string(callable_t(all_callables_t))).to eql("Callable[0, 0, Callable]")
      expect(calculator.string(callable_t(string_t, all_callables_t))).to eql("Callable[String, Callable]")
      expect(calculator.string(callable_t(string_t, 1,1, all_callables_t))).to eql("Callable[String, 1, 1, Callable]")
    end

    it "should yield Unit for a Unit type" do
      expect(calculator.string(unit_t)).to eql('Unit')
    end

    it "should yield 'NotUndef' for a PNotUndefType" do
      t = not_undef_t
      expect(calculator.string(t)).to eq('NotUndef')
    end

    it "should yield 'NotUndef[T]' for a PNotUndefType[T]" do
      t = not_undef_t(data_t)
      expect(calculator.string(t)).to eq('NotUndef[Data]')
    end

    it "should yield 'NotUndef['string']' for a PNotUndefType['string']" do
      t = not_undef_t('hey')
      expect(calculator.string(t)).to eq("NotUndef['hey']")
    end
  end

  context 'when processing meta type' do
    it 'should infer PType as the type of all other types' do
      ptype = Puppet::Pops::Types::PType
      calculator.infer(Puppet::Pops::Types::PUndefType.new()       ).is_a?(ptype).should() == true
      calculator.infer(Puppet::Pops::Types::PDataType.new()      ).is_a?(ptype).should() == true
      calculator.infer(Puppet::Pops::Types::PScalarType.new()   ).is_a?(ptype).should() == true
      calculator.infer(Puppet::Pops::Types::PStringType.new()    ).is_a?(ptype).should() == true
      calculator.infer(Puppet::Pops::Types::PNumericType.new()   ).is_a?(ptype).should() == true
      calculator.infer(Puppet::Pops::Types::PIntegerType.new()   ).is_a?(ptype).should() == true
      calculator.infer(Puppet::Pops::Types::PFloatType.new()     ).is_a?(ptype).should() == true
      calculator.infer(Puppet::Pops::Types::PRegexpType.new()   ).is_a?(ptype).should() == true
      calculator.infer(Puppet::Pops::Types::PBooleanType.new()   ).is_a?(ptype).should() == true
      calculator.infer(Puppet::Pops::Types::PCollectionType.new()).is_a?(ptype).should() == true
      calculator.infer(Puppet::Pops::Types::PArrayType.new()     ).is_a?(ptype).should() == true
      calculator.infer(Puppet::Pops::Types::PHashType.new()      ).is_a?(ptype).should() == true
      calculator.infer(Puppet::Pops::Types::PRuntimeType.new()   ).is_a?(ptype).should() == true
      calculator.infer(Puppet::Pops::Types::PHostClassType.new() ).is_a?(ptype).should() == true
      calculator.infer(Puppet::Pops::Types::PResourceType.new()  ).is_a?(ptype).should() == true
      calculator.infer(Puppet::Pops::Types::PEnumType.new()      ).is_a?(ptype).should() == true
      calculator.infer(Puppet::Pops::Types::PPatternType.new()   ).is_a?(ptype).should() == true
      calculator.infer(Puppet::Pops::Types::PVariantType.new()   ).is_a?(ptype).should() == true
      calculator.infer(Puppet::Pops::Types::PTupleType.new()     ).is_a?(ptype).should() == true
      calculator.infer(Puppet::Pops::Types::POptionalType.new()  ).is_a?(ptype).should() == true
      calculator.infer(Puppet::Pops::Types::PCallableType.new()  ).is_a?(ptype).should() == true
    end

    it 'should infer PType as the type of all other types' do
      ptype = Puppet::Pops::Types::PType
      calculator.string(calculator.infer(Puppet::Pops::Types::PUndefType.new()       )).should == "Type[Undef]"
      calculator.string(calculator.infer(Puppet::Pops::Types::PDataType.new()      )).should == "Type[Data]"
      calculator.string(calculator.infer(Puppet::Pops::Types::PScalarType.new()   )).should == "Type[Scalar]"
      calculator.string(calculator.infer(Puppet::Pops::Types::PStringType.new()    )).should == "Type[String]"
      calculator.string(calculator.infer(Puppet::Pops::Types::PNumericType.new()   )).should == "Type[Numeric]"
      calculator.string(calculator.infer(Puppet::Pops::Types::PIntegerType.new()   )).should == "Type[Integer]"
      calculator.string(calculator.infer(Puppet::Pops::Types::PFloatType.new()     )).should == "Type[Float]"
      calculator.string(calculator.infer(Puppet::Pops::Types::PRegexpType.new()    )).should == "Type[Regexp]"
      calculator.string(calculator.infer(Puppet::Pops::Types::PBooleanType.new()   )).should == "Type[Boolean]"
      calculator.string(calculator.infer(Puppet::Pops::Types::PCollectionType.new())).should == "Type[Collection]"
      calculator.string(calculator.infer(Puppet::Pops::Types::PArrayType.new()     )).should == "Type[Array[?]]"
      calculator.string(calculator.infer(Puppet::Pops::Types::PHashType.new()      )).should == "Type[Hash[?, ?]]"
      calculator.string(calculator.infer(Puppet::Pops::Types::PRuntimeType.new()   )).should == "Type[Runtime[?, ?]]"
      calculator.string(calculator.infer(Puppet::Pops::Types::PHostClassType.new() )).should == "Type[Class]"
      calculator.string(calculator.infer(Puppet::Pops::Types::PResourceType.new()  )).should == "Type[Resource]"
      calculator.string(calculator.infer(Puppet::Pops::Types::PEnumType.new()      )).should == "Type[Enum]"
      calculator.string(calculator.infer(Puppet::Pops::Types::PVariantType.new()   )).should == "Type[Variant]"
      calculator.string(calculator.infer(Puppet::Pops::Types::PPatternType.new()   )).should == "Type[Pattern]"
      calculator.string(calculator.infer(Puppet::Pops::Types::PTupleType.new()     )).should == "Type[Tuple]"
      calculator.string(calculator.infer(Puppet::Pops::Types::POptionalType.new()  )).should == "Type[Optional]"
      calculator.string(calculator.infer(Puppet::Pops::Types::PCallableType.new()  )).should == "Type[Callable]"

      calculator.infer(Puppet::Pops::Types::PResourceType.new(:type_name => 'foo::fee::fum')).to_s.should == "Type[Foo::Fee::Fum]"
      calculator.string(calculator.infer(Puppet::Pops::Types::PResourceType.new(:type_name => 'foo::fee::fum'))).should == "Type[Foo::Fee::Fum]"
      calculator.infer(Puppet::Pops::Types::PResourceType.new(:type_name => 'Foo::Fee::Fum')).to_s.should == "Type[Foo::Fee::Fum]"
    end

    it "computes the common type of PType's type parameter" do
      int_t    = Puppet::Pops::Types::PIntegerType.new()
      string_t = Puppet::Pops::Types::PStringType.new()
      calculator.string(calculator.infer([int_t])).should == "Array[Type[Integer], 1, 1]"
      calculator.string(calculator.infer([int_t, string_t])).should == "Array[Type[Scalar], 2, 2]"
    end

    it 'should infer PType as the type of ruby classes' do
      class Foo
      end
      [Object, Numeric, Integer, Fixnum, Bignum, Float, String, Regexp, Array, Hash, Foo].each do |c|
        calculator.infer(c).is_a?(Puppet::Pops::Types::PType).should() == true
      end
    end

    it 'should infer PType as the type of PType (meta regression short-circuit)' do
      calculator.infer(Puppet::Pops::Types::PType.new()).is_a?(Puppet::Pops::Types::PType).should() == true
    end

    it 'computes instance? to be true if parameterized and type match' do
      int_t    = Puppet::Pops::Types::PIntegerType.new()
      type_t   = Puppet::Pops::Types::TypeFactory.type_type(int_t)
      type_type_t   = Puppet::Pops::Types::TypeFactory.type_type(type_t)
      calculator.instance?(type_type_t, type_t).should == true
    end

    it 'computes instance? to be false if parameterized and type do not match' do
      int_t    = Puppet::Pops::Types::PIntegerType.new()
      string_t = Puppet::Pops::Types::PStringType.new()
      type_t   = Puppet::Pops::Types::TypeFactory.type_type(int_t)
      type_t2   = Puppet::Pops::Types::TypeFactory.type_type(string_t)
      type_type_t   = Puppet::Pops::Types::TypeFactory.type_type(type_t)
      # i.e. Type[Integer] =~ Type[Type[Integer]] # false
      calculator.instance?(type_type_t, type_t2).should == false
    end

    it 'computes instance? to be true if unparameterized and matched against a type[?]' do
      int_t    = Puppet::Pops::Types::PIntegerType.new()
      type_t   = Puppet::Pops::Types::TypeFactory.type_type(int_t)
      calculator.instance?(Puppet::Pops::Types::PType.new, type_t).should == true
    end
  end

  context "when asking for an enumerable " do
    it "should produce an enumerable for an Integer range that is not infinite" do
      t = Puppet::Pops::Types::PIntegerType.new()
      t.from = 1
      t.to = 10
      calculator.enumerable(t).respond_to?(:each).should == true
    end

    it "should not produce an enumerable for an Integer range that has an infinite side" do
      t = Puppet::Pops::Types::PIntegerType.new()
      t.from = nil
      t.to = 10
      calculator.enumerable(t).should == nil

      t = Puppet::Pops::Types::PIntegerType.new()
      t.from = 1
      t.to = nil
      calculator.enumerable(t).should == nil
    end

    it "all but Integer range are not enumerable" do
      [Object, Numeric, Float, String, Regexp, Array, Hash].each do |t|
        calculator.enumerable(calculator.type(t)).should == nil
      end
    end
  end

  context "when dealing with different types of inference" do
    it "an instance specific inference is produced by infer" do
      calculator.infer(['a','b']).element_type.values.should == ['a', 'b']
    end

    it "a generic inference is produced using infer_generic" do
      calculator.infer_generic(['a','b']).element_type.values.should == []
    end

    it "a generic result is created by generalize! given an instance specific result for an Array" do
      generic = calculator.infer(['a','b'])
      generic.element_type.values.should == ['a', 'b']
      calculator.generalize!(generic)
      generic.element_type.values.should == []
    end

    it 'a generic result is created by generalize! given an instance specific result for a Hash' do
      generic = calculator.infer({'a' =>1,'b' => 2})
      generic.key_type.values.sort.should == ['a', 'b']
      generic.element_type.from.should == 1
      generic.element_type.to.should == 2
      calculator.generalize!(generic)
      generic.key_type.values.should == []
      generic.element_type.from.should == nil
      generic.element_type.to.should == nil
    end

    it 'ensures that Struct key types are not generalized' do
      generic = calculator.generalize!(struct_t({'a' => object_t}))
      expect(calculator.string(generic)).to eq("Struct[{'a'=>Any}]")
      generic = calculator.generalize!(struct_t({not_undef_t('a') => object_t}))
      expect(calculator.string(generic)).to eq("Struct[{NotUndef['a']=>Any}]")
      generic = calculator.generalize!(struct_t({optional_t('a') => string_t}))
      expect(calculator.string(generic)).to eq("Struct[{Optional['a']=>String}]")
    end

    it 'ensures that Struct value types are generalized' do
      generic = calculator.generalize!(struct_t({'a' => range_t(1, 3)}))
      expect(calculator.string(generic)).to eq("Struct[{'a'=>Integer}]")
    end

    it "does not reduce by combining types when using infer_set" do
      element_type = calculator.infer(['a','b',1,2]).element_type
      element_type.class.should == Puppet::Pops::Types::PScalarType
      inferred_type = calculator.infer_set(['a','b',1,2])
      inferred_type.class.should == Puppet::Pops::Types::PTupleType
      element_types = inferred_type.types
      element_types[0].class.should == Puppet::Pops::Types::PStringType
      element_types[1].class.should == Puppet::Pops::Types::PStringType
      element_types[2].class.should == Puppet::Pops::Types::PIntegerType
      element_types[3].class.should == Puppet::Pops::Types::PIntegerType
    end

    it "does not reduce by combining types when using infer_set and values are undef" do
      element_type = calculator.infer(['a',nil]).element_type
      element_type.class.should == Puppet::Pops::Types::PStringType
      inferred_type = calculator.infer_set(['a',nil])
      inferred_type.class.should == Puppet::Pops::Types::PTupleType
      element_types = inferred_type.types
      element_types[0].class.should == Puppet::Pops::Types::PStringType
      element_types[1].class.should == Puppet::Pops::Types::PUndefType
    end
  end

  context 'when determening callability' do
    context 'and given is exact' do
      it 'with callable' do
        required = callable_t(string_t)
        given = callable_t(string_t)
        calculator.callable?(required, given).should == true
      end

      it 'with args tuple' do
        required = callable_t(string_t)
        given = tuple_t(string_t)
        calculator.callable?(required, given).should == true
      end

      it 'with args tuple having a block' do
        required = callable_t(string_t, callable_t(string_t))
        given = tuple_t(string_t, callable_t(string_t))
        calculator.callable?(required, given).should == true
      end

      it 'with args array' do
        required = callable_t(string_t)
        given = array_t(string_t)
        factory.constrain_size(given, 1, 1)
        calculator.callable?(required, given).should == true
      end
    end

    context 'and given is more generic' do
      it 'with callable' do
        required = callable_t(string_t)
        given = callable_t(object_t)
        calculator.callable?(required, given).should == true
      end

      it 'with args tuple' do
        required = callable_t(string_t)
        given = tuple_t(object_t)
        calculator.callable?(required, given).should == false
      end

      it 'with args tuple having a block' do
        required = callable_t(string_t, callable_t(string_t))
        given = tuple_t(string_t, callable_t(object_t))
        calculator.callable?(required, given).should == true
      end

      it 'with args tuple having a block with captures rest' do
        required = callable_t(string_t, callable_t(string_t))
        given = tuple_t(string_t, callable_t(object_t, 0, :default))
        calculator.callable?(required, given).should == true
      end
    end

    context 'and given is more specific' do
      it 'with callable' do
        required = callable_t(object_t)
        given = callable_t(string_t)
        calculator.callable?(required, given).should == false
      end

      it 'with args tuple' do
        required = callable_t(object_t)
        given = tuple_t(string_t)
        calculator.callable?(required, given).should == true
      end

      it 'with args tuple having a block' do
        required = callable_t(string_t, callable_t(object_t))
        given = tuple_t(string_t, callable_t(string_t))
        calculator.callable?(required, given).should == false
      end

      it 'with args tuple having a block with captures rest' do
        required = callable_t(string_t, callable_t(object_t))
        given = tuple_t(string_t, callable_t(string_t, 0, :default))
        calculator.callable?(required, given).should == false
      end
    end
  end

  matcher :be_assignable_to do |type|
    calc = Puppet::Pops::Types::TypeCalculator.singleton

    match do |actual|
      calc.assignable?(type, actual)
    end

    failure_message_for_should do |actual|
      "#{calc.string(actual)} should be assignable to #{calc.string(type)}"
    end

    failure_message_for_should_not do |actual|
      "#{calc.string(actual)} is assignable to #{calc.string(type)} when it should not"
    end
  end

end
