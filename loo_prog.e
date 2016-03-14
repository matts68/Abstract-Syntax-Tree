class LOO_PROG
	--
	-- Program
	--

creation {ANY}
   make

feature {NONE}
   -- A program is composed of an expression
   expression : LOO_EXP;

feature {ANY}
   -- Initializes expression
   make(exp: LOO_EXP) is
      do
	 expression := exp;
      end;

   -- Displays program
   display is
      do
	 expression.display;
      end;

   -- Evaluates program
   eval(e: LOO_ENVIRO[STRING, INTEGER]) : reference INTEGER is
      require
	 -- A program must have an expression whose evaluation is equal to an integer
	 expression.eval(e) /= Void
      do
	 Result := expression.eval(e);
      ensure
	 -- A program must have an integer as a result
	 Result /= Void
      end;
end -- class LOO_PROG