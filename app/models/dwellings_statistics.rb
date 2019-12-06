class DwellingsStatistics
  attr_accessor :dwellings
  def initialize(dwellings = Dwelling.all)
    @dwellings = dwellings
  end

  def habitable_room_count(filter = {})
    dwellings.where(filter).sum(:habitable_rooms)
  end

  def bedroom_count(filter = {})
    dwellings.where(filter).sum(:habitable_rooms)
  end

  def dwelling_count(filter = {})
    dwellings.where(filter).count
  end

  def max_bedrooms
    dwellings.maximum(:bedrooms) || 1
  end

  def any_studios?
    dwellings.where(studio: true).any?
  end

  def affordable_habitable_rooms_percentage
    @affordable_habitable_rooms_percentage ||=
      ((habitable_room_count(tenure: %w[intermediate social]).to_f / habitable_room_count) * 100).to_i
  end

  def open_habitable_rooms_percentage
    100 - affordable_habitable_rooms_percentage
  end

  def affordable_dwellings_percentage
    @affordable_dwellings_percentage ||=
      ((dwelling_count(tenure: %w[intermediate social]).to_f / dwelling_count) * 100).to_i
  end

  def open_dwellings_percentage
    100 - affordable_dwellings_percentage
  end
end
