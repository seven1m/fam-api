defmodule Fam.SessionController do
  use Fam.Web, :controller

  alias Fam.User
  alias Fam.Registration
  alias Fam.Login

  def create(conn, %{"user" => user_params, "token" => token}) do
    changeset = User.changeset(%User{}, user_params)
    case Registration.create(token, changeset) do
      {:ok, user} ->
        {:ok, token, _claims} = Guardian.encode_and_sign(user, :token)
        respond(conn, 200, %{
          message: "User created",
          token: token})
      {:error, errors} ->
        respond(conn, 422, %{
          message: "There was an error",
          errors: errors})
    end
  end

  def create(conn, %{"email" => email, "password" => password}) do
    case Login.create(email, password) do
      {:ok, user} ->
        {:ok, token, _claims} = Guardian.encode_and_sign(user, :token)
        respond(conn, 200, %{
          message: "User authenticated",
          token: token})
      {:error, _error} ->
        respond(conn, 401, %{
          message: "There was an error",
          errors: "Email and password do not match our records"})
    end
  end

  defp respond(conn, status, data) do
    conn
    |> put_status(status)
    |> render data: data
  end
end
