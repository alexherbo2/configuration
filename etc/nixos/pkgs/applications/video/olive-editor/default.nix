{ stdenv, appimageTools, fetchurl }:

let
  pname = "olive-editor";
  version = "nightly";
in
appimageTools.wrapType2 rec {
  name = "${pname}-${version}";

  src = fetchurl {
    name = "${pname}";
    url = "https://olivevideoeditor.org/dl/Olive-3c2da0a9-Linux-x86_64.AppImage";
    sha256 = "j/UvbmzgmJJx4qEUO5/y1VhxYLLWKWXndmiGGmK+l4w=";
  };

  extraInstallCommands = "mv $out/bin/${name} $out/bin/${pname}";

  meta = with stdenv.lib; {
    description = "A free and open-source non-linear video editor";
    longDescription = ''
      A free and open-source non-linear video editor.
    '';
    homepage = https://olivevideoeditor.org;
    license = licenses.gpl3;
    maintainers = with maintainers; [ alexherbo2 ];
    platforms = [ "x86_64-linux" ];
  };
}
