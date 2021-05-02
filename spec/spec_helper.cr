require "spec"
require "webmock"

require "../src/tiktoker"
require "./support/*"

include ProfileFeedMock
include FixtureHelpers
include TempDirHelpers

# Clears all Webmock stubs and sets `Webmock.allow_net_connect` to false.
Spec.before_each(&->WebMock.reset)
