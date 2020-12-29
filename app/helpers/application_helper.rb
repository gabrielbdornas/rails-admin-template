module ApplicationHelper

  def date_between
    # https://stackoverflow.com/questions/925905/is-it-possible-to-create-a-list-of-months-between-two-dates-in-rails
    initial_date = Date.parse("2020-08-01")
    final_date = Date.parse("#{Time.new.year}-#{Time.new.month}-#{Time.new.day}")
    date_between_range = []
    Date.months_between(initial_date,final_date).to_a.each do |date|
      date_between_range << "#{date.month}/#{date.year}"
    end
    date_between_range
  end
end
