# This test runs podman and checks if simple container starts

import ./make-test-python.nix (
  { pkgs, lib, ... }: {
    name = "podman";
    meta = {
      maintainers = lib.teams.podman.members;
    };

    nodes = {
      podman =
        { pkgs, ... }:
        {
          virtualisation.podman.enable = true;
          virtualisation.containers.users = [
            "alice"
          ];

          users.users.alice = {
            isNormalUser = true;
            home = "/home/alice";
            description = "Alice Foobar";
          };

        };
    };

    testScript = ''
      import shlex


      def su_cmd(cmd):
          cmd = shlex.quote(cmd)
          return f"su alice -l -c {cmd}"


      podman.wait_for_unit("sockets.target")
      start_all()


      with subtest("Run container as root"):
          podman.succeed("tar cv --files-from /dev/null | podman import - scratchimg")
          podman.succeed(
              "podman run -d --name=sleeping -v /nix/store:/nix/store -v /run/current-system/sw/bin:/bin scratchimg /bin/sleep 10"
          )
          podman.succeed("podman ps | grep sleeping")
          podman.succeed("podman stop sleeping")

      with subtest("Run container rootless"):
          podman.succeed(su_cmd("tar cv --files-from /dev/null | podman import - scratchimg"))
          podman.succeed(
              su_cmd(
                  "podman run -d --name=sleeping -v /nix/store:/nix/store -v /run/current-system/sw/bin:/bin scratchimg /bin/sleep 10"
              )
          )
          podman.succeed(su_cmd("podman ps | grep sleeping"))
          podman.succeed(su_cmd("podman stop sleeping"))
    '';
  }
)
