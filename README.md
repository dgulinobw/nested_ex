# Nested

A library to handle nested Elixir maps, based on the Erlang [nested](https://github.com/odo/nested) library.

```elixir
map = %{one: %{two: %{three: 4}}}

# This:
map
|> Nested.get([:one, :two, :three])
4

# Instead of this:
map
|> Map.get(:one)
|> Map.get(:two)
|> Map.get(:three)
4
```

## Requirements
Elixir 1.13 or newer

## Building

```
git clone git@github.com:dgulinobw/nested_ex.git
cd nested_ex
mix
iex -S mix
```

## Usage

### Get

get the value of an existing key:
```elixir
map = %{two: %{one: :target, one_side: 1}, two_side: 2}
Nested.get(map,[:two, :one])

:target
```

Or use a default in case the key does not exist:

```elixir
map = %{two: %{one: :target, one_side: 1}, two_side: 2}
Nested.get(map,[:two, :some_unknown_key], :default)

:default
```

### Put
Put some value under a key that might or might not exist:

```elixir
map = %{two: %{one: :target, one_side: 1}, two_side: 2}
Nested.put(map, [:two, :one], :i_got_you)

%{two: %{one: :i_got_you, one_side: 1}, two_side: 2}
```

If there are more keys than in the original map, nested maps are created:

```elixir
Nested.put(map, [:two, :down, :the, :rabbit, :hole], 42)

%{
  two: %{down: %{the: %{rabbit: %{hole: 42}}}, one: :target, one_side: 1},
  two_side: 2
}
```

### Update

Replace an exiting value:

```elixir
map = %{two: %{one: :target, one_side: 1}, two_side: 2}
Nested.update!(map, [:two, :one_side], 7)

%{two: %{one: :target, one_side: 7}, two_side: 2}
```

Instead of a value, you can pass a function with arity 1 which is passed the old value:

```elixir
Nested.update!(map, [:two_side], fn(e) -> e*2 end)

%{two: %{one: :target, one_side: 1}, two_side: 4}
```

If you really mean to set the value to a fun you have to wrap it in an update fun:

```elixir
Nested.update!(map, [:two_side], fn(_) -> fn(a, b) -> {a, b} end end)

%{
  two: %{one: :target, one_side: 1},
  two_side: #Function<41.125776118/2 in :erl_eval.expr/6>
}
```

### Append

append/3
```elixir 
Nested.append(%{"test" => "rest", "rest" => [1]},["rest"],2)

%{"rest" => [1, 2], "test" => "rest"}
```

append/4
If key not found, add key and append value to default List provided
  Similar to Python's defaultdict
```elixir
Nested.append(%{"test" => "rest", "rest" => [1]},["xest"],2,[])

%{"rest" => [1], "test" => "rest", "xest" => [2]}

Nested.append(%{"test" => "rest", "rest" => [1]},["rest"],2,[])

%{"rest" => [1, 2], "test" => "rest"}
```

### Keys
List the keys in a map:

```elixir
map = %{two: %{one: :target, one_side: 1}, two_side: 2}
Nested.keys(map, [:two])

[:one, :one_side]
```

### Delete

Delete a key:

```elixir
map = %{two: %{one: :target, one_side: 1}, two_side: 2}
Nested.delete(map, [:two, :one_side])

%{two: %{one: :target}, two_side: 2}
```

If the path does not exist, nothing changes:

```elixir
map = %{two: %{one: :target, one_side: 1}, two_side: 2}
Nested.delete(map, [:two, :unknown, :path])

%{two: %{one: :target, one_side: 1}, two_side: 2}
```

# TEST
```elixir
mix test
```

# TODO

Add the ability to pass functions to functions other than update!.
