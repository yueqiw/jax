# Copyright 2024 The JAX Authors.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

"""
Repository rule to set python version.
Can be set via argument line "--repo_env=HERMETIC_PYTHON_VERSION=3.10"
"""

VERSIONS = ["3.9", "3.10", "3.11", "3.12"]
DEFAULT_VERSION = "3.9"
WARNING = """
HERMETIC_PYTHON_VERSION variable was not set correctly, using default version. Python {}
will be used.
To select Python version, either set HERMETIC_PYTHON_VERSION env variable in your shell:
  export HERMETIC_PYTHON_VERSION=3.12
OR pass it as an argument to bazel command directly or inside your .bazelrc file:
  --repo_env=HERMETIC_PYTHON_VERSION="3.12"
""".format(DEFAULT_VERSION)

def _python_version_repository_impl(repository_ctx):
    repository_ctx.file("BUILD", "")
    version = repository_ctx.os.environ.get("HERMETIC_PYTHON_VERSION", "")
    if version not in VERSIONS:
        print(WARNING)  # buildifier: disable=print
        version = DEFAULT_VERSION
    else:
        print("Using hermetic Python %s" % version)  # buildifier: disable=print

    repository_ctx.file(
        "py_version.bzl",
        "HERMETIC_PYTHON_VERSION = \"%s\"" %
        version,
    )

python_version_repository = repository_rule(
    implementation = _python_version_repository_impl,
    environ = ["HERMETIC_PYTHON_VERSION"],
)
