# Exercises from The Little Elixir & OTP Guidebook 

### Includes 
1. Metex (GenServer)
2. Ping Pong
3. Term Store

## How to Run

```
mix deps.get
iex -S mix
```

#### Metex (GenServer)

```
alias Metex.Worker
Worker.get_temperature("London")
```

### Ping Pong

```
Metex.ping_pong()
```

### Term Store

```
alias Metex.Store
Store.start_link
Store.write(:key, "value")
Store.read(:key)
Store.exist?(:key)
Store.delete(:key)
Store.clear
```

