As the repository title says, these files are helpers for single-file cpp assignments.

*You could also use it for other languages, but you'll need to edit the* `autocompile.sh` *script!*

This also doesn't use any test libraries!
It's meant for classes that provide a test runner and a file containing the expected output!

## License

- [MIT](LICENSE)

## Dependencies

- [entr](http://entrproject.org/)
  - Some distros have it on the package manager, but it's easy to compile it, if needed
- `tmux` (for `startdev.sh`)
- `bash`
- `git`
  - `git status` is executed by `autocompile.sh`, you may remove this, if git isn't used

## Usage

Make sure that `expected_output.txt` is in the same folder as `file.cpp`

For best results, resize your terminal to occupy a whole screen then execute (assuming you are on the same folder as `startdev.sh`):

`./startdev.sh PATH/TO/file.cpp`

## What each file does?

- `autocompile.sh`<br/>Monitors the `.cpp` file and automatically recompiles it when it detects a modification.

- `autotest.sh`<br/>Monitors the executable file and automatically runs another test when it detects a modification

- `startdev.sh`<br/>Calls tmux and tells it to run both previous scripts on a terminal divided with a vertical line, compilation results is shown on the left and test run results are shown on the right.

## FAQ

#### How is the program execution checked?

1. You need an `expected_output.txt` file, be it provided by the professor or created by you.
2. The script executes the compiled program redirecting its output to `output.txt`.
3. `diff` is called to check the difference between `expected_output.txt` and `output.txt`
  - Only shows lines that differ
  - Output is done on 2-column mode
4. `diff`'s output is piped into `head`, limiting the output to 30 lines
  - The idea is to show the first errors, so the student can work on them before continuing to the next errors

#### Why not pipe the execution directly to diff?

Some professors require the students to copy paste the program execution at the end of the source file, so `output.txt` is generated by default for convenience.

#### Why not use a testing library like Catch, googletest, Boost::test, ...?

Some professors just provide a test runner file and a file containing expected output, this is made specifically for this situation.
