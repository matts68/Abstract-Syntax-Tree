class LOO_ENVIRO[KEY->HASHABLE, VALUE]
	--
	-- Environment
	--

creation {ANY}
	make

feature {NONE}
   -- An environment is composed of a list of dictionaries
   dictionaries : LINKED_LIST[HASHED_DICTIONARY[VALUE, KEY]];

feature {ANY}
   -- Initializes the attribute (list of dictionaries)
   make is
      do
	 create dictionaries.make;
      end;

   -- Pushes a new dictionary in the list
   push is
      require
	 -- List musn't be void
	 dictionaries /= Void
      local
	 new_dictionary : HASHED_DICTIONARY[VALUE, KEY];
      do
	 create new_dictionary.make;

	 if dictionaries.is_empty
	    then
	       dictionaries.add_first(new_dictionary);
	    else
	       dictionaries.add_last(new_dictionary);
	 end;
      ensure
	 -- The list must have at least one dictionary
	 not dictionaries.is_empty
      end;

   -- Pops the last dictionary
   pop is
      require
	 -- The list must exist and have at least one dictionary
	 dictionaries /= Void and not dictionaries.is_empty
      do
	 dictionaries.remove_last;
      end;

   -- Inserts a new value (that is found thanks to a key) in the last dictionary
   insert(k: KEY;  v: VALUE) is
      require
	-- Key mustn't exist in the last dictionary
	k /= Void and v /= Void and dictionaries /= Void and not dictionaries.last.has(k)
      do
	 dictionaries.last.add(v, k);
      ensure
	 -- The list must have at least one dictionary and value 
	 -- must be found through the given key
	 not dictionaries.is_empty and get(k) = v
      end;

   -- Sets a new value for a key
   set(k: KEY; v: VALUE) is
      require
	 -- The list must have at least one dictionary and the key 
	 -- must exist
	 v /= Void and not dictionaries.is_empty and has(k)
      local
	 i : INTEGER;
	 key_found : BOOLEAN;
      do
	 key_found := False;

	  -- Loop on the list to find out index of the last dictionary which has the given key
	 from 
	    i := dictionaries.upper
	 until
	    i = 0 or key_found
         loop
	    key_found := dictionaries.item(i).has(k);
	    i := i - 1;
	 end;

	 dictionaries.item(i+1).put(v, k); -- The new value is put for the key
      ensure
	 -- The value must be found through the given key
	 get(k) = v
      end;

   -- Seeks if key exist or not in the list
   has(k: KEY): BOOLEAN is
      require
	 -- The list must have at least one dictionary
	 k /= Void and not dictionaries.is_empty
      local
	 i : INTEGER;
	 key_found: BOOLEAN;
      do
	 key_found := False;

	 -- Loop on the list to find out index of the last dictionary which has the given key
	 from
	    i := dictionaries.upper
	 until
	    i = 0 or key_found
	 loop
	    key_found := dictionaries.item(i).has(k);
	    i := i - 1;
	 end;

	 Result := key_found;
      end;

   -- Returns value of the last key occurence
   get(k: KEY): VALUE is
      require
	 -- Key must exist in the list
	 has(k)
      local
	 i : INTEGER;
	 key_found : BOOLEAN;
      do
	 key_found := False;

	  -- Loop on the list to find out index of the last dictionary which has the given key
	 from 
	    i := dictionaries.upper
	 until
	    i = 0 or key_found
         loop
	    key_found := dictionaries.item(i).has(k);
	    i := i - 1;
	 end;

	 Result := dictionaries.item(i+1).at(k);
      ensure
	 -- A value must be found
	 Result /= Void
      end;
end -- class LOO_ENVIRO