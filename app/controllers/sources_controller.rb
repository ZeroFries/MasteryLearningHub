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

	def index
		repo = BaseRepository.new Source, current_user
		@sources, success = repo.find topic_id: params[:topic_id]
		if success
			render json: { sources: @sources }
		else
			raise ActiveRecord::RecordNotFound, params[:topic_id]
		end
	end

	def search
	end

	def destroy
		repo = BaseRepository.new Source, current_user
		@source, success = repo.find_and_delete params[:id]
		if success
			render json: { source: @source, deleted: true }
		else
			raise ActiveRecord::RecordNotFound, params[:id]
		end
	end

end
