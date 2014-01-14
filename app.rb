require 'sinatra'

require 'mail'

require 'securerandom'

require 'erb'
require 'tilt'

require 'aws/s3'

if ENV == nil
	require 'dotenv'
	Dotenv.load
end

AWS::S3::Base.establish_connection!(
  :access_key_id => ENV['S3_ACCESS_KEY_ID'],
  :secret_access_key => ENV['S3_SECRET_ACCESS_KEY']
)

post '/parse' do
  headers = Mail.new(params[:headers])

  id = headers['X-Save-Mail-ID'] || SecureRandom.uuid

  template_name = headers['X-Save-Mail-Template'] || "default"

  template_name += ".html.erb"

  template = Tilt.new("_templates/" + template_name)
  result = template.render(params, :parsed_headers => headers)

  AWS::S3::S3Object.store(
      "#{id}.html",
      result,
      ENV['S3_BUCKET'],
      :content_type => 'text/html',
      :access => :public_read
  )

  "OK."
end