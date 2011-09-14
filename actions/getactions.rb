newaction("getactions") do |cmd, ud, md, config|
    if cmd.include?(:url) and cmd.include?(:list)
        url = cmd[:url]
        list = cmd[:list]

        EC2Boot::Util.log("Fetching action list (#{list}) from #{url}")

        list = EC2Boot::Util.get_url("#{url}/#{list}")

        list.split("\n").each do |command|
            EC2Boot::Util.log("Fetching command: #{command}")

            body = EC2Boot::Util.get_url("#{url}/#{command}")

            File.open(config.actions_dir + "/#{command}", "w") do |f|
                f.print body
            end
        end

        config.actions.load_actions
    end
end
