require 'bundler/setup'

require 'active_record'
require 'pry'

ActiveRecord::Base.establish_connection(
  'postgres://dimitar@localhost/active_record'
)

ActiveRecord::Schema.define do
  create_table :shows, force: true do |t|
    t.string :name
  end

  create_table :episodes, force: true do |t|
    t.string :name
    t.belongs_to :show, index: true
  end
end

class Show < ActiveRecord::Base
  has_many :episodes, inverse_of: :show
end

class Episode < ActiveRecord::Base
  belongs_to :show, inverse_of: :episodes, required: true
end

RSpec.describe 'some transactions' do
  it 'should work' do
    show = Show.create!(name: 'Big Bang Theory')
    Episode.create!(name: 'The New Beginning', show: show)


    expect([Show.count, Episode.count]).to eq([1, 1])
  end
end
