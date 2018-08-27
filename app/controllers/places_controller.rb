class PlacesController < ApplicationController
  before_action :set_place, only: [:show, :destroy]

  def create
    @place = Place.new(place_params)
    @place.ip = request.ip
    if @place.save
      render :create
    else
      redirect_to places_path, notice: @place.errors.join(', ')
    end
  end

  def index
    respond_to do |format|
      format.html do
        @coordinates = request.location.coordinates.reverse
        @coordinates = [0.0, 0.0] if @coordinates.empty?
        @place = Place.new
      end
      format.json do
        @places = Place.near([params[:lat], params[:lng]], 50)
        render json:  {
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
  end

  def destroy
    @place.destroy
    redirect_to places_path, notice: "#{@place.name} deleted!"
  end

  private

  def set_place
    @place = Place.find(params[:id])
  end

  def place_params
    params.require(:place).permit(:name, :street, :city, :state, :country, :latitude, :longitude)
  end

end
