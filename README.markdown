What is it?
===========

A script to help bootstrap generic EC2 instances into specific ones.

The basic idea is that you submit some user data in the form:

<pre>
---
:facts:
  foo: bar
:write_ec2_facts: true
:actions:
- :type: :getactions
  :url: http://your.net/ec2actions/
  :list: list.txt
- :type: :puppet
  :master: puppet.your.net
</pre>

This script when run from your init system will:

 * Get list of actions ("list.txt") from action root URL "http://your.net/ec2actions/"
 * Run action "puppet" passing the variable master into it (example only)

The getactions action is shipped with this script. You can supply
your own actions in the action list ("list.txt"). Actions should be
supplied relative to action root URL ("http://your.net/ec2actions/")
so that e.g. action "puppet.rb" in action list "list.txt" is located
at "http://your.net/ec2actions/puppet.rb".

You should use this to do the basic bootstrap actions like get Puppet
on your node, do the basic setup etc.  From there you'd configure the
machine using Puppet.


Actions:
--------

Actions are written in ruby, here's a simple one that execute a
shell command:

<pre>
newaction("shell") do |cmd, ud, md, config|
    if cmd.include?(:command)
        system(cmd[:command])
    end
end
</pre>

Facts:
------

Facts passed in via the YAML will be written to /etc/facts.txt, if you set
:write_ec2_facts it will also write all the ec2 meta data into this file

Status:
-------

This is very early work-in-progress chunk of code.
