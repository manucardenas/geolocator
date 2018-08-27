class PlacesController < ApplicationController

  def index
    respond_to do |format|
      format.html
        @coordinates = request.location.coordinates.reverse
        @coordinates = [0.0, 0.0] if @coordinates.empty?
      format.json do
        @places = Place.all
        render json: {
          type: "FeatureCollection",
          features: @places.map do |place|
            {
              type: "Feature",
              geometry: {
                type: "Point",
                coordinates: [place.longitude, place.latitude]
              },
              properties: {
                name: place.name,
                id: place.id
              }
            }
          end
        }
      end
    end
  end

  def show
    @place = Place.find(params[:id])
  end

end
