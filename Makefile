run:
	@cd lib && ruby delorean.rb -u admin -p 12345

test:
	@cd spec && spec --debugger *.rb

flog:
	@find src -name \*.rb | xargs flog -d
	@reek src

clear:
	@rm -rf /tmp/db/
