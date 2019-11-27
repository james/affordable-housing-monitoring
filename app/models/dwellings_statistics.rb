class DwellingsStatistics
  attr_accessor :developments
  def initialize(developments = Dwelling.all)
    @developments = developments
  end

  def habitable_room_count(filter = {})
    developments.where(filter).sum(:habitable_rooms)
  end

  def bedroom_count(filter = {})
    developments.where(filter).sum(:habitable_rooms)
  end

  def unit_count(filter = {})
    developments.where(filter).count
  end

  def max_bedrooms
    developments.maximum(:bedrooms) || 1
  end

  def any_studios?
    developments.where(studio: true).any?
  end

  def affordable_habitable_rooms_percentage
    @affordable_habitable_rooms_percentage ||=
      ((habitable_room_count(tenure: %w[intermediate social]).to_f / habitable_room_count) * 100).to_i
  end

  def open_habitable_rooms_percentage
    100 - affordable_habitable_rooms_percentage
  end
end
