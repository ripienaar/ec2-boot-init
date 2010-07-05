module EC2Boot
    class Util
        def self.get_url(url)
            uri = URI.parse(url)
            http = Net::HTTP.new(uri.host, uri.port)
            http.open_timeout = 3
            http.read_timeout = 3

            retries = 5

            begin
                result = Net::HTTP.get URI.parse(url)
                request = Net::HTTP::Get.new(uri.request_uri)
                response = http.request(request)

                raise URLNotFound if response.code == "404"
                raise URLFetchFailed, "#{url}: #{response.code}" unless response.code == "200"

                if response.code == "200"
                    return response.body
                else
                    return ""
                end
            rescue URLFetchFailed => e
                retries -= 1
                sleep 1
                retry if retries > 0
            end
        end

        def self.write_facts(ud, md, config)
            File.open(config.facts_file, "w") do |facts|

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

                if data.include?("placement_availability_zone")
                    facts.puts("ec2_placement_region=" + data["placement_availability_zone"].chop)
                end
            end
        end
    end
end
