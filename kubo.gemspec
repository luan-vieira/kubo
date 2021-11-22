# frozen_string_literal: true

require_relative "lib/kubo/version"

Gem::Specification.new do |spec|
  spec.name = "kubo"
  spec.version = Kubo::VERSION
  spec.authors = ["Luan Vieira"]
  spec.email = ["luan@hey.com"]

  spec.summary = "Kubernetes CLI to simplify day-to-day work with less commands"
  spec.homepage = "https://github.com/luan-vieira/kubo"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.6.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/luan-vieira/kubo"
  spec.metadata["changelog_uri"] = "https://github.com/luan-vieira/kubo/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end
  spec.bindir = "bin"
  spec.executables = ["kubo"]
  # spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "tty-option"
  spec.add_dependency "tty-prompt"
  spec.add_dependency "tty-table"
  spec.add_dependency "kubeclient"
  spec.add_dependency "openid_connect" # Used for OIDC auth. It would be nice to only conditionally include it

  # For more information and examples about making a new gem, checkout our
  # guide at: https://bundler.io/guides/creating_gem.html
end
