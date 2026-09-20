import random 
import subprocess


SIZE = 3

def generate_matrices():
    A = [[random.randint(-10, 10) for _ in range(SIZE)] for _ in range(SIZE)]
    B = [[random.randint(-10, 10) for _ in range(SIZE)] for _ in range(SIZE)]
    return A, B

def create_input_file(A, B):
    with open("verification/input.txt", "w") as f:
        for row in A:
            for value in row:
                f.write(f"{value} ")
            f.write("\n")
        for row in B:
            for value in row:
                f.write(f"{value} ")
            f.write("\n")

# reference answer

def compute_reference_answer(A, B):
    C = [[0 for _ in range(SIZE)] for _ in range(SIZE)]


    for i in range(SIZE):
        for j in range(SIZE):
            for k in range(SIZE):
                C[i][j] += A[i][k] * B[k][j]
    return C

def compile_rtl():
    subprocess.run([
            "iverilog",
            "-g2012",
            "-Wall",
            "-o", "sim.vvp",
            "rtl/pe.sv",
            "rtl/systolic_array.sv",
            "tb/systolic_array/systolic_array_file_tb.sv"
        ], check=True)
    
def simulate_rtl():
    subprocess.run([
        "vvp",
        "sim.vvp"
    ], check=True,  stdout=subprocess.DEVNULL)


def read_actual_answer():
    actual_C = []
    
    with open("verification/output.txt", "r") as f:
        for line in f:
            row = [int(value) for value in line.split()]
            actual_C.append(row)

    return actual_C

def run_test(A = None, B = None):
    if A is None or B is None:
        A, B = generate_matrices()

    create_input_file(A, B)

    expected_C = compute_reference_answer(A, B)

    simulate_rtl()

    actual_C = read_actual_answer()

    return A, B, expected_C, actual_C

def check_test(name, A, B):
    A, B, expected_C, actual_C = run_test(A, B)

    if actual_C == expected_C:
        print(f"Test {name}: PASS")
        return True
    else:
        print(f"Test {name}: FAIL")
        print("A:", A)
        print("B:", B)
        print("Expected:", expected_C)
        print("Actual:  ", actual_C)
        return False
    

def main():
    identity = [
    [1, 0, 0],
    [0, 1, 0],
    [0, 0, 1]
    ]

    zero = [
    [0, 0, 0],
    [0, 0, 0],
    [0, 0, 0]
    ]

    mixed = [
    [5, -2, 7],
    [-3, 8, -4],
    [-6, 1, 9]
    ]

    all_negative = [
    [-1, -2, -3],
    [-4, -5, -6],
    [-7, -8, -9]
    ]

    max_int8 = [
    [127, 127, 127],
    [127, 127, 127],
    [127, 127, 127]
    ]

    min_int8 = [
    [-128, -128, -128],
    [-128, -128, -128],
    [-128, -128, -128]
    ]

    compile_rtl()

    print("Directed tests:")

    check_test("Identity", identity, mixed)
    check_test("Zero", zero, mixed)
    check_test("All negative", all_negative, all_negative)
    check_test("INT8 maximum", max_int8, max_int8)
    check_test("INT8 minimum", min_int8, min_int8)

    print()

    # now separately run randomized regression

    num_tests = 100
    passed = 0

    print("Random tests:")

    for test_num in range(1, num_tests + 1):
        if check_test(f"Random {test_num}", None, None):
            passed += 1

    print()
    print(f"{passed}/{num_tests} random tests passed")
    
if __name__ == "__main__":
    main()