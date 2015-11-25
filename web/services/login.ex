defmodule Fam.Login do
  alias Fam.Repo
  alias Fam.User
  alias Comeonin.Bcrypt

  def create(nil, _), do: {:error, :bad_email}
  def create(_, nil), do: {:error, :bad_password}

  def create(email, password) do
    user = Repo.get_by User, email: email
    cond do
      user && password_matches?(user, password) -> {:ok, user}
      user -> {:error, :bad_password}
      true -> {:error, :bad_email}
    end
  end

  defp password_matches?(user, password) do
    if to_string(user.crypted_password) != "" do
      Bcrypt.checkpw(password, user.crypted_password)
    end
  end
end
