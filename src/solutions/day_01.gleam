import gleam/iterator
import gleam/dict
import gleam/string
import gleam/int
import gleam/io
import gleam/option.{type Option, None, Some}

pub fn part_1(input_lines: iterator.Iterator(String)) {
  input_lines
  |> part_1_logic
  |> int.to_string
  |> string.append("The total of all the numbers is ", _)
  |> io.println
}

pub fn part_1_logic(input_lines: iterator.Iterator(String)) -> Int {
  input_lines
  |> iterator.map(get_numbers(_, None))
  |> iterator.map(fn(nums) { become_number(nums.0, nums.1) })
  |> iterator.fold(from: 0, with: int.add)
}

pub fn part_2(input_lines: iterator.Iterator(String)) {
  input_lines
  |> part_2_logic
  |> int.to_string
  |> string.append("The total of all the numbers is ", _)
  |> io.println
}

pub fn part_2_logic(input_lines: iterator.Iterator(String)) -> Int {
  input_lines
  |> iterator.map(get_numbers_with_text(_, None))
  |> iterator.map(fn(nums) { become_number(nums.0, nums.1) })
  |> iterator.fold(from: 0, with: int.add)
}

fn get_numbers(str: String, current_nums: Option(#(Int, Int))) -> #(Int, Int) {
  case string.pop_grapheme(str) {
    Error(Nil) -> {
      let assert Some(nums) = current_nums
      nums
    }

    Ok(#(next_char, rest)) -> {
      case int.parse(next_char) {
        Error(Nil) -> get_numbers(rest, current_nums)

        Ok(number) -> {
          let new_nums = case current_nums {
            None -> Some(#(number, number))
            Some(#(first_num, _)) -> Some(#(first_num, number))
          }

          get_numbers(rest, new_nums)
        }
      }
    }
  }
}

fn get_numbers_with_text(
  str: String,
  current_nums: Option(#(Int, Int)),
) -> #(Int, Int) {
  // Define the set of acceptable "number words"
  let acceptable_nums =
    dict.from_list([
      #("one", "1"),
      #("two", "2"),
      #("three", "3"),
      #("four", "4"),
      #("five", "5"),
      #("six", "6"),
      #("seven", "7"),
      #("eight", "8"),
      #("nine", "9"),
    ])

  // Get the set of keys from that dict which are a prefix to the current string
  let matching_prefixes =
    acceptable_nums
    |> dict.keys
    |> iterator.from_list
    |> iterator.filter(string.starts_with(str, _))
    |> iterator.to_list

  // If we got a match from the dict, transform the string prefix into the actual numeric value
  let updated_str = case matching_prefixes {
    [dict_key] -> {
      let assert Ok(str_num) = dict.get(acceptable_nums, dict_key)
      // Keep the last letter to deal with overlapping number words
      str_num <> string.drop_left(from: str, up_to: string.length(dict_key) - 1)
    }
    _ -> str
  }

  // Now just use the part 1 recursion again
  case string.pop_grapheme(updated_str) {
    // Case where 
    Error(Nil) -> {
      let assert Some(nums) = current_nums
      nums
    }

    Ok(#(next_char, rest)) -> {
      case int.parse(next_char) {
        Error(Nil) -> get_numbers_with_text(rest, current_nums)

        Ok(number) -> {
          let new_nums = case current_nums {
            None -> Some(#(number, number))
            Some(#(first_num, _)) -> Some(#(first_num, number))
          }

          get_numbers_with_text(rest, new_nums)
        }
      }
    }
  }
}

fn become_number(num1: Int, num2: Int) -> Int {
  num1 * 10 + num2
}
