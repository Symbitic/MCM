Mutant CMake Modules
====================

[![Travis CI][travis_img]][travis_url]
[![GPLv3 License][license_img]][license_url]

**M**utant **C**Make **M**odules (MCM) is a collection of CMake modules to aid
in developing Mutant Engine.

About
-----

MCM was created so that Mutant Engine could use CMake as the underlying build
system, without requiring large amounts of boilerplate setup code in every
project.

For more information about MCM, see <https://symbitic.github.com/mcm/>

Getting Started
---------------

Mutant Engine is still in pre-release beta. Users must clone the GitHub
repository and build it themselves if they wish to use MCM. In the future,
binary releases may be uploaded for easier use.

Building
--------

Mutant Engine projects uses [CMake] as the build system.
CMake 3.0.0 or later is required.

The recommended way of building MCM is by building the entire Mutant Engine
toolchain. To download and build Mutant Engine using CMake and [Ninja]
(Recommended), run:

```bash
$ git clone https://github.com/Symbitic/Mutant
$ mkdir Mutant/build
$ cd Mutant/build
$ cmake -G "Ninja" ..
$ ninja
```

CMake will then handle downloading, configuring, building, and packaging of
all Mutant Engine components. An active internet connection is needed to
download the Mutant Engine sub-components.

Alternatively, MCM may be compiled manually from the GitHub repo, or from a
source code release. This is not recommended for beginners, as it may involve
lots of manual configuration.

Legal
-----

![GPLv3][gpl_img]

Copyright (c) 2015-2016 Mutant Engine Contributors.

MCM is distributed under the terms of version 3 of the
[GNU General Public License], with a linking exception. For full terms, see
[COPYING.txt].

[travis_img]: https://img.shields.io/travis/Symbitic/MCM.svg?style=flat-square&label=Build

[travis_url]: https://travis-ci.org/Symbitic/MCM

[license_img]: https://img.shields.io/github/license/Symbitic/MCM.svg?style=flat-square&label=License

[license_url]: http://choosealicense.com/licenses/gpl-3.0/

[CMake]: http://www.cmake.org/

[Ninja]: https://ninja-build.org/

[gpl_img]: http://www.gnu.org/graphics/gplv3-127x51.png

[GNU General Public License]: http://www.gnu.org/licenses/gpl-3.0.html

[COPYING.txt]: ./COPYING.txt: