# frozen_string_literal: true

module Types
  class InsuredType < Types::BaseObject
    field :id, ID, null: false
    field :name, String
    field :cpf, ID
  end
end
