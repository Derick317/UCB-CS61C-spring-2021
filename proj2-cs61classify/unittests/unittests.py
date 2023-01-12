from unittest import TestCase
from framework import AssemblyTest, print_coverage


class TestAbs(TestCase):
    def test_minus_one(self):
        t = AssemblyTest(self, "abs.s")
        t.input_scalar("a0", -1)
        t.call("abs")
        t.check_scalar("a0", 1)
        t.execute()
        
    def test_zero(self):
        t = AssemblyTest(self, "abs.s")
        # load 0 into register a0
        t.input_scalar("a0", 0)
        # call the abs function
        t.call("abs")
        # check that after calling abs, a0 is equal to 0 (abs(0) = 0)
        t.check_scalar("a0", 0)
        # generate the `assembly/TestAbs_test_zero.s` file and run it through venus
        t.execute()

    def test_one(self):
        # same as test_zero, but with input 1
        t = AssemblyTest(self, "abs.s")
        t.input_scalar("a0", 1)
        t.call("abs")
        t.check_scalar("a0", 1)
        t.execute()

    @classmethod
    def tearDownClass(cls):
        print_coverage("abs.s", verbose=False)


class TestRelu(TestCase):
    def test_simple(self):
        t = AssemblyTest(self, "relu.s")
        # create an array in the data section
        array0 = t.array([1, -2, 3, -4, 5, -6, 7, -8, 9])
        # load address of `array0` into register a0
        t.input_array("a0", array0)
        # set a1 to the length of our array
        t.input_scalar("a1", len(array0))
        # call the relu function
        t.call("relu")
        # check that the array0 was changed appropriately
        t.check_array(array0, [1, 0, 3, 0, 5, 0, 7, 0, 9])
        # generate the `assembly/TestRelu_test_simple.s` file and run it through venus
        t.execute()

    def test_length_zero(self):
        t = AssemblyTest(self, "relu.s")
        # create an array in the data section
        array0 = t.array([])
        # load address of `array0` into register a0
        t.input_array("a0", array0)
        # set a1 to the length of our array
        t.input_scalar("a1", len(array0))
        # call the relu function
        t.call("relu")
        # generate the `assembly/TestRelu_test_simple.s` file and run it through venus
        t.execute(code=115)
    

    @classmethod
    def tearDownClass(cls):
        print_coverage("relu.s", verbose=False)


class TestArgmax(TestCase):
    def test_length_one(self):
        t = AssemblyTest(self, "argmax.s")
        # create an array in the data section
        array0 = t.array([123])
        # load address of the array into register a0
        t.input_array("a0", array0)
        # set a1 to the length of the array
        t.input_scalar("a1", len(array0))
        # call the `argmax` function
        t.call("argmax")
        # check that the register a0 contains the correct output
        t.check_scalar("a0", 0)
        # generate the `assembly/TestArgmax_test_simple.s` file and run it through venus
        t.execute()

    def test_first(self):
        t = AssemblyTest(self, "argmax.s")
        # create an array in the data section
        array0 = t.array([1, -2, 1, -2, 1, -2])
        # load address of the array into register a0
        t.input_array("a0", array0)
        # set a1 to the length of the array
        t.input_scalar("a1", len(array0))
        # call the `argmax` function
        t.call("argmax")
        # check that the register a0 contains the correct output
        t.check_scalar("a0", 0)
        # generate the `assembly/TestArgmax_test_simple.s` file and run it through venus
        t.execute()

    def test_last(self):
        t = AssemblyTest(self, "argmax.s")
        # create an array in the data section
        array0 = t.array([-3, -2, -1, 0, 1, 2])
        # load address of the array into register a0
        t.input_array("a0", array0)
        # set a1 to the length of the array
        t.input_scalar("a1", len(array0))
        # call the `argmax` function
        t.call("argmax")
        # check that the register a0 contains the correct output
        t.check_scalar("a0", 5)
        # generate the `assembly/TestArgmax_test_simple.s` file and run it through venus
        t.execute()

    def test_second(self):
        t = AssemblyTest(self, "argmax.s")
        # create an array in the data section
        array0 = t.array([-3, 100, -1, 0, 1, 2])
        # load address of the array into register a0
        t.input_array("a0", array0)
        # set a1 to the length of the array
        t.input_scalar("a1", len(array0))
        # call the `argmax` function
        t.call("argmax")
        # check that the register a0 contains the correct output
        t.check_scalar("a0", 1)
        # generate the `assembly/TestArgmax_test_simple.s` file and run it through venus
        t.execute()

    def test_length_zero(self):
        t = AssemblyTest(self, "argmax.s")
        # create an array in the data section
        array0 = t.array([])
        # load address of `array0` into register a0
        t.input_array("a0", array0)
        # set a1 to the length of our array
        t.input_scalar("a1", len(array0))
        # call the relu function
        t.call("argmax")
        # generate the `assembly/TestRelu_test_simple.s` file and run it through venus
        t.execute(code=120)

    @classmethod
    def tearDownClass(cls):
        print_coverage("argmax.s", verbose=False)


class TestDot(TestCase):
    def test_length_zero(self):
        t = AssemblyTest(self, "dot.s")
        # create arrays in the data section
        array0 = t.array([])
        array1 = t.array([1, 2, 3])
        # load array addresses into argument registers
        t.input_array("a0", array0)
        t.input_array("a1", array1)
        # load array attributes into argument registers
        t.input_scalar("a2", 0)
        t.input_scalar("a3", 5)
        t.input_scalar("a4", -1)
        # call the `dot` function
        t.call("dot")
        # check the return value
        t.execute(code=123)
    
    def test_invalid_stride(self):
        t = AssemblyTest(self, "dot.s")
        # create arrays in the data section
        array0 = t.array([2, 4, 5])
        array1 = t.array([1, 2, 3])
        # load array addresses into argument registers
        t.input_array("a0", array0)
        t.input_array("a1", array1)
        # load array attributes into argument registers
        t.input_scalar("a2", 3)
        t.input_scalar("a3", 5)
        t.input_scalar("a4", -1)
        # call the `dot` function
        t.call("dot")
        # check the return value
        t.execute(code=124)

    def test_length_one(self):
        t = AssemblyTest(self, "dot.s")
        # create arrays in the data section
        array0 = t.array([2])
        array1 = t.array([1])
        # load array addresses into argument registers
        t.input_array("a0", array0)
        t.input_array("a1", array1)
        # load array attributes into argument registers
        t.input_scalar("a2", 1)
        t.input_scalar("a3", 1)
        t.input_scalar("a4", 1)
        # call the `dot` function
        t.call("dot")
        # check the return value
        t.check_scalar("a0", 2)
        t.execute()
    
    def test_length_two(self):
        t = AssemblyTest(self, "dot.s")
        # create arrays in the data section
        array0 = t.array([2, 55])
        array1 = t.array([-1, 0])
        # load array addresses into argument registers
        t.input_array("a0", array0)
        t.input_array("a1", array1)
        # load array attributes into argument registers
        t.input_scalar("a2", 2)
        t.input_scalar("a3", 1)
        t.input_scalar("a4", 1)
        # call the `dot` function
        t.call("dot")
        # check the return value
        t.check_scalar("a0", -2)
        t.execute()
    
    def test_stride(self):
        t = AssemblyTest(self, "dot.s")
        # create arrays in the data section
        array0 = t.array([2, 3, 4, 5, 6, 7, 8])
        array1 = t.array([-1, 0, 1, 2, 3, 2, 1, 0, -1, -2])
        # load array addresses into argument registers
        t.input_array("a0", array0)
        t.input_array("a1", array1)
        # load array attributes into argument registers
        t.input_scalar("a2", 3)
        t.input_scalar("a3", 2)
        t.input_scalar("a4", 3)
        # call the `dot` function
        t.call("dot")
        # check the return value
        t.check_scalar("a0", 12)
        t.execute()
    
    def test_self_product(self):
        t = AssemblyTest(self, "dot.s")
        # create arrays in the data section
        array0 = t.array([1, 2, 3, 4, 5, 6, 7, 8, 9])
        # load array addresses into argument registers
        t.input_array("a0", array0)
        t.input_array("a1", array0)
        # load array attributes into argument registers
        t.input_scalar("a2", 3)
        t.input_scalar("a3", 1)
        t.input_scalar("a4", 2)
        # call the `dot` function
        t.call("dot")
        # check the return value
        t.check_scalar("a0", 22)
        t.execute()

    @classmethod
    def tearDownClass(cls):
        print_coverage("dot.s", verbose=False)


class TestMatmul(TestCase):

    def do_matmul(self, m0, m0_rows, m0_cols, m1, m1_rows, m1_cols, result, code=0):
        t = AssemblyTest(self, "matmul.s")
        # we need to include (aka import) the dot.s file since it is used by matmul.s
        t.include("dot.s")

        # create arrays for the arguments and to store the result
        array0 = t.array(m0)
        array1 = t.array(m1)
        array_out = t.array([0] * len(result))

        # load address of input matrices and set their dimensions
        t.input_array("a0", array0)
        t.input_scalar("a1", m0_rows)
        t.input_scalar("a2", m0_cols)
        t.input_array("a3", array1)
        t.input_scalar("a4", m1_rows)
        t.input_scalar("a5", m1_cols)
        # load address of output array
        t.input_array("a6", array_out)
        # call the matmul function
        t.call("matmul")

        # check the content of the output array
        t.check_array(array_out, result)

        # generate the assembly file and run it through venus, we expect the simulation to exit with code `code`
        t.execute(code=code)

    def test_simple(self):
        self.do_matmul(
            [1, 2, 3, 4, 5, 6, 7, 8, 9], 3, 3,
            [1, 2, 3, 4, 5, 6, 7, 8, 9], 3, 3,
            [30, 36, 42, 66, 81, 96, 102, 126, 150]
        )

    def test_invalid_m0(self):
        self.do_matmul(
            [1, 2, 3, 4, 5, 6, 7, 8, 9], 0, 1,
            [1, 2, 3, 4, 5, 6, 7, 8, 9], 1, 3,
            [30, 36, 42, 66, 81, 96, 102, 126, 150],
            code=125)
    
    def test_invalid_m0_2(self):
        self.do_matmul(
            [1, 2, 3, 4, 5, 6, 7, 8, 9], -1, 2,
            [1, 2, 3, 4, 5, 6, 7, 8, 9], 2, 3,
            [30, 36, 42, 66, 81, 96, 102, 126, 150],
            code=125)
    
    def test_invalid_m1(self):
        self.do_matmul(
            [1, 2, 3, 4, 5, 6, 7, 8, 9], 3, 3,
            [1, 2, 3, 4, 5, 6, 7, 8, 9], 3, 0,
            [30, 36, 42, 66, 81, 96, 102, 126, 150],
            code=126)
    
    def test_invalid_m1_2(self):
        self.do_matmul(
            [1, 2, 3, 4, 5, 6, 7, 8, 9], 1, 1,
            [1, 2, 3, 4, 5, 6, 7, 8, 9], -1, 1,
            [30, 36, 42, 66, 81, 96, 102, 126, 150],
            code=126)

    def test_unmatch(self):
        self.do_matmul(
            [1, 2, 3, 4, 5, 6, 7, 8, 9], 1, 1,
            [1, 2, 3, 4, 5, 6, 7, 8, 9], 3, 3,
            [30, 36, 42, 66, 81, 96, 102, 126, 150],
            code=127)
    
    def test_1x1_1x1(self):
        self.do_matmul(
            [1, 2, 3, 4, 5, 6, 7, 8, 9], 1, 1,
            [1, 2, 3, 4, 5, 6, 7, 8, 9], 1, 1,
            [1])
    
    def test_1x4_4x1(self):
        self.do_matmul(
            [1, 2, 3, 4, 5, 6, 7, 8, 9], 1, 4,
            [1, 2, 3, 4, 5, 6, 7, 8, 9], 4, 1,
            [30])

    def test_1x4_4x2(self):
        self.do_matmul(
            [1, 2, 3, 4, 5, 6, 7, 8, 9], 1, 4,
            [1, 2, 3, 4, 5, 6, 7, 8, 9], 4, 2,
            [50, 60])

    def test_2x4_4x1(self):
        self.do_matmul(
            [1, 2, 3, 4, 5, 6, 7, 8, 9], 2, 4,
            [1, 2, 3, 4, 5, 6, 7, 8, 9], 4, 1,
            [30, 70])
    
    @classmethod
    def tearDownClass(cls):
        print_coverage("matmul.s", verbose=False)


class TestReadMatrix(TestCase):

    def do_read_matrix(self, path: str, result: list, fail='', code=0):
        t = AssemblyTest(self, "read_matrix.s")
        # load address to the name of the input file into register a0
        t.input_read_filename("a0", path)

        # allocate space to hold the rows and cols output parameters
        rows = t.array([-1])
        cols = t.array([-1])

        # load the addresses to the output parameters into the argument registers
        t.input_array("a1", rows)
        t.input_array("a2", cols)

        # call the read_matrix function
        t.call("read_matrix")

        # check the output from the function
        if code == 0:
            t.check_array_pointer("a0", result)

        # generate assembly and run it through venus
        t.execute(fail=fail, code=code)

    def test_simple(self):
        self.do_read_matrix("inputs/test_read_matrix/test_input.bin", [1, 2, 3, 4, 5, 6, 7, 8, 9])

    def test_input_2(self):
        self.do_read_matrix("inputs/test_read_matrix/test_input_2.bin", [1, 2, 3, 10, 4, 5, 6, 9, 7, 8, 9, 8])

    def test_fail_opening(self):
        self.do_read_matrix("inputs/test_read_matrix/fail_open.bin", [], code=117)
    
    def test_fail_reading_3(self):
        self.do_read_matrix("inputs/test_read_matrix/test_fail_read_3.bin", [], code=118)
    
    def test_fail_reading_2(self):
        self.do_read_matrix("inputs/test_read_matrix/test_fail_read_2.bin", [], code=118)
    
    def test_fail_reading_1(self):
        self.do_read_matrix("inputs/test_read_matrix/test_fail_read_1.bin", [], code=118)

    def test_fail_malloc(self):
        self.do_read_matrix("inputs/test_read_matrix/test_fail_malloc.bin", [], code=116)
    
    def test_fail_fclose(self):
        self.do_read_matrix("inputs/test_read_matrix/test_input_2.bin", [], fail="fclose", code=119)

    @classmethod
    def tearDownClass(cls):
        print_coverage("read_matrix.s", verbose=False)


class TestWriteMatrix(TestCase):

    def do_write_matrix(self, rows, cols, elems, outfile, reffile, fail='', code=0):
        t = AssemblyTest(self, "write_matrix.s")
        header = "outputs/test_write_matrix/"
        # load output file name into a0 register
        t.input_write_filename("a0", header + outfile)
        # load input array and other arguments
        t.input_array("a1", t.array(elems))
        t.input_scalar("a2", rows)
        t.input_scalar("a3", cols)
        # call `write_matrix` function
        t.call("write_matrix")
        # generate assembly and run it through venus
        t.execute(fail=fail, code=code)
        # compare the output file against the reference
        if not code:
            t.check_file_output(header + outfile, header + reffile)

    def test_simple(self):
        self.do_write_matrix(3, 3, list(range(1, 14)), "student.bin", "reference.bin")
    
    def test_simple2(self):
        self.do_write_matrix(1, 4, [3, 0, 4, -4], "student.bin", "reference2.bin")

    def test_fail_open(self):
        self.do_write_matrix(3, 3, [1, 2], "student.bin", "reference.bin",  "fopen", code=112)
    
    def test_fail_write(self):
        self.do_write_matrix(3, 3, [1, 2], "student.bin", "reference.bin", "fwrite", code=113)
    
    def test_fail_close(self):
        self.do_write_matrix(3, 3, [1, 2], "student.bin", "reference.bin", "fclose", code=114)

    @classmethod
    def tearDownClass(cls):
        print_coverage("write_matrix.s", verbose=False)


class TestClassify(TestCase):

    def make_test(self):
        t = AssemblyTest(self, "classify.s")
        t.include("argmax.s")
        t.include("dot.s")
        t.include("matmul.s")
        t.include("read_matrix.s")
        t.include("relu.s")
        t.include("write_matrix.s")
        return t

    def test_simple0_input0(self):
        t = self.make_test()
        out_file = "outputs/test_basic_main/student0.bin"
        ref_file = "outputs/test_basic_main/reference0.bin"
        args = ["inputs/simple0/bin/m0.bin", "inputs/simple0/bin/m1.bin",
                "inputs/simple0/bin/inputs/input0.bin", out_file]
        # call classify function
        t.call("classify")
        # generate assembly and pass program arguments directly to venus
        t.execute(args=args)

        # compare the output file and
        t.check_file_output(args[-1], ref_file)
        # compare the classification output with `check_stdout`

    @classmethod
    def tearDownClass(cls):
        print_coverage("classify.s", verbose=False)


# The following are some simple sanity checks:
import subprocess, pathlib, os
script_dir = pathlib.Path(os.path.dirname(__file__)).resolve()

def compare_files(test, actual, expected):
    assert os.path.isfile(expected), f"Reference file {expected} does not exist!"
    test.assertTrue(os.path.isfile(actual), f"It seems like the program never created the output file {actual}!")
    # open and compare the files
    with open(actual, 'rb') as a:
        actual_bin = a.read()
    with open(expected, 'rb') as e:
        expected_bin = e.read()
    test.assertEqual(actual_bin, expected_bin, f"Bytes of {actual} and {expected} did not match!")

class TestMain(TestCase):
    """ This sanity check executes src/main.S using venus and verifies the stdout and the file that is generated.
    """

    def run_main(self, inputs, input_id, output_id, label):
        args = [f"{inputs}/m0.bin", f"{inputs}/m1.bin",
                f"{inputs}/inputs/input{input_id}.bin",
                f"outputs/test_basic_main/student{output_id}.bin"]
        reference = f"outputs/test_basic_main/reference{output_id}.bin"

        t= AssemblyTest(self, "main.s", no_utils=True)
        t.call("main")
        t.execute(args=args)
        t.check_stdout(label)
        t.check_file_output(args[-1], reference)

    def test00(self):
        self.run_main("inputs/simple0/bin", "0", "0", "2")

    def test10(self):
        self.run_main("inputs/simple1/bin", "0", "1", "1")
    
    def test01(self):
        self.run_main("inputs/simple0/bin", "1", "01", "2")

    def test12(self):
        self.run_main("inputs/simple1/bin", "2", "12", "1")
    
    def test20(self):
        self.run_main("inputs/simple2/bin", "0", "20", "7")
