class Task
  include DataMapper::Resource
  property :id,           Serial
  property :name,         String, :required => true
  property :completed_at, DateTime
  belongs_to :list
end

class List
  include DataMapper::Resource
  property :id,           Serial
  property :name,         String, :required => true
  has n, :tasks, :constraint => :destroy
  belongs_to :user
end

class User
  include DataMapper::Resource
  property :id,           Serial
  property :email,        String, :required => true, :unique => true
  property :password,     BCryptHash
  has n, :lists, :constraint => :destroy
end

DataMapper.finalize
DataMapper.auto_migrate!
