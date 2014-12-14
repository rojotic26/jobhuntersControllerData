require 'aws-sdk'

class Tutorial < AWS::Record::HashModel
  string_attr :title
  string_attr :date
  string_attr :city
  string_attr :details
  timestamps

  def self.destroy(id)
    find(id).delete
  end

  def self.delete_all
    all.each { |r| r.delete }
  end

end
class Category < ActiveRecord::Base
  string_attr :description
  string_attr :category
  string_attr :city
  timestamps

  def self.destroy(id)
    find(id).delete
  end

  def self.delete_all
    all.each { |r| r.delete }
  end
  
end
