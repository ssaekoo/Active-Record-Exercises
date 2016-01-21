# == Schema Information
#
# Table name: users
#
#  id                                                                    :integer          not null, primary key
#  created_at                                                            :datetime
#  updated_at                                                            :datetime
#  email                                                                 :string
#  #<ActiveRecord::ConnectionAdapters::TableDefinition:0x007fb6a0073f38> :string
#

class User < ActiveRecord::Base
  validates :email, :uniqueness => true, :presence => true

  has_many :shortened_urls,
    foreign_key: :submitter_id,
    primary_key: :id,
    class_name: 'ShortenedUrl'

  has_many :visits,
    foreign_key: :user_id,
    primary_key: :id,
    class_name: 'Visit'

  has_many :visited_shortened_urls,
    through: :shortened_urls,
    source: :visits

end
