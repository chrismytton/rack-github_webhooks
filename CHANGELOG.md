# Change Log

All notable changes to this project will be documented in this file.
This project adheres to [Semantic Versioning](http://semver.org/).

## [0.4.0] - 2016-03-25

### Fixed

- Call `env['rack.input'].rewind` after reading from it. Thanks @ppworks for the patch.

## [0.3.0] - 2015-11-29

### Changed

- Internal refactor to separate out `Signature` class.

## [0.2.0] - 2015-11-29

### Fixed

- Don't error when there's no 'X-Hub-Signature' header.


## 0.1.0 - 2015-11-29

- Initial release

[0.2.0]: https://github.com/chrismytton/rack-github_webhooks/compare/v0.1.0...v0.2.0
[0.3.0]: https://github.com/chrismytton/rack-github_webhooks/compare/v0.2.0...v0.3.0
[0.4.0]: https://github.com/chrismytton/rack-github_webhooks/compare/v0.3.0...v0.4.0
