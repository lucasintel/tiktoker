# TikToker

[![Built with Crystal 0.36.1](https://img.shields.io/badge/Crystal-1.0.0-%23333333)](https://crystal-lang.org/)
[![GitHub release](https://img.shields.io/github/release/kandayo/tiktoker.svg?label=Release)](https://github.com/kandayo/tiktoker/releases)
[![CI](https://github.com/kandayo/tiktoker/actions/workflows/ci.yml/badge.svg)](https://github.com/kandayo/tiktoker/actions/workflows/ci.yml)
[![Documentation](https://github.com/kandayo/tiktoker/actions/workflows/docs.yml/badge.svg)](https://github.com/kandayo/tiktoker/actions/workflows/docs.yml)

TikToker is a **command-line client for TikTok**. It allows you to search and
browse users from the terminal, and to download videos and its metadata from an
user profile or from a hashtag.

For now, you'll have to spin up a signature server, used to sign requests to
the Tiktok API.

See [**TikTok Passport**](https://github.com/kandayo/tiktok-passport).

## Index

- [Features](#features)
- [Disclaimer](#disclaimer)
- [Installation](#installation)
  - [Pre-built - Recommended](#pre-built--recommended)
  - [From source](#from-source)
- [Flags](#flags)
  - [Incremental sync](#incremental-sync)
  - [Verbosity](#verbosity)
  - [Cronjob mode](#cronjob-mode)
  - [Error handling](#error-handling)
- [Commands](#commands)
  - [Find user](#find-user)
  - [Search user](#search-user)
  - [Download user profile](#download-user-profile)
  - [Download from batch file](#download-from-batch-file)
- [As a library](#as-a-library)
  - [Installation as a shard](#installation-as-a-shard)
  - [Configuration](#configuration)
  - [Iterators](#iterators)
  - [Client](#client)
     - [Manually building a request](#manually-building-a-request)
     - [Manually signing a request](#manually-signing-a-request)
- [Development](#development)
  - [Dockerized environment](#dockerized-environment)
  - [Local](#local)
- [Contributing](#contributing)
- [Contributors](#contributors)
- [License](#license)

## Features

- Download public and private profiles.
- Download hashtags.
- **Built with archivists in mind: incremental sync.**
- Automatically resumes previously-interrupted download iterations to prevent rate limiting.
- JSON metadata is stored alongside the video.
- Batch file, cronjob friendly.

## Disclaimer

This lib is in no way affiliated with, authorized, maintained or endorsed by
TikTok or any of its affiliates or subsidiaries.

This is purely an educational proof of concept.

## Installation

### Pre-built - Recommended

Just download the latest release for your platform [here](https://github.com/kandayo/tiktoker/releases).
Then move the binary to your PATH, or just use it right away.

### From source

It only takes a few seconds to compile it yourself. It's not rocket science.

Build dependencies:
 - Crystal language, https://crystal-lang.org/install

```bash
$ git clone https://github.com/kandayo/tiktoker
$ cd tiktoker
$ shards build --release --ignore-crystal-version
$ ./bin/tiktoker --help
```

Then move the binary to your PATH, or just use it right away.

## Flags

### Incremental sync

If `--fast-update` (or `-f`) is given, TikToker stops when arriving at the
first already downloaded video. This flag is recommended when you use TikToker
to update your personal archive.

This concept was inspired by Instaloader.

```
$ tiktoker download user charlidamelio --fast-update

Collecting videos from user feed  -- username: charlidamelio
 + Charli D’amelio - 000002.mp4 [========================] 11.1 MB | 100%
 + Charli D’amelio - 000001.mp4; exists
✅ Charli D’amelio in sync!
```

### Verbosity

If `--verbose` (or `-V`) is given, TikToker will print debug information for
each operation. You can use it to inspect request/response params, headers and
body.

### Cronjob mode

If `--quiet` (or `-q`) is given, TikTok will not produce any output (except
error messages). The download progress bar is disabled as well. This makes
TikToker suitable as a cron job.

### Error handling

Network errors are gracefully retried following a randomized exponential
backoff technique. This behaviour is customizable.

```
--retry-attempts [attempts; default: 10]
  Maximum number of retry attempts until a request is aborted.

--connect-timeout [seconds; default: 5]
  Timeout waiting for TikTok server connection to open in seconds.

--write-timeout [seconds; default: 5]
  Timeout when waiting for TikTok server to receive data.

--read-timeout [seconds; default: 5]
  Timeout when waiting for TikTok server to return data.
```

## Commands

See `tiktoker --help`. For more examples, please refer to the [**documentation**](https://absolab.xyz/tiktoker).

### Find user

*Usage: tiktoker user [username] [--feed]*

```
$ tiktoker user charlidamelio

┌───────────────────────────────────────────────────────────────────────┐
│ charli d’amelio [Verified]                                            │
│ @charlidamelio                                                        │
├─────────────────┬─────────────────┬─────────────────┬─────────────────┤
│ 1.21K Following │ 114M Followers  │ 9.2B Likes      │ 1763 Videos     │
└─────────────────┴─────────────────┴─────────────────┴─────────────────┘
┌─────────────────────────────────────────────────────────────────┬───────┬───────┬──────────┐
│ URL                                                             │ Views │ Likes │ Comments │
├─────────────────────────────────────────────────────────────────┼───────┼───────┼──────────┤
│ https://www.tiktok.com/@charlidamelio/video/6957450991809662214 │ 8.8M  │ 2.5M  │ 188K     │
│ https://www.tiktok.com/@charlidamelio/video/6957004076668177670 │ 17.3M │ 3.7M  │ 457K     │
│ https://www.tiktok.com/@charlidamelio/video/6956671135194844422 │ 14.2M │ 2.4M  │ 77.0K    │
│ https://www.tiktok.com/@charlidamelio/video/6956651282199284997 │ 22.5M │ 4.5M  │ 78.1K    │
│ https://www.tiktok.com/@charlidamelio/video/6956256557197790469 │ 20.3M │ 3.8M  │ 111K     │
│ https://www.tiktok.com/@charlidamelio/video/6955937279537990918 │ 18.2M │ 3.1M  │ 94.0K    │
└─────────────────────────────────────────────────────────────────┴───────┴───────┴──────────┘
[...]
```

You can also get more specific information about an user.

```
SecUID           : MS4wLjABAAAA-VASjiXTh7wDDyXvjk10VFhMWUAoxr8bgfO1kAL1-9s
ID               : 5831967
Avatar           : https://p16-sign-va.tiktokcdn.com/musically-maliva-obj/0a0242e5f906bf9301f859c568b5ecc4~c5_1080x1080.jpeg
Registered at    : Saturday, 14 Nov 2015 12:57
Comment settings : Everyone
Duet settings    : Everyone
Stitch settings  : Everyone
[...]
```

### Search user

*Usage: tiktoker search user [criteria] [--cursor]*

```
$ tiktoker search user charlidamelio

┌───────────────────┬───────────────────────────────┬───────────┬──────────┐
│ Username          │ Nickname                      │ Followers │ Verified │
├───────────────────┼───────────────────────────────┼───────────┼──────────┤
│ charlidamelio     │ charli d’amelio               │ 113.9M    │ true     │
│ augustrush        │ charli d’amelio’s Adopted Bro │ 1.5M      │ true     │
│ charlidamelio6650 │ Charli Damelio                │ 502.2K    │ false    │
│ charlidameilo     │ charli d’amelio               │ 333.2K    │ false    │
│ cactiboy          │ Charli D’amelio               │ 208.1K    │ false    │
│ blidmor           │ charlidamelio                 │ 154.3K    │ false    │
└───────────────────┴───────────────────────────────┴───────────┴──────────┘
[...]
```

### Download user profile

*Usage: tiktoker download user [username or SecUID] [--fast-update] [--cursor]*

```
$ tiktoker download user charlidamelio

Collecting videos from user feed  -- username: charlidamelio
 + Charli D’amelio - 6957004076668177670.mp4 [========================] 11.1 MB | 100%
 + Charli D’amelio - 6956671135194844422.mp4 [========================] 19.2 MB | 100%
 + Charli D’amelio - 6957004076668177670.mp4 [========================] 14.1 MB | 100%
 + Charli D’amelio - 6956671135194844422.mp4 [========================] 23.3 MB | 100%
   [...]
```

### Download from batch file

*Usage: tiktoker download batch [file] [--fast-update]*

If `--batch-file <file.txt>` (or `-a`) is given, TikToker will read *file.txt*
expecting @usernames and SecUIDs to download, one identifier per line. Lines
starting with an `#` or empty lines are considered as comments and ignored.

Usernames must be prefixed with an `@`, e.g. `@username`, `@charlidamelio`.

SecUIDs must not be prefixed with an `@`, e.g. `MS4wLjABA[...]`.

```bash
$ cat batch.txt
 ~> # Comment (ignored)
 ~> MS4wLjABAAAA-VASjiXTh7wDDyXvjk10VFhMWUAoxr8bgfO1kAL1-9s
 ~> @charlidamelio # Inline comments are also allowed.

$ tiktoker download batch file.txt
```

## As a library

### Installation as a shard

1. Add the dependency to your `shard.yml`:

   ```yaml
   dependencies:
     tiktoker:
       github: kandayo/tiktoker
   ```

2. Run `shards install --ignore-crystal-version`.

### Configuration

```cr
require "tiktoker"

TikToker.config.with do |config|
  config.signature_server_url = "http://passport.internal.docker"
  config.retry_attempts = 0
end
```

### Iterators

A iterator allows transparently iterating a resource by page.

```cr
iterator = TikToker::ProfileIterator.new(SecUID, cursor)

iterator.next # => Page 1
iterator.next # => Page 2
iterator.next # => Iterator::Stop
```

Most of the time, what you really want is to iterate through the posts without
having to worry about pagination.

```cr
iterator = TikToker::ProfileIterator.new(SecUID, cursor)

iterator.each_post do |post|
  post # => TikTok::Post
end
```

### Client

For more examples, please refer to the [**documentation**](https://absolab.xyz/tiktoker).

```cr
TikToker.find_user(username)               # => TikTok::UserProfile
TikToker.find_user_secuid(username)        # => "MS4wLjABAAAA-VASjiXTh7wDDyXvjk10VFhMWUAoxr8bgfO1kAL1-9s"
TikToker.user_profile_feed(SecUID, cursor) # => TikTok::PostCollection
TikToker.search_user(term, cursor)         # => TikTok::SearchResult
```

### Manually building a request

```cr
request = TikToker::RequestBuilder.search_user(term, cursor)

request        # => TikToker::Request
request.build  # => "https://m.tiktok.com/api/search/user/full?[...]"
```

### Manually signing a request

```cr
TikToker::RequestSigner.sign(request)
```

You can use your own signer backend. Make sure to define a `#call` instance
method and inherit from `RequestSigner::Backend`.

```cr
class CustomSigner < TikToker::RequestSigner::Backend
  def initialize(@request : TikToker::Request)
  end

  def call : TikToker::SignedRequest
    # ...
  end
end

TikToker::RequestSigner.sign(request, backend: CustomSigner)
```

## Development

### Dockerized environment

Dependencies:

 - Docker
 - Docker compose
 - Dip, https://github.com/bibendi/dip

Provision the project by running `dip provision` and then use `dip crystal`,
`dip spec` or `dip runner` to interact with the dockerized development
environment.

### Local

If you prefer developing on your local machine, make sure you have all
dependencies installed and running.

## Contributing

1. Fork it (<https://github.com/kandayo/tiktoker/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [kandayo](https://github.com/kandayo) - creator and maintainer

## License

The lib is available as open source under the terms of the MIT License.
