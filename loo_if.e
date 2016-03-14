class LOO_IF
	--
	-- If expression
	--

inherit LOO_EXP

creation {ANY}
   make

feature {NONE}
   -- An if expression is composed of three expressions (one for test, 
   -- one if test is true, another one if it's false)
   exp_test, exp_then, exp_else : LOO_EXP;

feature {ANY}
   -- Initializes attributes
   make(etest, ethen, eelse : LOO_EXP) is
      do
	 exp_test := etest;
	 exp_then := ethen;
	 exp_else := eelse;
      end;

   -- Displays if expression
   display is
      do
	 io.put_string("if ");
	 exp_test.display;
	 io.put_string(" then ");
	 exp_then.display;
	 io.put_string(" else ");
	 exp_else.display;
	 io.put_new_line;
      end;

   -- Evaluates if expression
   eval(e: LOO_ENVIRO[STRING, INTEGER]) : reference INTEGER is
      require
	-- Test expression can't be void and both expressions composing then and else conditions must have the same type
	 exp_test.eval(e) /= Void and
	((exp_then.eval(e) = Void and exp_else.eval(e) = Void) or (exp_then.eval(e) /= Void and exp_else.eval(e) /= Void))
      do
	 -- Result is calculated following the test is valid or 
	 -- not : it can be an integer or void
	 if exp_test.eval(e).item.to_boolean
	 then
	    Result := exp_then.eval(e);
	 else
	    Result := exp_else.eval(e);
	 end;
	 -- There is no final verification
      end;
end -- class LOO_IF