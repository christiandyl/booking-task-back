module Api
  module V1
    class CoachesController < ApplicationController
      def index
        @coaches = Coach.all
      end
    end
  end
end
