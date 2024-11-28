FROM ghcr.io/cirruslabs/flutter:3.24.4
 
RUN sdkmanager --install "platform-tools" "platforms;android-33"
 
COPY ./android ./app/android
COPY ./assets ./app/assets
COPY ./lib ./app/lib
COPY ./analysis_options.yaml ./app
COPY ./pubspec.yaml ./app
 
RUN cd /app && flutter pub get
 
WORKDIR /app
CMD ["flutter","build","apk","--debug"]