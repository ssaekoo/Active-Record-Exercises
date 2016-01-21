# == Schema Information
#
# Table name: shortened_urls
#
#  id           :integer          not null, primary key
#  short_url    :string
#  long_url     :string
#  submitter_id :integer
#  created_at   :datetime
#  updated_at   :datetime
#

class ShortenedUrl < ActiveRecord::Base
  include SecureRandom
  validates :submitter_id, uniqueness: {scope: :short_url}, presence: true

  belongs_to :submitter,
    foreign_key: :submitter_id,
    primary_key: :id,
    class_name: 'User'

  has_many :visits,
    foreign_key: :shortened_url_id,
    primary_key: :id,
    class_name: 'Visit'

  has_many :users,
    through: :visits,
    source: :user

  has_many :visitors,
    Proc.new { distinct },
    through: :visits,
    source: :user

  def self.random_code
    a = SecureRandom.urlsafe_base64
    until self.exists?(a) == false
      a = SecureRandom.urlsafe_base64
    end
    a
  end

  def self.create_for_user_and_long_url!(user, long_url)
    shortened_url = ShortenedUrl.random_code
    ShortenedUrl.create!(submitter_id: user.id,long_url: long_url, short_url: shortened_url)
  end

  # def test_num_clicks
  #   visits.where("(created_at - #{Time.now})/60 <= 10")
  # end

  def num_clicks
    self.visits.length
  end

  def num_recent_uniques
    current_time = Time.now

    recent = self.visits.select do |visit|
      (current_time - visit.created_at)/ 60 <= 10
    end

    recent.map {|visit| visit.user_id }.uniq.count
  end
  
  # def num_uniques
  #   a = ShortenedUrl.count_by_sql(<<-SQL)
  #     SELECT COUNT(DISTINCT user_id) AS counts
  #     FROM visits
  #     JOIN shortened_urls
  #       ON visits.shortened_url_id = shortened_urls.id
  #     WHERE visits.shortened_url_id = #{self.id}
  #   SQL
  # end

  def num_uniques
    self.visitors.count
  end
end
