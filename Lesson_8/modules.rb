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

module Valid
  def valid?
    validate!
  rescue StandardError
    false
  end
end
