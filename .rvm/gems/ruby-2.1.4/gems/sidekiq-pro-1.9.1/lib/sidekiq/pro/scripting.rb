module Sidekiq
  module Pro
    module Scripting

      LUA_SCRIPTS = {
        :queue_delete_by_jid => <<-LUA,
          local window = 50
          local size = redis.call('llen', KEYS[1])
          local idx = 0
          local result = nil
          while (idx < size) do
            local jobs = redis.call('lrange', KEYS[1], idx, idx+window-1)
            for _,jobstr in pairs(jobs) do
              if string.find(jobstr, ARGV[1]) then
                local job = cjson.decode(jobstr)
                if job.jid == ARGV[1] then
                  redis.call('lrem', KEYS[1], 1, jobstr)
                  result = jobstr
                  break
                end
              end
            end
            idx = idx + window
          end
          return result
        LUA
        :queue_delete_by_class => <<-LUA,
          local size = redis.call('llen', KEYS[1])
          local page_size = 50
          local result = 0
          local r = size - 1
          while (r >= 0) do
            local l = r - page_size
            if l < 0 then
              l = 0
            end
            local jobs = redis.call('lrange', KEYS[1], l, r)
            for _, jobstr in pairs(jobs) do
              if string.find(jobstr, ARGV[1]) then
                local job = cjson.decode(jobstr)
                if job.class == ARGV[1] then
                  redis.call('lrem', KEYS[1], 1, jobstr)
                  result = result + 1
                end
              end
            end
            r = r - page_size
          end
          return result
        LUA
        :sorted_set_find_by_jid => <<-LUA
        local window = 50
          local size = redis.call('zcard', KEYS[1])
          local idx = 0
          local result = nil
          while (idx < size) do
            local jobs = redis.call('zrange', KEYS[1], idx, idx+window-1, 'withscores')
            for i = 1,table.getn(jobs),2 do
              local jobstr = jobs[i]
              local score = jobs[i + 1]
              if string.find(jobstr, ARGV[1]) then
                local job = cjson.decode(jobstr)
                if job.jid == ARGV[1] then
                  result = {}
                  result[1] = jobstr
                  result[2] = score
                  break
                end
              end
            end
            idx = idx + window
          end
          return result
        LUA
      }

      SHAs = {}

      def self.bootstrap
        Sidekiq.logger.debug { "Loading Sidekiq Pro Lua extensions" }

        Sidekiq.redis do |conn|
          LUA_SCRIPTS.each_with_object(SHAs) do |(name, lua), memo|
            memo[name] = conn.script(:load, lua)
          end
        end
      end

      def self.call(name, keys, args)
        bootstrap if SHAs.length != LUA_SCRIPTS.length

        Sidekiq.redis do |conn|
          conn.evalsha(SHAs[name], keys, args)
        end

      rescue Redis::CommandError => ex
        if ex.message =~ /unknown command/
          raise "Redis 2.6 is required for Lua usage, please upgrade [#{Sidekiq.redis_version}]"
        else
          raise
        end
      end

    end
  end
end
