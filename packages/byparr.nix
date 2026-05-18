{
  sources,
  pkgs,
  lib,
  ...
}:
let
  inherit (pkgs) python314 makeWrapper;
  inherit (pkgs.stdenv) mkDerivation;
  inherit (lib) composeManyExtensions getExe';

  pyproject-nix = import sources."pyproject.nix" { inherit lib; };
  uv2nix = import sources.uv2nix { inherit pyproject-nix lib; };
  pyproject-build-systems = import sources.build-system-pkgs { inherit pyproject-nix uv2nix lib; };

  python = python314;

  pythonBase = pkgs.callPackage pyproject-nix.build.packages {
    inherit python;
  };

  workspace = uv2nix.lib.workspace.loadWorkspace { workspaceRoot = sources.Byparr.outPath; };

  overlay = workspace.mkPyprojectOverlay {
    sourcePreference = "wheel";
  };

  pathFixOverride = _final: prev: {
    camoufox = (
      prev.camoufox.overrideAttrs (
        oldAttrs: {
          postInstall = (oldAttrs.postInstall or "") + ''
            substituteInPlace $out/${python.sitePackages}/camoufox/locale.py --replace-fail \
                "MMDB_FILE = LOCAL_DATA / 'GeoLite2-City.mmdb'" \
                "import os; from pathlib import Path; MMDB_FILE = Path(os.path.expanduser('~/.cache/Byparr/GeoLite2-City.mmdb')); os.makedirs(MMDB_FILE.parent, exist_ok=True)"
          '';
        }
      )
    );

    playwright-captcha = (
      prev.playwright-captcha.overrideAttrs (
        oldAttrs: {
          postInstall = (oldAttrs.postInstall or "") + ''
            substituteInPlace $out/${python.sitePackages}/playwright_captcha/utils/camoufox_add_init_script/add_init_script.py --replace-fail \
                "scripts_dir = os.path.join(addon_path, 'scripts')" \
                "scripts_dir = Path(os.path.expanduser('~/.cache/Byparr/scripts/')); os.makedirs(scripts_dir.parent, exist_ok=True)"
          '';
        }
      )
    );
  };

  pythonSet = pythonBase.overrideScope (composeManyExtensions [
    pyproject-build-systems.overlays.wheel
    overlay
    pathFixOverride
  ]);

  venv = pythonSet.mkVirtualEnv "Byparr-env" workspace.deps.default;
in
{
  # Temporary method until I can find the patchElf equivalent inside of camoufoxOverride
  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      gtk3
      alsa-lib
      libX11
    ];
  };

  nixpkgs.overlays = [
    (_final: _prev: {
      byparr = mkDerivation {
        pname = "Byparr";
        version = "0.1.0";
        src = sources.Byparr.outPath;

        nativeBuildInputs = [ makeWrapper ];

        installPhase = ''
          mkdir -p $out/bin

          makeWrapper ${getExe' venv "python"} $out/bin/Byparr \
            --add-flags ${sources.Byparr.outPath}/main.py \
            --prefix PYTHONPATH : "${sources.Byparr.outPath}"
        '';

        meta.mainProgram = "Byparr";
      };
    })
  ];
}
