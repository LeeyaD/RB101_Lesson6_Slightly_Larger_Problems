# Input: an Array
# Output: a String
# Rules:
# - display a joining word, 'or', for the last element
# - delimiting option for between elements in array?

# EDGE CASE
# - what happens when there's an array w/ only 1 element?
#   - choosing to assume that it should return its self as a string in that case

# ALGO
# take 3 arguments (array, delimiter, join_word), the last 2 being optional
# - the last 2 being optional, delimiter = ", " and join_word = "or"
# if array.size == 1, => the element as a string
# if array.size == 2, => 'or' btwn both elements
# initialize 'result' = ""
# initialize curr_value = nil
# iniitalize counter = 0
# loop through array
#   assign curr_value to array[counter]
#   on each iteration convert curr_value to a string, #to_s, and append delimiter to the end of it, '+'
#   increase counter by 1
# when loop ends, append join_word to front of last character in string
#  result.insert(-2, join_word) 
require 'pry'
def joinor(array, delimiter = ", ", join_word = "or")
  if array.size == 1
    "array[0]"
  elsif array.size == 2
    "#{array[0]} " + join_word + " #{array[1]}"
  else
    result = ""
    curr_value = nil
    counter = 0

    loop do
      break if counter >= array.size - 1
      curr_value = array[counter]
      result << curr_value.to_s + delimiter
      counter += 1
    end
    result + join_word + " #{array[-1]}"
  end
end

p joinor([1, 2]) == "1 or 2"
p joinor([1, 2, 3]) == "1, 2, or 3"
p joinor([1, 2, 3], '; ') == "1; 2; or 3"
p joinor([1, 2, 3], ', ', 'and') == "1, 2, and 3"