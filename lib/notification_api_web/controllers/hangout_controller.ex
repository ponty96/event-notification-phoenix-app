defmodule NotificationApiWeb.HangoutController do
  use NotificationApiWeb, :controller

  alias NotificationApi.Event
  alias NotificationApi.Event.Hangout

  action_fallback NotificationApiWeb.FallbackController

  def index(conn, _params) do
    hangouts = Event.list_hangouts()
    render(conn, "index.json", hangouts: hangouts)
  end

  def create(conn, %{"hangout" => hangout_params}) do
    with {:ok, %Hangout{} = hangout} <- Event.create_hangout(hangout_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.hangout_path(conn, :show, hangout))
      |> render("show.json", hangout: hangout)
    end
  end

  def show(conn, %{"id" => id}) do
    hangout = Event.get_hangout!(id)
    render(conn, "show.json", hangout: hangout)
  end

  def update(conn, %{"id" => id, "hangout" => hangout_params}) do
    hangout = Event.get_hangout!(id)

    with {:ok, %Hangout{} = hangout} <- Event.update_hangout(hangout, hangout_params) do
      render(conn, "show.json", hangout: hangout)
    end
  end

  def delete(conn, %{"id" => id}) do
    hangout = Event.get_hangout!(id)

    with {:ok, %Hangout{}} <- Event.delete_hangout(hangout) do
      send_resp(conn, :no_content, "")
    end
  end
end