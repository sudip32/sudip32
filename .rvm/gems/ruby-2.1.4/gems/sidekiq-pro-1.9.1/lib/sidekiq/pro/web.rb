require 'sidekiq/web'
require 'sidekiq/batch'

module Sidekiq::Pro
  module Web
    ROOT = File.expand_path('../../../../web', __FILE__)

    module Helpers
      def filtering(which)
        @version ||= begin
          require 'sidekiq/pro/api'
          Sidekiq.redis {|c| c.info['redis_version'] }
        end
        return unless @version >= '2.7.106' # SCAN working in this version

        render(:erb, File.read("#{ROOT}/views/filtering.erb"), :locals => { :which => which })
      end
    end

    def self.registered(app)
      app.helpers ::Sidekiq::Pro::Web::Helpers

      ####
      # Batches
      app.get "/batches/:bid" do
        @batch = Sidekiq::Batch::Status.new(params[:bid])
        render(:erb, File.read("#{ROOT}/views/batch.erb"))
      end

      app.get "/batches" do
        @count = (params[:count] || 25).to_i
        # support pre-1.4 batch data where the score is the created_at time, not expiry time.
        # Prune conservatively.  TODO Change this to just `Time.now` in a few months.
        Sidekiq.redis {|conn| conn.zremrangebyscore('batches', '-inf', Time.now.to_f - 60*60*24) }
        (@current_page, @total_size, @batches) = page("batches", params[:page], @count, :reverse => true)
        render(:erb, File.read("#{ROOT}/views/batches.erb"))
      end
      app.tabs['Batches'] = 'batches'

      ########
      # Filtering
      app.get '/filter/retries' do
        redirect "#{root_path}retries"
      end

      app.post '/filter/retries' do
        @retries = Sidekiq::RetrySet.new.scan(params[:substr])
        @current_page = 1
        @count = @total_size = @retries.size
        erb :retries
      end

      app.get '/filter/scheduled' do
        redirect "#{root_path}scheduled"
      end

      app.post '/filter/scheduled' do
        @scheduled = Sidekiq::ScheduledSet.new.scan("*#{params[:substr]}*")
        @current_page = 1
        @count = @total_size = @scheduled.size
        erb :scheduled
      end

      app.get '/filter/dead' do
        redirect "#{root_path}morgue"
      end

      app.post '/filter/dead' do
        @dead = Sidekiq::DeadSet.new.scan("*#{params[:substr]}*")
        @current_page = 1
        @count = @total_size = @dead.size
        erb :morgue
      end

      app.settings.locales << File.expand_path('locales', ROOT)
    end
  end
end

::Sidekiq::Web.register Sidekiq::Pro::Web
