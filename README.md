A collection of dev templates.
Using [flake-utils](https://github.com/numtide/flake-utils).

List templates:
```nix flake show --refresh github:rmcalvert/dev-shells```

## Usage
Replace `<template>` with the name of the language template you would like to use.
```sh
mkdir project && cd project
nix flake init --refresh -t github:rmcalvert/dev-shells#<template>
```
