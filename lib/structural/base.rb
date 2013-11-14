class Structural
  class Base
    class << self
      alias_method :subclass_new, :new
    end

    def initialize(*args)
      default_values.each do |name, value|
        idx = attr_names.index(name)
        if (args.fetch(idx, NoSuchDefault) == NoSuchDefault)
          args[idx] = value
        end
      end

      if args.size != attr_names.size
        raise ArgumentError.new("Expected #{attr_names.size} arguments, got #{args.size}")
      end

      attr_names.each_with_index do |attr, i|
        instance_variable_set :"@#{attr}", args[i]
      end

      freeze
    end

    def copy(new_values)
      transform do
        new_values.each do |attr, value|
          instance_variable_set(:"@#{attr}", value)
        end
      end
    end

    def ==(other)
      attr_names.all? do |attr|
        other.instance_of?(self.class) &&
          (recursive_reference?(other, attr) || send(attr) == other.send(attr))
      end
    end

    def hash
      hash_val = attr_names.size
      attr_names.each do |attr|
        value = send(attr)
        unless value.equal?(self)
          hash_val ^= value.hash
        end
      end
      hash_val
    end

    private

    def attr_names
      self.class::STRUCTURAL_ATTR_NAMES
    end

    def default_values
      if self.class.const_defined?(:STRUCTURAL_ATTR_DEFAULTS)
        self.class::STRUCTURAL_ATTR_DEFAULTS
      else
        {}
      end
    end

    def transform(&block)
      dup.tap do |copy|
        copy.instance_eval(&block)
      end
    end

    def recursive_reference?(other, attr)
      send(attr).equal?(self) && other.send(attr).equal?(self)
    end

    NoSuchDefault = Object.new
  end
end
