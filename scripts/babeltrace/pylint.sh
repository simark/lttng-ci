#!/bin/sh -exu
#
# Copyright (C) 2015 - Michael Jeanson <mjeanson@efficios.com>
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

BABELTRACE_DIR="deps/babeltrace/build"

PYTHON3=python3
P3_VERSION=$($PYTHON3 -c "import sys;print(sys.version[:3])")

BINDINGS_DIR="$BABELTRACE_DIR/lib/python${P3_VERSION}/dist-packages/babeltrace"

PYENV_HOME="$WORKSPACE/.pyenv/"

# Delete previously built virtualenv
if [ -d "$PYENV_HOME" ]; then
    rm -rf "$PYENV_HOME"
fi

# Create virtualenv and install necessary packages
virtualenv --system-site-packages -p ${PYTHON3} "$PYENV_HOME"

set +u
. "$PYENV_HOME/bin/activate"
set -u

pip install --quiet pylint
pip install --quiet pep8

pep8 --exclude="nativebt.py" "$BINDINGS_DIR" | tee pep8.out

pylint -f parseable --ignore="nativebt.py" "$BINDINGS_DIR" | tee pylint.out
