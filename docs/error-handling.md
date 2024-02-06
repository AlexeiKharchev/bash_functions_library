[Main](../../../) / [Usage](../../../#usage) / [Libraries](../../../#libraries) / [Functions](function-list.md) / [Installation](installation.md) / [Description](description.md) / [Coding](coding-standards.md) / [Constants](../../../#Constants) / Error handling / [Tests](../../../#tests) / [Templates](../../../#templates) / [Examples](../../../#examples) / [Docs](../../../#documentation) / [ToDo](../../../#todo)

## Error Handling

[BFL error vs BFL die](#bfl-die-vs-error) / [BFL die](#bfl-die) / [Verify arguments count](#verify-arguments-count) / [Guidelines](#guidelines)  / [Exit with Command Substitution](#exit-with-command-substitution)


### BFL error vs BFL die

Function bfl::die() is one of most often used functions in [JMooring library](https://github.com/jmooring/bash-function-library). Function bfl::die() calls `exit 1` statement,<br />
which is appropriate for running external scripts (`./some_script`), but on any error it closes terminal imediately. Scripts should not die immediately, but write log and return code error.<br />
I accept using `exit 1` instead of `return 1` in case of code mistakes **absolute absense**.<br />

Another problem: `trap 'bfl::write_failure ... ' ERR` doesn't work correctly from `bfl::die` - exit should be called from function which is error source.<br />

The only way to exit function is [according to stackoverflow](https://stackoverflow.com/questions/9640660/any-way-to-exit-bash-script-but-not-quitting-the-terminal):<br />
1) to remember error code result;<br />
2) to replace bfl::die() by bfl::error(), which looks like `write_log ...; return 0`;<br />
3) return with saved error code.

I refused from using bfl::die() on error in almost all scripts, because I am trying to integrate `Bash Functions Library` in all system scripts.<br />
Moreover, my library is located in /etc directory (see [Usage](../../../#usage)).<br />

I understand idea `bfl::die`, but I refused as `Bash` terminal halts on exit 1 (I am a novice in Bash and don't know many nuances). Comparing error() with die():<br />

               bfl::error                               bfl::die
```bash
bfl::foo () {                               bfl::foo () {
  local -i iErr                               if [[ ! -f "${file}" ]]; then
  if [[ ! -f "${file}" ]]; then                 bfl::die "${file} does not exist."
    iErr=$?                                   fi
    bfl::error "${file} does not exist."      }
    return ${iErr}
  fi
  }
```

In my BFL version, upon error, almost all library functions call `bfl::error` with an error message. Only `bfl::error` call `bfl::die` - cause error inside error processing function.<br />

### BFL die

The `bfl::die` function calls `exit 1`. If the chain of commands leading to
`bfl::die` is direct (no command substitution), the parent script exits when
`bfl::die` fires. If command substitution occurs **anywhere** in the chain of
commands leading to `bfl::die`, the parent script will **not** exit because
command substitution spawns a subshell.
See [Exit with Command Substitution](#exit-with-command-substitution)
for a detailed explanation.


### Verify arguments count

The `bfl::verify_arg_count` function **is useful for study, but is too heavy for execution**. Because there is no way to write ultrashort expressions, without extra `return ${iErr}` statement,<br />
there is no need for this function. Comparing verify_arg_count() with simple bash syntax:<br />

```bash
bfl::verify_arg_count "$#" 1 3 || { usage; exit 1; }
                         vs
(( $# > 0 && $# < 4 )) ||
  { bfl::error "arguments count $# ∉ [1..3]."; return 1; }
```

Original [JMooring library](https://github.com/jmooring/bash-function-library) also uses inside `bfl::verify_arg_count` statement `return 1` upon error.
This exception allows the parent script to call a usage function when the
argument count is incorrect.


### Guidelines

1\) Within the `main()` function of a script, if `bfl::verify_arg_count` fails, display the usage message.<br />
For example:
```bash
bfl::verify_arg_count "$#" 1 3 || { usage; exit 1; }
```

2\) Within any other function, if `bfl::verify_arg_count` fails, exit 1.<br />
For example:
```bash
bfl::verify_arg_count "$#" 1 3 || exit 1
```

Although you could call `bfl::die "foo"` instead of `exit 1`, it would have the same result but with a second error message.<br />
Either way is fine, but prefer the former.

3\) Except for `bfl::verify_arg_count` there is no need to test the exit status when calling a library function directly&mdash;library<br />
functions call `bfl::die` upon error. For example:
```bash
bfl::foo "bar"
```

3\) Always test the exit status when performing command substitution.<br />
For example:
```bash
var=$(bfl::foo "bar") || bfl::die "Unable to foo the bar."
var=$(pwd) || bfl::die "Unable to determine working directory."
```

4\) Logical library functions such as `bfl::is_empty` and `bfl::is_integer` have an exit status of 0 if true, 1 if false.<br />
By definition you will always test the exit status, either explicitly or implicitly, when using logical library functions.<br />
For example:
```bash
if bfl::is_integer "${foo}"; then
  printf "%s is an integer.\\n" "${foo}"
else
  printf "%s is not an integer.\\n" "${foo}"
fi

bfl::is_empty "${bar}" && printf "\${bar} is empty.\\n" "${bar}"
```

### Exit with Command Substitution

Define a function within a script:

```bash
my_function() {
  exit 1
}
```

Now call the function directly:

```bash
my_function
```
The script will exit.<br />
Now, instead of calling the function directly, use command substitution:
```bash
var=$(my_function)
```
In this case the script will *not* exit because command substitution occurs in a subshell.<br />
The subshell exits, not the shell or script that invoked it. There are two ways to address this:

1\) Test the exit status of command substitution. For example:

```bash
var=$(bfl::trim "${foo}") || exit 1
```

2\) Configure the shell or script to exit if any command exits with a non-zero status with `set -e`.<br />
In this configuration, the shell or script that invokes command substitution will exit when the subshell exits.

Recommendation: code defensively by testing the exit status of all but the most trivial commands, and invoke<br />
`set -euo pipefail` at the beginning of the script. While we don't want to rely on `set -e`, it may catch items we miss.

Do both&mdash;take no chances!
