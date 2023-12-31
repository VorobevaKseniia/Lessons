# frozen_string_literal: true

module Manufacturer
  attr_accessor :manufacturer

  def manufacturer(name)
    @manufacturer = name
  end
end

module InstanceCounter
  # Чтобы мы могли использовать include InstanceCounter
  # *base -> в качестве аргумента передается класс
  def self.included(base)  # Метод самого модуля
    base.extend ClassMethods
    base.send :include, InstanceMethods
  end

  module ClassMethods
    attr_accessor :instances

    def instances
      @instances ||= 0  # если nil/ false, то 0
    end

    def increase_instances
      @instances ||= 0
      @instances += 1
    end
  end

  module InstanceMethods

    def register_instance
      self.class.increase_instances
    end
  end
end

module Valid
  def valid?
    validate!
  rescue
    false
  end
end