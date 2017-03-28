defmodule Metex do
  def temperatures_of(cities) do
    coordinator_pid =
      spawn(Metex.Coordinator, :loop, [[], Enum.count(cities)])

      cities |> Enum.each(fn city ->
        worker_pid = spawn(Metex.Worker, :loop, [])
        send worker_pid, {coordinator_pid, city}
      end)
  end

  def ping_pong do
    ping_id = spawn(Metex.Ping, :loop, [])
    pong_id = spawn(Metex.Pong, :loop, [])
    send ping_id, {pong_id, "initial"}
  end
end
