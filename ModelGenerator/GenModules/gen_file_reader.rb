# frozen_string_literal: true

require 'json'
require 'mustache'
require 'fileutils'
require_relative 'gen_types'
require_relative 'gen_log_manager.rb'

# Чтение файлов
class FileReader
  # rubocop:disable JSONLoad

  # Считывает json модели
  def self.read_template(template_path)
    LogManager.log_msg("Загрузка json по пути #{template_path}")
    return JSON.load(File.open(template_path))
  end

  # rubocop:enable JSONLoad

  # Считывает шаблон для записи
  def self.read_model(model_path)
    LogManager.log_msg("Загрузка шаблона по пути #{model_path}")
    return File.read(model_path)
  end

  # Записать конфиг в шаблон
  def self.render_configuration(configuration, model, file_name)
    file_path = file_name + ".swift"

    LogManager.log_msg("Попытка рендеринга конфига #{configuration["name"]} по пути #{file_path}")

    FileReader.save_new_file(file_path, configuration, model)
  end

  # Сохранить данные в файл
  def self.save_new_file(path, configuration, model)
    if File.file?(path)
      puts GenError.GEN_FILE_EXIST_YET(path)
    else
      File.open(path, 'w') do |file|
        file.puts(Mustache.render(model, configuration))
      end
      LogManager.log_msg("Рендеринг конфига #{configuration["name"]} по пути #{path} прошел успешно}")
    end
  end

  # Создать директорию, если необходимо
  def self.touch_directory(name)
    unless File.exist?(name)
      LogManager.log_msg("Директория #{name} не существует, попытка создать директорию")
      FileUtils.mkdir_p(name)
      LogManager.log_msg("Директория #{name} создана")
    end
  end

  # Проверка на валдиность JSON
  def self.is_json_valid(smth_json)
    JSON.parse(smth_json)
    return true
  rescue JSON::ParseError
    return false
  end

  # Проверяет все файлы с json на валидность
  def self.check_json_files(json_mask)
    LogManager.log_msg("Запущена проверка JSON-файлов на валидность")
    json_not_exist = true
    all_json_valid = true

    Dir.glob(json_mask) do |filename|
      json_not_exist = false
      json_str = File.read(filename)
      unless is_json_valid(json_str)
        puts GenError.GEN_WRONG_JSON_FILE(filename)
        all_json_valid = false
      end
    end

    puts GenError.GEN_ANY_JSON_NOT_EXIST if json_not_exist
    LogManager.log_msg("Завершена проверка JSON-файлов на валидность")
    return all_json_valid
  end

  # Считывает и возвращает шаблоны для записи
  def self.templates
    return TemplateModels.new(
      read_model(StaticPath.MODEL_PATH),
      read_model(StaticPath.TRANSLATOR_MODEL_PATH),
      read_model(StaticPath.TESTS_MODEL_PATH),
      read_model(StaticPath.SEEDS_MODEL_PATH)
    )
  end
end
