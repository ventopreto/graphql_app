# frozen_string_literal: true

module Types
  class VehicleInputType < Types::BaseInputObject
    argument :brand, String, required: true
    argument :model, String, required: true
    argument :year, String, required: true
    argument :registration_plate, String, required: true, camelize: false
  end
end
