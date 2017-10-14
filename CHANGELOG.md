# Changelog

## 0.3.0 (Oct 14 2017)

### New features

- Top level Directive definitions are now diffed, but not directives used on definitions (Coming soon)
- Base class for changes added.

### breaking changes

- `breaking` method on change objects has been renamed `breaking?` for style

### Bug fixes

- Fix message for `EnumValueRemoved` (#5)

## 0.2.0 (Aug 18 2017)

### New features

- Add `#non_breaking_changes` to get a list of non breaking changes from a comparison result. (#4)
- CLI now Prints results sorted and grouped by breaking / non-breaking (#3)

### Bug fixes

- Fix message for `EnumValueRemoved` (#5)
