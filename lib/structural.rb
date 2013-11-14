require "structural/version"

class Structural
  class << self
    alias_method :subclass_new, :new
  end

  def self.new(*attrs, &block)
    klass = Class.new(self) do
      attr_accessor(*attrs)

      def self.new(*args, &block)
        subclass_new(*args, &block)
      end

      const_set :STRUCTURAL_ATTR_NAMES, attrs
    end

    if block
      klass.module_eval(&block)
    end

    klass
  end

  def initialize(*args)
    if args.size != attr_names.size
      raise ArgumentError.new("Expected #{attr_names.size} arguments, got #{args.size}")
    end

    attr_names.each_with_index do |attr, i|
      instance_variable_set :"@#{attr}", args[i]
    end
  end

  private

  def attr_names
    self.class::STRUCTURAL_ATTR_NAMES
  end
end
