import gleam/iterator.{type Iterator}
import gleam/option.{type Option, None, Some}
import gleam/string
import gleam/int
import gleam/list
import gleam/result

pub type PotentialPartNumber {
  NumberLocation(number: Int, row: Int, column_range: #(Int, Int))
}

pub fn find_potential_part_numbers(
  number_grid: Iterator(String),
) -> List(PotentialPartNumber) {
  number_grid
  |> iterator.index
  // Becomes Iterator(#(line, index))
  |> iterator.map(fn(grid_row) {
    extract_numbers_from_line(grid_row.0, grid_row.1, 0, None)
  })
  // Becomes Iterator(List(PotentialPartNumber))
  |> iterator.map(iterator.from_list)
  // Becomes Iterator(Iterator(PotentialPartNumber))
  |> iterator.flatten
  // Becomes Iterator(PotentialPartNumber)
  |> iterator.to_list
}

fn extract_numbers_from_line(
  current_line: String,
  row: Int,
  start_column: Int,
  partial_number: Option(Int),
) -> List(PotentialPartNumber) {
  case string.pop_grapheme(current_line) {
    Error(Nil) ->
      case partial_number {
        None -> []
        Some(number) -> {
          let num_digits =
            number
            |> int.digits(10)
            |> result.unwrap([])
            |> list.length

          // We need to subtract 1 from the start column because the number would have ended at the previous character
          [
            NumberLocation(number, row, column_range: #(
              start_column - num_digits,
              start_column - 1,
            )),
          ]
        }
      }

    Ok(#(next_char, rest)) -> {
      case int.parse(next_char) {
        Error(Nil) ->
          case partial_number {
            Some(number) -> {
              let num_digits =
                number
                |> int.digits(10)
                |> result.unwrap([])
                |> list.length

              // We need to subtract 1 from the start column because the number would have ended at the previous character
              [
                NumberLocation(number, row, column_range: #(
                  start_column - num_digits,
                  start_column - 1,
                )),
                ..extract_numbers_from_line(rest, row, start_column + 1, None)
              ]
            }

            None -> extract_numbers_from_line(rest, row, start_column + 1, None)
          }

        Ok(num) ->
          case partial_number {
            None ->
              extract_numbers_from_line(rest, row, start_column + 1, Some(num))
            Some(existing_number) ->
              extract_numbers_from_line(
                rest,
                row,
                start_column + 1,
                Some(existing_number * 10 + num),
              )
          }
      }
    }
  }
}
