# frozen_string_literal: true

require_relative 'gen_commands'
require_relative 'gen_types'

# Класс для работы с командами скрипта
class GenCommandManager
  # Определяет по ключу, является ли определенной командой
  def self.is_command(name, command)
    [command.full, command.short].include?(name)
  end

  # Возвращает список найденных команд
  def self.command_list(arguments)
    commands = arguments.select do |arg|
      arg[0] == '-'
    end
    LogManager.log_msg("Найдены команды #{commands}")
    return commands
  end

  # Определяет, есть ли среди команд неизвестные
  def self.check_commands_availability(commands)
    all_available = true
    commands.each do |command|
      all_available = !command_for_key(command).nil?
    end
    LogManager.log_msg("Все команды валидны: #{all_available}")
    return all_available
  end

  # Возвращает список параметров для команды инициализации
  def self.initialization_parameters(arguments)
    command_parameters(arguments, GenCommand.initialization)
  end

  # Возвращает список параметров для команды перезаписи
  def self.rewrite_parameters(arguments)
    command_parameters(arguments, GenCommand.rewrite)
  end

  # Содержит ли список аргументов указанную команду
  def self.contains_command(arguments, command)
    contains_short = arguments.include? command.short
    contains_full = arguments.include? command.full
    return contains_short || contains_full
  end

  # Возвращает индекс комманды в списке
  def self.index_of_command(arguments, command)
    index = arguments.index(command.short)
    index = arguments.index(command.full) if index.nil?
    LogManager.log_msg("Индекс комманды #{command} в списке #{arguments} - #{index}")
    return index
  end

  # Возвращает параметры команды
  def self.command_parameters(arguments, command)
    LogManager.log_msg("Поиск параметров для команды #{command} в #{arguments}")
    commands = command_list(arguments)
    command_index = index_of_command(arguments, command)

    return nil if command_index.nil?

    last_command = commands[commands.size - 1]
    last_index = arguments.size

    unless is_command(last_command, command)
      init_command_index = index_of_command(commands, command)
      next_command = commands[init_command_index + 1]
      last_index = arguments.index(next_command)
    end

    start_index = command_index + 1
    size = last_index - start_index

    found_arguments = arguments.slice(start_index, size)
    LogManager.log_msg("Найдены аргументы #{found_arguments} для команды #{command}")
    return found_arguments
  end

  # Возвращает команду по ключу
  def self.command_for_key(key)
    result_command = nil
    GenCommand.commands_list.each do |command|
      result_command = command if is_command(key, command)
    end
    LogManager.log_msg("Найдена команда #{result_command} по ключу #{key}")
    return result_command
  end
end
