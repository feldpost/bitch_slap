require 'rubygems'
require 'extlib'
require 'twibot'
gem 'twibot', '>=0.1.3'
require 'daemon-spawn'
require File.join(File.dirname(__FILE__),'slap')
require File.join(File.dirname(__FILE__),'twibot_patch')

class Bot < DaemonSpawn::Base

  def start( args )    
    message do | message, params |
      begin
        slap = Slap.create message
        post_tweet slap.outgoing_message
      rescue
        nil
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