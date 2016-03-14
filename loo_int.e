class LOO_INT
	--
	-- Integer expression
	--

inherit LOO_EXP

creation {ANY}
   make

feature {NONE}
   int_value : INTEGER;

feature {ANY}
   -- Initializes integer value
   make(val: INTEGER) is
      do
	 int_value := val;
      end;

   -- Displays integer value
   display is
      do
	 io.put_integer(int_value);
      end;

   -- Evluates integer value
   eval(e: LOO_ENVIRO[STRING, INTEGER]) : reference INTEGER is
      do
	 Result := int_value;
      ensure
	 -- Result must be an integer
	 Result /= Void
      end;
end -- class LOO_INT