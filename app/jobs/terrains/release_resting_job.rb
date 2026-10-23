module Terrains
  class ReleaseRestingJob < ApplicationJob
    queue_as :default

    def perform
      Terrains::ReleaseResting.call
    end
  end
end
