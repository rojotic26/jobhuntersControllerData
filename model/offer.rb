require 'aws-sdk'

class Tutorial < AWS::Record::HashModel
  string_attr :title
  string_attr :date
  string_attr :city
  string_attr :details
  timestamps
end
class Category < ActiveRecord::Base
  string_attr :description
  string_attr :category
  string_attr :city
  timestamps
end
