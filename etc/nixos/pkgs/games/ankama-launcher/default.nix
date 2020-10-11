{ stdenv, appimageTools, fetchurl }:

let
  pname = "ankama-launcher";
  version = "2.0";
in
appimageTools.wrapType2 rec {
  name = "${pname}-${version}";

  src = fetchurl {
    name = "${pname}";
    url = "https://launcher.cdn.ankama.com/installers/production/Ankama%20Launcher-Setup-x86_64.AppImage";
    sha256 = "17xrrcgrf1jnpy6717223ca036yzfcihnrspl1wm5jc51vc7k7sw";
  };

  extraInstallCommands = "mv $out/bin/${name} $out/bin/${pname}";

  meta = with stdenv.lib; {
    description = "Ankama Launcher";
    longDescription = ''
      Ankama Launcher
    '';
    homepage = https://ankama.com;
    license = licenses.unfree;
    maintainers = with maintainers; [ alexherbo2 ];
    platforms = [ "x86_64-linux" ];
  };
}
