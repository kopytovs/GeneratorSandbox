# frozen_string_literal: true

require_relative 'gen_types'

# Служит для логгирования сообщений
class LogManager
  # Флаг логгирования
  class << self
    attr_accessor :verbose_mode
  end

  def self.log_msg(msg)
    puts msg if verbose_mode
  end
end
