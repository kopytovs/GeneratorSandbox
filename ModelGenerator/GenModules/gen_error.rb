# frozen_string_literal: true

# rubocop:disable MethodName

# Класс с возможными ошибками
class GenError
  def self.GEN_HELP_MESSAGE
    "#{LOGO}"\
      "\n\tИзвините, вы ввели неверную команду, попробуйте эти:\n\n" \
      "\t* --init [names] - инициализация json файлов для описания моделей, где [names] - массив имен моделей, если массив пустой, то будет создан дефолтный json (-i);\n\n" \
      "\t* --generate - генерация моделей, трансляторов и тестов к ним по обнаруженным в модуле json файлам с описанием моделей (-g);\n\n" \
      "\t* --seeds - генерация сидов к моделям (-s);\n\n" \
      "\t* --verbose - режим отладки с подробным описанием работы скрипта (-v);\n\n" \
      "\t* --rewrite - режим перезаписи файлов, если нужно перезаписать только выбранные модели, укажите их названия через пробел (-r);\n\n" \
      "\tТакже, перед каждой командой необходимо указать название модуля и сабмодуля, например: './model_generator.sh Shareholders Common -g')\n\n"
  end

  def self.GEN_SUBMODULE_NOT_EXIST
    "Извините, сабмодуль не найден"
  end

  def self.GEN_FILE_EXIST_YET(file_path)
    "Извините, но файл #{file_path} уже существует, если вы хотите его перезаписать, то сперва его нужно удалить или запустить с ключом (-r)."
  end

  def self.GEN_WRONG_JSON_FILE(file_path)
    "Извините, json файл #{file_path} не распознан"
  end

  def self.GEN_ANY_JSON_NOT_EXIST
    "Извините, ни один конфигурационный json не найден"
  end
end

# rubocop:enable MethodName
