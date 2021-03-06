class Api::BaseController < ApplicationController
  protect_from_forgery :with => :null_session
  before_action :authorize!

  respond_to :json

  def create
    build_resource
    trigger_resource_events if save_resource
    respond_with_resource
  end

  def show
    find_resource
    respond_with_resource
  end

  private

  def api_keys
    @api_keys ||= ENV["API_KEYS"].to_s.split(";")
  end

  def authorize!
    deny_access! if !ActionController::HttpAuthentication::Basic.has_basic_credentials?(request)
    authenticate_with_http_basic { |api_key| !api_keys.include?(api_key) }
  end

  def deny_access!
    head(:unauthorized)
  end

  def build_resource
    @resource ||= association_chain.new(permitted_params)
  end

  def save_resource?
    true
  end

  def save_resource
    save_resource? ? resource.save : resource.valid?
  end

  def find_resource
    @resource = association_chain.find(params[:id])
  end

  def trigger_resource_events
  end

  def resource
    @resource
  end

  def respond_with_resource
    respond_with(:api, resource) if resource.persisted? || resource.errors.any?
  end
end
