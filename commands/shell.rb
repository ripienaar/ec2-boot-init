newaction("shell") do |cmd, ud, md, config|
    if cmd.include?(:command)
        system(cmd[:command])
    end
end
