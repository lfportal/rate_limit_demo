# frozen_string_literal: true

# Base Application Record
class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
end
