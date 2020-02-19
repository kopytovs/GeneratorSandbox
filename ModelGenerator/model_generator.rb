# frozen_string_literal: true

require 'mustache'
require 'json'
require_relative './GenModules/gen_types'
require_relative './GenModules/gen_file_reader'
require_relative './GenModules/gen_log_manager.rb'
require_relative './GenModules/gen_command_actions'

arguments = ARGV.clone
models = FileReader.templates

if arguments.length < 3
  puts GenError.GEN_HELP_MESSAGE
else
  module_name = arguments[0]
  submodule_name = arguments[1]
  submodule_path = "#{StaticPath.MODULES_PATH}#{module_name}/#{submodule_name}/"
  command = arguments[2]
  submodule_json_mask = "#{submodule_path}**/*_gen.json"
  potential_verbose = arguments.pop

  if GenCommand.is_verbose(potential_verbose)
    VERBOSE_MODE = true
    LogManager.log_msg("Режим логгирования включен")
  else
    arguments.push(potential_verbose)
  end

  unless Dir.exist? submodule_path
    puts GenError.GEN_SUBMODULE_NOT_EXIST
    exit
  end

  if GenCommand.is_generate(command)
    # Запустить генерация
    CommandActions.generate_models(submodule_path, module_name, models, submodule_json_mask)
  elsif GenCommand.is_initialization(command)
    # запустить инициализацию JSON файлов
    CommandActions.init_jsons(submodule_path, arguments)
  elsif GenCommand.is_seeds(command)
    # Запустить генерацию сидов
    CommandActions.generate_seeds(submodule_path, submodule_json_mask, models)
  elsif GenCommand.is_generate_with_seeds(command)
    # Запустить генерацию + генерацию сидов
    CommandActions.generate_models(submodule_path, module_name, models, submodule_json_mask)
    CommandActions.generate_seeds(submodule_path, submodule_json_mask, models)
  else
    puts GenError.GEN_HELP_MESSAGE
  end
end
