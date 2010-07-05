What is it?
===========

A script to help bootstrap generic EC2 instances into specific ones.

The basic idea is that you submit some user data in the form:

<pre>
--- 
:facts: 
  foo: bar
:actions: 
- :url: http://your.net/ec2commands/
  :type: :getcommands
- :master: puppet.your.net
  :type: :puppet
</pre>

This script when run from your init system will:

 * Connect to http://your.net/ec2commands/ and fetch a bunch of actions
 * Run the action called "puppet" passing the variable master into it

The puppet action isn't shipped but can be supplied by your on the
URL to the getcommands action.

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

Once run all the EC2 meta data and user data are cached locally
and a file /etc/facts.txt gets written in a list of key=value pairs.

Ideal for importing in tools like Facter.

Status:
-------

This is very early work-in-progress chunk of code.
