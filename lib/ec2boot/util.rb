module EC2Boot
    class Util
        # Fetches a url, it will retry 5 times if it still
        # failed it will return ""
        #
        # If an optional file is specified it will write
        # the retrieved data into the file in an efficient way
        # in this case return data will be true or false
        #
        # raises URLNotFound for 404s and URLFetchFailed for
        # other non 200 status codes
        def self.get_url(url, file=nil)
            uri = URI.parse(url)
            http = Net::HTTP.new(uri.host, uri.port)
            http.open_timeout = 3
            http.read_timeout = 3

            retries = 5

            begin
                if file
                    dest_file = File.open(file, "w")
                    response = http.get(uri.path) do |r|
                        dest_file.write r
                    end
                    close dest_file
                else
                    response = http.get(uri.path)
                end

                raise URLNotFound if response.code == "404"
                raise URLFetchFailed, "#{url}: #{response.code}" unless response.code == "200"

                if response.code == "200"
                    if file
                        return true
                    else
                        return response.body
                    end
                else
                    if file
                        return false
                    else
                        return ""
                    end
                end
            rescue URLFetchFailed => e
                retries -= 1
                sleep 1
                retry if retries > 0
            end
        end

        # Logs to stdout and syslog
        def self.log(msg)
            puts "#{Time.now}> #{msg}"
            system("logger msg")
        end

        def self.write_facts(ud, md, config)
            File.open(config.facts_file, "w") do |facts|

                if ud.fetched?
                    if ud.user_data.is_a?(Hash)
                        if ud.user_data.include?(:facts)
                            ud.user_data[:facts].each_pair do |k,v|
                                facts.puts("#{k}=#{v}")
                            end
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
