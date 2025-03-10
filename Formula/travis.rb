class Travis < Formula
  desc "Command-line client for Travis CI"
  homepage "https://github.com/travis-ci/travis.rb/"
  url "https://github.com/travis-ci/travis.rb/archive/v1.11.0.tar.gz"
  sha256 "76cb0821aeb60e3e302932365dd437a393674de80e02972873bf3e511af564ca"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "c958a67e6b4dfdbfaaebf46cd0969cc50acb2a6858c01cc20b261b4d0b674525"
    sha256 cellar: :any,                 arm64_big_sur:  "3afffdb6a8cff070d4e0bc7600b385b376211ae322edd7a4dd409ce7c80cefd8"
    sha256 cellar: :any,                 monterey:       "d1399bdcdcda8d29168d7025c2e7d0a982bd624c32e5bfe2ce2e1a7120da9365"
    sha256 cellar: :any,                 big_sur:        "eaacba9560a492f137f52667dd9cd4e45eef82916bd42084b03b4837048d64b3"
    sha256 cellar: :any,                 catalina:       "34ab31ccc944b833995eebb21e3511dd900fb91787ec692a38d7fc0e47e1623f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8a2ba763f98cd49975b49331e0db0b15dc3d05e3c56922356e0dd0a8f413f434"
  end

  depends_on "pkg-config" => :build
  depends_on "ruby"

  if MacOS.version < :catalina
    depends_on "libffi"
  else
    uses_from_macos "libffi"
  end

  resource "activesupport" do
    url "https://rubygems.org/gems/activesupport-5.2.4.4.gem"
    sha256 "8d3ddc9b86431f4e2df3c641c2f534c4c244621e57a7efa4f98e94a38198f636"
  end

  resource "concurrent-ruby" do
    url "https://rubygems.org/gems/concurrent-ruby-1.1.7.gem"
    sha256 "ff4befc88d522ccb2109596da26309f4b0b041683ca62d3cb903b313e1caddee"
  end

  resource "i18n" do
    url "https://rubygems.org/gems/i18n-1.8.5.gem"
    sha256 "f3bb7c9e89804cde8264b89f47f4746527f7293e7b5e4c74e66a9b70cfe97a94"
  end

  resource "minitest" do
    url "https://rubygems.org/gems/minitest-5.14.2.gem"
    sha256 "9b401338e287c50cd2354353b4b781d3766d863cae413b2a1bf585d237131e9c"
  end

  resource "tzinfo" do
    url "https://rubygems.org/gems/tzinfo-1.2.7.gem"
    sha256 "3945d8a57c62a59e691d527ae4daaf562d6e07a3c0d032876c6b066e108072c4"
  end

  resource "addressable" do
    url "https://rubygems.org/gems/addressable-2.7.0.gem"
    sha256 "5e9b62fe1239091ea9b2893cd00ffe1bcbdd9371f4e1d35fac595c98c5856cbb"
  end

  resource "public_suffix" do
    url "https://rubygems.org/gems/public_suffix-4.0.6.gem"
    sha256 "a99967c7b2d1d2eb00e1142e60de06a1a6471e82af574b330e9af375e87c0cf7"
  end

  resource "diff-lcs" do
    url "https://rubygems.org/gems/diff-lcs-1.4.4.gem"
    sha256 "bf3a658875f70c1467fe7a3b302b795f074c84b28db6e4a2bd6b1ad6d12a2255"
  end

  resource "ruby2_keywords" do
    url "https://rubygems.org/gems/ruby2_keywords-0.0.2.gem"
    sha256 "145c91edd2ef4c509403328ed05ae4387a8841b7a3ae93679e71c0fd3860ec9e"
  end

  resource "faraday" do
    url "https://rubygems.org/gems/faraday-1.1.0.gem"
    sha256 "6578c3ca23d2f63abf436031ca89b47ffe2c7b0d7952928ba079c75b22bfaa99"
  end

  resource "faraday_middleware" do
    url "https://rubygems.org/gems/faraday_middleware-1.0.0.gem"
    sha256 "19e808539681bbf2e65df30dfbe27bb402bde916a1dceb4c7496dbe8de14334a"
  end

  # required by typhoeus
  resource "ffi" do
    url "https://rubygems.org/gems/ffi-1.12.2.gem"
    sha256 "048ad01d5369f67075f943c16f1058f10663af2a66eedb87d921316ba1828e82"
  end

  resource "gh" do
    url "https://rubygems.org/gems/gh-0.18.0.gem"
    sha256 "eb93f18a88db3ba92eb888610fc53fae731d9dacfe55922b58cc3f3aca776a47"
  end

  resource "highline" do
    url "https://rubygems.org/gems/highline-2.0.3.gem"
    sha256 "2ddd5c127d4692721486f91737307236fe005352d12a4202e26c48614f719479"
  end

  resource "json" do
    url "https://rubygems.org/gems/json-2.3.1.gem"
    sha256 "3f9ebb42fcd46ec3ecad16c89c7b174dc539bdd353610c39c15aecca1d570e95"
  end

  resource "json_pure" do
    url "https://rubygems.org/gems/json_pure-2.3.1.gem"
    sha256 "9d06adb6c324d54e9fd363a55d5cdd3ce030e26cba189d82dc6872ec268fff02"
  end

  # launchy v2.5.0 requires ruby > 2.4.0
  resource "launchy" do
    url "https://rubygems.org/gems/launchy-2.4.3.gem"
    sha256 "42f52ce12c6fe079bac8a804c66522a0eefe176b845a62df829defe0e37214a4"
  end

  resource "multi_json" do
    url "https://rubygems.org/gems/multi_json-1.15.0.gem"
    sha256 "1fd04138b6e4a90017e8d1b804c039031399866ff3fbabb7822aea367c78615d"
  end

  resource "multipart-post" do
    url "https://rubygems.org/gems/multipart-post-2.1.1.gem"
    sha256 "d2dd7aa957650e0d99e0513cd388401b069f09528441b87d884609c8e94ffcfd"
  end

  resource "net-http-persistent" do
    url "https://rubygems.org/gems/net-http-persistent-2.9.4.gem"
    sha256 "24274d207ffe66222ef70c78a052c7ea6e66b4ff21e2e8a99e3335d095822ef9"
  end

  resource "net-http-pipeline" do
    url "https://rubygems.org/gems/net-http-pipeline-1.0.1.gem"
    sha256 "6923ce2f28bfde589a9f385e999395eead48ccfe4376d4a85d9a77e8c7f0b22f"
  end

  resource "pusher-client" do
    url "https://rubygems.org/gems/pusher-client-0.6.2.gem"
    sha256 "c405c931090e126c056d99f6b69a01b1bcb6cbfdde02389c93e7d547c6efd5a3"
  end

  resource "thread_safe" do
    url "https://rubygems.org/gems/thread_safe-0.3.6.gem"
    sha256 "9ed7072821b51c57e8d6b7011a8e282e25aeea3a4065eab326e43f66f063b05a"
  end

  resource "typhoeus" do
    url "https://rubygems.org/gems/typhoeus-0.8.0.gem"
    sha256 "28b7cf3c7d915a06d412bddab445df94ab725252009aa409f5ea41ab6577a30f"
  end

  resource "websocket" do
    url "https://rubygems.org/gems/websocket-1.2.8.gem"
    sha256 "1d8155c1cdaab8e8e72587a60e08423c9dd84ee44e4e827358ce3d4c2ccb2138"
  end

  def install
    ENV["GEM_HOME"] = libexec
    # gem issue on Mojave
    ENV["SDKROOT"] = MacOS.sdk_path if MacOS.version == :mojave

    resources.each do |r|
      r.fetch
      system "gem", "install", r.cached_download, "--ignore-dependencies",
             "--no-document", "--install-dir", libexec
    end
    system "gem", "build", "travis.gemspec"
    system "gem", "install", "--ignore-dependencies", "travis-#{version}.gem"
    bin.install libexec/"bin/travis"
    (libexec/"gems/travis-#{version}/assets/notifications/Travis CI.app").rmtree
    bin.env_script_all_files(libexec/"bin", GEM_HOME: ENV["GEM_HOME"])
  end

  test do
    (testpath/".travis.yml").write <<~EOS
      language: ruby

      matrix:
        include:
          - os: osx
            rvm: system
    EOS
    output = shell_output("#{bin}/travis lint #{testpath}/.travis.yml")
    assert_match "valid", output
    output = shell_output("#{bin}/travis init 2>&1", 1)
    assert_match "Can't figure out GitHub repo name", output
  end
end
