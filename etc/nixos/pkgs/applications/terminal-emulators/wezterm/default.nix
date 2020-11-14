{ stdenv, appimageTools, fetchurl }:

let
  pname = "wezterm";
  version = "nightly";
in
appimageTools.wrapType2 rec {
  name = "${pname}-${version}";

  src = fetchurl {
    name = "${pname}";
    url = "https://github.com/wez/wezterm/releases/download/nightly/WezTerm-nightly-Ubuntu16.04.AppImage";
    sha256 = "0s5i4fb2gvvcq236rc5vpq0rjyzl166ln47bc5fq5c18gjz854zm";
  };

  extraInstallCommands = "mv $out/bin/${name} $out/bin/${pname}";

  meta = with stdenv.lib; {
    description = "A GPU-accelerated cross-platform terminal emulator and multiplexer";
    longDescription = ''
      A GPU-accelerated cross-platform terminal emulator and multiplexer written by @wez and implemented in Rust.
    '';
    homepage = https://wezfurlong.org/wezterm/;
    license = licenses.mit;
    maintainers = with maintainers; [ alexherbo2 ];
    platforms = [ "x86_64-linux" ];
  };
}
