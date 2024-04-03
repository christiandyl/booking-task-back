module Api
  module V1
    class SlotsController < ApplicationController
      before_action :find_coach, only: [:index]
      before_action :find_slot, only: [:reserve]

      def index
        @slots = @coach.available_slots(params[:date], params[:timezone])
      end

      def reserve
        if @slot.reserve(params.require(:slot).permit(:date))
          head(:ok)
        else
          render(json: { error: "slot already reserved" }, status: 422)
        end
      end

      private

      def find_coach
        @coach = Coach.find(params[:coach_id])
      end

      def find_slot
        @slot = Slot.find(params[:slot_id])
      end
    end
  end
end
