require 'open-uri'
require 'json'

class Score
  attr_reader :grid, :attempt, :final_score, :message, :total_time
  attr_accessor :start_time, :end_time, :attempt

  def initialize
    @grid = []
    @start_time = 0
    @end_time = 0
    @total_time = 0
    @attempt = ""
    @final_score = 0
    @message = ""
  end

  def generate_grid
    9.times do |x|
      @grid << ('A'..'Z').to_a.sample
    end
  end

  def included?
    @attempt.upcase.chars.all? { |letter| @attempt.count(letter) <= @grid.count(letter) }
  end

  def compute_score
    @total_time = @end_time - @start_time
    @total_time > 60.0 ? @final_score = 0 : @final_score = @attempt.size * (1.0 - total_time / 60.0)
  end

  def run_game
    score_and_message
  end

  def score_and_message
    if included?
      if english_word?
        @final_score = compute_score
        @message = "well done"
      else
        @final_score = 0
        @message = "not an english word"
      end
    else
      @final_score = 0
      @message = "not in the grid"
    end
  end

  private

  def english_word?
    url = "https://wagon-dictionary.herokuapp.com/#{@attempt}"
    response = open(url)
    json = JSON.parse(response.read)
    return json['found']
  end
end
