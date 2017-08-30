class TestRun < ActiveRecord::Base
  has_many :tracking_events, :dependent => :destroy
  has_many :mock_responses, :dependent => :destroy
end