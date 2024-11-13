# Num Fuzzer

Here are some tools to facilitate your programming.

## Contents

- `rand`: a program that generates random numbers
- `check.sh`: a shell script where you can check the bignum reading and printing program
- `check_report.sh`: checks whether your report contains 200 words or more
- `inp_to_bignum_prog.txt`: example input to the bignum printing program
- `inp_to_lisp_parser.txt`: example input to the LISP parser

Type `make` to compile.

## Test the Bignum Program

The following will start a fuzzing job:

```bash
./check.sh ./rand <bignum program>
```

Try

```bash
cat inp_to_bignum_prog.txt | <bignum program>
```

The output must be the same as the input.

## Test the LISP parser

```bash
<your lisp parser> inp_to_lisp_parser.txt
```

You must get the same result as `z3`:

```bash
z3 inp_to_lisp_parser.txt
```
