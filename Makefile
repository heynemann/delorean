run:
	@cd src && ruby console.rb

test:
	@cd spec && spec --debugger *.rb