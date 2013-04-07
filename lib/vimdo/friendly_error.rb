module VimDo
  def self.with_friendly_errors
    yield
  rescue VimDo::VimDoError => e
    VimDo.ui.error e.message, :wrap => true
    VimDo.ui.trace e
    exit e.status_code
  rescue LoadError => e
    raise e unless e.message =~ /cannot load such file -- openssl|openssl.so|libcrypto.so/
    VimDo.ui.error "\nCould not load OpenSSL."
    VimDo.ui.warn <<-WARN, :wrap => true
      You must recompile Ruby with OpenSSL support or change the sources in your \
      Gemfile from 'https' to 'http'. Instructions for compiling with OpenSSL \
      using RVM are available at rvm.io/packages/openssl.
    WARN
    VimDo.ui.trace e
    exit 1
  rescue Interrupt => e
    VimDo.ui.error "\nQuitting..."
    VimDo.ui.trace e
    exit 1
  rescue SystemExit => e
    exit e.status
  rescue Exception => e
    VimDo.ui.error <<-ERR, :wrap => true
      Unfortunately, a fatal error has occurred. Please see the VimDo \
      troubleshooting documentation or raise an issue in github. Thanks!
    ERR
    raise e
  end
end
