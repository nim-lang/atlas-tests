# atlas-tests
Persistent Atlas tests.

To generate an update atlas-tests.zip run:

    nim atlasTestsCreate

This will create a couple of folders needed for testing Atlas's workspaces:

    atlas-tests/ws_generate/buildGraph
    atlas-tests/ws_generate/buildGraphNoGitTags
    atlas-tests/ws_generate/manifest.txt
    atlas-tests/ws_generate/<org>/<repo>...
    atlas-tests/ws_generate/readme.md
    atlas-tests/ws_ingtegration/manifest.txt
    atlas-tests/ws_ingtegration/<org>/<repo>...

The file `atlas-tests/ws_generate/readme.md` should not be modified as it's contents are used as a sanity check in Atlas `tester.nim`.
