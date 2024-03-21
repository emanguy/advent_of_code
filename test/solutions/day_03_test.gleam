import file_tooling
import gleam/option.{Some}
import solutions/day_03
import gleeunit/should

pub fn part_number_extraction_test() {
  file_tooling.day_input_by_line(challenge: 3, sample: Some(1))
  |> day_03.find_potential_part_numbers
  |> should.equal([
    day_03.NumberLocation(number: 467, row: 0, column_range: #(0, 2)),
    day_03.NumberLocation(number: 114, row: 0, column_range: #(5, 7)),
    day_03.NumberLocation(number: 35, row: 2, column_range: #(2, 3)),
    day_03.NumberLocation(number: 633, row: 2, column_range: #(6, 8)),
    day_03.NumberLocation(number: 617, row: 4, column_range: #(0, 2)),
    day_03.NumberLocation(number: 58, row: 5, column_range: #(7, 8)),
    day_03.NumberLocation(number: 592, row: 6, column_range: #(2, 4)),
    day_03.NumberLocation(number: 755, row: 7, column_range: #(6, 8)),
    day_03.NumberLocation(number: 664, row: 9, column_range: #(1, 3)),
    day_03.NumberLocation(number: 598, row: 9, column_range: #(5, 7)),
  ])
}
