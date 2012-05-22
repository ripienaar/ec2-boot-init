newaction("getactions") do |cmd, ud, md, config|
  if cmd.include?(:url) and cmd.include?(:list)
    url = cmd[:url]
    list = cmd[:list]

    EC2Boot::Util.log("Fetching action list (#{list}) from action root: #{url}")

    list = EC2Boot::Util.get_url("#{url}/#{list}")

    list.split("\n").each do |action|
      EC2Boot::Util.log("Fetching action from action root: #{action}")

      body = EC2Boot::Util.get_url("#{url}/#{action}")

      File.open(config.actions_dir + "/#{action}", "w") do |f|
        f.print body
      end
    end

    config.actions.load_actions
  end
end
