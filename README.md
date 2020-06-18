# My Solution

Hi!

Please run

```sh

ruby main.rb

```

And to run tests

```sh
  bundle exec rspec
```

My solution is based on a class `MerkleTreeVerifier` which reads the json file
and converts it to an array of timestamps.

Then, we walk through the timestamps appling the operation `Operator(Prefix + message + Postfix)`
to each. Finally, we compare the final message to the big-endian converted merkle root.

If this class was to be used outside of a test-environment, it would be useful to
build in error checks, to ensure the operations are all timestamps, the
operators are valid operators, the prefixes and postfixes are strings and so on.


# Verisart Coding Test

This coding test is about using standard Go/Python routines to parse a Merkle path embedded in a json file. A Merkle
path consists of a series of cryptographic operations, applied to an initial `message`. Each operation has an `Operator` and
two operands (`Prefix` and `Postfix`). The output of each operation is `Operator(Prefix + message + Postfix)`, which will become
the `message` in the operation. The final `message` is a hash called the Merkel root. Your task is to implement a
function called `VerifyHash` that takes in a list of operations, the initial message and the Merkle root and returns whether
the message can be verified by following the path.

Please use the provided files (main.go or main.py) as the starting points.
