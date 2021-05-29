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
