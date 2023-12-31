defmodule Day08.Part1 do
  def solve(path) do
    {dirs, maps} =
      path
      |> File.read!()
      |> String.split("\n", trim: true)
      |> parse_lines()

    process(dirs, dirs, "AAA", maps, 0)
  end

  def parse_lines([lrs | mappings]) do
    dirs =
      lrs
      |> String.graphemes()
      |> Enum.map(fn c ->
        if c == "L" do
          :left
        else
          :right
        end
      end)

    maps = Enum.map(mappings, &parse_mapping/1)
    {dirs, maps}
  end

  def process(_, _, "ZZZ", _, count), do: count

  def process([], dirs, current, maps, count), do: process(dirs, dirs, current, maps, count)

  def process([lr | dirs], all_dirs, current, maps, count) do
    maps
    |> Enum.find(fn map -> map.from == current end)
    |> (fn m -> process(dirs, all_dirs, m[lr], maps, count + 1) end).()
  end

  def parse_mapping(mapping) do
    [[_, from, left, right]] = Regex.scan(~r/([A-Za-z]*) = \(([A-Za-z]*), ([A-Za-z]*)\)/, mapping)
    %{from: from, left: left, right: right}
  end
end

defmodule Day08.Part2 do
  def solve(path) do
    {dirs, maps} =
      path
      |> File.read!()
      |> String.split("\n", trim: true)
      |> parse_lines()

    maps
    |> Enum.filter(&String.ends_with?(&1.from, "A"))
    |> Enum.map(&process(dirs, dirs, &1.from, maps, 0))
    |> Enum.reduce(fn x, y -> div(x * y, Integer.gcd(x, y)) end)
  end

  def process([], all, current, maps, count), do: process(all, all, current, maps, count)

  def process([lr | dirs], all, current, maps, count) do
    if String.ends_with?(current, "Z") do
      count
    else
      maps
      |> Enum.find(fn map -> map.from == current end)
      |> (fn m -> process(dirs, all, m[lr], maps, count + 1) end).()
    end
  end

  def parse_lines([lrs | mappings]) do
    dirs =
      lrs
      |> String.graphemes()
      |> Enum.map(fn c ->
        if c == "L" do
          :left
        else
          :right
        end
      end)

    maps = Enum.map(mappings, &parse_mapping/1)
    {dirs, maps}
  end

  def parse_mapping(mapping) do
    [[_, from, left, right]] =
      Regex.scan(
        ~r/([A-Z0-9][A-Z0-9][A-Z0-9]) = \(([A-Z0-9][A-Z0-9][A-Z0-9]), ([A-Z0-9][A-Z0-9][A-Z0-9])\)/,
        mapping
      )

    %{from: from, left: left, right: right}
  end
end

defmodule Mix.Tasks.Day08 do
  use Mix.Task

  def run(_) do
    path = "inputs/day08-input.txt"
    IO.puts("Part 1: " <> (Day08.Part1.solve(path) |> Integer.to_string()))
    IO.puts("Part 2: " <> (Day08.Part2.solve(path) |> Integer.to_string()))
  end
end
