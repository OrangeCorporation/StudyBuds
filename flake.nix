{
  description = "Flutter 3.13.x";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    android-nixpkgs.url = "github:tadfisher/android-nixpkgs";
  };
  outputs = { self, nixpkgs, flake-utils, android-nixpkgs }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          config = {
            android_sdk.accept_license = true;
            allowUnfree = true;
          };
        };
        androidSdk = android-nixpkgs.sdk.${system} (
          sdkPkgs: with sdkPkgs; [
            cmdline-tools-latest
            # build-tools-30-0-3
            build-tools-33-0-1
            # build-tools-33-0-2
            # build-tools-34-0-0
            platform-tools
            emulator
            #patcher-v4
            # platforms-android-28
            # platforms-android-29
            # platforms-android-30
            # platforms-android-31
            # platforms-android-32
            platforms-android-33
            platforms-android-34
          ]
        );
      in
      {
        devShell =
          with pkgs; mkShell {
            ANDROID_HOME = "${androidSdk}/share/android-sdk";
            # ANDROID_SDK_HOME = "${androidSdk}/share/android-sdk";
            # GRADLE_OPTS = "-Dorg.gradle.project.android.aapt2FromMavenOverride=${androidSdk}/share/android-sdk/build-tools/34.0.0/aapt2";
            CHROME_EXECUTABLE = "${pkgs.chromium}/bin/chromium";
            buildInputs = [
              flutter
              androidSdk # The customized SDK that we've made above
              jdk17
            ];
            packages = [
              nodejs
              just
              nodePackages.vega-lite
              yq
              docker
              docker-compose
              ffmpeg
              uv
              scrcpy
              linux-wifi-hotspot
              hostapd
              usql
            ];
            shellHook = ''
              echo ${pkgs.flutter}/packages/flutter_tools/gradle
              if [ ! -w "${pkgs.flutter}/packages/flutter_tools/gradle" ]
              then
                  # sudo chmod o+w "${pkgs.flutter}/packages/flutter_tools/gradle"
              fi
              if [ ! -e /var/run/docker.sock ]
              then
                  # sudo ls
                  # sudo podman system service -t0 unix:///var/run/docker.sock &
              fi
              DOCKER_HOST=unix:///var/run/docker.sock
            '';
          };
      });
}
