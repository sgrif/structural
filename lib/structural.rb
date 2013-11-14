require "structural/version"
require "structural/base"

class Structural
  def self.new(*attrs, &block)
    klass = Class.new(Base) do
      attr_accessor(*attrs)
      attrs.each do |attr|
        private :"#{attr}="
      end

      def self.new(*args, &block)
        subclass_new(*args, &block)
      end

      def self.with_defaults(defaults, &block)
        klass = Class.new(self) do
          const_set :STRUCTURAL_ATTR_DEFAULTS, defaults
        end

        Structural.run_klass_block(klass, &block)
      end

      const_set :STRUCTURAL_ATTR_NAMES, attrs
    end

    run_klass_block(klass, &block)
  end

  protected

  def self.run_klass_block(klass, &block)
    if block
      klass.module_eval(&block)
    end

    klass
  end
end
