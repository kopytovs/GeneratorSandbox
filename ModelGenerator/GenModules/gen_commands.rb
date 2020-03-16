# frozen_string_literal: true

# Доступные комманды
class GenCommand
  def self.commands_list
    [initialization, generate, seeds_generate, verbose, rewrite]
  end

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

  def self.rewrite
    Command.new("--rewrite", "-r")
  end
end
