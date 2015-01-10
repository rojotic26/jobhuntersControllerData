require 'aws-sdk'

class Category < AWS::Record::HashModel
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

class Jobs < AWS::Record::HashModel
  string_attr :description
  string_attr :category
  string_attr :city
  string_attr :results
  timestamps

  def self.destroy(id)
    find(id).delete
  end

  def self.delete_all
    all.each { |r| r.delete }
  end

end
