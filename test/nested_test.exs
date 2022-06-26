defmodule NestedTest do
  use ExUnit.Case
  doctest Nested

  test "Nested.has_key?_test" do
    assert false == Nested.has_key?(%{}, [:fnord, :foo, :bar])
    assert true == Nested.has_key?(%{fnord: 23}, [:fnord])
    assert true == Nested.has_key?(test_map(), [:three, :two, :one])
    assert false == Nested.has_key?(test_map(), [:three, :two, :seven])
  end


  test "get_test" do
    assert test_map() == Nested.get(test_map(), [])
    assert 3 == Nested.get(test_map(),[:three_side])
    assert 2 == Nested.get(test_map(), [:three, :two_side])
    assert %{one: :target, one_side: 1} == Nested.get(test_map(), [:three, :two])
    assert :target == Nested.get(test_map(), [:three, :two, :one])
  end


  test "get_fails_test" do
    assert nil == Nested.get(test_map(),[:unknown])
    assert nil == Nested.get(test_map(),[:three, :unknown])
    assert_raise BadMapError, "expected a map, got: :target", fn -> Nested.get(test_map(),[:three, :two, :one, :unknown]) end
  end


  test "get_with_default_test" do
    assert test_map() == Nested.get(test_map(), [], :default)
    assert 3 == Nested.get(test_map(), [:three_side], :default)
    assert 2 == Nested.get(test_map(), [:three, :two_side], :default)
    assert %{one: :target, one_side: 1} == Nested.get(test_map(), [:three, :two], :default)
    assert :target == Nested.get(test_map(), [:three, :two, :one], :default)
    assert :default == Nested.get(test_map(), [:unknown], :default)
    assert :default == Nested.get(test_map(), [:three, :unknown], :default)
  end


  test "get_with_default_fails_test" do
    assert_raise FunctionClauseError, "no function clause matching in Nested.get/3", fn -> Nested.get([:three, :two, :one, :unknown], test_map(), :default) end
  end


  test "update_test" do
    assert 3 == Nested.update(test_map(), [], 3)
    assert %{three: 3, three_side: 3} == Nested.update(test_map(),[:three], 3)
    assert %{three: %{two: 2, two_side: 2}, three_side: 3} == Nested.update(test_map(), [:three, :two], 2)
    assert %{three: %{two: %{one: :target, one_side: 11}, two_side: 2}, three_side: 3} == Nested.update(test_map(),[:three, :two, :one_side], fn e -> e + 10 end)
  end


  test "update_fails_test" do
    assert_raise ArgumentError, "argument error", fn -> Nested.update([:unknown], 1, test_map()) end   
    assert_raise ArgumentError, "argument error", fn -> Nested.update([:three, :unknown], 1, test_map()) end
    assert_raise ArgumentError, "argument error", fn -> Nested.update([:foo, :bar, :buz], 1, %{foo: %{bar: []}}) end
  end


  test "put_test" do
    assert 3 == Nested.put(test_map(),[], 3)
    assert %{three: 3, three_side: 3} == Nested.put(test_map(), [:three], 3)
    assert %{three: %{two: 2, two_side: 2}, three_side: 3} == Nested.put(test_map(),[:three, :two], 2)
    assert %{unknown: 1, three: %{two: %{one: :target, one_side: 1}, two_side: 2}, three_side: 3} == Nested.put(test_map(),[:unknown], 1)
    assert %{three: %{two: %{one: :target, one_side: 1, eleven: %{twelve: 12}}, two_side: 2}, three_side: 3} == Nested.put(test_map(), [:three, :two, :eleven, :twelve], 12)
    assert %{three: %{two: %{one: %{minus_one: -1}, one_side: 1}, two_side: 2}, three_side: 3} == Nested.put(test_map(),[:three, :two, :one, :minus_one], -1)
  end


  test "delete_test" do
    assert %{three: %{two_side: 2}, three_side: 3} == Nested.delete(test_map(), [:three, :two])
    assert %{three: %{two: %{one_side: 1}, two_side: 2}, three_side: 3} == Nested.delete(test_map(),[:three, :two, :one])
    assert test_map() == Nested.delete(test_map(),[:unknown, :path])
    assert test_map() == Nested.delete(test_map(),[:three, :unknown_key])
  end


  test "delete_fail_test" do
    assert_raise FunctionClauseError, "no function clause matching in Nested.delete/2",fn -> Nested.delete([], test_map()) end
  end


  test "keys_test" do
    assert [:three, :three_side] == Nested.keys(test_map(),[])
    assert [:one, :one_side] == Nested.keys(test_map(),[:three, :two])
  end


  test "append_test" do
    testMap = %{outer: %{list: [1], hash: %{}}}
    assert %{outer: %{list: [1, 2], hash: %{}}} == Nested.append(testMap,[:outer, :list], 2)
  end


  test "append_fail_test" do
    testMap = %{outer: %{list: [1], hash: %{}}}
    assert_raise ErlangError, "Erlang error: :no_list", fn -> Nested.append(testMap,[:outer, :hash], 2) end
  end


  def test_map do
    l1 = %{one: :target, one_side: 1}
    l2 = %{two: l1, two_side: 2}
    %{three: l2, three_side: 3}
  end
end
