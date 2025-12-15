# cmdline: A simple command line parser for C++

## About

This is a simple command line parser for C++, by Hideyuki Tanaka.

- Easy to use
- Only one header file
- Automatic type check

<br>

## Installation

Run:

```sh
$ npm i cmdline.cxx
```

And then include `cmdline.h` as follows:

```cxx
// main.cxx
#include "node_modules/cmdline.cxx/cmdline.h"

int main() { /* ... */ }
```

And then compile with `clang++` or `g++` as usual.

```bash
$ clang++ main.cxx  # or, use g++
$ g++     main.cxx
```

You may also use a simpler approach:

```cxx
// main.cxx
#include <cmdline.h>

int main() { /* ... */ }
```

If you add the path `node_modules/cmdline.cxx` to your compiler's include paths.

```bash
$ clang++ -I./node_modules/cmdline.cxx main.cxx  # or, use g++
$ g++     -I./node_modules/cmdline.cxx main.cxx
```

<br>

## Sample

Here show sample usages of cmdline.

## Normal usage

This is an example of simple usage.

```cxx
#include <cmdline.h>

int main(int argc, char *argv[])
{
  // create a parser
  cmdline::parser a;

  // add specified type of variable.
  // 1st argument is long name
  // 2nd argument is short name (no short name if '\0' specified)
  // 3rd argument is description
  // 4th argument is mandatory (optional. default is false)
  // 5th argument is default value  (optional. it used when mandatory is false)
  a.add<string>("host", 'h', "host name", true, "");

  // 6th argument is extra constraint.
  // Here, port number must be 1 to 65535 by cmdline::range().
  a.add<int>("port", 'p', "port number", false, 80, cmdline::range(1, 65535));

  // cmdline::oneof() can restrict options.
  a.add<string>("type", 't', "protocol type", false, "http",
                cmdline::oneof<string>("http", "https", "ssh", "ftp"));

  // Boolean flags also can be defined.
  // Call add method without a type parameter.
  a.add("gzip", '\0', "gzip when transfer");

  // Run parser.
  // It returns only if command line arguments are valid.
  // If arguments are invalid, a parser output error msgs then exit program.
  // If help flag ('--help' or '-?') is specified, a parser output usage message then exit program.
  a.parse_check(argc, argv);

  // use flag values
  cout << a.get<string>("type") << "://"
       << a.get<string>("host") << ":"
       << a.get<int>("port") << endl;

  // boolean flags are referred by calling exist() method.
  if (a.exist("gzip")) cout << "gzip" << endl;
}
```

Here are some execution results:

```sh
$ ./a.out
usage: ./a.out --host=string [options] ...
options:
  -h, --host    host name (string)
  -p, --port    port number (int [=80])
  -t, --type    protocol type (string [=http])
      --gzip    gzip when transfer
  -?, --help    print this message
```

```sh
$ ./a.out -?
usage: ./a.out --host=string [options] ...
options:
  -h, --host    host name (string)
  -p, --port    port number (int [=80])
  -t, --type    protocol type (string [=http])
     --gzip    gzip when transfer
  -?, --help    print this message
```

```sh
$ ./a.out --host=github.com
http://github.com:80
```

```sh
$ ./a.out --host=github.com -t ftp
ftp://github.com:80
```

```sh
$ ./a.out --host=github.com -t ttp
option value is invalid: --type=ttp
usage: ./a.out --host=string [options] ...
options:
  -h, --host    host name (string)
  -p, --port    port number (int [=80])
  -t, --type    protocol type (string [=http])
      --gzip    gzip when transfer
  -?, --help    print this message
```

```sh
$ ./a.out --host=github.com -p 4545
http://github.com:4545
```

```sh
$ ./a.out --host=github.com -p 100000
option value is invalid: --port=100000
usage: ./a.out --host=string [options] ...
options:
  -h, --host    host name (string)
  -p, --port    port number (int [=80])
  -t, --type    protocol type (string [=http])
      --gzip    gzip when transfer
  -?, --help    print this message
```

```sh
$ ./a.out --host=github.com --gzip
http://github.com:80
gzip
```

<br>

## Extra Options

### Rest of arguments

Rest of arguments are referenced by `rest()` method.
It returns a `vector<string>`.
Usually, they are used to specify filenames, and so on.

```cxx
for (int i = 0; i < a.rest().size(); i++)
  cout << a.rest()[i] << endl;
```

### Footer

`footer()` method adds a footer text to the usage message.

```cxx
...
a.footer("filename ...");
...
```

Result is:

```sh
$ ./a.out
usage: ./a.out --host=string [options] ... filename ...
options:
  -h, --host    host name (string)
  -p, --port    port number (int [=80])
  -t, --type    protocol type (string [=http])
      --gzip    gzip when transfer
  -?, --help    print this message
```

### Program name

A parser shows the program name in the usage message.
The default program name is determined by `argv[0]`.
`set_program_name()` method can set any string as the program name.

## Process flags manually

`parse_check()` method parses command line arguments and
checks errors and the help flag.

You can do this process manually.
The `bool parse()` method parses command line arguments and then
returns whether they are valid.

You should check the result and handle errors or help output yourself.

(For more information, you may read `test2.cpp`.)

<br>
<br>


[![ORG](https://img.shields.io/badge/org-nodef-green?logo=Org)](https://nodef.github.io)
![](https://ga-beacon.deno.dev/G-RC63DPBH3P:SH3Eq-NoQ9mwgYeHWxu7cw/github.com/nodef/cmdline.cxx)
