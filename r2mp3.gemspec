# frozen_string_literal: true

require_relative "lib/r2mp3/version"

Gem::Specification.new do |spec|
  spec.name = "r2mp3"
  spec.version = R2mp3::VERSION
  spec.authors = ["zdk"]
  spec.email = ["di.warachet@gmail.com"]

  spec.summary = "Audio files converter"
  spec.description = "Some audio files format to mp3"
  spec.homepage = "https://github.com/zdk/r2mp3"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.0.0"
  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/zdk/r2mp3"
  spec.metadata["changelog_uri"] = "https://github.com/zdk/r2mp3/changelog.txt"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  gemspec = File.basename(__FILE__)
  spec.files = IO.popen(%w[git ls-files -z], chdir: __dir__, err: IO::NULL) do |ls|
    ls.readlines("\x0", chomp: true).reject do |f|
      (f == gemspec) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git appveyor Gemfile])
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "base64"
  spec.add_dependency "wahwah"
end
