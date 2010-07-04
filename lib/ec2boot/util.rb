module EC2Boot
    class Util
        def self.get_url(url)
            Net::HTTP.get URI.parse(url)
        end

        def self.write_facts(ud, md, config)
            File.open(config.cache_dir + "/facts.txt", "w") do |facts|

                if ud.fetched?
                    if ud.user_data.include?(:facts)
                        ud.user_data[:facts].each_pair do |k,v|
                            facts.puts("#{k}=#{v}")
                        end
                    end
                end

                if md.fetched?
                    data = md.flat_data

                    data.keys.sort.each do |k|
                        facts.puts("ec2_#{k}=#{data[k]}")
                    end
                end
            end
        end
    end
end
