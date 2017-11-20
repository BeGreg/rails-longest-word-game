class PagesController < ApplicationController
  def initialize
    @score = Score.new
    super
  end

  def game
    # @score = Score.new
    session[:score] = [] unless session[:score]
    @score.generate_grid
    @score.start_time = Time.now
    @array = @score.grid
  end

  def score
    @score.start_time = Time.parse(params[:starttime])
    @score.attempt = params[:attempt]
    @score.end_time = Time.now
    @score.score_and_message
    session[:score] << @score.final_score
  end
end
