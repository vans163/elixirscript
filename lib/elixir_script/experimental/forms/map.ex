defmodule ElixirScript.Experimental.Forms.Map do
  alias ESTree.Tools.Builder, as: J
  alias ElixirScript.Experimental.Form

  def compile({:%{}, _, properties}) do
    properties
    |> Enum.map(fn
      ({x, y}) ->
        case x do
          {_, _, nil } ->
            J.property(Form.compile(x),  Form.compile(y), :init, false, false, true)
          _ ->
            make_property(Form.compile(x), Form.compile(y))
        end
    end)
    |> J.object_expression
  end

  def make_property(%ESTree.Identifier{} = key, value) do
    J.property(key, value)
  end

  def make_property(%ESTree.Literal{value: k}, value) when is_binary(k) do
    key = case String.contains?(k, "-") do
      true ->
        J.literal(k)
      false ->
        J.identifier(k)
    end

    J.property(key, value)
  end

  def make_property(key, value) do
    J.property(key, value, :init, false, false, true)
  end

  def make_shorthand_property(%ESTree.Identifier{} = key) do
    J.property(key, key, :init, true)
  end

end
