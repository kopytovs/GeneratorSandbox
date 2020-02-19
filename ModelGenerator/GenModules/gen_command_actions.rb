# frozen_string_literal: true

require 'mustache'
require 'json'
require_relative 'gen_types'
require_relative 'gen_model_generator'
require_relative 'gen_file_reader'
require_relative 'gen_log_manager.rb'

# Реализация комманд скрипта
class CommandActions
  # Инициализация json файлов
  def self.init_jsons(submodule_path, arguments)
    LogManager.log_msg("Запущен процесс инцииализации json файлов")

    generator = ModelGenerator.new
    json_model_path = StaticPath.JSON_MODEL_PATH

    json_path = "#{submodule_path}#{StaticPath.JSON_SUBPATH}"
    FileReader.touch_directory(json_path)

    json_names = []

    if arguments.length == 3
      json_names.push(JSON_DEFAULT_NAME)
    else
      (3...arguments.length).each do |i|
        json_names.push(arguments[i])
      end
    end

    LogManager.log_msg("Получены модели: #{json_names}")

    json_model = FileReader.read_model(json_model_path)

    generator.init_json_directory(submodule_path, json_path, json_model, json_names)

    LogManager.log_msg("Инициализация завершена успешно")
  end

  # Генерация моделей, трансляторов и тестов к ним
  def self.generate_models(submodule_path, module_name, models, submodule_json_mask)
    LogManager.log_msg("Запущен процесс генерации")

    unless FileReader.check_json_files(submodule_json_mask)
      LogManager.log_msg("Генерация не завершена")
      exit
    end

    generator = ModelGenerator.new

    models_path = "#{submodule_path}#{StaticPath.MODEL_SUBPATH}"
    translators_path = "#{submodule_path}#{StaticPath.TRANSLATOR_SUBPATH}"
    FileReader.touch_directory(models_path)
    FileReader.touch_directory(translators_path)

    Dir.glob(submodule_json_mask) do |filename|
      template = FileReader.read_template(filename)
      generator.generate_model(
        template,
        module_name,
        models.model,
        models.translator_model,
        models.tests_model,
        models_path,
        translators_path
      )

      LogManager.log_msg("#{template["name"]} закончила генерацию")
    end

    LogManager.log_msg("Генерация завершена")
  end

  # Генерация сидов
  def self.generate_seeds(submodule_path, submodule_json_mask, models)
    LogManager.log_msg("Запущен процесс генерации сидов")

    unless FileReader.check_json_files(submodule_json_mask)
      LogManager.log_msg("Генерация сидов не завершена")
      exit
    end

    generator = ModelGenerator.new

    seeds_path = "#{submodule_path}#{StaticPath.SEEDS_SUBPATH}"
    FileReader.touch_directory(seeds_path)

    Dir.glob(submodule_json_mask) do |filename|
      template = FileReader.read_template(filename)
      generator.generate_seeds(
        template,
        seeds_path,
        models.seeds_model
      )
      LogManager.log_msg("#{template["name"]} сид закончила генерацию")
    end

    LogManager.log_msg("Генерация сидов завершена")
  end
end
