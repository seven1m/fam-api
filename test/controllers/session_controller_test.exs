defmodule Fam.SessionControllerTest do
  use Fam.ConnCase

  alias Fam.Invite
  alias Fam.User
  alias Fam.Password

  @valid_token "abc123"
  @person_attrs %{
    email: "tim@timmorgan.org",
    first_name: "Tim",
    last_name: "Morgan",
    password: "password"
  }

  test "get an error when token doesn't exist" do
    %Invite{token: @valid_token} |> Repo.insert!
    conn = post conn(), "/api/session",
      %{token: "non-existent", user: @person_attrs}
    assert json_response(conn, 422) == %{
      "message" => "There was an error",
      "errors" => "token invalid"
    }
  end

  test "get an error when new user is not valid" do
    %Invite{token: @valid_token} |> Repo.insert!
    conn = post conn(), "/api/session",
      %{token: @valid_token, user: %{}}
    assert json_response(conn, 422) == %{
      "message" => "There was an error",
      "errors" => %{
        "email" => ["can't be blank"],
        "first_name" => ["can't be blank"],
        "last_name" => ["can't be blank"],
        "password" => ["can't be blank"]
      }
    }
  end

  test "create user when token and user is valid" do
    %Invite{token: @valid_token} |> Repo.insert!
    conn = post conn(), "/api/session",
      %{token: @valid_token, user: @person_attrs}
      %{"message" => "User created", "token" => token} = json_response(conn, 201)
      {:ok, %{"sub" => "User:" <> id}} = Guardian.decode_and_verify(token)
      assert Repo.get(User, id).first_name == "Tim"
  end

  test "log user in when email and password are correct" do
    %User{email: "tim@timmorgan.org", first_name: "Tim", last_name: "Morgan", crypted_password: Password.hash("password")}
    |> Repo.insert!
    conn = post conn(), "/api/session",
      %{email: "tim@timmorgan.org", password: "password"}
    %{"message" => "User authenticated", "token" => token} = json_response(conn, 201)
    {:ok, %{"sub" => "User:" <> id}} = Guardian.decode_and_verify(token)
    assert Repo.get(User, id).first_name == "Tim"
  end

  test "get an error when the password is incorrect" do
    %User{email: "tim@timmorgan.org", first_name: "Tim", last_name: "Morgan", crypted_password: Password.hash("password")}
    |> Repo.insert!
    conn = post conn(), "/api/session",
      %{email: "tim@timmorgan.org", password: "bad"}
    assert json_response(conn, 401) == %{
      "message" => "There was an error",
      "errors" => "Email and password do not match our records"
    }
  end
end
