# Remote Spec

Remote Spec is a simple testing framework that allows you to run automated checks on remote systems or your local machine. You can write your tests using shell scripts and run them easily against local, SSH, or Vagrant environments.

## Features
- Write descriptive test suites using shell scripts.
- Run tests locally, over SSH, or inside Vagrant.
- Perform common assertions like `AssertEquals`, `AssertInstalled`, and `AssertLineInFile`.
- Automatically track and display test results (pass/fail).

## Installation

Run the following script to install Remote Spec:

```bash
#!/usr/bin/env bash

install -m 744 remote-spec ~/.remote-spec
install -m 644 framework.sh ~/.remote-spec

echo "Add the following to your .bashrc"
echo "export PATH=\$PATH:~/.remote-spec"
echo "Create a test with: remote-spec init <name_of_your_test>"
echo "Run it with: remote-spec run <name_of_your_test>"
```

To install Remote Spec, simply copy and paste the above script into your terminal.

Then add Remote Spec to your PATH by adding the following line to your `.bashrc`:

```bash
export PATH=$PATH:~/.remote-spec
```

## Usage

Remote Spec offers an easy-to-use interface for defining and running tests:

### Create a Test
To create a new test, run:

```bash
remote-spec init <name_of_your_test>
```

This will create a new test script with the specified name.

### Run a Test
To run a test, use the following command:

```bash
remote-spec run <name_of_your_test>
```

## Writing Tests

The framework provides a set of functions for defining test cases:

- `Setup <provider>`: Specify the test provider (e.g., `local`, `ssh`, or `vagrant`).
- `Describe <description>`: Define a block of tests with a specific context or feature.
- `It <description>`: Define an individual test case.
- `AssertEquals <expected> <received>`: Check if the expected value matches the received value.
- `AssertInstalled <package>`: Verify that a given package is installed.
- `AssertLineInFile <line> <file>`: Check if a specific line exists in a given file.

### Example

Here is a basic example of how to write a test using Remote Spec:

```bash
#!/usr/bin/env bash

Setup local

Describe "Basic Local Tests"
    It "should pass when echo outputs the correct string"
        result=$(echo "Hello World")
        AssertEquals "Hello World" "$result"
    End

    It "should have bash installed"
        AssertInstalled "bash"
    End
End
```

## Running Tests
You can run the test script by executing:

```bash
remote-spec run <test_script_name>
```

The results will be displayed in your terminal, showing `PASS` or `FAIL` for each assertion.

## Supported Providers
Remote Spec supports different execution environments:
- **Local**: Run commands directly on your local machine.
- **SSH**: Run commands on a remote machine over SSH (provide SSH options as needed).
- **Vagrant**: Run commands inside a Vagrant machine.

## Summary
Remote Spec is an easy-to-use testing framework to automate testing on remote systems or locally. It provides a basic set of tools to help you validate the state of your infrastructure.

Get started by writing a test today and simplify your testing process with Remote Spec!


