class PerconaServer < Formula
  desc "Drop-in MySQL replacement"
  homepage "https://www.percona.com"
  url "https://www.percona.com/downloads/Percona-Server-8.0/Percona-Server-8.0.26-16/source/tarball/percona-server-8.0.26-16.tar.gz"
  sha256 "3db3939bd9b317dbcfc1a5638779ff87e755f62d7e6feeb3137876be8bb59d6a"
  license "BSD-3-Clause"

  livecheck do
    url "https://www.percona.com/downloads/Percona-Server-LATEST/"
    regex(/value=.*?Percona-Server[._-]v?(\d+(?:\.\d+)+-\d+)["' >]/i)
  end

  bottle do
    sha256 arm64_big_sur: "014a5ba2286003e56befbed0ba6d7189aa6ce6f13d86a640b55b6a727a9a3cd5"
    sha256 big_sur:       "d5a07dec3cb81121637a91383ec55a921a0bfda07f402004c59687b3a038a3d2"
    sha256 catalina:      "bc8d54fa6d65f7830dac2a7b9a8c1c975067500483b4bed034e89f89fa173d0b"
    sha256 x86_64_linux:  "a5b2f1b1f061e39e3183b6cceba56bc99ab3cf1ab5b7914e628fc7b599a79515"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "icu4c"
  depends_on "libevent"
  depends_on "lz4"
  depends_on "openssl@1.1"
  depends_on "protobuf"
  depends_on "zstd"

  uses_from_macos "curl"
  uses_from_macos "cyrus-sasl"
  uses_from_macos "libedit"
  uses_from_macos "openldap"
  uses_from_macos "zlib"

  on_linux do
    depends_on "patchelf" => :build
    depends_on "readline"

    # Fix build with OpenLDAP 2.5+, which merged libldap_r into libldap
    patch :DATA
  end

  conflicts_with "mariadb", "mysql",
    because: "percona, mariadb, and mysql install the same binaries"

  # https://bugs.mysql.com/bug.php?id=86711
  # https://github.com/Homebrew/homebrew-core/pull/20538
  fails_with :clang do
    build 800
    cause "Wrong inlining with Clang 8.0, see MySQL Bug #86711"
  end

  # https://github.com/percona/percona-server/blob/Percona-Server-#{version}/cmake/boost.cmake
  resource "boost" do
    url "https://boostorg.jfrog.io/artifactory/main/release/1.73.0/source/boost_1_73_0.tar.bz2"
    sha256 "4eb3b8d442b426dc35346235c8733b5ae35ba431690e38c6a8263dce9fcbb402"
  end

  # Fix build on Monterey.
  # Remove with the next version.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/fcbea58e245ea562fbb749bfe6e1ab178fd10025/mysql/monterey.diff"
    sha256 "6709edb2393000bd89acf2d86ad0876bde3b84f46884d3cba7463cd346234f6f"
  end

  def install
    # -DINSTALL_* are relative to `CMAKE_INSTALL_PREFIX` (`prefix`)
    args = %W[
      -DFORCE_INSOURCE_BUILD=1
      -DCOMPILATION_COMMENT=Homebrew
      -DDEFAULT_CHARSET=utf8mb4
      -DDEFAULT_COLLATION=utf8mb4_0900_ai_ci
      -DINSTALL_DOCDIR=share/doc/#{name}
      -DINSTALL_INCLUDEDIR=include/mysql
      -DINSTALL_INFODIR=share/info
      -DINSTALL_MANDIR=share/man
      -DINSTALL_MYSQLSHAREDIR=share/mysql
      -DINSTALL_PLUGINDIR=lib/percona-server/plugin
      -DMYSQL_DATADIR=#{var}/mysql
      -DSYSCONFDIR=#{etc}
      -DENABLED_LOCAL_INFILE=1
      -DWITH_EMBEDDED_SERVER=ON
      -DWITH_INNODB_MEMCACHED=ON
      -DWITH_UNIT_TESTS=OFF
      -DWITH_EDITLINE=system
      -DWITH_ICU=system
      -DWITH_LIBEVENT=system
      -DWITH_LZ4=system
      -DWITH_PROTOBUF=system
      -DWITH_SSL=#{Formula["openssl@1.1"].opt_prefix}
      -DWITH_ZLIB=system
      -DWITH_ZSTD=system
    ]

    if OS.linux?
      args << "-DWITH_LDAP=#{Formula["openldap"].opt_prefix}"
      args << "-DWITH_SASL=#{Formula["cyrus-sasl"].opt_prefix}"
    end

    # MySQL >5.7.x mandates Boost as a requirement to build & has a strict
    # version check in place to ensure it only builds against expected release.
    # This is problematic when Boost releases don't align with MySQL releases.
    (buildpath/"boost").install resource("boost")
    args << "-DWITH_BOOST=#{buildpath}/boost"

    # Percona MyRocks does not compile on macOS
    # https://bugs.launchpad.net/percona-server/+bug/1741639
    args.concat %w[-DWITHOUT_ROCKSDB=1]

    # TokuDB does not compile on macOS
    # https://bugs.launchpad.net/percona-server/+bug/1531446
    args.concat %w[-DWITHOUT_TOKUDB=1]

    system "cmake", ".", *std_cmake_args, *args
    system "make"
    system "make", "install"

    (prefix/"mysql-test").cd do
      test_args = ["--vardir=#{Dir.mktmpdir}"]
      # For Linux, disable failing on warning: "Setting thread 31563 nice to 0 failed"
      # Docker containers lack CAP_SYS_NICE capability by default.
      test_args << "--nowarnings" if OS.linux?
      system "./mysql-test-run.pl", "status", *test_args
    end

    if OS.mac?
      # Remove libssl copies as the binaries use the keg anyway and they create problems for other applications
      rm lib/"libssl.dylib"
      rm lib/"libssl.1.1.dylib"
      rm lib/"libcrypto.1.1.dylib"
      rm lib/"libcrypto.dylib"
    end

    # Remove the tests directory
    rm_rf prefix/"mysql-test"

    # Don't create databases inside of the prefix!
    # See: https://github.com/Homebrew/homebrew/issues/4975
    rm_rf prefix/"data"

    # Fix up the control script and link into bin.
    inreplace "#{prefix}/support-files/mysql.server",
              /^(PATH=".*)(")/,
              "\\1:#{HOMEBREW_PREFIX}/bin\\2"
    bin.install_symlink prefix/"support-files/mysql.server"

    # Install my.cnf that binds to 127.0.0.1 by default
    (buildpath/"my.cnf").write <<~EOS
      # Default Homebrew MySQL server config
      [mysqld]
      # Only allow connections from localhost
      bind-address = 127.0.0.1
    EOS
    etc.install "my.cnf"
  end

  def post_install
    # Make sure the var/mysql directory exists
    (var/"mysql").mkpath

    # Don't initialize database, it clashes when testing other MySQL-like implementations.
    return if ENV["HOMEBREW_GITHUB_ACTIONS"]

    unless (var/"mysql/mysql/user.frm").exist?
      ENV["TMPDIR"] = nil
      system bin/"mysqld", "--initialize-insecure", "--user=#{ENV["USER"]}",
        "--basedir=#{prefix}", "--datadir=#{var}/mysql", "--tmpdir=/tmp"
    end
  end

  def caveats
    s = <<~EOS
      We've installed your MySQL database without a root password. To secure it run:
          mysql_secure_installation
      MySQL is configured to only allow connections from localhost by default
      To connect run:
          mysql -uroot
    EOS
    if (my_cnf = ["/etc/my.cnf", "/etc/mysql/my.cnf"].find { |x| File.exist? x })
      s += <<~EOS
        A "#{my_cnf}" from another install may interfere with a Homebrew-built
        server starting up correctly.
      EOS
    end
    s
  end

  service do
    run [opt_bin/"mysqld_safe", "--datadir", var/"mysql"]
    keep_alive true
    working_dir var/"mysql"
  end

  test do
    (testpath/"mysql").mkpath
    (testpath/"tmp").mkpath
    system bin/"mysqld", "--no-defaults", "--initialize-insecure", "--user=#{ENV["USER"]}",
      "--basedir=#{prefix}", "--datadir=#{testpath}/mysql", "--tmpdir=#{testpath}/tmp"
    port = free_port
    fork do
      system "#{bin}/mysqld", "--no-defaults", "--user=#{ENV["USER"]}",
        "--datadir=#{testpath}/mysql", "--port=#{port}", "--tmpdir=#{testpath}/tmp"
    end
    sleep 5
    assert_match "information_schema",
      shell_output("#{bin}/mysql --port=#{port} --user=root --password= --execute='show databases;'")
    system "#{bin}/mysqladmin", "--port=#{port}", "--user=root", "--password=", "shutdown"
  end
end

__END__
--- a/plugin/auth_ldap/CMakeLists.txt
+++ b/plugin/auth_ldap/CMakeLists.txt
@@ -36,7 +36,7 @@ IF(WITH_LDAP)

   # libler?
   MYSQL_ADD_PLUGIN(authentication_ldap_simple ${ALP_SOURCES_SIMPLE}
-    LINK_LIBRARIES ldap_r MODULE_ONLY MODULE_OUTPUT_NAME "authentication_ldap_simple")
+    LINK_LIBRARIES ldap MODULE_ONLY MODULE_OUTPUT_NAME "authentication_ldap_simple")

   IF(UNIX)
     IF(INSTALL_MYSQLTESTDIR)
