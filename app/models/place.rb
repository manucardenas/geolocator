class Place < ApplicationRecord
  validates :name, presence: true
  geocoded_by :geocode_method
  after_validation :geocode , if: :needs_geocode?

  def address
    [street, city, state, country].compact.join(', ')
  end

  private

  def geocode_method
    if address.present?
      address
    else
      ip
  end
end

  def needs_geocode
    if address.present?
      true
    else
      latitude.nil? || longitude.nil?
  end
end

end
