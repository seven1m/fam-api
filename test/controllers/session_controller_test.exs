defmodule Fam.SessionControllerTest do
  use Fam.ConnCase

  test "POST with missing params returns 422" do
    conn = post conn(), "/api/session", %{user: %{}}
    assert json_response(conn, 422) == %{
      "message" => "There was an error",
      "errors" => %{
        "email" => ["can't be blank"],
        "first_name" => ["can't be blank"],
        "last_name" => ["can't be blank"]
      }
    }
  end

  test "POST with proper params saves the user and returns the token" do
    user = %{
      first_name: "Tim",
      last_name: "Morgan",
      email: "tim@timmorgan.org"
    }
    conn = post conn(), "/api/session", %{user: user}
    data = json_response(conn, 200)
    assert String.length(data["token"]) == 25
  end
end
