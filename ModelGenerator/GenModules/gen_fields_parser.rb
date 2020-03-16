# frozen_string_literal: true

# rubocop:disable ClassLength

require_relative 'gen_types'
require_relative 'gen_log_manager.rb'
# Считывает массив полей и парсит его
class FieldsParser
  # rubocop:disable MethodLength
  # rubocop:disable CyclomaticComplexity
  # rubocop:disable PerceivedComplexity
  # Генерирует структуру AnyFields, содержащую массивы, разделенные по типу:
  # (простые поля, енамы, поля с кастомным типом, поля с массивами кастомного типа)
  def self.generate_any_fields(fields)
    LogManager.log_msg("Запущена генерация массивов различных типов данных")
    normal_fields = []
    custom_fields = []
    array_custom_fields = []
    enum_fields = []
    url_fields = []
    decimal_fields = []

    fields.each do |field|
      field_type = field["clean_type"]
      if SIMPLE_TYPES.include?(field_type) || (field_type.include? ":")
        LogManager.log_msg("Поле по ключу #{field["key"]} распознано, как простейший тип")
        normal_fields.push(field)
      elsif field["enum"]
        LogManager.log_msg("Поле по ключу #{field["key"]} распознано, как enum")
        enum_fields.push(field)
      elsif !DEFAULT_TYPES.include? field_type
        if field["type"].include? "["
          LogManager.log_msg("Поле по ключу #{field["key"]} распознано, как массив кастомного типа")
          array_custom_fields.push(field)
        else
          LogManager.log_msg("Поле по ключу #{field["key"]} распознано, как кастомный тип")
          custom_fields.push(field)
        end
      elsif field_type == "URL"
        LogManager.log_msg("Поле по ключу #{field["key"]} распознано, как URL")
        url_fields.push(field)
      elsif field_type == "Decimal"
        LogManager.log_msg("Поле по ключу #{field["key"]} распознано, как Decimal")
        decimal_fields.push(field)
      else
        LogManager.log_msg("Поле по ключу #{field["key"]} не распознано")
      end
    end

    normal_fields = normal_fields.empty? ? nil : normal_fields
    custom_fields = custom_fields.empty? ? nil : custom_fields
    array_custom_fields = array_custom_fields.empty? ? nil : array_custom_fields
    enum_fields = enum_fields.empty? ? nil : enum_fields
    url_fields = url_fields.empty? ? nil : url_fields
    decimal_fields = decimal_fields.empty? ? nil : decimal_fields

    LogManager.log_msg("Генерация массивов различных типов данных завершена")
    return AnyFields.new(normal_fields, custom_fields, array_custom_fields, enum_fields, url_fields, decimal_fields)
  end
  # rubocop:enable CyclomaticComplexity
  # rubocop:enable MethodLength
  # rubocop:enable PerceivedComplexity

  # Создает и возвращает хэш с массивом всех найденных кастомных типов
  def self.create_custom_types(fields, is_public)
    LogManager.log_msg("Запущена генерация хэша с массивом всех найденных кастомных типов")

    custom_types = []

    fields.each do |field|
      clean_type = field["type"].delete "?"
      is_dictionary = clean_type.include? ":"
      clean_type = clean_type.delete "[]" unless is_dictionary

      next unless !(field["enum"]) &&
                  (!DEFAULT_TYPES.include? clean_type) &&
                  is_dictionary == false

      translator_class = create_translator_class(field[clean_type], field["translator_class"])
      new_type = {
        "value" => clean_type,
        "lowcase_value" => create_camel_case(clean_type),
        "translator_class" => translator_class,
        "translator_name" => create_camel_case(translator_class),
        "comma" => true
      }

      LogManager.log_msg("Распознан кастомный тип #{clean_type}")
      custom_types.push(new_type)
    end

    custom_types_hash = nil

    unless custom_types.empty?
      custom_types = custom_types.uniq
      custom_types.last["comma"] = false
      custom_types_hash = { "public" => is_public, "types" => custom_types }
    end

    LogManager.log_msg("Генерация хэша с массивом всех найденных кастомных типов завершена")
    return custom_types_hash
  end

  # Создает массив, содержащим все поля в преобразованном виде
  def self.create_all_fields(fields, is_public)
    all_fields = []

    fields.each do |field|
      new_field = {}
      new_field["key"] = field["key"]
      new_field["public"] = is_public
      new_field["custom_name"] = !field["custom_name"].nil? ? field["custom_name"] : field["key"]
      new_field["description"] = field["description"]
      new_field["comma"] = true

      clean_type = field["type"].delete "?"
      clean_type = clean_type.delete "[]" unless clean_type.include? ":"
      translator_class = create_translator_class(clean_type, field["translator_class"])
      new_field["translator_class"] = translator_class
      new_field["translator_name"] = create_camel_case(translator_class)
      new_field["clean_type"] = clean_type

      new_field["type"] = field["type"]
      optional = field["type"].include? "?"
      new_field["optional"] = optional
      new_field["not_nil"] = !optional

      new_field["enum"] = field["enum"] unless field["enum"].nil?

      new_field["open_bracket"] = "{"
      new_field["closed_bracket"] = "}"

      all_fields.push(new_field)
    end

    all_fields.last["comma"] = false
    return all_fields
  end

  # rubocop:disable MethodLength
  # Создает массив опциональных полей
  def self.create_optional_fields(fields)
    LogManager.log_msg("Запущена генерация массива с опциональными полями")

    optional_fields = []

    fields.each do |field|
      next unless field["optional"]

      new_optional = {}
      custom_name = field["custom_name"]
      new_optional["custom_name"] = custom_name
      new_optional["custom_name_up"] = create_capitalize(custom_name)
      nullable_fields = []
      fields.each do |n_field|
        new_field = n_field.clone
        if (n_field["optional"]) && (new_field["key"] == field["key"])
          new_field["nullable"] = true
        else
          new_field["normal"] = true
        end
        nullable_fields.push(new_field)
      end
      new_optional["nullable_fields"] = nullable_fields
      fields_without_nullable = fields.reject { |item| item["custom_name"] == custom_name }
      any_fields = FieldsParser.generate_any_fields(fields_without_nullable)
      new_optional["normal_fields"] = any_fields.normal_fields
      new_optional["custom_fields"] = any_fields.custom_fields
      new_optional["array_custom_fields"] = any_fields.array_custom_fields
      new_optional["enum_fields"] = any_fields.enum_fields
      new_optional["url_fields"] = any_fields.url_fields
      new_optional["decimal_fields"] = any_fields.decimal_fields

      LogManager.log_msg("Добавлено опциональное поле с именем #{new_optional["custom_name"]}")
      optional_fields.push(new_optional)
    end

    LogManager.log_msg("Генерация массива с опциональными полями завершена")
    return optional_fields.empty? ? nil : optional_fields
  end
  # rubocop:enable MethodLength

  # rubocop:disable MethodLength
  # Считывает массив вложенных енамов, парсит его, преобразовывает
  # в технический формат и возвращает хэш в преобразованном формате
  def self.read_subenums(subenums, is_public)
    LogManager.log_msg("Запущена генерация массива вложенных enum")

    if subenums.nil?
      LogManager.log_msg("Сабенамы не найдены")
      return []
    end

    new_subenums = []
    subenums.each do |enums|
      new_enum = {}
      new_enum["name"] = enums["name"]
      new_enum["description"] = enums["description"]
      new_enum["public"] = is_public

      enum_type = enums["type"]
      new_enum["type"] = enum_type

      new_cases = []
      enums["cases"].each do |cases|
        new_case = {}
        new_case["name"] = cases["name"]
        new_case["public"] = is_public
        unless cases["custom_key"].nil?
          new_custom_key = {}
          new_custom_key["value"] = cases["custom_key"]

          if enum_type == "String"
            new_custom_key["first_quote"] = true
            new_custom_key["second_quote"] = true
          end

          new_case["custom_key"] = new_custom_key
        end

        new_cases.push(new_case)
      end

      new_enum["cases"] = new_cases

      LogManager.log_msg("Добавлен новый вложенный enum #{new_enum["name"]}")
      new_subenums.push(new_enum)
    end

    LogManager.log_msg("Генерация массива вложенных enum завершена")

    return new_subenums
  end
  # rubocop:enable MethodLength

  # Создает массив импортов
  def self.create_imports(imports, use_test_imports)
    LogManager.log_msg("Запущена генерация импортов")
    default_imports = create_imports_array(DEFAULT_IMPORTS.clone)
    custom_imports = create_imports_array(imports.clone)
    test_imports = create_imports_array(TEST_IMPORTS.clone)

    result_imports = default_imports + custom_imports
    result_imports += test_imports if use_test_imports

    LogManager.log_msg("Генерация импортов завершена")
    return result_imports.sort_by { |dict| dict["import_name"] }
  end

  def self.create_imports_array(imports)
    return [] if imports.nil?

    imports_hash_array = []
    imports.each do |import|
      import_hash = { "import_name" => import.clone }
      imports_hash_array.push(import_hash)
    end
    return imports_hash_array
  end

  # Создает строку со спиком протоколов
  def self.create_protocols(protocols)
    LogManager.log_msg("Запущена генерация протоколов")
    protocols_string = ""
    default_protocols = create_protocols_string(DEFAULT_PROTOCOLS)
    custom_protocols = create_protocols_string(protocols)
    protocols_string += default_protocols
    protocols_string += ", #{custom_protocols}" unless protocols.nil?

    LogManager.log_msg("Генерация протоколов завершена")

    return { "protocols_list" => protocols_string }
  end

  # Создает строку со списком протоколов через запятую
  def self.create_protocols_string(protocols)
    protocols_string = ""

    return protocols_string if protocols.nil?

    suffix = ", "
    protocols.each do |protocol|
      protocols_string += "#{protocol}#{suffix}"
    end
    return protocols_string.delete_suffix(suffix)
  end

  # Создает хэш с названием валидной модели
  def self.create_valid_model_hash(name, valid_model)
    model = valid_model.nil? ? "#{name}.Seeds.#{DEFAULT_SEED_NAME}" : valid_model
    return { "name" => model }
  end

  # Проверяет поля на nullability
  def self.check_fields_nullability(fields)
    LogManager.log_msg("Запущена проверка полей на nullability - #{fields}")
    not_null_fields = []
    fields.each do |field|
      not_null_fields.push(field) unless field["type"].include? "?"
    end
    LogManager.log_msg("Проверка завершена с флагом #{not_null_fields.empty?}")
    return not_null_fields.empty?
  end

  # Создает camelCase из типа
  def self.create_camel_case(type)
    LogManager.log_msg("Запущена генерация camelCase для #{type}")
    camel_case_type = type.dup
    camel_case_type[0] = camel_case_type[0].downcase
    LogManager.log_msg("Получен camelCase: #{camel_case_type}")
    return camel_case_type
  end

  def self.create_capitalize(name)
    LogManager.log_msg("Запущена генерация uppercase первого символа для #{name}")
    capitalize_name = name.dup
    capitalize_name[0] = capitalize_name[0].capitalize
    LogManager.log_msg("Получен uppercase первого символа: #{name}")
    return capitalize_name
  end

  # Создает название транслятора
  def self.create_translator_class(type, translator_class)
    LogManager.log_msg("Запущена генерация названия транслятора для типа #{type}")
    return translator_class if translator_class.nil? == false

    return "#{type}Translator"
  end
end

# rubocop:enable ClassLength
