module EC2Boot
  class Data
    def initialize(config)
      @fetched = false
      @config = config
    end

    def fetched?
      @fetched
    end
  end
end
