defmodule K8sSchedulersTest do
  use ExUnit.Case
  doctest K8sSchedulers

  test "greets the world" do
    assert K8sSchedulers.hello() == :world
  end
end
