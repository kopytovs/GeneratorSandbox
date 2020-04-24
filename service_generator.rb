# frozen_string_literal: true

require 'service_generator'

generator = ServiceGenerator::ServiceGenerator.new

generator.generate_models(ARGV.clone)
