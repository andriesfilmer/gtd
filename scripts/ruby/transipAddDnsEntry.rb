#!/usr/bin/ruby

require 'net/http'
require 'json'
require 'openssl'
require 'base64'
require 'securerandom'

# Obtain a private key by transip
# https://www.transip.nl/cp/account/api/
private_key_path = '/path/to/transip-private.key' # replace with the path to your private key
private_key = OpenSSL::PKey::RSA.new(File.read(private_key_path))

nonce = SecureRandom.hex
request_body = {
  login: 'username', # replace with your actual login
  nonce: nonce
}.to_json

# Step 1: Obtain Access Token
digest = OpenSSL::Digest::SHA512.new
signature = private_key.sign(digest, request_body)
base64_signature = Base64.strict_encode64(signature)

uri = URI('https://api.transip.nl/v6/auth')
http = Net::HTTP.new(uri.host, uri.port)
http.use_ssl = true

request = Net::HTTP::Post.new(uri.path)
request['Signature'] = base64_signature
request['Content-Type'] = 'application/json'
request.body = request_body

response = http.request(request)

if response.is_a?(Net::HTTPSuccess)
  response_body = JSON.parse(response.body)
  token = response_body['token']
  puts "Bearer #{token}"

  # Step 2: Create DNS Entry
  dns_entry_body = {
  "dnsEntry": {
    "name": "www",
    "expire": 86400,
    "type": "A",
    "content": "127.0.0.1"
    }
  }.to_json

  dns_uri = URI('https://api.transip.nl/v6/domains/domain.com/dns')
  dns_http = Net::HTTP.new(dns_uri.host, dns_uri.port)
  dns_http.use_ssl = true

  dns_request = Net::HTTP::Post.new(dns_uri.path)
  dns_request['Authorization'] = "Bearer #{token}"
  dns_request['Content-Type'] = 'application/json'
  dns_request.body = dns_entry_body

  dns_response = dns_http.request(dns_request)

  if dns_response.is_a?(Net::HTTPSuccess)
    puts "DNS Entry created successfully"
  else
    puts "Error creating DNS entry: #{dns_response.message}"
    puts "Response Body: #{dns_response.body}"
  end
else
  puts "Error obtaining access token: #{response.message}"
  puts "Response Body: #{response.body}"
end
