class TerrainSerializer < ActiveModel::Serializer
  attributes :id, :name, :rest_days, :status, :state_details, :created_at, :updated_at

  def state_details
    return occupied_details if object.occupied?
    return resting_details if object.resting?

    available_details
  end

  private

  def occupied_details
    occupation = object.current_occupation
    {
      current_group: serialize_group(object.current_group),
      entered_at: occupation&.started_at
    }
  end

  def resting_details
    {
      remaining_rest_days: object.remaining_rest_days,
      last_group: serialize_group(object.last_group),
      last_occupation: serialize_occupation(object.last_occupation)
    }
  end

  def available_details
    {
      days_free: object.days_free,
      last_group: serialize_group(object.last_group),
      last_occupation: serialize_occupation(object.last_occupation)
    }
  end

  def serialize_group(group)
    return nil unless group

    GroupSummarySerializer.new(group).attributes
  end

  def serialize_occupation(occupation)
    return nil unless occupation

    {
      id: occupation.id,
      started_at: occupation.started_at,
      ended_at: occupation.ended_at
    }
  end
end
