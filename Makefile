run:
	@cd src && ruby console.rb

test:
	@cd tests && spec *.rb