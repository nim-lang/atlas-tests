import std/[os, strutils]

import wsGenerated
import wsIntegration
import downloadTestRepos

runWsGenerated()
runWsIntegration()

let zipfile = "atlas-tests.zip"
exec "zip -ru $1 atlas-tests/ws_generated/ atlas-tests/ws_integration/" % [zipfile]
