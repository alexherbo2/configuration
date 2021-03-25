# surf
# https://surf.suckless.org
# https://github.com/NixOS/nixpkgs/blob/master/pkgs/applications/networking/browsers/surf/default.nix

{ lib, stdenv, fetchgit
, pkg-config, wrapGAppsHook
, glib, glib-networking, gsettings-desktop-schemas, libsoup, webkitgtk, gcr
, xorg, dmenu, findutils, gnused, coreutils
, patches ? null
}:

stdenv.mkDerivation rec {
  name = "surf";

  src = fetchgit {
    url = https://git.suckless.org/surf;
    rev = "d068a3878b6b9f2841a49cd7948cdf9d62b55585";
    sha256 = "0pjsv2q8c74sdmqsalym8wa2lv55lj4pd36miam5wd12769xw68m";
  };

  nativeBuildInputs = [ pkg-config wrapGAppsHook ];
  buildInputs = [ glib glib-networking gsettings-desktop-schemas libsoup webkitgtk gcr ];

  inherit patches;

  installFlags = [ "PREFIX=$(out)" ];

  # Add run-time dependencies to PATH.  Append them to PATH, so the user can
  # override the dependencies with their own PATH.
  preFixup = let
    depsPath = lib.makeBinPath [ xorg.xprop dmenu findutils gnused coreutils ];
  in ''
    gappsWrapperArgs+=(
      --suffix PATH : ${depsPath}
    )
  '';

  meta = with lib; {
    description = "A simple web browser based on WebKitGTK";
    longDescription = ''
      surf is a simple web browser based on WebKitGTK.
      It is able to display websites and follow links.
      It supports the XEmbed protocol which makes it possible to embed it in another application.
      Furthermore, one can point surf to another URI by setting its XProperties.
    '';
    homepage = https://surf.suckless.org;
    license = licenses.mit;
    maintainers = with maintainers; [ alexherbo2 ];
    platforms = webkitgtk.meta.platforms;
  };
}
