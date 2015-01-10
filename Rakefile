require './app'
require 'rake/testtask'
require_relative 'model/offer.rb'

task :default => :spec

desc "Run all tests"
Rake::TestTask.new(name=:spec) do |t|
  t.pattern = 'spec/*_spec.rb'
end

namespace :db do
  desc "Creates database"
  task :migrate do
    begin
      Category.create_table(5, 6)
    rescue AWS::DynamoDB::Errors::ResourceInUseException => e
      puts 'DB exists -- no changes made, no retry attempted'
    end
  end
  task :populate do
    begin
     countries = ['Guatemala', 'El Salvador', 'Honduras','Nicaragua','Costa Rica','Panama']
     jobs = ['banca', 'marketing']
     jobs.each do |cat|
      countries.each do |city|
       job = Jobs.new
       job.category = cat.to_json
       job.city = city.to_json
       if job.save
         puts 'Record of added'
       else
         puts "there was an error with #{x}"
       end
     end
    end
   end
  end
end
