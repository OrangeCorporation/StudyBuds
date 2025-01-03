set dotenv-load
ip := shell('ip address show dev wlp0s20f3 | grep -E -o "inet [0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}" | cut -d" " -f2')

switch-branch branch:
    git checkout {{branch}}

restart-backend:
    docker compose up --build -d --force-recreate backend postgres

checkout branch: (switch-branch branch) restart-backend run-apk

run-apk:
    cd mobile_app && flutter run --dart-define DRIVER=${DRIVER:-false} --dart-define API_URL=${API_URL:-http://{{ip}}:5000}

build-apk-driver:
    cd mobile_app && flutter build apk --debug --dart-define DRIVER=true --dart-define API_URL=${API_URL:-http://{{ip}}:5000}

run-apk-release:
    cd mobile_app && flutter run --release

screenshare:
    scrcpy >/dev/null 2>/dev/null &!

acceptance-tests *args='': build-apk-driver
    docker compose up -d appium
    docker compose exec appium adb install /apk/app-debug.apk
    APPIUM_HOST="{{ip}}" docker compose run --rm --build acceptance-tests {{args}}

generate-schema:
    docker compose run --rm --build generate-schema
