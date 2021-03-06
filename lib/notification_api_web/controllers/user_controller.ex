defmodule NotificationApiWeb.UserController do
  use NotificationApiWeb, :controller

  alias NotificationApi.Account
  alias NotificationApi.Account.User

  action_fallback NotificationApiWeb.FallbackController

  def index(conn, _params) do
    users = Account.list_users()
    render(conn, "index.json", users: users)
  end

  def create(conn, user_params) do
    notification_via = Map.get(user_params, "notification_via")
    email = Map.get(user_params, "email")
    phone_number = Map.get(user_params, "phone_number")

    with {:ok, true} <- Account.validate_notification_via(notification_via, email, phone_number),
         {:ok, %User{} = user} <- Account.create_user(user_params) do
      conn
      |> put_status(:created)
      |> render("show.json", user: user)
    else
      {:error, error} -> {:error, error, "Failed to create user"}
    end
  end

  # def show(conn, %{"id" => id}) do
  #   user = Account.get_user!(id)
  #   render(conn, "show.json", user: user)
  # end

  # def update(conn, %{"id" => id, "user" => user_params}) do
  #   user = Account.get_user!(id)

  #   with {:ok, %User{} = user} <- Account.update_user(user, user_params) do
  #     render(conn, "show.json", user: user)
  #   end
  # end

  # def delete(conn, %{"id" => id}) do
  #   user = Account.get_user!(id)

  #   with {:ok, %User{}} <- Account.delete_user(user) do
  #     send_resp(conn, :no_content, "")
  #   end
  # end
end
