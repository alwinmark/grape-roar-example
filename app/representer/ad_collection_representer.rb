module AdCollectionRepresenter
  include Roar::Representer::JSON::HAL

  def ads
    all
  end

  collection :ads, extend: AdRepresenter
end
