CREATE OR REPLACE FUNCTION svec_in(cstring) RETURNS svec
    AS '$libdir/gp_svec.so', 'svec_in'
    LANGUAGE c IMMUTABLE STRICT;

CREATE OR REPLACE FUNCTION svec_out(svec) RETURNS cstring
    AS '$libdir/gp_svec.so', 'svec_out'
    LANGUAGE c IMMUTABLE STRICT;

CREATE OR REPLACE FUNCTION svec_recv(internal) RETURNS svec
    AS '$libdir/gp_svec.so', 'svec_recv'
    LANGUAGE c IMMUTABLE STRICT;

CREATE OR REPLACE FUNCTION svec_send(svec) RETURNS bytea
    AS '$libdir/gp_svec.so', 'svec_send'
    LANGUAGE c IMMUTABLE STRICT;

CREATE OR REPLACE FUNCTION float8arr_cast_float4(real) RETURNS double precision[]
    AS '$libdir/gp_svec.so', 'float8arr_cast_float4'
    LANGUAGE c IMMUTABLE STRICT;

CREATE OR REPLACE FUNCTION float8arr_cast_float8(double precision) RETURNS double precision[]
    AS '$libdir/gp_svec.so', 'float8arr_cast_float8'
    LANGUAGE c IMMUTABLE STRICT;

CREATE OR REPLACE FUNCTION float8arr_cast_int2(smallint) RETURNS double precision[]
    AS '$libdir/gp_svec.so', 'float8arr_cast_int2'
    LANGUAGE c IMMUTABLE STRICT;

CREATE OR REPLACE FUNCTION float8arr_cast_int4(integer) RETURNS double precision[]
    AS '$libdir/gp_svec.so', 'float8arr_cast_int4'
    LANGUAGE c IMMUTABLE STRICT;

CREATE OR REPLACE FUNCTION float8arr_cast_int8(bigint) RETURNS double precision[]
    AS '$libdir/gp_svec.so', 'float8arr_cast_int8'
    LANGUAGE c IMMUTABLE STRICT;

CREATE OR REPLACE FUNCTION float8arr_cast_numeric(numeric) RETURNS double precision[]
    AS '$libdir/gp_svec.so', 'float8arr_cast_numeric'
    LANGUAGE c IMMUTABLE STRICT;

CREATE OR REPLACE FUNCTION float8arr_div_float8arr(double precision[], double precision[]) RETURNS svec
    AS '$libdir/gp_svec.so', 'float8arr_div_float8arr'
    LANGUAGE c IMMUTABLE;

CREATE OR REPLACE FUNCTION float8arr_div_svec(double precision[], svec) RETURNS svec
    AS '$libdir/gp_svec.so', 'float8arr_div_svec'
    LANGUAGE c IMMUTABLE;

CREATE OR REPLACE FUNCTION float8arr_eq(double precision[], double precision[]) RETURNS boolean
    AS '$libdir/gp_svec.so', 'float8arr_equals'
    LANGUAGE c IMMUTABLE;

CREATE OR REPLACE FUNCTION float8arr_minus_float8arr(double precision[], double precision[]) RETURNS svec
    AS '$libdir/gp_svec.so', 'float8arr_minus_float8arr'
    LANGUAGE c IMMUTABLE;

CREATE OR REPLACE FUNCTION float8arr_minus_svec(double precision[], svec) RETURNS svec
    AS '$libdir/gp_svec.so', 'float8arr_minus_svec'
    LANGUAGE c IMMUTABLE;

CREATE OR REPLACE FUNCTION float8arr_mult_float8arr(double precision[], double precision[]) RETURNS svec
    AS '$libdir/gp_svec.so', 'float8arr_mult_float8arr'
    LANGUAGE c IMMUTABLE;

CREATE OR REPLACE FUNCTION float8arr_mult_svec(double precision[], svec) RETURNS svec
    AS '$libdir/gp_svec.so', 'float8arr_mult_svec'
    LANGUAGE c IMMUTABLE;

CREATE OR REPLACE FUNCTION float8arr_plus_float8arr(double precision[], double precision[]) RETURNS svec
    AS '$libdir/gp_svec.so', 'float8arr_plus_float8arr'
    LANGUAGE c IMMUTABLE;

CREATE OR REPLACE FUNCTION float8arr_plus_svec(double precision[], svec) RETURNS svec
    AS '$libdir/gp_svec.so', 'float8arr_plus_svec'
    LANGUAGE c IMMUTABLE;

CREATE OR REPLACE FUNCTION svec_cast_float4(real) RETURNS svec
    AS '$libdir/gp_svec.so', 'svec_cast_float4'
    LANGUAGE c IMMUTABLE STRICT;

CREATE OR REPLACE FUNCTION svec_cast_float8(double precision) RETURNS svec
    AS '$libdir/gp_svec.so', 'svec_cast_float8'
    LANGUAGE c IMMUTABLE STRICT;

CREATE OR REPLACE FUNCTION svec_cast_float8arr(double precision[]) RETURNS svec
    AS '$libdir/gp_svec.so', 'svec_cast_float8arr'
    LANGUAGE c IMMUTABLE STRICT;

CREATE OR REPLACE FUNCTION svec_cast_int2(smallint) RETURNS svec
    AS '$libdir/gp_svec.so', 'svec_cast_int2'
    LANGUAGE c IMMUTABLE STRICT;

CREATE OR REPLACE FUNCTION svec_cast_int4(integer) RETURNS svec
    AS '$libdir/gp_svec.so', 'svec_cast_int4'
    LANGUAGE c IMMUTABLE STRICT;

CREATE OR REPLACE FUNCTION svec_cast_int8(bigint) RETURNS svec
    AS '$libdir/gp_svec.so', 'svec_cast_int8'
    LANGUAGE c IMMUTABLE STRICT;

CREATE OR REPLACE FUNCTION svec_cast_numeric(numeric) RETURNS svec
    AS '$libdir/gp_svec.so', 'svec_cast_numeric'
    LANGUAGE c IMMUTABLE STRICT;

CREATE OR REPLACE FUNCTION svec_cast_positions_float8arr(bigint[], double precision[], bigint, double precision) RETURNS svec
    AS '$libdir/gp_svec.so', 'svec_cast_positions_float8arr'
    LANGUAGE c IMMUTABLE STRICT;

CREATE OR REPLACE FUNCTION svec_concat(svec, svec) RETURNS svec
    AS '$libdir/gp_svec.so', 'svec_concat'
    LANGUAGE c IMMUTABLE;

CREATE OR REPLACE FUNCTION svec_concat_replicate(integer, svec) RETURNS svec
    AS '$libdir/gp_svec.so', 'svec_concat_replicate'
    LANGUAGE c IMMUTABLE;

CREATE OR REPLACE FUNCTION svec_div(svec, svec) RETURNS svec
    AS '$libdir/gp_svec.so', 'svec_div'
    LANGUAGE c IMMUTABLE STRICT;

CREATE OR REPLACE FUNCTION svec_div_float8arr(svec, double precision[]) RETURNS svec
    AS '$libdir/gp_svec.so', 'svec_div_float8arr'
    LANGUAGE c IMMUTABLE;

CREATE OR REPLACE FUNCTION svec_dot(svec, svec) RETURNS double precision
    AS '$libdir/gp_svec.so', 'svec_dot'
    LANGUAGE c IMMUTABLE STRICT;

CREATE OR REPLACE FUNCTION svec_dot(double precision[], double precision[]) RETURNS double precision
    AS '$libdir/gp_svec.so', 'float8arr_dot'
    LANGUAGE c IMMUTABLE STRICT;

CREATE OR REPLACE FUNCTION svec_dot(svec, double precision[]) RETURNS double precision
    AS '$libdir/gp_svec.so', 'svec_dot_float8arr'
    LANGUAGE c IMMUTABLE STRICT;

CREATE OR REPLACE FUNCTION svec_dot(double precision[], svec) RETURNS double precision
    AS '$libdir/gp_svec.so', 'float8arr_dot_svec'
    LANGUAGE c IMMUTABLE STRICT;

CREATE OR REPLACE FUNCTION svec_eq(svec, svec) RETURNS boolean
    AS '$libdir/gp_svec.so', 'svec_eq'
    LANGUAGE c IMMUTABLE STRICT;

CREATE OR REPLACE FUNCTION svec_l2_cmp(svec, svec) RETURNS integer
    AS '$libdir/gp_svec.so', 'svec_l2_cmp'
    LANGUAGE c IMMUTABLE;

CREATE OR REPLACE FUNCTION svec_l2_eq(svec, svec) RETURNS boolean
    AS '$libdir/gp_svec.so', 'svec_l2_eq'
    LANGUAGE c IMMUTABLE;

CREATE OR REPLACE FUNCTION svec_l2_ge(svec, svec) RETURNS boolean
    AS '$libdir/gp_svec.so', 'svec_l2_ge'
    LANGUAGE c IMMUTABLE;

CREATE OR REPLACE FUNCTION svec_l2_gt(svec, svec) RETURNS boolean
    AS '$libdir/gp_svec.so', 'svec_l2_gt'
    LANGUAGE c IMMUTABLE;

CREATE OR REPLACE FUNCTION svec_l2_le(svec, svec) RETURNS boolean
    AS '$libdir/gp_svec.so', 'svec_l2_le'
    LANGUAGE c IMMUTABLE;

CREATE OR REPLACE FUNCTION svec_l2_lt(svec, svec) RETURNS boolean
    AS '$libdir/gp_svec.so', 'svec_l2_lt'
    LANGUAGE c IMMUTABLE;

CREATE OR REPLACE FUNCTION svec_l2_ne(svec, svec) RETURNS boolean
    AS '$libdir/gp_svec.so', 'svec_l2_ne'
    LANGUAGE c IMMUTABLE;

CREATE OR REPLACE FUNCTION svec_minus(svec, svec) RETURNS svec
    AS '$libdir/gp_svec.so', 'svec_minus'
    LANGUAGE c IMMUTABLE STRICT;

CREATE OR REPLACE FUNCTION svec_minus_float8arr(svec, double precision[]) RETURNS svec
    AS '$libdir/gp_svec.so', 'svec_minus_float8arr'
    LANGUAGE c IMMUTABLE;

CREATE OR REPLACE FUNCTION svec_mult(svec, svec) RETURNS svec
    AS '$libdir/gp_svec.so', 'svec_mult'
    LANGUAGE c IMMUTABLE STRICT;

CREATE OR REPLACE FUNCTION svec_mult_float8arr(svec, double precision[]) RETURNS svec
    AS '$libdir/gp_svec.so', 'svec_mult_float8arr'
    LANGUAGE c IMMUTABLE;

CREATE OR REPLACE FUNCTION svec_plus(svec, svec) RETURNS svec
    AS '$libdir/gp_svec.so', 'svec_plus'
    LANGUAGE c IMMUTABLE STRICT;

CREATE OR REPLACE FUNCTION svec_plus_float8arr(svec, double precision[]) RETURNS svec
    AS '$libdir/gp_svec.so', 'svec_plus_float8arr'
    LANGUAGE c IMMUTABLE;

CREATE OR REPLACE FUNCTION svec_pow(svec, svec) RETURNS svec
    AS '$libdir/gp_svec.so', 'svec_pow'
    LANGUAGE c IMMUTABLE STRICT;

CREATE OR REPLACE FUNCTION svec_return_array(svec) RETURNS double precision[]
    AS '$libdir/gp_svec.so', 'svec_return_array'
    LANGUAGE c IMMUTABLE;


\i /Users/qianh1/p4Repository/tincrepo/team_madlib/mpp/hawq/tests/utilities/upgrade/test_dir/load_madlib_success.sql

CREATE OR REPLACE FUNCTION bool_to_text (BOOLEAN)
RETURNS TEXT
STRICT
LANGUAGE SQL AS $$
    SELECT CASE
        WHEN $1 THEN $SQL$t$SQL$
        ELSE $SQL$f$SQL$
    END;
$$;
