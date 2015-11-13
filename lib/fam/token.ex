defmodule Fam.Token do
  def generate(length \\ 25) do
    length
    |> :crypto.strong_rand_bytes
    |> Base.url_encode64
    |> String.slice(0, length)
  end
end
