class Slap
  attr_accessor :sender, :message

  ONE_HOUR = 3600 #seconds

  def self.create( message )
    sender = message.sender.screen_name 
    message = message.to_s
    slap = Slap.new(sender,message)
    slap.save
    return slap
  end

  def initialize( sender, message )
    @sender = sender
    @message = message
    @exists = storage.has_key?(sender)
  end

  def valid?
    !exists? && valid_message?
  end

  def valid_message?
    message.match(/@([0-9a-z_]+)/i)
  end

  def exists?
     @exists
  end
  
  def outgoing_message
    if exists?
       d sender, "Only once a day. Try again tomorrow."
    elsif not valid?
      d sender, "We're all about behavior modification and noticed that you didn't target your last note. Try again."
    else
      message
    end
  end

  def save
    return false unless valid?
    storage.store(sender, message, :expires_in => ONE_HOUR)
  end

  private
  
  def d( recipient, text )
    "d #{recipient} #{text}"
  end

  def storage
    @storage ||= Moneta::DataMapper.new(:setup => "sqlite3:///#{File.join(Dir.pwd,'data','slaps.db')}")
  end

end