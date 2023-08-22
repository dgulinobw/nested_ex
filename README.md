# Nested

Alibrary to handle nested Elixir maps, a reimplementation of the Erlang [nested](https://github.com/odo/nested) library.

## requirements
Elixir 1.13 or newer

## building

```
git clone git@github.com:dgulinobw/nested_ex.git
cd nested_ex
mix
iex -S mix
```

## usage

### get

get the value of an existing key:

```elixir
map = %{two: %{one: :target, one_side: 1}, two_side: 2}
Nested.get(map,[:two, :one])
```
```elixir
:target
```

or use a default in case the key does not exist:


```elixir
map = %{two: %{one: :target, one_side: 1}, two_side: 2}
Nested.get(map,[:two, :some_unknown_key], :default)
```
```
:default
```

### put
put some value under a key that might or might not exist:

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

### update

replace an exiting value:

```elixir
map = %{two: %{one: :target, one_side: 1}, two_side: 2}
Nested.update!(map, [:two, :one_side], 7)
```
```elixir
%{two: %{one: :target, one_side: 7}, two_side: 2}
```

### keys
list the keys in a sup map:

```elixir
map = %{two: %{one: :target, one_side: 1}, two_side: 2}
Nested.keys(map, [:two])
```
```elixir
[:one, :one_side]
```

### delete

delete a key:

```elixir
map = %{two: %{one: :target, one_side: 1}, two_side: 2}
Nested.delete(map, [:two, :one_side])
```
```elixir
%{two: %{one: :target}, two_side: 2}
```

if the path does not exist, nothing changes:

```elixir
map = %{two: %{one: :target, one_side: 1}, two_side: 2}
Nested.delete(map, [:two, :unknown, :path])
```
```elixir
#{two => #{one => target,one_side => 1},two_side => 2}
```

instead of a value, you can pass a function with arity 1 which is passed the old value:

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

# TODO:

### getf/1, getf/2, updatef/1, putf/1, removef/1, keysf/1

you can use these variants to get a function with the path in the context:

```elixir
map = %{two: %{one: :target, one_side: 1}, two_side: 2}
```
```elixir
TwoOneSelector = Nested.getf([:two, :one])
```
```elixir
#Fun<nested.0.895889
```
```elixir
TwoOneSelector(map)
```
```elixir
target
```
```elixir
TwoOneUpdater = Nested.updatef([:two, :one])
```
```elixir
#Fun<nested.1.895889
```
```elixir
TwoOneUpdater(map, :new_value)
```
```elixir
#{two => #{one => new_value,one_side => 1},two_side => 2}
```
