# Generated by erl2ex (http://github.com/dazuma/erl2ex)
# From Erlang source: /home/dgulino/Documents/workspace/nested/src/nested.erl
# At: 2022-06-25 17:24:15

defmodule Nested do
  @moduledoc """
  Library to work with nested maps
  Elixir reimplementation of Erlang library [nested](https://github.com/odo/nested)
  """

  def append(map, path, value) do
    appendFun = fn
      list when is_list(list) ->
        list ++ [value]
      _ ->
        :erlang.error(:no_list)
    end
    update!(map, path, appendFun)
  end

  def delete(map, []) do
    map
  end

  def delete(map, [lastKey]) do
    Map.delete(map,lastKey)
  end

  def delete(map, [key | pathRest]) do
    case(Map.has_key?(map,key)) do
      true ->
        Map.put(map, key, delete(Map.get(map, key), pathRest))
      false ->
        map
    end
  end

  def fetch!(map, path) do
    case get(map, path) do
      :nil ->
        raise KeyError, "key path #{inspect(path)} not found"
      value ->
        {:ok, value}
    end
  end

  def fetch(map, path) do
    case get(map, path) do
      :nil ->
        :error
      value ->
        {:ok, value}
    end
  end
  
  @doc """

  ## Examples

      iex> Nested.get(%{test: :rest}, [:test] )
      :rest

      iex> Nested.get(%{}, [:a])
      nil 

      iex> Nested.get(%{a: %{b: 1}}, [:a,:b])
      1
      
      iex> Nested.get(%{a: %{b: 1}}, [:a,:c])
      nil
      
      iex> Nested.get(%{a: %{b: 1}}, [:c], 3)
      3
  """
  
  def get(map,[key | pathRest]) do
    get(Map.get(map, key), pathRest)
  end

  def get(value, []) do
    value
  end


  def get(map, [key | pathRest], default) do
    case(Map.get(map,key,{__MODULE__, default})) do
      {__MODULE__, ^default} ->
        default
      nestedMap ->
        get(nestedMap, pathRest, default)
    end
  end

  def get(value, [], _) do
    value
  end

  def has_key?(map, [key]) do
    Map.has_key?(map, key)
  end

  def has_key?(map,[key | pathRest]) do
    case(map) do
      %{^key => subMap} ->
        has_key?(subMap, pathRest)
      _ ->
        false
    end
  end

  def keys(map, [key | pathRest]) do
    keys(Map.get(map,key), pathRest)
  end

  def keys(map, []) do
    Map.keys(map)
  end
  
  def put(map, [key | pathRest], value) do
    subMap = case(Map.has_key?(map, key) and is_map(Map.get(map,key))) do
      true ->
        Map.get(map, key)
      false ->
        %{}
    end
    Map.put(map, key, put(subMap, pathRest, value) )
  end

  def put(_, [], value) do
    value
  end

  def update!(map, path, valueOrFun) do
    try do
      updatef_interal!(map, path, valueOrFun)
    catch
      :error, {:error, {:no_map, pathRest, element}} ->
        pathLength = length(path) - length(pathRest)
        pathToThrow = :lists.sublist(path, pathLength)
        :erlang.error({:no_map, pathToThrow, element})
    end
  end

  defp updatef_interal!(map, [key | pathRest], valueOrFun) when is_map(map) do
    Map.put(map,key, updatef_interal!(Map.fetch!(map,key), pathRest, valueOrFun))
  end

  defp updatef_interal!(oldValue, [], fun) when is_function(fun) do
    fun.(oldValue)
  end

  defp updatef_interal!(_, [], value) do
    value
  end

  defp updatef_interal!(element, path, _) do
    :erlang.error({:error, {:no_map, path, element}})
  end
  
  def update(map, path, default, valueOrFun) do
    try do
      updatef_interal(map, path, default, valueOrFun)
    catch
      :error, {:error, {:no_map, pathRest, element}} ->
        pathLength = length(path) - length(pathRest)
        pathToThrow = :lists.sublist(path, pathLength)
        :erlang.error({:no_map, pathToThrow, element})
    end
  end


  defp updatef_interal(map, [key | pathRest], default, valueOrFun) when is_map(map) do
    Map.put(map,key, updatef_interal(Map.get(map,key,default), pathRest, valueOrFun))
  end

  defp updatef_interal(oldValue, [], fun) when is_function(fun) do
    fun.(oldValue)
  end

  defp updatef_interal(_, [], value) do
    value
  end

  defp updatef_interal(element, path, _) do
    :erlang.error({:error, {:no_map, path, element}})
  end

end
