# frozen_string_literal: true

require 'mustache'
require 'json'
require_relative './GenModules/gen_types'
require_relative './GenModules/gen_file_reader'
require_relative './GenModules/gen_log_manager.rb'
require_relative './GenModules/gen_command_actions'
require_relative './GenModules/gen_command_manager'

arguments = ARGV.clone
models = FileReader.templates

commands = GenCommandManager.command_list(arguments)

LogManager.verbose_mode = GenCommandManager.contains_command(arguments, GenCommand.verbose)

LogManager.log_msg("Получены команды #{commands}")

if commands.empty? || !GenCommandManager.check_commands_availability(commands)
  puts GenError.GEN_HELP_MESSAGE
else
  module_name = arguments[0]
  submodule_name = arguments[1]
  submodule_path = "#{StaticPath.MODULES_PATH}#{module_name}/#{submodule_name}/"
  submodule_json_mask = "#{submodule_path}#{JSON_FILES_SUFFIX}"

  LogManager.log_msg("Найден модуль #{module_name}")
  LogManager.log_msg("Найден сабмодуль #{submodule_name}")
  LogManager.log_msg("Путь к сабмодулю #{submodule_path}")
  LogManager.log_msg("Путь к конфигурационным json-файлам #{submodule_json_mask}")

  unless GenCommandManager.contains_command(arguments, GenCommand.initialization) ||
         FileReader.check_json_files(submodule_json_mask)
    exit
  end

  unless Dir.exist? submodule_path
    puts GenError.GEN_SUBMODULE_NOT_EXIST
    exit
  end

  if GenCommandManager.contains_command(arguments, GenCommand.rewrite)
    LogManager.log_msg("Найдена команда перезаписи файлов")

    all_models = FileReader.get_all_jsons(submodule_json_mask)
    all_models_names = all_models.map { |m| m["name"] }
    rewrite_parameters = GenCommandManager.command_parameters(arguments, GenCommand.rewrite)
    FileReader.rewriting_models = rewrite_parameters.empty? ? all_models_names : rewrite_parameters

    LogManager.log_msg("Будут перезаписаны модели #{FileReader.rewriting_models}")
  end

  if GenCommandManager.contains_command(arguments, GenCommand.initialization)
    LogManager.log_msg("Найдена команда инциализации json-файлов")
    # Запустить инициализацию JSON файлов
    init_model_names = GenCommandManager.initialization_parameters(arguments)
    init_model_names.push(JSON_DEFAULT_NAME) if init_model_names.empty?
    LogManager.log_msg("Будут инциализированы json файлы #{init_model_names}")
    CommandActions.init_jsons(submodule_path, init_model_names)
  end
  if GenCommandManager.contains_command(arguments, GenCommand.generate)
    LogManager.log_msg("Найдена команда генерации моделей, трансляторов и тестов к ним")
    # Запустить генерацию моделей
    CommandActions.generate_models(submodule_path, module_name, models, submodule_json_mask)
  end

  if GenCommandManager.contains_command(arguments, GenCommand.seeds_generate)
    LogManager.log_msg("Найдена команда генерации сидов")
    # Запустить генерацию сидов
    CommandActions.generate_seeds(submodule_path, submodule_json_mask, models)
  end

end
