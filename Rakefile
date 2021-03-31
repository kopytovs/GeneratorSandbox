# frozen_string_literal: true

namespace :examples do
  task :mocks do
    exec "bundle exec agen mocks -p Sandbox/Mocks/Mockable -v"
  end

  task :model do
    exec "bundle exec agen model -p Sandbox/Model/Shareholders/Common -g -r -n Model"
  end

  namespace :config do
    task :generate do
      Dir.chdir "Sandbox/Config/generate"
      exec "bundle exec agen config -p config.yaml"
    end

    task :no_config do
      Dir.chdir "Sandbox/Config/no_config"
      exec "bundle exec agen mocks -p . --config config.yaml"
    end

    task :invalid_config do
      Dir.chdir "Sandbox/Config/invalid_config"
      exec "bundle exec agen mocks -p . --config config.yaml"
    end
  end
end