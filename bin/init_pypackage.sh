#!/bin/bash
name=$1
user=akiyoshi
uid=akiyoshi83
email=mail@akiyoshi83.info
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

cat <<EOS > setup.py
from setuptools import find_packages, setup

with open('README.rst') as f:
    readme = f.read()

with open('LICENSE') as f:
    license = f.read()

setup(
    name='$name',
    version='0.0.1',
    description='',
    long_description=readme,
    author='$uid',
    author_email='$email',
    url='https://github.com/$uid/$name',
    license=license,
    packages=find_packages(exclude=('tests', 'docs'))
)
