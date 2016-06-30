require 'bundler/gem_tasks'
require 'gemfury'
require 'gemfury/command'

GEMFURY_ACCOUNT = 'markkendall'

# Monkey patch the Bundler Rake task helpers to push the released gem to
# Gemfury instead of RubyGems.org.
module Bundler
  class GemHelper
    unless instance_methods.include?(:rubygem_push)
      fail 'Rake task monkey patch misapplied'
    end

    def rubygem_push(path, account=GEMFURY_ACCOUNT)
      ::Gemfury::Command::App.start(['push', path, "--as=#{GEMFURY_ACCOUNT}"])
      Bundler.ui.confirm "Pushed #{name} #{version} to Gemfury as #{account}"
    end
  end
end
