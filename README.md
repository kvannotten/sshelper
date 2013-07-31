# Sshelper

This gem is supposed to make your life easier if you have to do a lot of repetitive tasks over SSH. If you are sick 
of doing the constant ```ssh user@example.org```, ```cd /opt/path/to/something```, ```./start.sh``` 
etc, then this tool is for you!


## Installation

Install it as follows:

    $ gem install sshelper

## Usage

After installation, you will have to create a '.sshelper.json' file in your home directory:

    $ touch ~/.sshelper.json
    
Open it in your favorite editor:

    $ nano ~/.sshelper.json
    
And use the following structure to add labels:
```
{
  "my_label1": {
    "servers": [
        {
          "host": "example.org",
          "port": 22,
          "user": "root"
        },
        {
          "host": "test.com",
          "port": 1234,
          "user": "eddy"
        }
      ],
    "commands": [
        "ls -l",
        "cat `ls -1rt | tail -1`"
      ]
  },
  "my_label2": {
    "servers": [
        {
          "host": "example.org",
          "port": 22,
          "user": "root"
        }
      ],
    "commands": [
        "ls -1"
      ]
  }
}

```

After you have added a configuration file with labels, servers and commands, you can do stuff like this:

    $ sshelper my_label1
    
This will execute all commands defined under "my_label1" on all servers defined under that same block! Talking about
enhancing your workflow...

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
