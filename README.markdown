README
======

Basics
------

server.rb (forks a subprocess):

```ruby
EM.popen("ruby [...] -e 'Tournament::Agent.new'", ClientProxy)
```

agent.rb (in order to receive input the stdin will be attached to EM)

```ruby
EM::attach($stdin, ServerProxy)
```

Messages
--------

JSON is used for messages

a message, that does

{
  message: 'action',
  arguments: [arg1,arg2]
}

{
  receiver: <uuid_for_population>
  message: 'action',
  arguments: [arg1,arg2]
}

a message that expects a return value

{
  message: 'action',
  arguments: [arg1,arg2]
  return: uuid
}

{
  return: uuid,
  value: 'return value'
}

Credits
-------

Inpired by