import std/[os, strutils]

import wsGenerated
import wsIntegration
import downloadTestRepos

runWsGenerated()
runWsIntegration()

withDir "atlas-tests":
  let zipfile = "atlas-tests.zip"
  exec "zip -ru $1 ws_generated/ ws_integration/" % [zipfile]
