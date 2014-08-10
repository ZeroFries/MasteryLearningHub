class BaseRepository
  attr_accessor :opts, :current_user, :klass

  SANITIZED_PARAMS = [:id, :created_at, :updated_at]

  def initialize(klass, current_user, opts={})
    @current_user = current_user
    @klass = klass
  end

  def create(attributes={})
    attributes = sanitize_attributes attributes
    model_attributes = {}#{ created_by_id: @current_user.id,
                         #updated_by_id: @current_user.id, deleted: false }
    attributes.merge! model_attributes

    instance_obj = klass.send :new, attributes

    success = instance_obj.save

    return instance_obj, success
  end

  def find_and_update_all(attributes_array)
    updated_models = []
    klass.send :transaction do
      begin
        updated_models = attributes_array.map do |attributes|
          model, success = find_and_update(attributes)
          raise ActiveRecord::Rollback unless success
          model
        end
      rescue Exception
        raise ActiveRecord::Rollback
      end
    end

    success = attributes_array.nil? ? false : (updated_models.size == attributes_array.size)
    return updated_models, success
  end

  def find_and_update(attributes)
    model, successful_find = find_by_id (attributes[:id] || attributes['id'])
    return model, false unless successful_find

    model, success = update model, attributes
    return model, success
  end

  def find_and_delete(id)
    model, successful_find = find_by_id id
    return model, false unless successful_find

    model, success = delete model
    return model, success
  end

  def find_by_id(id)
    models, success = find({id: id})
    return models.first, success
  end


  def find(query={})
    models = klass.send :where, query
    return models, models.any?
  end

  def delete(model)
    model.destroy
    return model, model.destroyed?
  end

  def update(model, attributes)
    attributes = sanitize_attributes attributes
    model.assign_attributes attributes #.merge(updated_by_id: @current_user.id)
    success = model.save

    return model, success
  end

  private

  def symbolize_attributes(attributes)
    return {} if attributes.blank?
    attributes.symbolize_keys.merge!(attributes.dup.delete_if { |key| key if key.kind_of?(String) })
  end

  def sanitize_attributes(attributes)
    return {} if attributes.blank?
    attributes = symbolize_attributes attributes
    attributes.except! *SANITIZED_PARAMS
  end
end