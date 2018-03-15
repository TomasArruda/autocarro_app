class Schedule < ApplicationRecord
  belongs_to :bus, optional: true
  belongs_to :trip

  validates :trip, uniqueness: { scope: [:start_time, :end_time] }

  def schedule_time_range
    "#{short_start_time} to #{short_end_time}"
  end

  private

  def short_start_time
    start_time.strftime('%H:%M')
  end

  def short_end_time
    end_time.strftime('%H:%M')
  end
end
