README
======

[![Build Status](https://secure.travis-ci.org/grrrisu/em-box.png?branch=master)](http://travis-ci.org/grrrisu/em-box)

Basics
------

server.rb (forks a subprocess):

```ruby
EM.popen("ruby [...] -e 'MyClient.new'", ClientConnection)
```

agent.rb (in order to receive input the stdin will be attached to EM)

```ruby
EM::attach($stdin, ServerConnection)
```

Messages
--------

JSON is used for messages

```javascript
{
  status: 'ready'
}

{
  message: 'action',
  arguments: [arg1,arg2]
}

{
  receiver: <uuid_for_population>
  message: 'action',
  arguments: [arg1,arg2]
}
```

a message that expects a return value

```javascript
{
  message: 'action',
  arguments: [arg1,arg2],
  return: uuid
}

{
  return: uuid,
  value: 'return value'
}
```

Credits
-------

Thanks to
* Avdi Grimm for his series 'A dozen (or so) ways to start sub-processes in Ruby' [part 1](http://devver.wordpress.com/2009/06/30/a-dozen-or-so-ways-to-start-sub-processes-in-ruby-part-1/), [part 2](http://devver.wordpress.com/2009/07/13/a-dozen-or-so-ways-to-start-sub-processes-in-ruby-part-2/) and [part 3](http://devver.wordpress.com/2009/10/12/ruby-subprocesses-part_3/)
* Tass [Cyberspace](https://github.com/Tass/cyberspace) for inspiring me back

Copyright
--------

Copyright (c) 2012 Alessandro Di Maria. See LICENSE.txt for further details.
