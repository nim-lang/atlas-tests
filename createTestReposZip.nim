import std/[os, strutils]

import wsGenerated
import wsIntegration
import downloadTestRepos

createDir("atlas-tests")
runWsGenerated()
runWsIntegration()

exec("cp atlas_tests.nimble atlas-tests/atlas_tests.nimble")
exec("cat atlas-tests/*/*-manifest.txt > atlas-tests/manifest.txt")
exec("shasum atlas-tests/manifest.txt > atlas-tests/manifest.shasum")
let zipfile = "atlas-tests.zip"
exec "zip -ru $1 atlas-tests/atlas_tests.nimble atlas-tests/manifest.txt atlas-tests/manifest.shasum atlas-tests/ws_generated/ atlas-tests/ws_integration/" % [zipfile]
