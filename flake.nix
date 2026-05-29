# flake.nix
# =========
#
# Copying
# -------
#
# Copyright (c) 2025 Thrasibule.Mx - All Rights Reserved
#
# Unauthorized copying of this file, via any medium is strictly prohibited.
# Proprietary and confidential.
#
{
  description = "Thrasibule.Mx development environment.";

  inputs = {
    # universe-config, general user and system environments configuration.
    universe = {
      url = "git+https://github.com/Thrasibule-Mx/universe-config.git?ref=main";
    };
  };

  outputs = inputs: let
    allInputs = inputs.universe.inputs // inputs;

    lib = allInputs.snowfall-lib.mkLib {
      inputs = allInputs;

      src = ./.;

      snowfall = {
        namespace = "thrasibule";

        meta = {
          title = "Thrasibule.Mx development environment";
          name = "thrasibule";
          license = "Proprietary";
        };
      };
    };
  in
    with allInputs;
      lib.mkFlake {
        inherit (universe) checks devShells formatter;
        supportedSystems = ["aarch64-darwin" "x86_64-linux"];
      };
}
