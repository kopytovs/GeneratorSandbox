# frozen_string_literal: true

require_relative 'gen_types'

# Служит для логгирования сообщений
class LogManager
  def self.log_msg(msg)
    puts msg if VERBOSE_MODE
  end
end
