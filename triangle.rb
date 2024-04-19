# Triangle Project Code.

# Triangle analyzes the lengths of the sides of a triangle
# (represented by a, b and c) and returns the type of triangle.
#
# It returns:
#   :equilateral  if all sides are equal
#   :isosceles    if exactly 2 sides are equal
#   :scalene      if no sides are equal
#
# The tests for this method can be found in
#   about_triangle_project.rb
# and
#   about_triangle_project_2.rb
#
def triangle(a, b, c)
  a, b, c = [a, b, c].sort
  #this is part of triangle project part 2
    # This line sorts the lengths 
    # of the sides of the triangle 
    # in ascending order and assigns 
    # them back to a, b, and c. This 
    # is to simplify later checks because 
    # in a triangle, the longest side 
    # always comes last after sorting.
  fail TriangleError if (a+b) <= c
  #this is part of triangle project part 2
    # This line checks if the sum of 
    # the two shortest sides is less 
    # than or equal to the longest side. 
    # If this condition is true, it means 
    # the sides cannot form a valid triangle 
    # according to the triangle inequality 
    # theorem, so it raises a TriangleError exception.
  sides = [a, b, c].uniq
    # This line creates an array sides containing 
    # the unique lengths of the sides of the triangle. 
    # This is done to determine the type of triangle later.
  [nil, :equilateral, :isosceles, :scalene][sides.size]
    # This line returns the type of triangle based on the number 
    # of unique sides. It uses the number of unique sides as an 
    # index to select the corresponding type of triangle from the array. 
    # Here's how it works:
    #   If sides.size is 1, all sides are equal, so it's an equilateral triangle.
    #   If sides.size is 2, two sides are equal, so it's an isosceles triangle.
    #   If sides.size is 3, all sides are different, so it's a scalene triangle.
    #   If none of the above conditions match, it returns nil.
end

# Error class used in part 2.  No need to change this code.
class TriangleError < StandardError
end
