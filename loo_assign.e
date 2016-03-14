class LOO_ASSIGN
      --
	-- Assignment expression
	--

inherit LOO_EXP

creation {ANY}
   make

feature {NONE}
   -- An assignment is composed of a variable and an expression
   variable   : LOO_VAR;
   expression : LOO_EXP;

feature {ANY}
   -- Initializes attributes
   make(var: LOO_VAR; exp: LOO_EXP) is
      do
	 variable := var;
	 expression := exp;
      end;

   -- Displays assignment
   display is
      do
	 variable.display;
	 io.put_string(" := ");
	 expression.display;
      end;

   -- Evaluates assignment
   eval(e: LOO_ENVIRO[STRING, INTEGER]) : reference INTEGER is
      require
	 -- Expression must be an integer
	 expression.eval(e) /= Void
      local
	 new_value : INTEGER;
      do
	 new_value := expression.eval(e).item;
	 e.set(variable.get_name, new_value); -- Variable has a new value that is saved into the environment
	 Result := Void; -- An assignment doesn't return anything
      ensure
	 -- Result must be void
	 Result = Void
      end;
end -- class LOO_ASSIGN