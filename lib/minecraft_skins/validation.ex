defmodule Validation do
  @spec __using__(list(atom())) :: any
  defmacro __using__(validators) when is_list(validators) do
    quote do
      @validators unquote(validators)
      @before_compile Validation
    end
  end

  defmacro __before_compile__(_) do
    inject()
  end

  defp inject() do
    quote do
      def validate(params, errors \\ %{}, validators \\ @validators) when (
        is_map(params) and is_map(errors) and is_list(validators)
      ) do
        cond do
          length(validators) == 0 ->
            cond do
              Map.equal?(errors, %{}) -> :ok
              true -> %{errors: errors}
            end

          true ->
            [validator | next_validators] = validators

            case apply(__MODULE__, validator, [params]) do
              {_, :ok} -> validate(params, errors, next_validators)
              {field, error} -> validate(params, Map.put(errors, field, error), next_validators)
            end
        end
      end
    end
  end
end
