#!/bin/bash
name=$1
user=$(git config --global user.name 2>/dev/null || echo "Your Name")
uid=$(git config --global github.user 2>/dev/null || echo "$user")
email=$(git config --global user.email 2>/dev/null || echo "you@example.com")
year=$(date "+%Y")

mkdir $name && cd $_
mkdir tests docs $name

cat <<EOS > LICENSE
MIT License

Copyright (c) $year $user

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
EOS

cat <<EOS > README.rst
=====
$name
=====

Overview

Description
-----------

Demo
----

Requirement
-----------

Usage
-----

Install
-------

Licence
-------

\`MIT <https://github.com/$uid/$name/blob/master/LICENCE>\`_

Author
------

\`$user <https://github.com/$uid>\`_
EOS

cat <<EOS > pyproject.toml
[build-system]
requires = ["hatchling"]
build-backend = "hatchling.build"

[project]
name = "$name"
version = "0.0.1"
description = ""
readme = "README.rst"
license = { file = "LICENSE" }
authors = [
  { name = "$user", email = "$email" }
]

[project.urls]
Repository = "https://github.com/$uid/$name"

[tool.hatch.build.targets.wheel]
packages = ["$name"]
EOS

touch $name/__init__.py

git init
git add .
git commit -m "Initial commit"
