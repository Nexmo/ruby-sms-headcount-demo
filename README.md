# Taking a Headcount with Nexmo SMS API and Ruby

A Sinatra and Ruby app showing how you can take attendance for an event with SMS and the Nexmo SMS API.

## Prerequisites

* [A Nexmo account](https://dashboard.nexmo.com/sign-up)
* [Ruby 2.5+](https://www.ruby-lang.org/)
* [Sinatra 2.0.5+](http://sinatrarb.com/)

## Getting Started

```sh
# clone this repository
git clone git@github.com:Nexmo/ruby-headcount-sms-demo
# change to folder
cd ruby-headcount-sms-demo
# install dependencies
bundle install
# copy example .env to actual .env
cp .env.sample .env
```

Next you will need to sign up for a Nexmo account, grabv your API credentials from the API dashboard, register a phone number and put all those details in your `.env` file.

Finally, make sure to link the callback URL for your number to your app. This needs to be a publicly accessible URL. Tools like [ngrok](https://ngrok.com/) give you a URL that can be accessed externally. You can link your callback URL to your Nexmo phone number by using the Nexmo CLI:

```sh
> nexmo link:sms [your number] http://your-ngrok-domain/inbound
Number updated
```

## Usage

To start your server execute `ruby headcount.rb` from the command line and then go visit [localhost:4567](localhost:4567) from your web browser. 

You can put in as many phone numbers as you like, seperated by a comma. Each number you send to will receive a message asking them to confirm their attendance. Receipients can respond with either "1" for yes or "2" for no.

Once you send the confirmation SMS, you will be redirected to a page that will display in realtime the number of confirmed attendees. When the number hits the minimum required for the event, a confirmation message will be sent to all those who responded affirmatively that the event is on. 

As this is a simple starter app, this app does not validate or store the responses.

## License

This project is licensed under the [MIT License](LICENSE).