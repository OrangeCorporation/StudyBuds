check: lint format-check test

test: frontend-test backend-test test-test admin-test
format: frontend-format backend-format test-format admin-format
lint: frontend-lint backend-lint test-lint admin-lint
format-check: frontend-format-check backend-format-check test-format-check admin-format-check

frontend-test:
    cd frontend && flutter test

frontend-format:
    cd frontend && dart format lib test

frontend-format-check:
    cd frontend && dart format --set-exit-if-changed -onone lib test

frontend-lint:
    cd frontend && dart analyze

backend-test:
    cd backend && pnpm test

backend-format:
    cd backend && pnpm exec prettier -c src test

backend-format-check:
    cd backend && pnpm exec prettier --write src test

backend-lint:
    cd backend && pnpm exec eslint

test-test:
    cd test && pnpm exec cucumber-js --require-module ts-node/register --require 'steps/*.ts'

test-format:
    cd test && pnpm exec prettier -c features steps

test-format-check:
    cd test && pnpm exec prettier --write features steps

test-lint:
    cd test && pnpm exec eslint

admin-test:
    cd admin && pnpm test:unit run

admin-lint:
    cd admin && pnpm exec eslint

admin-format:
    cd backend && pnpm exec prettier -c src test

admin-format-check:
    cd backend && pnpm exec prettier --write src test

emulator:
    docker run --rm -d -p 6080:6080 -p 4723:4723 -e EMULATOR_DEVICE="Samsung Galaxy S10" -e WEB_VNC=true -e APPIUM=true --volume ./frontend/build/app/outputs/apk/debug:/apk:ro --device /dev/kvm --name android-container budtmo/docker-android:emulator_11.0

emulator-stop:
    docker stop android-container

build-apk:
    cd mobile_app && flutter build apk --dart-define API_URL=$API_URL

install-apk: build-apk
    adb install mobile_app/build/app/outputs/apk/release/app-release.apk

screenshare:
    scrcpy

hotspot:
    sudo $(which create_ap) wlp0s20f3 wlp0s20f3 islandwifi island01 --freq-band 2.4 -g 192.168.137.1 --no-dnsmasq --daemon && sleep 5 && sudo dnsmasq --interface=ap0 --bind-interfaces --dhcp-range=192.168.137.2,192.168.137.255 -z -H hosts

stop-hotspot:
    sudo pkill create_ap && sudo pkill dnsmasq
