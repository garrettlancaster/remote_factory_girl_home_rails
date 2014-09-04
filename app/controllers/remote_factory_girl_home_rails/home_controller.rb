module RemoteFactoryGirlHomeRails
  class HomeController < ApplicationController 

    skip_before_filter *RemoteFactoryGirlHomeRails.skip_before_filter
    
    def create
      if RemoteFactoryGirlHomeRails.enabled?
        begin
          factory = FactoryGirl.create(factory(params), attributes(params))
          render json: factory
        rescue ActiveRecord::RecordInvalid => invalid
          return render json: {errors: [{factory: factory(params), message: invalid.message}] }, status: 422
        end
      else
        forbidden = 403
        render json: { status: forbidden }, status: forbidden
      end
    end

    def index
      factories = FactoryGirl.factories.map(&:name)
      render json: { factories: factories }
    end

    private

    def factory(params)
      params['factory'].to_sym
    end

    def attributes(params)
      params['attributes'] || {}
    end
  end
end
