require 'nexmo'
require 'sinatra'
require 'dotenv'

Dotenv.load

# Set Up Nexmo Credentials
client = Nexmo::Client.new(
    api_key: ENV['NEXMO_API_KEY'],
    api_secret: ENV['NEXMO_API_SECRET'],
)

# Event Minimum Headcount Required
@@required = 10

# Headcount variable
@@headcount = 0

# Attendees variable array
@@attendees = []

# Render index page
get '/' do
    erb :index
end

# Send SMS headcount message
post '/send' do
    # Define the phone numbers array
    @numbers = params['numbers'].split(',')

    puts "Sending headcount message..."
    @numbers.each do |number|
        client.sms.send(
            from: ENV['NEXMO_NUMBER'],
            to: number,
            text: "Can you make the event today? Please respond with 1 for YES and 2 for NO. Thank you!"
        )
    end
    puts "Finished sending the headcount message..."
    erb :summary
end

# Receive message receipt
get '/delivery' do
    puts "Message to #{params['msisdn']}, status: #{params['status']}."
end

# Process the response
get '/inbound' do
    status 200
    # Assign params to local variables
    answer = params['text'].to_i
    number = params['msisdn']

    if answer == 1
        @@headcount += 1
        @@attendees << number
    end
    if answer == 2
        client.sms.send(
            from: ENV['NEXMO_NUMBER'],
            to: number,
            text: "Sorry you can't make it, but thanks for letting us know!"
        )
    end

    if @@headcount >= @@required
        @@attendees.each do |attendee|
            client.sms.send(
                from: ENV['NEXMO_NUMBER'],
                to: attendee,
                text: "The event is confirmed. See you there!"
            )
        end
        @@headcount = 0
    end
    'okay'
end

get '/summary' do
    erb :summary
end

get '/update_headcount' do
    halt 200, {:headcount => @@headcount, :required => @@required}.to_json
end

get '/confirmation' do
    erb :confirmation
end