defmodule Metex.Store do
  use GenServer

  @name ST

  ## Client API

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, :ok, opts ++ [name: ST])
  end

  def write(key, value) when is_atom(key) do
    GenServer.call(@name, {:write, key, value})
  end

  def read(key) when is_atom(key) do
    GenServer.call(@name, {:read, key})
  end

  def exist?(key) when is_atom(key) do
    GenServer.call(@name, {:exist, key})
  end

  def delete(key) when is_atom(key) do
    GenServer.cast(@name, {:delete, key})
  end

  def clear do
    GenServer.cast(@name, :clear)
  end

  ## Server API

  def init(:ok) do
    {:ok, %{}}
  end

  def handle_call({:write, key, value}, _from, stats) do
    case exists(stats, key) do
      true ->
        {:reply, :error, stats}
      false ->
        new_stats = Map.put(stats, key, value)
        {:reply, "#{key}: #{value}", new_stats}
    end
  end

  def handle_call({:read, key}, _from, stats) do
    case exists(stats, key) do
      true ->
        res = Map.fetch!(stats, key)
        {:reply, "#{key}: #{res}", stats}
      false ->
        {:reply, "No such key", stats}
    end
  end

  def handle_call({:exist, key}, _from, stats) do
    case exists(stats, key) do
      true ->
        {:reply, "#{key} exists", stats}
      false ->
        {:reply, "No such key", stats}
    end
  end

  def handle_cast({:delete, key}, _stats) do
    case exists(_stats, key) do
      true ->
        new_stats = Map.delete(_stats, key)
        {:noreply, new_stats}
      false ->
        {:noreply, _stats}
    end
  end

  def handle_cast(:clear, _stats) do
    {:noreply, %{}}
  end

  def handle_cast(:stop, stats) do
    {:stop, :normal, stats}
  end

  def handle_info(msg, stats) do
    IO.puts "received #{inspect msg}"
    {:noreply, stats}
  end

  def terminate(reason, stats) do
    IO.puts "server terminated because of #{inspect reason}"
       inspect stats
    :ok
  end

  ## Helper Functions

  defp exists(old_stats, key) do
    Map.has_key?(old_stats, key)
  end
end
