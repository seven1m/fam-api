defmodule Fam.SessionControllerTest do
  use Fam.ConnCase

  alias Fam.Invite

  @valid_token "abc123"
  @person_attrs %{
    email: "tim@timmorgan.org",
    first_name: "Tim",
    last_name: "Morgan",
    password: "password"
  }

  setup do
    invite = %Invite{token: @valid_token}
    Repo.insert!(invite)
    {:ok, %{"foo" => "bar"}}
  end

  test "POST with bad invite token returns 422 with an error" do
    conn = post conn(), "/api/session",
      %{token: "non-existent", user: @person_attrs}
    assert json_response(conn, 422) == %{
      "message" => "There was an error",
      "errors" => "token invalid"
    }
  end

  test "POST with missing user attributes returns 422 with errors" do
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

  test "POST with valid params returns 200 and adds the user to the session" do
    conn = post conn(), "/api/session",
      %{token: @valid_token, user: @person_attrs}
    assert json_response(conn, 200) == %{"message" => "User created"}
    session = conn.private.plug_session
    %Fam.User{first_name: first_name} = session["user"]
    assert first_name == "Tim"
  end
end
