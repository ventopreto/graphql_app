# frozen_string_literal: true

class GraphqlController < ApplicationController
  before_action :authenticated?
  rescue_from JWT::DecodeError, with: :decode_error
  rescue_from JWT::VerificationError, with: :invalid_token
  rescue_from JWT::ExpiredSignature, with: :expiration_error

  def execute
    variables = prepare_variables(params[:variables])
    query = params[:query]
    operation_name = params[:operationName]
    context = {authenticated?: authenticated?, token: @token}
    result = MyappSchema.execute(query, variables: variables, context: context, operation_name: operation_name)
    render json: result
  rescue => e
    raise e unless Rails.env.development?
    handle_error_in_development(e)
  end

  private

  def authenticated?
    @token = request.headers["Authorization"]&.split(" ")&.last
    jwt_payload = Warden::JWTAuth::TokenDecoder.new.call(@token)
    jwt_payload["sub"].present?
  end

  def invalid_token
    render json: {errors: [{message: "Erro ao verificar token: O token é inválido ou modificado"}]},
      status: 401
  end

  def decode_error
    render json: {errors: [{message: "Erro ao decodificar token: formato inválido ou token inexistente."}]},
      status: 401
  end

  def expiration_error
    render json: {errors: [{message: "Token expirado, recrie o token e tente novamente"}]}, status: 401
  end

  # Handle variables in form data, JSON body, or a blank value
  def prepare_variables(variables_param)
    case variables_param
    when String
      if variables_param.present?
        JSON.parse(variables_param) || {}
      else
        {}
      end
    when Hash
      variables_param
    when ActionController::Parameters
      variables_param.to_unsafe_hash # GraphQL-Ruby will validate name and type of incoming variables.
    when nil
      {}
    else
      raise ArgumentError, "Unexpected parameter: #{variables_param}"
    end
  end

  def handle_error_in_development(e)
    logger.error e.message
    logger.error e.backtrace.join("\n")

    render json: {errors: [{message: e.message, backtrace: e.backtrace}], data: {}}, status: 500
  end
end
