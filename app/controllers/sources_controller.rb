class SourcesController < ApplicationController
	respond_to :json

	def new
		@source = Source.new
		render json: { source: @source }
	end

	def create
		repo = BaseRepository.new Source, current_user
		@source, success = repo.create params[:source]
		if success
			render json: { source: @source }
		else
			raise ActiveRecord::RecordInvalid, @source
		end
	end

	def show
		repo = BaseRepository.new Source, current_user
		@source, success = repo.find_by_id params[:id]
		if success
			render json: { source: @source }
		else
			raise ActiveRecord::RecordNotFound, params[:id]
		end
	end
end
