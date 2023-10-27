# Changelog

## 1.2.1 (October 27 2023)

### Bug Fix

  - Add support for path on `DirectiveArgumentAdded` (#57)

## 1.2.0 (October 18 2023)

### Bug Fix

  - More selective detection of breaking/dangerous enum value changes (#54)
  - Improve schema root operation type changes (#55)

## 1.1.2 (September 15 2022)

### Bug Fix

  - Fix field argument removed message (#51)
  - Fix safe type change comparison (#53)

## 1.1.1 (January 7 2022)

### Bug Fix

  - Fix directive type change false positive bug (#47)

## 1.1.0 (December 20 2021)

### Bug Fix

  - Adding non-null arguments with a default value should be non-breaking (#38)

### New Features

  - Remove legacy `graphql` gem API usage and support versions >= 1.13 (#46)

## 1.0.1 (May 26 2021)

### Bug Fix

  - Fix comparing directives (#36)

## 1.0.0 (January 23 2020)

### Breaking Changes

  - Add support for graphql-ruby 1.10.0+ (#28)
  - Starting from 1.0.0 a minimum of graphql-ruby 1.10 is required

## 0.6.1 (May 21rst 2019)

  - Added a bunch of reasons to breaking changes (#17)
  - Relaxed Thor Dependency
  - Add `verify` task for CI usage which returns exit codes depending on breaking changes (#24)

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

  - Fix issue in Enum differ (https://github.com/xuorig/graphql-schema_comparator/issues/9)

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
