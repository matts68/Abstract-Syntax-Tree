class LOO_TEST
	--
	-- Test
	--
	-- Compile with:
	--    compile -o  loo_test loo_test
	-- Run with:
	--    loo_test
	--

creation {ANY}
	make

feature {ANY}
   -- Main program
   make is
      local
	 nb		: INTEGER
	 enviro     : LOO_ENVIRO[STRING, INTEGER];
	 exp		: LOO_EXP;
	 prog       : LOO_PROG;
	 res        : INTEGER;
      
	do

	if argument_count = 0 then
		io.put_string("Correct tests %N")
		io.put_string("------------- %N")
		io.put_string("  1.  Basic binary expression %N")
		io.put_string("  2.  Basic if expression %N")
		io.put_string("  3.  Test on a variable expression through a let exp.%N")
		io.put_string("  4.  Test on environment %N")
		io.put_string("  5.  Complex if expression %N")
		io.put_string("  6.  Test on assignment %N")
		io.put_string("  7.  Complex binary operation %N")

		io.put_string("Incorrect tests %N")
		io.put_string("--------------- %N")
		io.put_string("  8.  Undeclared variable %N")
		io.put_string("  9.  Variable no more visible %N")
		io.put_string("  10. A void program %N")
		io.put_string("  11. A binary operation whose one node is void%N")
		io.put_string("  12. Assignment with a void expression %N")
		io.put_string("  13. Environment with a variable declared twice in the same let expression %N")
		io.put_string("  14. A declaration needing the value of an unreachable variable %N")
		io.put_string("  15. A if whose then and else expressions aren't compatible (the first one returns an integer, the last one a void value) %N")

		io.put_string("Nb of test (see documentation for more information): ")
		io.flush
		io.read_integer
		nb := io.last_integer
	elseif argument_count /= 1 then
		io.put_string("Usage: loo_test <NumberOfTest>%N")
		die_with_code(exit_failure_code)
	elseif argument(1).is_integer then
		nb := argument(1).to_integer.max(1)
	else
		io.put_string("loo_test: bad argument (not an integer)%N")
		die_with_code(exit_failure_code)
	end;

	if nb < 1 or nb > 15 then
	   io.put_string("Number of test must be between 1 and 15!")
	   die_with_code(exit_failure_code)
	end;
	   

	inspect nb
		-- Right tests
	        when 1  then exp := correct_basic_bin;
		when 2  then exp := correct_basic_if;
  		when 3  then exp := correct_var
  		when 4  then exp := correct_enviro
  		when 5  then exp := correct_if
		when 6  then exp := correct_assign
		when 7  then exp := correct_bin

		-- Wrong tests
                when 8  then exp := incorrect_undeclared_var;
  		when 9  then exp := incorrect_var
  		when 10 then exp := incorrect_prog
  		when 11 then exp := incorrect_bin
		when 12 then exp := incorrect_assign
		when 13 then exp := incorrect_enviro
		when 14 then exp := incorrect_declara
		when 15 then exp := incorrect_if
	end

	create enviro.make;
	create prog.make(exp);
	io.put_string("%NProgram: %N");
	prog.display;
	res := prog.eval(enviro).item;
	io.put_string("%NResult: ");
	io.put_integer(res);
	io.put_new_line;
	end;

   correct_basic_bin : LOO_EXP is
	do
		Result := create {LOO_BIN}.make(create {LOO_BIN}.make(create {LOO_INT}.make(3), create {LOO_INT}.make(10), '-'), create {LOO_INT}.make(5), '*');
	end;

   correct_basic_if : LOO_EXP is
	do
		Result := create {LOO_IF}.make(create {LOO_BIN}.make(create {LOO_INT}.make(12), create {LOO_BIN}.make(create {LOO_INT}.make(10), create {LOO_INT}.make(3), '+'), '<'), create {LOO_INT}.make(2), create {LOO_INT}.make(8));
	end;

   correct_var : LOO_EXP is
	local
		dec : LINKED_LIST[LOO_DECLA];
	 	exp : LINKED_LIST[LOO_EXP];
	do
		create dec.make;
		create exp.make;
		dec.add_first(create {LOO_DECLA}.make(create {LOO_VAR}.make("a"), create {LOO_INT}.make(5)));
		exp.add_first(create {LOO_VAR}.make("a"));
		Result := create {LOO_LET}.make(dec, exp);
	end;

   correct_enviro : LOO_EXP is
	local
		dec, dec2 : LINKED_LIST[LOO_DECLA];
	 	exp, exp2 : LINKED_LIST[LOO_EXP];
	do
		create dec.make;
		create exp.make;
		dec.add_first(create {LOO_DECLA}.make(create {LOO_VAR}.make("a"), create {LOO_INT}.make(3)));
		dec.add_last(create {LOO_DECLA}.make(create {LOO_VAR}.make("b"), create {LOO_INT}.make(2)));
		dec.add_last(create {LOO_DECLA}.make(create {LOO_VAR}.make("c"), create {LOO_INT}.make(4)));
		create dec2.make;
		create exp2.make;
		dec2.add_first(create {LOO_DECLA}.make(create {LOO_VAR}.make("a"), create {LOO_INT}.make(0)));
		dec2.add_last(create {LOO_DECLA}.make(create {LOO_VAR}.make("b"), create {LOO_INT}.make(1)));
		exp2.add_first(create {LOO_BIN}.make(create {LOO_VAR}.make("a"), create {LOO_VAR}.make("b"), '+'));
		exp.add_first(create {LOO_LET}.make(dec2, exp2));
		exp.add_last(create {LOO_VAR}.make("a"));
		Result := create {LOO_LET}.make(dec, exp);
	end;

   correct_if : LOO_EXP is
	local
		dec, dec2 : LINKED_LIST[LOO_DECLA];
	 	exp, exp2 : LINKED_LIST[LOO_EXP];
	do
		create dec.make;
		create exp.make;
		dec.add_first(create {LOO_DECLA}.make(create {LOO_VAR}.make("a"), create {LOO_INT}.make(5)));
		dec.add_last(create {LOO_DECLA}.make(create {LOO_VAR}.make("b"), create {LOO_INT}.make(7)));
		create dec2.make;
		create exp2.make;
		dec2.add_first(create {LOO_DECLA}.make(create {LOO_VAR}.make("a"), create {LOO_INT}.make(1)));
		dec2.add_last(create {LOO_DECLA}.make(create {LOO_VAR}.make("b"), create {LOO_INT}.make(2)));
		exp2.add_first(create {LOO_ASSIGN}.make(create {LOO_VAR}.make("a"), create {LOO_BIN}.make(create {LOO_VAR}.make("a"), create {LOO_VAR}.make("b"), '*')));
		exp2.add_last(create {LOO_VAR}.make("a"));
		exp.add_first(create {LOO_IF}.make(create {LOO_BIN}.make(create {LOO_BIN}.make(create {LOO_VAR}.make("a"), create {LOO_VAR}.make("b"), '+'), create {LOO_INT}.make(15), '<'), create {LOO_LET}.make(dec2, exp2), create {LOO_INT}.make(0)));
		Result := create {LOO_LET}.make(dec, exp);
	end;

   correct_assign : LOO_EXP is
	local
		dec, dec2 : LINKED_LIST[LOO_DECLA];
	 	exp, exp2 : LINKED_LIST[LOO_EXP];
	do
		create dec.make;
		create exp.make;
		dec.add_first(create {LOO_DECLA}.make(create {LOO_VAR}.make("a"), create {LOO_INT}.make(6)));
		dec.add_last(create {LOO_DECLA}.make(create {LOO_VAR}.make("b"), create {LOO_INT}.make(2)));
		create dec2.make;
		create exp2.make;
		dec2.add_first(create {LOO_DECLA}.make(create {LOO_VAR}.make("a"), create {LOO_VAR}.make("b")));
		dec2.add_last(create {LOO_DECLA}.make(create {LOO_VAR}.make("c"), create {LOO_INT}.make(3)));
		exp2.add_first(create {LOO_IF}.make(create {LOO_BIN}.make(create {LOO_VAR}.make("a"), create {LOO_BIN}.make(create {LOO_VAR}.make("c"), create {LOO_INT}.make(1), '-'), '='), create {LOO_VAR}.make("a"), create {LOO_VAR}.make("c")));
		exp.add_first(create {LOO_ASSIGN}.make(create {LOO_VAR}.make("a"), create {LOO_LET}.make(dec2, exp2)));
		exp.add_last(create {LOO_VAR}.make("a"));
		Result := create {LOO_LET}.make(dec, exp);
	end;

   correct_bin : LOO_EXP is
	local
		dec, dec2, dec3 : LINKED_LIST[LOO_DECLA];
	 	exp, exp2, exp3 : LINKED_LIST[LOO_EXP];
	do
		create dec.make;
		create exp.make;
		dec.add_first(create {LOO_DECLA}.make(create {LOO_VAR}.make("a"), create {LOO_INT}.make(3)));
		dec.add_last(create {LOO_DECLA}.make(create {LOO_VAR}.make("b"), create {LOO_INT}.make(2)));
		dec.add_last(create {LOO_DECLA}.make(create {LOO_VAR}.make("c"), create {LOO_INT}.make(4)));
		dec.add_last(create {LOO_DECLA}.make(create {LOO_VAR}.make("d"), create {LOO_INT}.make(11)));
		create dec2.make;
		create exp2.make;
		dec2.add_first(create {LOO_DECLA}.make(create {LOO_VAR}.make("a"), create {LOO_BIN}.make(create {LOO_VAR}.make("c"), create {LOO_INT}.make(2), '+')));
		dec2.add_last(create {LOO_DECLA}.make(create {LOO_VAR}.make("b"), create {LOO_VAR}.make("d")));
		exp2.add_first(create {LOO_BIN}.make(create {LOO_VAR}.make("a"), create {LOO_VAR}.make("b"), '+'));
		create dec3.make;
		create exp3.make;
		dec3.add_first(create {LOO_DECLA}.make(create {LOO_VAR}.make("c"), create {LOO_BIN}.make(create {LOO_BIN}.make(create {LOO_VAR}.make("a"), create {LOO_VAR}.make("b"), '-'), create {LOO_VAR}.make("d"), '/')));
		exp3.add_first(create {LOO_VAR}.make("c"));
		exp.add_first(create {LOO_BIN}.make(create {LOO_BIN}.make(create {LOO_LET}.make(dec2, exp2), create {LOO_IF}.make(create {LOO_BIN}.make(create {LOO_VAR}.make("a"), create {LOO_INT}.make(3), '='), create {LOO_LET}.make(dec3, exp3), create {LOO_VAR}.make("a")), '*'), create {LOO_VAR}.make("d"), '+'));
		Result := create {LOO_LET}.make(dec, exp);
	end;

   incorrect_undeclared_var : LOO_EXP is
	do
		Result := create {LOO_BIN}.make(create {LOO_VAR}.make("a"), create {LOO_INT}.make(1), '+');
	end;

   incorrect_var : LOO_EXP is
	local
		dec, dec2 : LINKED_LIST[LOO_DECLA];
	 	exp, exp2 : LINKED_LIST[LOO_EXP];
	do
		create dec.make;
		create exp.make;
		dec.add_first(create {LOO_DECLA}.make(create {LOO_VAR}.make("a"), create {LOO_INT}.make(3)));
		create dec2.make;
		create exp2.make;
		dec2.add_first(create {LOO_DECLA}.make(create {LOO_VAR}.make("b"), create {LOO_VAR}.make("a")));
		exp2.add_first(create {LOO_VAR}.make("b"));
		exp.add_first(create {LOO_BIN}.make(create {LOO_LET}.make(dec2, exp2), create {LOO_BIN}.make(create {LOO_VAR}.make("b"), create {LOO_VAR}.make("a"), '+'), '*'));
		Result := create {LOO_LET}.make(dec, exp);
	end;

   incorrect_prog : LOO_EXP is
	local
		dec : LINKED_LIST[LOO_DECLA];
	 	exp : LINKED_LIST[LOO_EXP];
	do
		create dec.make;
		create exp.make;
		dec.add_first(create {LOO_DECLA}.make(create {LOO_VAR}.make("a"), create {LOO_INT}.make(10)));
		exp.add_first(create {LOO_IF}.make(create {LOO_BIN}.make(create {LOO_VAR}.make("a"), create {LOO_INT}.make(5), '<'), create {LOO_ASSIGN}.make(create {LOO_VAR}.make("a"), create {LOO_BIN}.make(create {LOO_VAR}.make("a"), create {LOO_INT}.make(2), '-')), create {LOO_ASSIGN}.make(create {LOO_VAR}.make("a"), create {LOO_BIN}.make(create {LOO_VAR}.make("a"), create {LOO_INT}.make(2), '/'))));
		Result := create {LOO_LET}.make(dec, exp);
	end;

   incorrect_bin : LOO_EXP is
	local
		dec : LINKED_LIST[LOO_DECLA];
	 	exp : LINKED_LIST[LOO_EXP];
	do
		create dec.make;
		create exp.make;
		dec.add_first(create {LOO_DECLA}.make(create {LOO_VAR}.make("a"), create {LOO_INT}.make(3)));
		dec.add_last(create {LOO_DECLA}.make(create {LOO_VAR}.make("b"), create {LOO_INT}.make(5)));
		exp.add_first(create {LOO_ASSIGN}.make(create {LOO_VAR}.make("a"), create {LOO_BIN}.make(create {LOO_VAR}.make("b"), create {LOO_IF}.make(create {LOO_BIN}.make(create {LOO_VAR}.make("a"), create {LOO_INT}.make(3), '='), create {LOO_ASSIGN}.make(create {LOO_VAR}.make("a"), create {LOO_VAR}.make("b")), create {LOO_ASSIGN}.make(create {LOO_VAR}.make("a"), create {LOO_INT}.make(0))), '+')));
		exp.add_last(create {LOO_VAR}.make("a"));
		Result := create {LOO_LET}.make(dec, exp);
	end;

    incorrect_assign : LOO_EXP is
	local
		dec : LINKED_LIST[LOO_DECLA];
	 	exp : LINKED_LIST[LOO_EXP];
	do
		create dec.make;
		create exp.make;
		dec.add_first(create {LOO_DECLA}.make(create {LOO_VAR}.make("a"), create {LOO_INT}.make(100)));
		dec.add_last(create {LOO_DECLA}.make(create {LOO_VAR}.make("b"), create {LOO_INT}.make(50)));
		dec.add_last(create {LOO_DECLA}.make(create {LOO_VAR}.make("c"), create {LOO_INT}.make(4)));
		exp.add_first(create {LOO_ASSIGN}.make(create {LOO_VAR}.make("a"), create {LOO_ASSIGN}.make(create {LOO_VAR}.make("b"), create {LOO_BIN}.make(create {LOO_VAR}.make("c"), create {LOO_INT}.make(3), '+'))));
		Result := create {LOO_LET}.make(dec, exp);
	end;

    incorrect_enviro: LOO_EXP is
	local
		dec, dec2 : LINKED_LIST[LOO_DECLA];
	 	exp, exp2 : LINKED_LIST[LOO_EXP];
	do
		create dec.make;
		create exp.make;
		dec.add_first(create {LOO_DECLA}.make(create {LOO_VAR}.make("a"), create {LOO_INT}.make(2)));
		dec.add_last(create {LOO_DECLA}.make(create {LOO_VAR}.make("b"), create {LOO_INT}.make(3)));
		create dec2.make;
		create exp2.make;
		dec2.add_first(create {LOO_DECLA}.make(create {LOO_VAR}.make("a"), create {LOO_BIN}.make(create {LOO_VAR}.make("b"), create {LOO_INT}.make(1), '+')));
		dec2.add_last(create {LOO_DECLA}.make(create {LOO_VAR}.make("a"), create {LOO_INT}.make(3)));
		exp2.add_first(create {LOO_VAR}.make("a"));
		exp.add_first(create {LOO_LET}.make(dec2, exp2));
		Result := create {LOO_LET}.make(dec, exp);
	end;

    incorrect_declara: LOO_EXP is
	local
		dec, dec2 : LINKED_LIST[LOO_DECLA];
	 	exp, exp2 : LINKED_LIST[LOO_EXP];
	do
		create dec.make;
		create exp.make;
		dec.add_first(create {LOO_DECLA}.make(create {LOO_VAR}.make("a"), create {LOO_VAR}.make("b")));
		create dec2.make;
		create exp2.make;
		dec2.add_first(create {LOO_DECLA}.make(create {LOO_VAR}.make("b"), create {LOO_INT}.make(2)));
		exp2.add_first(create {LOO_VAR}.make("b"));
		exp.add_first(create {LOO_LET}.make(dec2, exp2));
		Result := create {LOO_LET}.make(dec, exp);
	end;

    incorrect_if: LOO_EXP is
	local
		dec : LINKED_LIST[LOO_DECLA];
	 	exp : LINKED_LIST[LOO_EXP];
	do
		create dec.make;
		create exp.make;
		dec.add_first(create {LOO_DECLA}.make(create {LOO_VAR}.make("c"), create {LOO_INT}.make(3)));
		dec.add_last(create {LOO_DECLA}.make(create {LOO_VAR}.make("d"), create {LOO_INT}.make(5)));
		exp.add_first(create {LOO_IF}.make(create {LOO_BIN}.make(create {LOO_VAR}.make("c"), create {LOO_VAR}.make("d"), '='), create {LOO_VAR}.make("d"), create {LOO_ASSIGN}.make(create {LOO_VAR}.make("d"), create {LOO_BIN}.make(create {LOO_VAR}.make("d"), create {LOO_VAR}.make("c"), '/'))));
		Result := create {LOO_LET}.make(dec, exp);
	end;
end -- class LOO_TEST