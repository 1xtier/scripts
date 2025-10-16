#!/usr/bin/env ruby

require 'net/http'
require 'uri'
require 'json'

class TelegramNotifier
  def initialize 
    @token = ENV['TELEGRAM_BOT_TOKEN']
    @chat_id = ENV['TELEGRAM_CHAT_ID']
  end 
  def send_alert(service, description, event, host = nil)
    begin 
      host ||= 'hostname'.chomp
      timestamp = Time.now.strftime("%Y-%m-%d %H:%M:%S")
      message = format_message(service, description, event, host, timestamp)
      send_to_telegram(message)
      log("Alert sent successfully: #{service} - #{event}")
    rescue => e
      log("Error: #{e.message}")
    end
  end 

  private 

  def format_message(service, description, event, host, timestamp)
    event_emoji = {
      'ACTION' => '🔧',
      'EXEC' => '⚡', 
      'TIMEOUT' => '⏰',
      'RESTART' => '🔄',
      'CHECKSUM' => '🔍',
      'RESOURCE' => '📊',
      'CONNECTION' => '🔌',
      'START' => '🟢',
      'STOP' => '🔴',
      'FAILED' => '❌',
      'HIGH_CPU' => '🔥',
      'HIGH_LOAD' => '📈',
      'HIGH_MEMORY' => '💾',
      'DISK_SPACE' => '💽',
      'DISK_INODE' => '📁'     
    }

    emoji = event_emoji[event.to_s.upcase] || 'ℹ️'
    description = description[0..2000] + "..." if description.length > 2000
  message = <<~MSG
    #{emoji} <b>MONIT - #{event.to_s.upcase}</b>

🏠 <b>Host:</b> <code>#{host}</code>
📦 <b>Service:</b> <code>#{service}</code>
⏰ <b>Time:</b> <code>#{timestamp}</code>

📋 <b>Description:</b>
<pre>#{description}</pre>

MSG
  if message.length > 4096
    log("Message too long: #{message.length} characters. Truncating...")
    message = message[0.4096] + "\n..."
  end 
  message
  end 


  def send_to_telegram(text)
    uri = URI.parse("https://api.telegram.org/bot#{@token}/sendMessage")
    data = {
      chat_id: @chat_id,
      text: text,
      parse_mode: 'HTML',
      disable_web_page_preview: true
    }
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    request = Net::HTTP::Post.new(uri.path)
    request.content_type = 'application/json'
    request.body = data.to_json
    response = http.request(request)
    log("Telegram response: #{response.code}")
    if response.code != '200'
      log("Telegram error response: #{response.body}")
       error_info = JSON.parse(response.body) rescue {}
        if error_info['description']&.include?('chat not found')
           log("ERROR: Chat not found! Please check:")
           log("1. TELEGRAM_CHAT_ID: #{@chat_id}")
           log("2. Bot is added to the chat/channel")
           log("3. For channels: use @channelname format")
           log("4. For private chats: use numeric ID")
      end
      return false
    end
    true 
  rescue => e
    log("Network error: #{e.message}")
    false 
  end
  end 
  def log(message)
    File.open('/var/log/monit/alert_monit.log', 'a') do |f|
      f.puts "#{Time.now} - #{message}"
    end
  end

if __FILE__ == $0 
  if ARGV.length >= 3
    service, description, event = ARGV[0], ARGV[1], ARGV[2]
    host = ARGV[3]
    notifier = TelegramNotifier.new
    notifier.send_alert(service, description, event, host)
  else
    puts "Usage: #{$0} <service> <description> <event> [host]"
    puts "Example: #{$0} nginx 'Process failed' FAILED server1"
    exit 1
  end 
end
