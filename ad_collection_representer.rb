module AdCollectionRepresenter
  include Roar::Representer::JSON::HAL

  collection :all, extend: AdRepresenter
end
