import file_tooling
import solutions/day_02
import gleeunit/should
import gleam/option.{Some}

pub fn part_1_works_with_sample_data_test() {
  file_tooling.day_input_by_line(challenge: 2, sample: Some(1))
  |> day_02.part_1_logic
  |> should.equal(8)
}

pub fn part_2_works_with_sample_data_test() {
  file_tooling.day_input_by_line(challenge: 2, sample: Some(1))
  |> day_02.part_2_logic
  |> should.equal(2286)
}