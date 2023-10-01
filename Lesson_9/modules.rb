# frozen_string_literal: true

module Manufacturer
  attr_accessor :name
end

module InstanceCounter
  def self.included(base)
    base.extend ClassMethods
    base.send :include, InstanceMethods
  end

  module ClassMethods
    attr_accessor :instance_count

    def instances
      instance_count
    end
  end

  module InstanceMethods
    protected

    def register_instance
      self.class.instance_count ||= 0
      self.class.instance_count += 1
    end
  end
end

module Validation
  def self.included(base)
    base.extend ClassMethods
    base.include InstanceMethods
  end

  module ClassMethods
    attr_accessor :validations

    def validate(attr_name, type, *args)
      @validations ||= []
      @validations << { attr_name: attr_name, type: type, args: args}
    end
  end

  module InstanceMethods
    def validate!
      self.class.validations.each do |validation|
        attr = instance_variable_get("@#{validation[:attr_name]}".to_sym)
        send("#{validation[:type]}_validate", attr, validation[:args])
      end
    end

    def valid?
      validate!
    rescue StandardError
      false
    end

    def presence_validate(attr)
      raise "The attribute value must not be empty" if attr == "" || attr.nil?
    end

    def format_validate(attr, format)
      raise "Attribute does not match the format" if attr !~ format
    end

    def type_validate(attr, attr_class)
      raise "Class is not correctly specified" unless attr.is_a?(attr_class)
    end
  end
end

module Acсessors
  def attr_accessor_with_history(*names)
    names.each do |name|
      var_name = "@#{name}".to_sym
      var_history = "@#{name}_history".to_sym

      define_method(name) { instance_variable_get(var_name) }
      define_method("#{name}=") do |value|
        if instance_variable_get(var_history).nil?
          instance_variable_set(var_history, [])
        else
          instance_variable_get(var_history) << instance_variable_get(var_name)
        end
        instance_variable_set(var_name, value)
      end
    end
  end

  def strong_attr_accessor(name, attr_class)
    define_method(name.to_s) { instance_variable_get(":@#{name}") }
    define_method("#{name}=") do |value|
      raise(ArgumentError, "Class is not correctly specified") unless value.is_a? attr_class
      instance_variable_set("@#{name}", value)
    end
  end
end