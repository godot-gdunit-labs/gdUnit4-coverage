extends GdUnitTestSuite


func test_calculator_add() -> void:
	var calc: Calculator = Calculator.new()
	assert_that(calc.add(2, 3)).is_equal(5)


func test_calculator_subtract() -> void:
	var calc: Calculator = Calculator.new()
	assert_that(calc.subtract(5, 3)).is_equal(2)
