require "language/node"

class Ncc < Formula
  desc "Compile a Node.js project into a single file"
  homepage "https://github.com/vercel/ncc"
  url "https://registry.npmjs.org/@vercel/ncc/-/ncc-0.33.1.tgz"
  sha256 "3fcd1d928a5a2282d45083cc042cb49de7ea48bf5a8e3c5cfa2b2899f1ae4330"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "b77752e502789b9102fd3379598011f1cccefcb0b1d9e341049c70c8b5566cd8"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"input.js").write <<~EOS
      function component() {
        const element = document.createElement('div');
        element.innerHTML = 'Hello' + ' ' + 'webpack';
        return element;
      }

      document.body.appendChild(component());
    EOS

    system bin/"ncc", "build", "input.js", "-o", "dist"
    assert_match "document.createElement", File.read("dist/index.js")
  end
end
