deferred class LOO_EXP
	--
	-- Expression
	--

feature {ANY}
  -- Displays expression
  display is deferred end;

  -- Evaluates expression
  eval (e: LOO_ENVIRO[STRING, INTEGER]) : reference INTEGER is deferred end;

end -- class LOO_EXP