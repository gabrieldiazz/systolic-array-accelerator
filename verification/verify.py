import random 
import subprocess


SIZE = 3

A = [[random.randint(-10, 10) for j in range(SIZE)] for i in range(SIZE)]
B = [[random.randint(-10, 10) for j in range(SIZE)] for i in range(SIZE)]

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
C = [[0 for j in range(SIZE)] for i in range(SIZE)]


for i in range(SIZE):
    for j in range(SIZE):
        for k in range(SIZE):
            C[i][j] += A[i][k] * B[k][j]

print("A:", A)
print("B:", B)
print("Expected C:", C)


# compile the SystemVerilog
subprocess.run([
    "iverilog",
    "-g2012",
    "-Wall",
    "-o", "sim.vvp",
    "rtl/pe.sv",
    "rtl/systolic_array.sv",
    "tb/systolic_array/systolic_array_file_tb.sv"
], check=True)

# run the simulation
subprocess.run([
    "vvp",
    "sim.vvp"
], check=True)

# rtl answer
actual_C = []

with open("verification/output.txt", "r") as f:
    for line in f:
        row = [int(value) for value in line.split()]
        actual_C.append(row)

print("Actual C:", actual_C)

if actual_C == C:
    print("PASS")
else:
    print("FAIL")
    print("Expected:", C)
    print("Actual:  ", actual_C)