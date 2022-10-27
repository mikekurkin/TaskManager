class API::V1::UsersController < API::V1::ApplicationController
  respond_to :json

  def index
    users = User.all
      .ransack(ransack_params)
      .result
      .page(page)
      .per(per_page)

    respond_with(users, each_serializer: UserSerializer,
                        root: 'items',
                        meta: build_meta(users))
  end

  def show
    user = User.find(params[:id])

    respond_with(user, serializer: UserSerializer)
  end
end
