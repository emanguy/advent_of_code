import gleam/iterator
import gleam/int
import gleam/io
import gleam/string
import gleam/option.{type Option, None, Some}
import simplifile

pub fn day_input_by_line(
  challenge day: Int,
  sample sample_num: Option(Int),
) -> iterator.Iterator(String) {
  let padded_day = case day {
    single_day if day < 10 -> "0" <> int.to_string(single_day)
    _ -> int.to_string(day)
  }
  let folder_target = "./aoc_data/day_" <> padded_day
  let file_path = case sample_num {
    None -> folder_target <> "/input.txt"
    Some(sample_id) ->
      folder_target <> "/input_sample_" <> int.to_string(sample_id) <> ".txt"
  }

  let file_content = case simplifile.read(file_path) {
    Ok(content) -> content
    Error(error) -> {
      io.println("Whoopsie, couldn't open the test file " <> file_path)
      io.debug(error)
      panic as "File read failed!"
    }
  }

  file_content
  |> string.split("\n")
  |> iterator.from_list
}
