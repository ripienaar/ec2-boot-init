module EC2Boot
    class UserData<Data
        attr_reader :user_data, :user_data_raw

        def initialize(config)
            @user_data = nil

            super(config)

            fetch
        end

        private
        def fetch
            @user_data_raw = Util.get_url(@config.user_data_url)
            @user_data = YAML.load(@user_data_raw)

            File.open(@config.cache_dir + "/user-data.raw", "w") do |ud|
                ud.puts @user_data_raw
            end

            @fetched = true
        end
    end
end
