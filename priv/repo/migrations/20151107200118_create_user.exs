defmodule Fam.Repo.Migrations.CreateUser do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :email, :string
      add :first_name, :string
      add :last_name, :string
      add :token, :string, size: 25

      timestamps
    end
  end
end
