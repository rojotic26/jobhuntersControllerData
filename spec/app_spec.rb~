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

#Created 10/12/2014
describe 'Testing /api/v2/job_openings/:category.json'
    #Happy path
    it 'should return jobs' do
      get '/api/v2/job_openings/marketing.json'
      last_response.must_be :ok?
    end

    #Sad paths goes here!
    it 'should return 404 not found' do
      get '/api/v1/job_openings/falsecategory.json'
      last_response.must_be :not_found?
    end
end

#Created 10/12/2014
describe 'Testing /api/v2/job_openings/:category/city/:city.json'
    #happy path :)
    it 'should return jobs' do
      get '/api/v2/job_openings/marketing-ventas/city/Nicaragua.json'
      last_response.must_be :ok?
    end
    it 'should return 404 not found' do
      get '/api/v2/job_openings/marketing-ventas/city/Taiwan.json'
      last_response.must_be :not_found?
    end
end

describe 'Testing /api/v2/offers/:id'
    #happy path :)
    it 'should return jobs ' do
      get '/api/v2/offers/1'
      last_response.must_be :ok?
    end
    
    #sad paths :(
    it 'should return 404 not found' do
      get '/api/v2/offers/50'
      last_response.must_be :not_found?
    end
end

end
