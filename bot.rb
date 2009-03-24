require 'rubygems'
require 'logger'
require 'twibot'
gem 'twibot', '>=0.1.3'
require 'daemon-spawn'
require File.join(File.dirname(__FILE__),'pathname_patch')
require 'moneta'
require 'moneta/datamapper'
require File.join(File.dirname(__FILE__),'slap')
require File.join(File.dirname(__FILE__),'twibot_patch')
require File.join(File.dirname(__FILE__),'message')

class Bot < DaemonSpawn::Base

  def start( args )    
    message do | message, params |
      begin
        unless Message.exists?(message)
          slap = Slap.create message
          post_tweet slap.outgoing_message
        end
      rescue => e
        STDERR.puts e.message
      end
    end
  end

  def stop
  end
  
end

Bot.spawn!  :log_file => File.join(File.dirname(__FILE__),'log','bitch_slap.log'),
            :pid_file => File.join(File.dirname(__FILE__),'pids','bitch_slap.pid'),
            :sync_log => true,
            :working_dir => File.dirname(__FILE__)