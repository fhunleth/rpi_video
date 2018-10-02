defmodule RpiVideoTest do
  use ExUnit.Case
  doctest RpiVideo

  test "greets the world" do
    assert RpiVideo.hello() == :world
  end
end
