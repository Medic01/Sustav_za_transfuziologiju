# variables
AVD_MANAGER = /home/antonio/Android/Sdk/emulator/emulator
AVD_NAME = Pixel_3a_API_34_extension_level_7_x86_64

#target
.PHONY: clean pub_get run_dev_web run_dev_android build_android run_dev_ios

# Clean the repo
clean_pub_get_run:
	@echo "clean the repo..."
	flutter clean

# Install dependencies
pub_get:
	@echo "getting the dependencies..."
	flutter pub get

# Run in browser
run_dev_web:
	@echo "Running in chrome..."
	flutter run -d chrome --dart-define=ENVIRONMENT=dev

# Run in android emulator
run_dev_android:
	@echo "Running app in android emulator..."
	$(AVD_MANAGER) -avd $(AVD_NAME)

build_android:
	@echo "Building Flutter project for Android..."
	flutter build apk

run_dev_ios:
	@echo "Running app in iOS env..."
	flutter run ios