import gleeunit/should
import solutions/day_01
import file_tooling
import gleam/option.{Some}

pub fn part_1_works_with_sample_data_test() {
  file_tooling.day_input_by_line(challenge: 1, sample: Some(1))
  |> day_01.part_1_logic
  |> should.equal(142)
}

pub fn part_2_works_with_sample_data_test() {
  file_tooling.day_input_by_line(challenge: 1, sample: Some(2))
  |> day_01.part_2_logic
  |> should.equal(281)
}