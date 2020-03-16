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
  def self.init_jsons(submodule_path, json_names)
    LogManager.log_msg("Запущен процесс инцииализации json файлов")

    generator = ModelGenerator.new
    json_model_path = StaticPath.JSON_MODEL_PATH

    json_path = "#{submodule_path}#{StaticPath.JSON_SUBPATH}"
    FileReader.touch_directory(json_path)

    LogManager.log_msg("Получены модели: #{json_names}")

    json_model = FileReader.read_model(json_model_path)

    generator.init_json_directory(submodule_path, json_path, json_model, json_names)

    LogManager.log_msg("Инициализация завершена успешно")
  end

  # Генерация моделей, трансляторов и тестов к ним
  def self.generate_models(submodule_path, module_name, models, submodule_json_mask)
    LogManager.log_msg("Запущен процесс генерации")

    generator = ModelGenerator.new

    models_path = "#{submodule_path}#{StaticPath.MODEL_SUBPATH}"
    translators_path = "#{submodule_path}#{StaticPath.TRANSLATOR_SUBPATH}"
    FileReader.touch_directory(models_path)
    FileReader.touch_directory(translators_path)

    configs = FileReader.get_all_jsons(submodule_json_mask)

    configs.each do |config|
      generator.generate_model(
        config,
        module_name,
        models.model,
        models.translator_model,
        models.tests_model,
        models_path,
        translators_path
      )

      LogManager.log_msg("#{config["name"]} закончила генерацию")
    end

    LogManager.log_msg("Генерация завершена")
  end

  # Генерация сидов
  def self.generate_seeds(submodule_path, submodule_json_mask, models)
    LogManager.log_msg("Запущен процесс генерации сидов")

    generator = ModelGenerator.new

    seeds_path = "#{submodule_path}#{StaticPath.SEEDS_SUBPATH}"
    FileReader.touch_directory(seeds_path)

    configs = FileReader.get_all_jsons(submodule_json_mask)

    configs.each do |config|
      generator.generate_seeds(
        config,
        seeds_path,
        models.seeds_model
      )
      LogManager.log_msg("#{config["name"]} сид закончила генерацию")
    end

    LogManager.log_msg("Генерация сидов завершена")
  end
end
