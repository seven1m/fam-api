defmodule Fam.LoginTest do
  use Fam.ModelCase

  alias Fam.Login
  alias Fam.User
  alias Fam.Repo
  alias Fam.Password

  setup do
    user = %User{email: "tim@timmorgan.org", first_name: "Tim", last_name: "Morgan", crypted_password: Password.hash("password")}
    user = Repo.insert!(user)
    {:ok, user: user}
  end

  test "create with unknown email" do
    {:error, :bad_email} = Login.create("unknown@example.com", "password")
  end

  test "create with bad password" do
    {:error, :bad_password} = Login.create("tim@timmorgan.org", "bad")
  end

  test "create with valid email and password", context do
    {:ok, user} = Login.create("tim@timmorgan.org", "password")
    assert user.id == context[:user].id
  end
end
