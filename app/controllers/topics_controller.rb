class TopicsController < ApplicationController
	respond_to :json

	def new
		@topic = Topic.new
		render json: { topic: @topic }
	end

	def create
		repo = BaseRepository.new Topic, current_user
		@topic, success = repo.create params[:topic]
		if success
			render json: show_json(@topic)
		else
			raise ActiveRecord::RecordInvalid, @topic
		end
	end

	def show
		repo = BaseRepository.new Topic, current_user
		@topic, success = repo.find_by_id params[:id]
		if success
			render json: show_json(@topic)
		else
			raise ActiveRecord::RecordNotFound, params[:id]
		end
	end

	def update
		repo = BaseRepository.new Topic, current_user
		@topic, success = repo.find_and_update params[:topic]
		if success
			render json: show_json(@topic)
		else
			if @topic.nil?
				raise ActiveRecord::RecordNotFound, params[:id]
			else
				raise ActiveRecord::RecordInvalid, @topic
			end
		end
	end

	def index
		repo = BaseRepository.new Topic, current_user
		@topics, success = repo.find topic_id: params[:topic_id]
		if success
			render json: { 
				topics: @topics.map { |topic| show_json topic }
			}
		else
			raise ActiveRecord::RecordNotFound, params[:topic_id]
		end
	end

	def search
	end

	def destroy
		repo = BaseRepository.new Topic, current_user
		@topic, success = repo.find_and_delete params[:id]
		if success
			render json: { topic: @topic, deleted: true }
		else
			raise ActiveRecord::RecordNotFound, params[:id]
		end
	end

	protected

	def show_json(topic)
		{
	  	topic: @topic, 
	  	parent_topic: topic.parent_topic, 
	  	child_topics: topic.child_topics 
		}
	end
end
