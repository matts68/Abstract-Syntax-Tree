class LOO_DECLA
      --
	-- Declaration
	--

creation {ANY}
   make

feature {NONE}
   -- A declaration is composed of a variable and an expression (like an assignment)
   dec_var : LOO_VAR;
   dec_exp : LOO_EXP;

feature {ANY}
   -- Initializes attributes
   make(var: LOO_VAR; exp: LOO_EXP) is
      do
	 dec_var := var;
	 dec_exp := exp;
      end;

   -- Returns expression
   get_expression : LOO_EXP is
      do
	 Result := dec_exp;
      end;

   -- Returns variable
   get_variable : LOO_VAR is
      do
	 Result := dec_var;
      end;

   -- Sets expression
   set_expression(exp: LOO_EXP) is
      do
	 dec_exp := exp;
      end;

   -- Sets variable
   set_variable(var: LOO_VAR) is
      do
	 dec_var := var;
      end;

   -- Displays declaration
   display is
      do
	 dec_var.display;
	 io.put_string(" := ");
	 dec_exp.display;
      end;
end -- class LOO_DECLA