# Idrop

*this is a work in progress*

watch folder -> [ mkv -> mp4 ] -> scp -> destination

## Installation

Add this line to your application's Gemfile:

    gem 'idrop'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install idrop

## Usage

`idrop help watch` to learn more

## Example

```
$ idrop watch -s here -d keyvan@there:in_here
Destination is set to keyvan@there:in_here. Make sure you can scp files there...
Recursively watching /Users/keyvan/Code/eyedrop/idrop/here for mkv files
Logging to /Users/keyvan/here/watcher/log/watcher.log
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
