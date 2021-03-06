require_dependency 'easy_tokens/application_controller'

module EasyTokens
  class TokensController < ::ApplicationController
    before_action :authorize!
    before_action :set_token, only: [:edit, :update, :destroy]

    layout 'easy_tokens/application'

    def index
      @tokens = Token.all
    end

    def new
      @token = Token.new
    end

    def edit
    end

    def create
      @token = Token.new(token_params)
      @token.owner_id = owner_resource.id

      if @token.save
        redirect_to tokens_path, notice: 'Token was successfully created.'
      else
        render :new
      end
    end

    def update
      if @token.update(token_params)
        redirect_to tokens_path, notice: 'Token was successfully updated.'
      else
        render :edit
      end
    end

    def deactivate_token
      @token = Token.find(params[:token_id])
      @token.touch(:deactivated_at)
      @token.save
      redirect_to tokens_path
    end

    private

    def set_token
      @token = Token.find(params[:id])
    end

    def token_params
      params.require(:token).permit(:description)
    end

    def authorize!
      return if owner_resource.public_send EasyTokens.owner_authorization_method
      render text: 'Unauthorized', status: :unauthorized
    end

    def owner_resource
      @owner_resource ||= send EasyTokens.token_owner_method
    end
  end
end
