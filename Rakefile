# frozen_string_literal: true

namespace :examples do
  task :mocks do
    exec "bundle exec agen mocks -p Sandbox/Mocks/Mockable -v"
  end

  task :model do
    exec "bundle exec agen model -p Sandbox/Model/Shareholders/Common -g -r -n Model && "\
    "open Sandbox/Model/Shareholders/Common/Generated"
  end

  namespace :strings do
    task :framework do
      exec "bundle exec agen strings -m Framework && " \
      "open Sandbox/Strings/Frameworks/Framework/Localization"
    end

    task :module do
      exec "bundle exec agen strings -m Module && " \
      "open Sandbox/Strings/Modules/Module/Localization"
    end
  end

  namespace :config do
    task :generate do
      Dir.chdir "Sandbox/Config/generate"
      exec "bundle exec agen config -p config.yaml && "\
      "open Sandbox/Config/generate"
    end

    task :no_config do
      Dir.chdir "Sandbox/Config/no_config"
      exec "bundle exec agen mocks -p . --config config.yaml && "\
      "open Sandbox/Config/no_config"
    end

    task :invalid_config do
      Dir.chdir "Sandbox/Config/invalid_config"
      exec "bundle exec agen mocks -p . --config config.yaml && "\
      "open Sandbox/Config/invalid_config"
    end
  end
end