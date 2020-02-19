# frozen_string_literal: true

# rubocop:disable MethodName

# Константы и публичные типы

# Массив примитивных типов
SIMPLE_TYPES = %w[Bool Int Float Double Character String]

# Версия генератора
GEN_VERSION = 0.2

# Стандартное название модели
JSON_DEFAULT_NAME = "temp"

# Формат даты
DEFAULT_DATE_FORMAT = "%d/%m/%Y"

# Флаг логгирования
VERBOSE_MODE = false

# Дефолтные импорты
DEFAULT_IMPORTS = ["AlfaFoundation"]

# Импорты для тестов
TEST_IMPORTS = ["Nimble", "Quick"]

# Дефолтные протоколы
DEFAULT_PROTOCOLS = ["Equatable"]

# Дефолтное название сида
DEFAULT_SEED_NAME = "value"

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
AnyFields = Struct.new(:normal_fields, :custom_fields, :array_custom_fields, :enum_fields)
# Структура, содержащая в себе полную и упрощенную команды
Command = Struct.new(:full, :short)

# Класс с возможными ошибками
class GenError
  def self.GEN_HELP_MESSAGE
    %(Извините, вы ввели неверную команду, попробуйте эти:

		* --init [names] - инициализация json файлов для описания моделей, где [names] - массив имен моделей, если массив пустой, то будет создан дефолтный json (-i);

		* --generate - генерация моделей, трансляторов и тестов к ним по обнаруженным в модуле json файлам с описанием моделей (-g);

    * --seeds - генерация сидов к моделям (-s);

		* --verbose - режим отладки с подробным описанием работы скрипта, указывается после всего (-v);

    Генерацию моделей можно запускать совместно с генерацией сидов, для этого нужно склеить команды вместе(--generate-seeds или просто -gs)

		Также, перед каждой командой необходимо указать название модуля и сабмодуля, например: './model_generator.sh Shareholders Common -g')
  end

  def self.GEN_SUBMODULE_NOT_EXIST
    "Извините, сабмодуль не найден"
  end

  def self.GEN_FILE_EXIST_YET(file_path)
    "Извините, но файл #{file_path} уже существует, если вы хотите его перезаписать, то сперва его нужно удалить."
  end

  def self.GEN_WRONG_JSON_FILE(file_path)
    "Извините, json файл #{file_path} не распознан"
  end

  def self.GEN_ANY_JSON_NOT_EXIST
    "Извините, ни один конфигурационный json не найден"
  end
end

# Доступные комманды
class GenCommand
  def self.initialization
    Command.new("--init", "-i")
  end

  def self.generate
    Command.new("--generate", "-g")
  end

  def self.seeds_generate
    Command.new("--seeds", "-s")
  end

  def self.verbose
    Command.new("--verbose", "-v")
  end

  def self.generate_with_seeds
    Command.new("--generate--seeds", "-gs")
  end

  def self.generate_with_seeds_alt
    Command.new("--seeds--generate", "-sg")
  end

  def self.is_initialization(command)
    is_command(command, initialization)
  end

  def self.is_generate(command)
    is_command(command, generate)
  end

  def self.is_verbose(command)
    is_command(command, verbose)
  end

  def self.is_seeds(command)
    is_command(command, seeds_generate)
  end

  def self.is_generate_with_seeds(command)
    is_command(command, generate_with_seeds) || is_command(command, generate_with_seeds_alt)
  end

  def self.is_command(name, command)
    [command.full, command.short].include?(name)
  end
end

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

# rubocop:enable MethodName
