# Homebrew Private Github Download Strategy

Use this Gem to create homebrew packages that allow to download private releases from Github.

Whenever you want to create a homebrew package for a private repository, you have to create a custom download strategy
as Homebrew does not support downloading releases from private repositories.
Thanks to this Gem and a bit of configuration in your homebrew formula, you will be able to make your private repository
available to your team via `brew install`.

## Release a new version

- Bump the version in the `brew-github-private-download-strategy.gemspec` file
- Publish a corresponding tag on Github
