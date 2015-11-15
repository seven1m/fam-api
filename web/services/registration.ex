defmodule Fam.Registration do
  import Ecto.Changeset, only: [put_change: 3]

  alias Fam.Repo
  alias Fam.Invite

  def create(token, changeset) do
    invite = Repo.get_by Invite, token: token
    if invite do
      changeset
      |> put_change(:crypted_password, hashed_password(changeset.params["password"]))
      |> Repo.insert()
    else
      {:error, "token invalid"}
    end
  end

  defp hashed_password(password) do
    if password, do: Comeonin.Bcrypt.hashpwsalt(password)
  end
end
