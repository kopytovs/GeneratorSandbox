# frozen_string_literal: true

require 'mustache'
require 'date'
require_relative 'gen_types'
require_relative 'gen_file_reader'
require_relative 'gen_fields_generator'
require_relative 'gen_log_manager.rb'

# rubocop:disable ClassLength

# Кодогенерация
class ModelGenerator
  # Получить конфигурационный файл из приходящего json
  def create_configuration(template)
    LogManager.log_msg("Получение конфигурационного файла из #{template["name"]}_gen.json для модели и транслятора")

    fields = FieldsGenerator.generate_new_fields(
      template["custom_imports"],
      template["protocols"],
      template["fields"],
      template["subenums"],
      template["public"]
    )

    configuration = {
      "name" => template["name"],
      "date" => Date.today.strftime(DEFAULT_DATE_FORMAT),
      "gen_version" => GEN_VERSION,
      "imports" => fields.imports,
      "description" => template["description"],
      "public" => template["public"],
      "protocols" => fields.protocols,
      "fields" => fields.all_fields,
      "custom_types" => fields.custom_types,
      "normal_fields" => fields.normal_fields,
      "custom_fields" => fields.custom_fields,
      "array_custom_fields" => fields.array_custom_fields,
      "enum_fields" => fields.enum_fields,
      "subenums" => fields.subenums
    }

    LogManager.log_msg("Конфигурационный файл получен")

    return configuration
  end

  # Получить конфигурационный файл для тестов из приходящего json
  def create_tests_configuration(template, module_name)
    LogManager.log_msg("Получение конфигурационного файла из #{template["name"]}_gen.json для тестов")

    fields = FieldsGenerator.generate_new_test_fields(
      template["name"],
      template["custom_imports"],
      template["fields"],
      template["valid_model"]
    )

    configuration = {
      "name" => template["name"],
      "valid_model" => fields.valid_model,
      "has_not_nil" => fields.has_not_nil,
      "create_valid_model" => fields.valid_model.nil?,
      "date" => Date.today.strftime(DEFAULT_DATE_FORMAT),
      "gen_version" => GEN_VERSION,
      "imports" => fields.imports,
      "module_name" => module_name,
      "optional_fields" => fields.optional_fields,
      "fields" => fields.all_fields,
      "normal_fields" => fields.normal_fields,
      "custom_fields" => fields.custom_fields,
      "array_custom_fields" => fields.array_custom_fields,
      "enum_fields" => fields.enum_fields
    }

    LogManager.log_msg("Конфигурационный файл получен")

    return configuration
  end

  # Получить конфигурационныйфайл для сидов из приходящего json
  def create_seeds_configuration(template)
    LogManager.log_msg("Получение конфигурационного файла из #{template["name"]}_gen.json для сидов")

    fields = FieldsGenerator.generate_new_seeds_fields(
      template["custom_imports"],
      template["fields"]
    )

    configuration = {
      "name" => template["name"],
      "gen_version" => GEN_VERSION,
      "date" => Date.today.strftime(DEFAULT_DATE_FORMAT),
      "imports" => fields.imports,
      "fields" => fields.all_fields
    }

    LogManager.log_msg("Конфигурационный файл получен")
    return configuration
  end

  # rubocop:disable ParameterLists
  # Запустить процес генерации
  def generate_model(template, module_name, model, translator_model, tests_model, models_path, translators_path)
    configuration = create_configuration(template)
    tests_config = create_tests_configuration(template, module_name)

    model_name = configuration["name"]
    translator_name = "#{model_name}Translator"
    tests_name = "#{model_name}TranslatorTests"

    full_models_path = "#{models_path}#{model_name}"
    full_translators_path = "#{translators_path}#{translator_name}"
    full_tests_path = "#{translators_path}#{tests_name}"

    LogManager.log_msg("Запущен процесс рендеринга модели #{model_name} по пути #{full_models_path}")
    FileReader.render_configuration(configuration, model, full_models_path)

    LogManager.log_msg("Запущен процесс рендеринга транслятора #{translator_name} по пути #{full_translators_path}")
    FileReader.render_configuration(configuration, translator_model, full_translators_path)

    LogManager.log_msg("Запущен процесс рендеринга тестов #{tests_name} по пути #{full_tests_path}")
    FileReader.render_configuration(tests_config, tests_model, full_tests_path)
  end

  # rubocop:enable ParameterLists

  # Создать json файлы в указанной директории
  def init_json_directory(_path, json_path, model, json_names)
    json_names.each do |name|
      file_path = "#{json_path}#{name}_gen.json"
      configuration = { name => name }
      FileReader.save_new_file(file_path, configuration, model)
    end
  end

  # Сгенерировать сиды
  def generate_seeds(template, seeds_path, seeds_model)
    configuration = create_seeds_configuration(template)
    seeds_name = "#{configuration["name"]}+Seeds"
    full_seeds_path = "#{seeds_path}#{seeds_name}"

    LogManager.log_msg("Запущен процесс рендеринга сидов #{seeds_name} по пути #{full_seeds_path}")
    FileReader.render_configuration(configuration, seeds_model, full_seeds_path)
  end
end

# rubocop:enable ClassLength
