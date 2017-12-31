require 'httparty'
require 'json'
require './lib/roadmap'

class Kele
  include HTTParty
  include Roadmap
  base_uri 'https://www.bloc.io/api/v1'

  def initialize(email, password)
    post_response = self.class.post('/sessions', body: {email: email, password: password})
    @auth_token = post_response['auth_token']

    raise "Invalid Login Credentials" if @auth_token.nil?

    puts @auth_token
  end

  def get_me
    response = self.class.get('/users/me', headers: {authorization: @auth_token} )
    JSON.parse(response.body)
  end

  def get_mentor_availability(mentor_id)
    response = self.class.get("/mentors/#{mentor_id}/student_availability", headers: {authorization: @auth_token} ).to_a
    availability = []
    response.map {|timeslot| timeslot if timeslot["booked"] == true }
    availability
  end

  def get_messages(page = nil)
    if page.nil?
      response = self.class.get("/message_threads", headers: { authorization: @auth_token })
    else
      response = self.class.get("/message_threads", body: { page: page }, headers: { authorization: @auth_token })
    end
    JSON.parse(response.body)
  end

  def create_message(recipient_id, subject, token = nil, msg)
    msg_data = "{
    'sender': #{get_me['email']},
    'recipient_id': #{recipient_id},
    'token': #{token},
    'subject': #{subject}
    'stripped-text': #{msg}
    }"

    response = self.class.post("/messages", header: { authorization: @auth_token }, body: msg_data)

    "Message Sent Successfully!" if response.success?
  end

# closes class
end
