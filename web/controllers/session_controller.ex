defmodule Fam.SessionController do
  use Fam.Web, :controller

  alias Fam.User
  alias Fam.Token

  plug :scrub_params, "user" when action === :create

  def create(conn, %{"user" => user_params}) do
    token = Token.generate
    user_params = Map.put(user_params, "token", token)
    changeset = User.changeset(%User{}, user_params)
    case Repo.insert(changeset) do
      {:ok, _user} -> conn |> render data: %{token: token}
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
