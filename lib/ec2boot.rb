require 'net/http'
require 'net/https'
require 'yaml'
require 'fileutils'

module EC2Boot
    class URLFetchFailed<RuntimeError;end
    class URLNotFound<RuntimeError;end

    autoload :Config, "ec2boot/config"
    autoload :Data, "ec2boot/data"
    autoload :UserData, "ec2boot/userdata"
    autoload :MetaData, "ec2boot/metadata"
    autoload :Util, "ec2boot/util"
    autoload :Actions, "ec2boot/actions"
end

def newaction(name, &block)
    EC2Boot::Actions.module_eval {
        define_method("#{name}_action", &block)
    }
end
