# frozen_string_literal: true
require_relative 'modules'

class Wagons
  include Manufacturer
  attr_reader :type
end
