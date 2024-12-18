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

system-docker:
    if [[ ! -e /var/run/docker.sock ]]; then sudo sh -c "$(which dockerd) &! sleep 1 || echo started && chmod 777 /var/run/docker.sock"; fi

emulator-backend: system-docker
    unset DOCKER_HOST && docker compose up -d backend postgres

emulator: emulator-backend
    unset DOCKER_HOST && docker compose down -v emulator && docker compose up -d emulator

switch-branch branch:
    git checkout {{branch}}

restart-backend:
    docker compose up --build -d --force-recreate backend postgres

checkout branch: (switch-branch branch) restart-backend run-apk

run-apk:
    cd mobile_app && flutter run --dart-define-from-file ../.env

run-apk-release:
    cd mobile_app && flutter run --release --dart-define-from-file ../.env

screenshare:
    scrcpy >/dev/null 2>/dev/null &!

hotspot:
    sudo $(which create_ap) wlp0s20f3 wlp0s20f3 islandwifi island01 --freq-band 2.4 -g 192.168.137.1 --no-dnsmasq --daemon && sleep 5 && sudo dnsmasq --interface=ap0 --bind-interfaces --dhcp-range=192.168.137.2,192.168.137.255 -z -H hosts

stop-hotspot:
    sudo pkill create_ap && sudo pkill dnsmasq

acceptance-test *args='':
    unset DOCKER_HOST && docker compose up -d --force-recreate postgres && docker compose run --rm --build acceptance-tests {{args}}

models:
    docker compose up -d --force-recreate postgres && docker compose run --rm --build backend-models

appium-server:
    if ! pgrep appium; then (cd test && npx appium > /tmp/appium 2>&1 )&! echo "Started appium" || echo "Started appium"; fi

physical-acceptance-test *args='': appium-server 
    docker compose up -d --force-recreate postgres && cd test && npx cucumber-js {{args}}

