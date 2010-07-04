module EC2Boot
    class MetaData<Data
        attr_reader :meta_data

        def initialize(config)
            @meta_data = nil

            super(config)

            FileUtils.mkdir_p(@config.cache_dir + "/meta-data")

            fetch
        end

        def flat_data
            flatten(@meta_data)
        end

        private
        def fetch
            @meta_data = get_tree("/")
            @fetched = true
        end

        # Turns the multi dimensional ec2 data into a boring flat version
        def flatten(data, prefix = "")
            flat = {}

            data.each_pair do |k,v|
                key = prefix + k.gsub("-", "_")

                if v.is_a?(String)
                    v.chomp!

                    # if it's got multiple lines split them out in _x
                    if v.match("\n")
                        v.split("\n").each_with_index do |val, idx|
                            flat[key + "_#{idx}"] = val
                        end
                    else
                        flat[key] = v
                    end
                elsif v.is_a?(Hash)
                    flat.merge!(flatten(v, "#{key}_"))
                end
            end

            flat
        end

        # gets an entire tree of ec2 data
        def get_tree(root)
            tree_url = @config.meta_data_url + root
            cache_root = @config.cache_dir + "/meta-data/" + root

            keys = {}

            tree_root = Util.get_url(tree_url).split("\n")

            tree_root.each do |branch|
                if branch =~ /\/$/
                    # its a sub dir
                    keyname = branch.chop

                    FileUtils.mkdir_p(cache_root + "/" + branch)
                    keys[keyname] = get_tree(root + "/" + branch)
                else
                    if branch =~ /(.+?)=(.+)/
                        FileUtils.mkdir_p(cache_root + "/" + $1)
                        keys[$1] = get_tree(root + "/" + $1 + "/")
                    else
                        keys[branch] = get_key(root + "/" + branch)
                    end
                end
            end

            keys
        end

        # strip out all //'s in key paths
        def clean_path(path)
            path = path.gsub(/\/\//, "/")

            if path.match(/\/\//)
                path = clean_path if path.match(/\/\//)
            end

            path
        end

        # gets a key, looks in the cache first
        def get_key(key)
            url = @config.meta_data_url + clean_path(key)
            cache_file = clean_path(@config.cache_dir + "/meta-data" + key)

            if File.exist?(cache_file)
                val = File.read(cache_file)
            else
                val = Util.get_url(url)
                File.open(cache_file, "w") {|f| f.puts val}
            end

            val
        end
    end
end
