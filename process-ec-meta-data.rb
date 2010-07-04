#!/usr/bin/ruby

require 'pp'
require 'ec2boot'

config = EC2Boot::Config.new
ud = EC2Boot::UserData.new(config)
md = EC2Boot::MetaData.new(config)

EC2Boot::Util.write_facts(ud, md, config)

config.actions.run_actions(ud, md, config)

