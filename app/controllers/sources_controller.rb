class SourcesController < ApplicationController
	respond_to :json

	def new
		@source = Source.new
		render json: { source: @source }
	end

	# def create
	# 	p params
	# end
end
