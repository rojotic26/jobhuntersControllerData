require_relative 'spec_helper'
require_relative 'support/jobs_helpers.rb'
require 'json'

describe 'Job Offers in CA' do
include JobsHelpers

describe 'Getting the route of the service'  do
    #Happy Path of root
    it 'Should return ok' do
        get '/'
        last_response.must_be :ok?
    end
end

  describe 'Testing for the POST path getting jobs from a certain category and a certain city' do
    before do
      Category.delete_all
    end

    it 'should find jobs within a city' do
      header = { 'CONTENT_TYPE' => 'application/json' }
      body = {
        category: ['marketing'],
        city: ['Guatemala']
      }

      #Check redirect URL from the post request
      post '/api/v2/joboffers', body.to_json, header
      last_response.must_be :redirect?
      next_location = last_response.location
      next_location.must_match /api\/v2\/offers\/\d+/

      # Check if request parameters are stored in ActiveRecord data store
      offer_id = next_location.scan(/offers\/(\d+)/).flatten[0].to_i
      saved_offer = Category.find(offer_id)
      JSON.parse(saved_offer[:category]).must_equal body[:category]
      JSON.parse(saved_offer[:city]).must_include body[:city][0]

      # Check if redirect works
      follow_redirect!
      last_request.url.must_match /api\/v2\/offers\/\d+/
    end
  end

  #Created 10/12/2014
describe 'Testing /api/v2/job_openings/:category.json' do
    #Happy path
    it 'should return jobs' do
      get '/api/v2/job_openings/marketing.json'
      last_response.must_be :ok?
    end

    #Sad paths goes here!
    it 'should return 400 bad request' do
      get '/api/v1/job_openings/falsecategory.json'
      last_response.must_be :bad_request?
    end
end

#Created 10/12/2014
describe 'Testing /api/v2/job_openings/:category/city/:city.json' do
    #happy path :)
    it 'should return jobs' do
      get '/api/v2/job_openings/marketing/city/Guatemala.json'
      last_response.must_be :ok?
    end
    it 'should return 404 not found' do
      get '/api/v2/job_openings/marketing-ventas/city/Taiwan.json'
      last_response.must_be :not_found?
    end
end

describe 'Testing the Delete'  do
it 'should report error if deleting an unknown entry' do
      delete "/api/v2/offer/55555"
      last_response.must_be :not_found?
    end
end

end
