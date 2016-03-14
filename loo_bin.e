class LOO_BIN
      --
	-- Binary expression
	--

inherit LOO_EXP

creation {ANY}
   make

feature {NONE}
   -- A binary expression is composed of two expressions and an operation
   left_node, right_node : LOO_EXP;
   operation : CHARACTER;

feature {ANY}
   -- Initializes attributes
   make(ln, rn: LOO_EXP; op: CHARACTER) is
      do
	 left_node := ln;
	 right_node := rn;
	 operation := op;
      end;

   -- Displays binary expression
   display is
      do
	 io.put_character('(');
	 left_node.display;
	 io.put_character(operation);
	 right_node.display;
	 io.put_character(')');
      end;

   -- Evaluates binary expression
   eval(e: LOO_ENVIRO[STRING, INTEGER]) : reference INTEGER is
      require
	 -- Both operandes must be an integer and operation must be a valid one
	 left_node.eval(e) /= Void and right_node.eval(e) /= Void and operation.compare('+') = 0 or operation.compare('-') = 0 or operation.compare('*') = 0 or operation.compare('/') = 0 or operation.compare('=') = 0 or operation.compare('<') = 0
      local
	 operande1 : INTEGER;
	 operande2 : INTEGER;
	 reel      : DOUBLE;
      do
	operande1 := left_node.eval(e).item;
	operande2 := right_node.eval(e).item;

	-- Calculation is made depending on type of operation (in 
	-- case of comparison, 1 means True and 0 means False)
	inspect operation
	   when '+' then Result := operande1 + operande2;
	   when '-' then Result := operande1 - operande2;
	   when '*' then Result := operande1 * operande2;
	   when '/' then reel := operande1 / operande2;
	         	 Result := reel.truncated_to_integer;
	   when '<' then if operande1 < operande2 then
	                    Result := 1
			 else
			    Result := 0;
			 end;
           when '=' then if operande1 = operande2 then
	                    Result := 1
			 else
			    Result := 0;
	                 end;
	end;
      ensure
	 -- Result must be an integer, so it can't be void
	 Result /= Void
      end;
end -- class LOO_BIN