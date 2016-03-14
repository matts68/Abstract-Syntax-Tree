class LOO_VAR
	--
	-- Variable expression
	--

inherit LOO_EXP

creation {ANY}
   make

feature {NONE}
   -- A variable is made of a name
   name_var : STRING;

feature {ANY}
   -- Initializes variable's name
   make(name: STRING) is
      do
	 name_var := name;
      end;

   -- Returns variable's name
   get_name : STRING is
      do
	 Result := name_var;
      end;

   -- Sets variable's name
   set_name(new_name: STRING) is
      do
	 name_var := new_name;
      end;

   -- Displays variable's name
   display is
      do
	 io.put_string(name_var);
      end;

   -- Evaluates variable thanks to its name
   eval(e: LOO_ENVIRO[STRING, INTEGER]) : reference INTEGER is
      require
	 -- Name must have at least one character
	 not name_var.is_empty
      do
	 Result := e.get(name_var);
      ensure
	 -- Result must be an integer
	 Result /= Void
      end;
end -- class LOO_VAR