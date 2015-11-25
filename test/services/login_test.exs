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

  test "create with nil email" do
    {:error, :bad_email} = Login.create(nil, "password")
  end

  test "create with blank email" do
    {:error, :bad_email} = Login.create("", "password")
  end

  test "create with nil password" do
    {:error, :bad_password} = Login.create("tim@timmorgan.org", nil)
  end

  test "create with blank password" do
    {:error, :bad_password} = Login.create("tim@timmorgan.org", "")
  end

  test "create with bad password" do
    {:error, :bad_password} = Login.create("tim@timmorgan.org", "bad")
  end

  test "create with valid email and password", context do
    {:ok, user} = Login.create("tim@timmorgan.org", "password")
    assert user.id == context[:user].id
  end

  test "create when user has a blank password", context do
    user = Map.put(context[:user], :crypted_password, "")
    Repo.update!(user)
    {:error, :bad_password} = Login.create("tim@timmorgan.org", "password")
  end
end
