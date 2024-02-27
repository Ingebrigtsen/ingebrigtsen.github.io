# ingebrigtsen.blog

## Jekyll - macOS

Do following, originally found [here](https://jekyllrb.com/docs/installation/macos/).

```shell
brew install chruby ruby-install xz
ruby-install ruby 3.2.3
echo "source $(brew --prefix)/opt/chruby/share/chruby/chruby.sh" >> ~/.zshrc
echo "source $(brew --prefix)/opt/chruby/share/chruby/auto.sh" >> ~/.zshrc
echo "chruby ruby-3.2.3" >> ~/.zshrc # run 'chruby' to see actual version
```

```shell
bundle
```

```shell
bundle exec jekyll serve --drafts --livereload
```
