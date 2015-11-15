defmodule Fam.RegistrationTest do
  use Fam.ModelCase

  alias Fam.Invite
  alias Fam.User
  alias Fam.Registration
  alias Fam.Repo

  @valid_attrs %{email: "tim@timmorgan.org", first_name: "Tim", last_name: "Morgan", password: "password"}
  @invalid_attrs %{}

  @valid_token "abc123"
  @invalid_token "invalid"

  setup context do
    invite = %Invite{token: @valid_token}
    Repo.insert!(invite)
    :ok
  end

  test "create with invalid token return an error" do
    changeset = User.changeset(%User{}, @valid_attrs)
    assert Registration.create(@invalid_token, changeset) == {:error, "token invalid"}
  end

  test "create with valid token and invalid user parameters return an error" do
    changeset = User.changeset(%User{}, @invalid_attrs)
    {:error, _changeset} = Registration.create(@valid_token, changeset)
    assert changeset.errors[:email] == "can't be blank"
  end

  test "create with valid token and valid user parameters creates the user with an encrypted password" do
    changeset = User.changeset(%User{}, @valid_attrs)
    {:ok, changeset} = Registration.create(@valid_token, changeset)
    assert changeset.crypted_password =~ ~r{\A[\$\w\./]+\z}i
  end
end
