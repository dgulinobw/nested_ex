# Nested

A library to handle nested Elixir maps, a reimplementation of the Erlang [nested](https://github.com/odo/nested) library.

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
```
```elixir
:target
```

Or use a default in case the key does not exist:


```elixir
map = %{two: %{one: :target, one_side: 1}, two_side: 2}
Nested.get(map,[:two, :some_unknown_key], :default)
```
```
:default
```

### Put
Put some value under a key that might or might not exist:

```elixir
map = %{two: %{one: :target, one_side: 1}, two_side: 2}
Nested.put(map, [:two, :one], :i_got_you)
```
```elixir
%{two: %{one: :i_got_you, one_side: 1}, two_side: 2}
```

If there are more keys than in the original map, nested maps are created:

```elixir
Nested.put(map, [:two, :down, :the, :rabbit, :hole], 42)
```
```elixir
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
```
```elixir
%{two: %{one: :target, one_side: 7}, two_side: 2}
```

Instead of a value, you can pass a function with arity 1 which is passed the old value:

```elixir
Nested.update!(map, [:two_side], fn(e) -> e*2 end)
```
```elixir
%{two: %{one: :target, one_side: 1}, two_side: 4}
```

If you really mean to set the value to a fun you have to wrap it in an update fun:

```elixir
Nested.update!(map, [:two_side], fn(_) -> fn(a, b) -> {a, b} end end)
```
```elixir
%{
  two: %{one: :target, one_side: 1},
  two_side: #Function<41.125776118/2 in :erl_eval.expr/6>
}
```

### Keys
List the keys in a sup map:

```elixir
map = %{two: %{one: :target, one_side: 1}, two_side: 2}
Nested.keys(map, [:two])
```
```elixir
[:one, :one_side]
```

### Delete

Delete a key:

```elixir
map = %{two: %{one: :target, one_side: 1}, two_side: 2}
Nested.delete(map, [:two, :one_side])
```
```elixir
%{two: %{one: :target}, two_side: 2}
```

If the path does not exist, nothing changes:

```elixir
map = %{two: %{one: :target, one_side: 1}, two_side: 2}
Nested.delete(map, [:two, :unknown, :path])
```
```elixir
#{two => #{one => target,one_side => 1},two_side => 2}
```

# TODO

Add the ability to pass functions to functions other than update!.
