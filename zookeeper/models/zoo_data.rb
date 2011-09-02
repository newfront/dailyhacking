require 'datamapper'
# Zoo Class
class Zoo
  include DataMapper::Resource
  
  property :id,               Serial
  property :name,             String, :unique => true
  property :created_at,       DateTime
  property :updated_at,       DateTime
  property :open,             Boolean, :default => false
  
  has n, :animals, :constraint => :destroy
  
end

class Animal
  include DataMapper::Resource
  
  property :id,               Serial
  property :name,             String, :required => true
  property :age,              Integer, :required => true
  
  # only allow one name per zoo
  validates_uniqueness_of :name, :scope => :zoo_id
  
  validates_length_of :name, :max => 120
  
  belongs_to :zoo
  has n, :animalizations, :constraint => :destroy
  has n, :classifications, :through => :animalizations, :constraint => :destroy
end

class Classification
  include DataMapper::Resource
  
  property :id,               Serial
  property :type,             String, :required => true, :unique => true
  
  validates_length_of :type, :max => 20
  
  has n, :animalizations, :constraint => :destroy
  has n, :animals, :through => :animalizations, :constraint => :destroy
  
end

class Animalization
  include DataMapper::Resource

  property :id,         Serial
  property :created_at, DateTime

  belongs_to :classification
  belongs_to :animal
end