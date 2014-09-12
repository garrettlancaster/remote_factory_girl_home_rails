module RemoteFactoryGirlHomeRails
  class FactoryController < ApplicationController
    skip_before_filter *RemoteFactoryGirlHomeRails.skip_before_filter
    around_filter :ensure_enabled
    around_filter :provide_clean_errors, only: [:create, :attributes_for]

    def create
      Rails.logger.debug "FactoryGirl.create( #{factory}, #{attributes.inspect})"
      factory_item = FactoryGirl.create(factory, attributes)
      render json: factory_item
    end

    def index
      factories = FactoryGirl.factories.map(&:name)
      render json: { factories: factories }
    end

    def attributes_for
      Rails.logger.debug "FactoryGirl.attributes_for( #{factory}, #{attributes.inspect})"
      attrs = FactoryGirl.attributes_for(factory, attributes)
      render json: {factory => attrs}, serializer: nil
    end

    private

    def factory
      params['factory'].to_sym
    end

    def attributes
      params['attributes'] || {}
    end

    def provide_clean_errors
      yield
    rescue StandardError => e
      Rails.logger.debug e.to_s
      Rails.logger.debug e.class
      #e.backtrace.each{|t| Rails.logger.debug t }
      render json: {errors: [{factory: factory, message: e.to_s}] }, status: 422, serializer: nil
    end

    def ensure_enabled
      if RemoteFactoryGirlHomeRails.enabled?
        yield
      else
        forbidden = 403
        render json: { status: forbidden }, status: forbidden, serializer: nil
      end
    end
  end
end
