class Node < ActiveRecord::Base
  belongs_to :learning_path
  belongs_to :topic

  def sources
  	Source.where id: self.source_ids
  end
end
