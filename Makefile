#Makefile

FLUTTER_BIN = /snap/bin/flutter
ENTRY_POINT = lib/main/main.dart
EMULATOR_NAME = Pixel_3a_API_34_extension_level_7_x86_64

.PHONY: all get-dependecies run-android run-web run-emulator clean

all: get-dependecies run-emulator run-android run-web clean

get-dependecies:
	$(FLUTTER_BIN) pub get

run-emulator:
	$(FLUTTER_BIN) emulators --launch $(EMULATOR_NAME)

run-android:
	$(FLUTTER_BIN) run -t $(ENTRY_POINT)

run-web:
	$(FLUTTER_BIN) run -d chrome -t $(ENTRY_POINT)

clean:
	$(FLUTTER_BIN) clean
