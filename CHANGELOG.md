# Changelog

## 0.4.0 (Nov 27 2017)

## Breaking Changes

  - Argument and InputValue type changes are considered non
    breaking if type goes from Null => Non-Null

## 0.3.2 (Nov 14 2017)

### New Features

Added changes:

  - `EnumValueDeprecated`
  - `EnumValueDescriptionChanged`

### Bug fixes

Fix issue in Enum differ (https://github.com/xuorig/graphql-schema_comparator/issues/9)

## 0.3.1 (Nov 13 2017)

### Bug Fixes

- Fix no method breaking issue https://github.com/xuorig/graphql-schema_comparator/issues/8

## 0.3.0 (Oct 14 2017)

### New features

- Top level Directive definitions are now diffed, but not directives used on definitions (Coming soon)
- Base class for changes added.

### breaking changes

- `breaking` method on change objects has been renamed `breaking?` for style

## 0.2.0 (Aug 18 2017)

### New features

- Add `#non_breaking_changes` to get a list of non breaking changes from a comparison result. (#4)
- CLI now Prints results sorted and grouped by breaking / non-breaking (#3)

### Bug fixes

- Fix message for `EnumValueRemoved` (#5)
