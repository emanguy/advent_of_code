import gleam/iterator
import gleam/string
import gleam/int
import gleam/bool
import gleam/io

pub fn part_1(input_lines: iterator.Iterator(String)) {
  input_lines
  |> part_1_logic
  |> int.to_string
  |> string.append("The sum of the valid game IDs is: ", _)
  |> io.println
}

pub fn part_1_logic(input_lines: iterator.Iterator(String)) -> Int {
  input_lines
  |> iterator.map(fn(line) {
    let assert [game_title, game_body] = string.split(line, ":")
    let game_id = {
      let assert "Game " <> game_id_str = game_title
      let assert Ok(game_id) = int.parse(game_id_str)
      game_id
    }
    let game_validity =
      game_body
      |> string.split(";")
      |> iterator.from_list
      |> iterator.map(string.trim)
      |> iterator.map(to_game)
      |> valid_game

    io.println(
      game_title <> " is a valid game: " <> bool.to_string(game_validity),
    )
    #(game_id, game_validity)
  })
  // Parse a game string with debug info
  |> iterator.filter(fn(game_result) { game_result.1 })
  // Filter out invalid games
  |> iterator.fold(0, fn(id_total, result) { id_total + result.0 })
  // Sum the game IDs
}

pub fn part_2(input_lines: iterator.Iterator(String)) {
  input_lines
  |> part_2_logic
  |> int.to_string
  |> string.append("The sum of the power across all minimum bags is: ", _)
  |> io.println
}

pub fn part_2_logic(input_lines: iterator.Iterator(String)) -> Int {
  input_lines
  |> iterator.map(fn(line) {
    let assert [_, game_body] = string.split(line, ":")

    game_body
    |> string.split(";")
    |> iterator.from_list
    |> iterator.map(string.trim)
    |> iterator.map(to_game)
    |> bag_minimum
    |> power
  })
  // Get the power of the minimum bag for the current game
  |> iterator.fold(0, int.add)
}

type CubeSet {
  Cubes(red: Int, green: Int, blue: Int)
}

const initial_set = Cubes(red: 0, green: 0, blue: 0)

fn valid_game(turns: iterator.Iterator(CubeSet)) -> Bool {
  let valid_bag = Cubes(red: 12, green: 13, blue: 14)

  turns
  |> iterator.map(fn(turn) {
    turn.red <= valid_bag.red
    && turn.green <= valid_bag.green
    && turn.blue <= valid_bag.blue
  })
  |> iterator.fold(True, bool.and)
}

fn bag_minimum(turns: iterator.Iterator(CubeSet)) -> CubeSet {
  iterator.fold(
    over: turns,
    from: Cubes(red: 0, green: 0, blue: 0),
    with: fn(cube_maxes, turn) {
      Cubes(
        red: int.max(turn.red, cube_maxes.red),
        green: int.max(turn.green, cube_maxes.green),
        blue: int.max(turn.blue, cube_maxes.blue),
      )
    },
  )
}

fn power(bag: CubeSet) -> Int {
  bag.red * bag.green * bag.blue
}

fn to_game(game_str: String) -> CubeSet {
  game_str
  |> string.split(",")
  |> iterator.from_list
  |> iterator.map(string.trim)
  |> iterator.fold(initial_set, fn(final_set, game_item) {
    let assert [number, color] = string.split(game_item, " ")
    let assert Ok(parsed_number) = int.parse(number)
    case color {
      "red" -> Cubes(..final_set, red: parsed_number)
      "green" -> Cubes(..final_set, green: parsed_number)
      "blue" -> Cubes(..final_set, blue: parsed_number)
      _ -> panic as "Received an invalid color!"
    }
  })
}
