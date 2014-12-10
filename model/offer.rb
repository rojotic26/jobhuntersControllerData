require 'sinatra'
require 'sinatra/activerecord'
require_relative '../config/environments'

class Offer < ActiveRecord::Base
end
class Category < ActiveRecord::Base
end
