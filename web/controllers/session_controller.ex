defmodule Fam.SessionController do
  use Fam.Web, :controller

  alias Fam.User
  alias Fam.Registration

  plug :scrub_params, "user" when action === :create

  def create(conn, %{"user" => user_params, "token" => token}) do
    changeset = User.changeset(%User{}, user_params)
    case Registration.create(token, changeset) do
      {:ok, user} ->
        conn
        |> fetch_session
        |> put_session(:user, user)
        |> render data: %{
          message: "User created"
        }
      {:error, errors} ->
        conn
        |> put_status(422)
        |> render data: %{
          message: "There was an error",
          errors: errors
        }
    end
  end
end
