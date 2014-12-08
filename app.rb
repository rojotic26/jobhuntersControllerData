require 'sinatra/base'
require 'jobhunters'
require 'json'
require_relative 'model/offer'

class HuntingForAJobService < Sinatra::Base

  configure :production, :development do
    enable :logging
  end

  helpers do

    def offerobject
      category = check_cat(params[:category])
      if category == 'none' then
        return nil
      end
      return nil unless category
      catego = { 'id' => category , 'offers' => [], }
      begin
        JobSearch::Tecoloco.getjobs(category).each do |title, date, cities, details|
          catego['offers'].push('title'=>title,'date'=>date,'city'=>cities, 'details'=>details)
        end
        catego
      rescue
        nil
      end
    end

    def get_jobs(category)
      jobs_after = {
        'type of job' => category,
        'kind' => 'openings',
        'jobs' => []
      }
      category = check_cat(params[:category])
      JobSearch::Tecoloco.getjobs(category).each do |title, date, cities, details|
        jobs_after['jobs'].push('id' => title, 'date' => date, 'city' => cities, 'details'=>details)
      end
      jobs_after
    end


    #Defining the function get_jobs_cat_city

    def get_jobs_cat_city(category,city)
      jobs_after_city = {
        'jobs' => []
      }
      flag=false
      cat = check_cat(category[0])
      cit = city[0]
      JobSearch::Tecoloco.getjobs(cat).each do |title, date, cities, details|
        if cities.to_s == cit.to_s
          flag=true
          jobs_after_city['jobs'].push('id' => title, 'date' => date, 'cities' => cities, 'details' => details)
        end
      end
      if flag==false then
        halt 404
      else
        jobs_after_city
      end
    end

    def get_jobs_cat_city_url(category,city)
      jobs_after_city = {
        'type of job' => category,
        'kind' => 'openings',
        'city' => city,
        'jobs' => []
      }
      flag=false
      category = check_cat(params[:category])
      city = params[:city]
      JobSearch::Tecoloco.getjobs(category).each do |title, date, cities|
        if cities.to_s == city.to_s
          flag=true
          jobs_after_city['jobs'].push('id' => title, 'date' => date)
        end
      end
      if flag==false then
        halt 404
      else
        jobs_after_city
      end
    end

    ##Checks if Category exists within Tecoloco
    def check_cat(category)
      case category
      when  "marketing"
        @output = "marketing-ventas"
      when "banca"
        @output = "banco-servicios-financieros"
      else
        @output = "none"
        halt 404
      end
      @output
    end

    def list_joboffers(categories)
      @list_all = {}
      categories.each do |category|
        @list_all[category] = JobSearch::Tecoloco.getjobs(category)
      end
      @list_all
    end
  end

  get '/' do
    'HuntingForJobs api/v2 is up and working at /api/v2/'
  end

  # API handlers

  get '/api/v1/?*' do
    status 400
    'HuntingForJobs api/v1 is deprecated: please use <a href="/api/v2/">api/v2</a>'
  end

  get '/api/v2/?' do
    'HuntingForJobs /api/v2 is up and working'
  end

  get '/api/v2/job_openings/:category.json' do
    cat = params[:category]
      content_type :json
      get_jobs(cat).to_json
    end

  

  get '/api/v2/job_openings/:category/city/:city.json' do
    content_type :json
    get_jobs_cat_city_url(params[:category],params[:city]).to_json
  end

  post '/api/v2/joboffers' do
    content_type:json

    body = request.body.read
    logger.info body
    begin
      req = JSON.parse(body)
      logger.info req
    rescue Exception => e
      puts e.message
      halt 400
    end

    cat = Category.new
    cat.category = req['category'].to_json
    cat.city = req['city'].to_json

    if cat.save
      redirect "/api/v2/offers/#{cat.id}"
    end
  end

  delete '/api/v2/joboffers/:id' do
    cat = Category.destroy(params[:id])
  end

  get '/api/v2/offers/:id' do
    content_type:json
    logger.info "GET /api/v2/offers/#{params[:id]}"
    begin
      @category = Category.find(params[:id])
      cat = JSON.parse(@category.category)
      cat2 = @category.category
      city = JSON.parse(@category.city)
    rescue
      halt 400
    end
    logger.info({ category: cat, city: city }.to_json)
    result = get_jobs_cat_city(cat, city).to_json
    logger.info "result: #{result}\n"
    result
  end
end
