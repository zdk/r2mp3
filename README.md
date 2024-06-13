# R2mp3

Simple audio files to mp3 library using ffmpeg and getting mp3 information.

## Installation

Install the gem and add to the application's Gemfile by executing:

    $ bundle add r2mp3

If bundler is not being used to manage dependencies, install the gem by executing:

    $ gem install r2mp3

## Usage

```
require "r2mp3"

converter = R2mp3::Converter.new(input_file: "./in.wav", output_file: "./out.mp3", bitrate: 320)
converter.run!

mp3 = R2mp3::Inspector.new(file: "out.mp3")
puts mp3.info

```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/zdk/r2mp3. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/[USERNAME]/r2mp3/blob/main/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the R2mp3 project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/zdk/r2mp3/blob/main/CODE_OF_CONDUCT.md).
