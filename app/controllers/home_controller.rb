# frozen_string_literal: true

# Home controller
class HomeController < ApplicationController
  def index
    render plain: 'ok'
  end
end
