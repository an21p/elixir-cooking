defmodule Metex.Ping do
  def loop do
    receive do
      {sender_id, val} ->
        IO.puts val
        send(sender_id, {self, "ping"})
      _ ->
        IO.puts "no clue what's going on"
    end
    loop
  end
end
