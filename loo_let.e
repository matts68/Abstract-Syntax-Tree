class LOO_LET
	--
	-- Let expression
	--

inherit LOO_EXP

creation {ANY}
   make

feature {NONE}
   -- A let expression is composed of a list of declarations and a 
   -- list of expressions
   declarations : LINKED_LIST[LOO_DECLA];
   expressions  : LINKED_LIST[LOO_EXP];

feature {ANY}
   -- Initializes attributes
   make(d: LINKED_LIST[LOO_DECLA]; e: LINKED_LIST[LOO_EXP]) is
	require
	 d /= Void and e /= Void and not d.is_empty and not e.is_empty
      do
	 declarations := d;
	 expressions  := e;
      end;

   -- Displays let expression
   display is
      local
	 i : INTEGER;
      do
	 io.put_string("let%N");

	 -- Display declarations (loop on list of items)
	 from
	    i := declarations.lower
	 until
	    i = declarations.upper + 1
	 loop
	    io.put_string("   ");
	    declarations.item(i).display;
	    io.put_new_line;
	    i := i + 1;
	 end;

	 io.put_string("in%N");

	 -- Display expressions (loop on list of items)
	 from
	    i := expressions.lower
	 until
	    i = expressions.upper + 1
	 loop
	    io.put_string("   ");
	    expressions.item(i).display;
	    io.put_new_line;
	    i := i + 1;
	 end;

	 io.put_string("end%N");
      end;

   -- Evaluates let expression
   eval(e: LOO_ENVIRO[STRING, INTEGER]) : reference INTEGER is
	-- No requirement : a let expression can have no declaration or/and no expression
      local
	 i : INTEGER;
	 value : reference INTEGER;
      do
	 -- Modification of the environment (declarations are added in a new 
	 -- dictionary through the following loop)
	 e.push;

	 from
	    i := declarations.lower
	 until
	    i = declarations.upper + 1
         loop
	    e.insert(declarations.item(i).get_variable.get_name, declarations.item(i).get_expression.eval(e));
	    i := i + 1;
	 end;

	 -- Loop on expressions for evaluation
	 from
	     i := expressions.lower
	 until
	     i = expressions.upper + 1
	 loop
	     value := expressions.item(i).eval(e);

	     Result := value;

	     --if value /= Void then
		--Result := value.item;
	     --end;
	     
	     i := i + 1;
	 end;

	 e.pop;
	-- No final verification : a let expression can return void or an integer
      end;
end -- class LOO_LET