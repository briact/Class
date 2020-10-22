return function()
	local Class = require(script.Parent.Class)
	
	describe("creation", function()
		it("should allow a class to be created", function()
			local class = Class.new("test")
			expect(type(class) == "table").to.be.ok()
		end)
		
		it("should allow a class to be extended", function()
			local class = Class.new("test")
			local classExtending = Class.new("test2", "test")
			expect(type(classExtending) == "table").to.be.ok()
		end)
		
		it("should allow method overriding and creation", function()
			local class = Class.new("test3")
			
			function class.new(self, int)
				self.int = int
			end
			
			function class:handleGet()
				return self.int
			end
			
			function class:explode()
				return self.int
			end
			
			expect(class.new).to.be.ok()
			expect(class.handleGet).to.be.ok()
			expect(class.explode).to.be.ok()
		end)
	end)
	
	describe("objects", function()
		
		it("should include constructor", function()
			local class = Class.new("test4")
			expect(class.new).to.be.ok()
		end)
		
		it("should allow object creation", function()
			local class = Class.new("test5")
			local object = class.new()
			expect(class.new).to.be.ok()
		end)
		
		it("should allow calling methods", function()
			local class = Class.new("test6")
			
			function class:new(int)
				self.int = int
			end

			function class:handleGet()
				return self.int
			end

			function class:explode()
				return self.int
			end
			
			local object = class.new(5)

			expect(object.int).to.be.ok()
			expect(object.int).to.equal(5)
			expect(object.explode).to.be.ok()
			expect(object:explode()).to.equal(5)
			expect(object.handleGet).to.be.ok()
			expect(object:handleGet()).to.equal(5)
		end)
		
		it("should throw unrouted methods", function()

			local class = Class.new("test7")
			
			function class:new(int)
				self.int = int
			end

			function class:explode()
				return self.int
			end
			
			local object = class.new(5)

			expect(object.xyz).never.to.be.ok()
			
			expect(function()
				object.xyz = 5
			end).to.throw()

			expect(function()
				local x = object + object
			end).to.throw()
			
			expect(function()
				local x = object - object
			end).to.throw()
			
			expect(function()
				local x = object * object
			end).to.throw()

			expect(function()
				local x = object / object
			end).to.throw()

			expect(function()
				local x = object % object
			end).to.throw()

			expect(function()
				local x = object ^ object
			end).to.throw()

			expect(function()
				local x = object < object
			end).to.throw()

			expect(function()
				local x = object <= object
			end).to.throw()

			expect(function()
				local x = object .. object
			end).to.throw()

			expect(function()
				local x = object()
			end).to.throw()
			
			expect(function()
				print(object)
			end).to.throw()
		end)

		it("should not throw routed methods", function()
			local class = Class.new("test8")

			function class:new(int)
				self.int = int
			end

			function class:explode()
				return self.int
			end
			
			function class:handleSet()
				-- uhh cant test this? lol
			end

			function class:handleGet()
				return true
			end

			function class:handleConcat()
				return "concat"
			end

			function class:handleArithmetic(value, operation)
				return 1
			end

			function class:handleComparison(comparison)
				return true
			end
			
			function class:handleCall()
				return 1
			end
			
			function class:toString()
				return "string"
			end
			
			function class:handleLength()
				return 1
			end

			class:enableRoute("handleGet")
			class:enableRoute("handleSet")
			class:enableRoute("handleCall")
			class:enableRoute("handleConcat")
			class:enableRoute("handleUnaryMinus")
			class:enableRoute("handleArithmetic")
			class:enableRoute("handleComparison")
			class:enableRoute("handleLength")
			class:enableRoute("toString")
			
			local object = class.new(5)

			expect(function()
				object.xyz = 5
			end).never.to.throw()

			expect(function()
				local a = object.xyz
			end).never.to.throw()

			expect(function()
				object()
			end).never.to.throw()

			expect(function()
				local a = object .. object
			end).never.to.throw()

			expect(function()
				local a = object + object
				a = object - object
				a = object / object
				a = object * object
				a = object % object
				a = object ^ object
			end).never.to.throw()
			
			expect(function()
				local a = object == object
				a = object < object
				a = object <= object
			end).never.to.throw()

			expect(function()
				local a = #object
			end).never.to.throw()
			
			expect(function()
				print(object)
			end).never.to.throw()
		end)
	end)
end