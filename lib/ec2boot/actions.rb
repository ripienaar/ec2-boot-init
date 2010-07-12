module EC2Boot
    class Actions
        def initialize(config)
            @actions_dir = config.actions_dir

            load_actions
        end

        def load_actions
            Dir.entries(@actions_dir).grep(/\.rb$/).each do |cmd|
                load [@actions_dir, cmd].join("/")
            end
        end

        def run_actions(ud, md, config)
            if ud.user_data.is_a?(Hash)
                if ud.user_data.include?(:actions)
                    ud.user_data[:actions].each do |action|
                        if action.include?(:type)
                            type = action[:type].to_s
                            meth = "#{type}_action"

                            if respond_to?(meth)
                                begin
                                    Util.log("Running action #{type}")

                                    send(meth, action, ud, md, config)
                                rescue Exception => e
                                    Util.log("Failed to run action #{type}: #{e.class}: #{e}")
                                end
                            else
                                # no such method
                            end
                        else
                            # no type
                        end
                    end
                else
                    # no :actions
                end
            else
                # not a hash
            end
        end
    end
end
