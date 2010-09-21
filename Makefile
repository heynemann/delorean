run:
	@cd src && ruby console.rb

test:
	@cd spec && spec --debugger *.rb

flog:
	@find src -name \*.rb | xargs flog -d