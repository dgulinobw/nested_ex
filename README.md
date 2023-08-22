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
#{two => #{one => i_got_you,one_side => 1},two_side => 2}
```

If there are more keys than in the original map, nested maps are created:

```elixir
Nested.put(map, [:two, :down, :the, :rabbit, :hole], 42)
#{two => #{down => #{the => #{rabbit => #{hole => 42}}},one => target,one_side => 1},
  two_side => 2}
```

### update

replace an exiting value:

```elixir
map = %{two: %{one: :target, one_side: 1}, two_side: 2}
Nested.update(map, [:two, :one_side], 7)
#{two => #{one => target,one_side => 7},two_side => 2}
```

### keys
list the keys in a sup map:

```elixir
map = %{two: %{one: :target, one_side: 1}, two_side: 2}
Nested.keys(map, [:two])
[one,one_side]
```

TODO:

#### remove
#
#delete a key:
#
#```elixir
#map = %{two: %{one: :target, one_side: 1}, two_side: 2}
#Nested.remove(map, [:two, :one_side])
##{two => #{one => target},two_side => 2}
#```
#
#
#instead of a value, you can pass a function with arity 1 which is passed the old value:
#
#```elixir
#Nested.update(map, [:two_side], fun(E) -> E*2 end)
##{two => #{one => target,one_side => 1},two_side => 4}
#```
#
#If you really mean to set the value to a fun you have to wrap it in an update fun:
#
#```elixir
#Nested.update(map, [two_side], fun(_) -> fun(A, B) -> {A, B} end end)
##{two => #{one => target,one_side => 1},
#  two_side => #Fun<erl_eval.12.106461118>}
#```
#
#if the path does not exist, nothing changes:
#
#```elixir
#map = %{two: %{one: :target, one_side: 1}, two_side: 2}
#Nested.remove(map, [:two, :unknown, :path])
##{two => #{one => target,one_side => 1},two_side => 2}
#```
#
#### getf/1, getf/2, updatef/1, putf/1, removef/1, keysf/1
#
#you can use these variants to get a function with the path in the context:
#
#```elixir
#map = #{two => #{one => target, one_side => 1}, two_side => 2}.
#TwoOneSelector = Nested.getf([:two, :one]).
##Fun<nested.0.895889(3)>
#TwoOneSelector(map).
#target
#TwoOneUpdater = Nested.updatef([:two, :one]).
##Fun<nested.1.895889(3)>
#TwoOneUpdater(map, :new_value).
##{two => #{one => new_value,one_side => 1},two_side => 2}
#```
