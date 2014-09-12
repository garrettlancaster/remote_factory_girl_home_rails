module RemoteFactoryGirlHomeRails
  class FactoryController < ApplicationController
    skip_before_filter *RemoteFactoryGirlHomeRails.skip_before_filter
    around_filter :provide_clean_errors, only: [:create, :attributes_for]

    def create
      #provide_clean_errors do
        Rails.logger.debug "FactoryGirl.create( #{factory(params)}, #{attributes(params).inspect})"
        factory = FactoryGirl.create(factory(params), attributes(params))
        render json: factory
      #end
    end

    def index
      factories = FactoryGirl.factories.map(&:name)
      render json: { factories: factories }
    end

    def attributes_for
      #provide_clean_errors do
        Rails.logger.debug "FactoryGirl.attributes_for( #{factory(params)}, #{attributes(params).inspect})"
        factory = FactoryGirl.attributes_for(factory(params), attributes(params))
        render json: {factory(params) => factory}, serializer: nil
      #end
    end

    private

    def factory(params)
      params['factory'].to_sym
    end

    def attributes(params)
      params['attributes'] || {}
    end

    def provide_clean_errors
      if RemoteFactoryGirlHomeRails.enabled?
        begin
          yield
        rescue StandardError => e
          Rails.logger.debug e.to_s
          Rails.logger.debug e.class
          #e.backtrace.each{|t| Rails.logger.debug t }
          render json: {errors: [{factory: factory(params), message: e.to_s}] }, status: 422, serializer: nil
        end
      else
        forbidden = 403
        render json: { status: forbidden }, status: forbidden, serializer: nil
      end

    end
  end
end
