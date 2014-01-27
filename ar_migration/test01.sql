drop function hawq_ar();
CREATE FUNCTION hawq_ar()
RETURNS void
AS $$
    plpy.info("Starting...")
    plpy.execute("""SELECT madlib.gen_rules_from_cfp('1,2,3', 3)""")
    plpy.execute("""SELECT madlib.svec_cast_positions_float8arr(ARRAY[1]::int8[], ARRAY[1], 4, 0)""");
    plpy.info("After svec_cast_positions_float8arr() ...")
    plpy.execute("""SELECT madlib.gen_rules_from_cfp('1,2,3', 3)""")
    plpy.info("Finished uccessfully!?")
$$ LANGUAGE plpythonu;

SELECT hawq_ar();
