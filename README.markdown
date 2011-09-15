What is it?
===========

A script to help bootstrap generic EC2 instances into specific ones.

The basic idea is that you submit some user data in the form:

<pre>
--- 
:facts: 
  foo: bar
:actions: 
- :type: :getactions
  :url: http://your.net/ec2actions/
  :list: list.txt
- :type: :puppet
  :master: puppet.your.net
</pre>

This script when run from your init system will:

 * Get a list of actions (list.txt) from action root URL http://your.net/ec2actions/
 * Run action called "puppet" passing the variable master into it

The puppet action isn't shipped but can be supplied by your on the
URL to the getactions action.

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

Once run all the EC2 meta data and user data are cached locally
and a file /etc/facts.txt gets written in a list of key=value pairs.

Ideal for importing in tools like Facter.

Status:
-------

This is very early work-in-progress chunk of code.
