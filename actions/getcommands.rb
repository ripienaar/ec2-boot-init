newaction("getcommands") do |cmd, ud, md, config|
    if cmd.include?(:url)
        url = cmd[:url]

        list = EC2Boot::Util.get_url(url)

        list.split("\n").each do |command|
            puts "Fetching command: #{command}"

            body = EC2Boot::Util.get_url("#{url}/#{command}")

            File.open(config.actions_dir + "/#{command}", "w") do |f|
                f.print body
            end
        end

        config.actions.load_actions
    end
end
