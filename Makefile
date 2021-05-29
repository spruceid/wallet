.PHONY: check-fastlane-user
check-fastlane-user:
ifeq ($(origin FASTLANE_USER),undefined)
	@echo "🛑 FASTLANE_USER env var not defined." && exit 1
endif

.PHONY: setup-didkit-ios
setup-didkit-ios:
	@./didkit_setup.sh -ios

.PHONY: deploy-ios
deploy-ios: check-fastlane-user setup-didkit-ios
	@cd ios && bundle exec fastlane beta

.PHONY: setup-didkit-android
setup-didkit-android:
	@./didkit_setup.sh -android

.PHONY: deploy-android
deploy-android: setup-didkit-android
	@flutter build appbundle
	@cd android && bundle exec fastlane beta

.PHONY: deploy-all
deploy-all: deploy-ios deploy-android