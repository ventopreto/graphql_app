# frozen_string_literal: true

module Types
  class InsuredInputType < Types::BaseInputObject
    argument :name, String, required: true
    argument :cpf, ID, required: true
  end
end
