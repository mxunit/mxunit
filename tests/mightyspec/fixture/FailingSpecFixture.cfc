component extends="mxunit.framework.Spec"{
			
			
	describe("A Thing that fails", function(){
		
		it("fails with expectation failures", function(){
			
			expect(1).toEqual(1);
			expect(1).toEqual(2);
			expect(1).toEqual("beer");
				
			expect( false ).toBeTrue();
			expect( 0 ).toBeTrue();			
		});
		
		it("fails with expectation failures again", function(){
			expect( true ).ToBeTrue();
			expect( false ).toBeTrue();
			expect( 0 ).toBeTrue();
			
			expect(1).toEqual(2);
			expect(1).toEqual("beer");
		});
		
		it("fails with expectation failures again II", function(){
			expect( false ).toBeTrue();
			expect( 0 ).toBeTrue();
			
			expect(1).toEqual(2);
			expect(1).toEqual("beer");
			expect('a').		
		});
		
	});			
			
}