defmodule Fam.Password do
  def hash(password) do
    if password, do: Comeonin.Bcrypt.hashpwsalt(password)
  end
end
