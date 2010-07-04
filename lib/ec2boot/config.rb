module EC2Boot
    class Config
        attr_reader :user_data_url, :meta_data_url, :cache_dir, :actions_dir, :actions

        def initialize
            @user_data_url = "http://nephilim.ml.org/~rip/fakeec2/user-data"
            @meta_data_url = "http://nephilim.ml.org/~rip/fakeec2/meta-data"
            @cache_dir = "/home/rip/temp/ec2cache"
            @actions_dir = "/home/rip/work/ec2-boot-init/commands"

            @actions = Actions.new(self)
        end
    end
end
