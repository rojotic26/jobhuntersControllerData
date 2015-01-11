require 'sinatra/base'
require 'jobhunters'
require 'json'
require_relative 'model/offer'

class JobDynamo < Sinatra::Base

  configure do
    AWS.config(
    access_id_key: ENV['AWS_ACCESS_KEY_ID'],
    secrect_access_key: ENV['AWS_SECRET_ACCESS_KEY'],
    region: ENV['AWS_REGION']
    )
  end
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
        {jobs: jobs_after_city}

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
    "#{app.class.name} api/v2 is up and working at /api/v2/'"
  end

  # API handlers

  get '/api/v1/?*' do
    status 400
    "#{app.class.name}api/v1 is deprecated: please use" + "<a href=\"/api/v2/\">#{request.host}/api/v2/</a>"
  end

  get '/api/v2/?' do
    "#{app.class.name}HuntingForJobs /api/v2 is up and working"
  end

  get '/api/v2/job_openings/:category.json' do
    cat = params[:category]
      content_type :json
      get_jobs(cat).to_json
    end

  post '/api/v2/joboffers'do
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
  end

  get '/api/v2/job_openings/:category/city/:city.json' do
    content_type :json
    category = params[:category]
    city = params[:city]
    logger.info category.class
    logger.info city
    get_jobs_cat_city_url(params[:category],params[:city]).to_json
  end

  post '/api/v2/offers' do
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

  get '/api/v2/offers/?' do
    content_type :json
    body = request.body.read

    begin
      index = Category.all.map do |t|
        { id: t.id, category: t.category, city: t.city,
          created_at: t.created_at, updated_at: t.updated_at }
      end
      rescue => e
        halt 400
    end

      index.to_json
  end
  get '/api/v2/jobs/?' do
    content_type :json
    body = request.body.read
    begin
      index = Jobs.all.map do |t|
        {id: t.id, category: t.category, city: t.city,
          created_at: t.created_at, updated_at: t.updated_at}
      end
    rescue => e
      halt 400
    end
    index.to_json
  end
  get '/api/v2/jobs/:id' do
    content_type :json
    begin
      jobs = Jobs.find(params[:id])
    rescue
      halt 404
    end
    begin
      category = JSON.parse(jobs.category)
      city = JSON.parse(jobs.city)
      logger.info category
      logger.info city
      joboffers = get_jobs_cat_city(category,city)
      jobs.results = joboffers[:jobs].to_json
      jobs.save
    rescue => e
      halt 400, e
    end
    jobs.results
  end
end
