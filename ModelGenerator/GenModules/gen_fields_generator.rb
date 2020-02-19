# frozen_string_literal: true

require_relative 'gen_types'
require_relative 'gen_fields_parser'

# Генерирует новые поля для технического джсона
class FieldsGenerator
  # Генерирует поля для модуля
  def self.generate_new_fields(imports, protocols, fields, subenums, is_public)
    imports_array = FieldsParser.create_imports(imports, false)
    protocols_hash = FieldsParser.create_protocols(protocols)
    all_fields = FieldsParser.create_all_fields(fields, is_public)
    any_fields = FieldsParser.generate_any_fields(all_fields)
    custom_types = FieldsParser.create_custom_types(all_fields, is_public)
    subenums = FieldsParser.read_subenums(subenums, is_public)

    return Fields.new(
      imports_array,
      protocols_hash,
      all_fields,
      custom_types,
      any_fields.normal_fields,
      any_fields.custom_fields,
      any_fields.array_custom_fields,
      any_fields.enum_fields,
      subenums
    )
  end

  # Генерирует поля для тестов
  def self.generate_new_test_fields(name, imports, fields, valid_model)
    imports_array = FieldsParser.create_imports(imports, true)
    all_fields = FieldsParser.create_all_fields(fields, false)
    any_fields = FieldsParser.generate_any_fields(all_fields)
    optional_fields = FieldsParser.create_optional_fields(all_fields)
    valid_model_field = FieldsParser.create_valid_model_hash(name, valid_model)
    all_fields_nullable = FieldsParser.check_fields_nullability(fields)

    return TestFields.new(
      imports_array,
      optional_fields,
      all_fields,
      any_fields.normal_fields,
      any_fields.custom_fields,
      any_fields.array_custom_fields,
      any_fields.enum_fields,
      valid_model_field,
      !all_fields_nullable
    )
  end

  # Генерирует поля для сидов
  def self.generate_new_seeds_fields(imports, fields)
    imports_array = FieldsParser.create_imports(imports, false)
    all_fields = FieldsParser.create_all_fields(fields, false)

    return SeedsFields.new(imports_array, all_fields)
  end
end
