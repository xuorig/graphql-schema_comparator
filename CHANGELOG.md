# Changelog

## 0.6.0 (Feb 28th 2018)

### New Features

  - Add `#path` which returns a dot-delimited path to the affected schema member. (#15)

## 0.5.1 (Feb 15th 2018)

### Bug Fix

  - Return a better message when adding a default value, if this one was nil before.

## 0.5.0 (Dec 2 2017)

### New Features

  - `AbstractChange#criticality` now returns a criticality object which
  has a level (non_breaking, dangerous, breaking) and a reason

  - Schema::ComparatorResult maintains a list of `#dangerous_changes`

  - New Methods: Change.non_breaking? Change.dangerous?

  - New CLI `schema_comparator` which includes `dangerous_changes`

### Breaking Changes

  - Some changes have been recategorized as dangerous
  - Some type changes now return breaking or non-breaking depending on the type kind

## 0.4.0 (Nov 27 2017)

### Breaking Changes

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
