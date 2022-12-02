Gem::Specification.new do |s|
  s.name        = "brew-github-private-download-strategy"
  s.version     = "0.1.0"
  s.summary     = "Create homebrew packages that allow to download private releases from Github."
  s.description = "Whenever you want to create a homebrew package for a private repository, you have to create a custom download strategy as Homebrew does not support downloading releases from private repositories.
  Thanks to this Gem and a bit of configuration in your homebrew formula, you will be able to make your private repository available to your team via `brew install`."
  s.authors     = ["Claudio Beatrice"]
  s.email       = "engineering@sighup.io"
  s.files       = ["lib/brew-github-private-download-strategy.rb"]
  s.homepage    =
    "https://rubygems.org/gems/brew-github-private-download-strategy"
  s.license       = "MIT"
end
