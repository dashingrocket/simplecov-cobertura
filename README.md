# simplecov-cobertura 
[![Build Status](https://travis-ci.com/dashingrocket/simplecov-cobertura.svg?branch=master)](https://travis-ci.com/dashingrocket/simplecov-cobertura)   [![Gem Version](https://badge.fury.io/rb/simplecov-cobertura.svg)](http://badge.fury.io/rb/simplecov-cobertura)  [![Downloads](http://ruby-gem-downloads-badge.herokuapp.com/simplecov-cobertura?type=total)](https://rubygems.org/gems/simplecov-cobertura)

Produces [Cobertura](http://cobertura.sourceforge.net/) formatted XML from [SimpleCov](https://github.com/colszowka/simplecov).

Output can be consumed by the [Jenkins Cobertura Plugin](https://wiki.jenkins-ci.org/display/JENKINS/Cobertura+Plugin) for easy 
coverage visualization.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'simplecov-cobertura'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install simplecov-cobertura

## Usage

```ruby
require 'simplecov-cobertura'

SimpleCov.formatter = SimpleCov::Formatter::CoberturaFormatter
```

Run your test suite. Coverage information will be saved to `coverage/coverage.xml` by default.

### Parallel Testing

If you use `parallel_tests` gem, then each test process writes coverage information to `coverage/coverage.xml` file at the end of the execution. The last process overwrites the file after all previous processes. Only coverage of the last process remains.

A solution is to write each process coverage to its own file. Similar to how test database names are formed - with the `TEST_ENV_NUMBER` environment variable - you can set coverage output file name:

```ruby
SimpleCov.formatter = SimpleCov::Formatter::CoberturaFormatter.new(filename: "coverage#{ENV['TEST_ENV_NUMBER']}.xml")
```

After running 4 parallel test processes, you will get 4 coverage reports:

```
coverage/coverage1.xml
coverage/coverage2.xml
coverage/coverage3.xml
coverage/coverage4.xml
```

NOTE: Set the `PARALLEL_TEST_FIRST_IS_1` environment variable to get this numbering. Without it, the first process will be unnumbered.

If you run a single test process without the parallel tasks, you will still get a single `coverage/coverage.xml` file.

## Continuous Integration
Tested in a CI environment against the following Ruby versions:
* 2.7
* 2.6
* 2.5
* 2.4
* 2.3
* 2.2
* 2.1
* 2.0
* 1.9

## Known Limitations
* No support for branch coverage

## Contributors
  * Jesse Bowes
  * Sean Clemmer
  * Ivailo Petrov
  * Rob Lester
  * Denis <Zaratan> Pasin
  * Jesper Rønn-Jensen
  * Pramod Shinde
  * Magnus Bergmark
  * Peter Leitzen

## Contributing

1. Fork it ( https://github.com/dashingrocket/simplecov-cobertura/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## License
Copyright 2020 Dashing Rocket, Ltd.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
