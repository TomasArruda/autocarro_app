
class CalculateWaitingTime
  include Interactor

  before :setup

  def call
    context.result = ;
  end

  private

  attr_accessor :start, :end, :time

  def setup
    @start = context.start
    @end = context.start
    @time = Time.now
  end
end