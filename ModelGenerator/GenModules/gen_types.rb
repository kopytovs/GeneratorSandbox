# frozen_string_literal: true

# rubocop:disable MethodName

# Константы, публичные типы и статичные пути к файлам

# Логотип

LOGO = %(

\t .d888888  dP .8888b                   dP                 dP
\td8'    88  88 88   "                   88                 88
\t88aaaaa88a 88 88aaa  .d8888b.          88        .d8888b. 88d888b.
\t88     88  88 88     88'  `88 88888888 88        88'  `88 88'  `88
\t88     88  88 88     88.  .88          88        88.  .88 88.  .88
\t88     88  dP dP     `88888P8          88888888P `88888P8 88Y8888'

)

# Массив примитивных типов
SIMPLE_TYPES = %w[Bool Int Float Double Character String UniqueIdentifiable]

ADDITIONAL_TYPES = %w[URL Decimal Dictionary]

DEFAULT_TYPES = SIMPLE_TYPES + ADDITIONAL_TYPES

# Версия генератора
GEN_VERSION = 0.3

# Стандартное название модели
JSON_DEFAULT_NAME = "temp"

# Формат даты
DEFAULT_DATE_FORMAT = "%d/%m/%Y"

# Дефолтные импорты
DEFAULT_IMPORTS = ["AlfaFoundation"]

# Импорты для тестов
TEST_IMPORTS = %w[Nimble Quick]

# Дефолтные протоколы
DEFAULT_PROTOCOLS = ["Equatable"]

# Дефолтное название сида
DEFAULT_SEED_NAME = "value"

# Дефолтный суффикс json-файлов
JSON_FILES_SUFFIX = "**/*_gen.json"

# Структура, содержащая в себе все массивы для генерации модели
Fields = Struct.new(
  :imports,
  :protocols,
  :all_fields,
  :custom_types,
  :normal_fields,
  :custom_fields,
  :array_custom_fields,
  :enum_fields,
  :url_fields,
  :decimal_fields,
  :subenums
)
# Структура, содержащая в себе все массивы для генерации тестов
TestFields = Struct.new(
  :imports,
  :optional_fields,
  :all_fields,
  :normal_fields,
  :custom_fields,
  :array_custom_fields,
  :enum_fields,
  :url_fields,
  :decimal_fields,
  :valid_model,
  :has_not_nil
)

# Структура, содержащая в себе все массивы для генерации файла с сидами
SeedsFields = Struct.new(
  :imports,
  :all_fields
)

# Структура с шаблонами на Mustache
TemplateModels = Struct.new(
  :model,
  :translator_model,
  :tests_model,
  :seeds_model
)

# Структура, содержащая в себе все массивы, разделенные по типам
AnyFields = Struct.new(
  :normal_fields,
  :custom_fields,
  :array_custom_fields,
  :enum_fields,
  :url_fields,
  :decimal_fields
)

# Структура, содержащая в себе полную и упрощенную команды
Command = Struct.new(:full, :short)

# Статичные пути к файлам
class StaticPath
  def self.MODULES_PATH
    "./Modules/"
  end

  def self.MODEL_PATH
    "ModelGenerator/Templates/model.mustache"
  end

  def self.TRANSLATOR_MODEL_PATH
    "ModelGenerator/Templates/translator.mustache"
  end

  def self.TESTS_MODEL_PATH
    "ModelGenerator/Templates/tests.mustache"
  end

  def self.JSON_MODEL_PATH
    "ModelGenerator/Templates/json.mustache"
  end

  def self.SEEDS_MODEL_PATH
    "ModelGenerator/Templates/seeds.mustache"
  end

  def self.JSON_SUBPATH
    "Generated/JSON/"
  end

  def self.MODEL_SUBPATH
    "Generated/Model/"
  end

  def self.TRANSLATOR_SUBPATH
    "Generated/Translator/"
  end

  def self.SEEDS_SUBPATH
    "Generated/Seeds/"
  end
end

# Вернет пустой массив, если исходный nil
def safe_array(array)
  array.nil? ? [] : array
end

# rubocop:enable MethodName
