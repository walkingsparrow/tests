select madlib.__array_sum(pg_temp_2.__madlib_temp_67014163_1385193538_44910278__(array[("length_opr"), ("diameter_opr"), ("height_opr"), ("whole_opr"), ("shucked_opr"), ("viscera_opr"), ("shell_opr")], array[((("p")::double precision * (-("p")::double precision + (1)))::double precision * ("length_opr")), ((("p")::double precision * (-("p")::double precision + (1)))::double precision * ("diameter_opr")), ((("p")::double precision * (-("p")::double precision + (1)))::double precision * ("height_opr")), ((("p")::double precision * (-("p")::double precision + (1)))::double precision * ("whole_opr")), ((("p")::double precision * (-("p")::double precision + (1)))::double precision * ("shucked_opr")), ((("p")::double precision * (-("p")::double precision + (1)))::double precision * ("viscera_opr")), ((("p")::double precision * (-("p")::double precision + (1)))::double precision * ("shell_opr"))])) as "cross_prod", madlib.__array_sum(pg_temp_2.__madlib_temp_67014163_1385193538_44910278__(array[((("p")::double precision * (-("p")::double precision + (1)))::double precision * ("length_opr")), ((("p")::double precision * (-("p")::double precision + (1)))::double precision * ("diameter_opr")), ((("p")::double precision * (-("p")::double precision + (1)))::double precision * ("height_opr")), ((("p")::double precision * (-("p")::double precision + (1)))::double precision * ("whole_opr")), ((("p")::double precision * (-("p")::double precision + (1)))::double precision * ("shucked_opr")), ((("p")::double precision * (-("p")::double precision + (1)))::double precision * ("viscera_opr")), ((("p")::double precision * (-("p")::double precision + (1)))::double precision * ("shell_opr"))], array[("y")])) as "cross_prod.1", avg((("p")::double precision * (-("p")::double precision + (1)))::double precision * ("length_opr")) as "p_p_opr_opr_length_opr_opr_avg", avg((("p")::double precision * (-("p")::double precision + (1)))::double precision * ("diameter_opr")) as "p_p_opr_opr_diameter_opr_opr_avg", avg((("p")::double precision * (-("p")::double precision + (1)))::double precision * ("height_opr")) as "p_p_opr_opr_height_opr_opr_avg", avg((("p")::double precision * (-("p")::double precision + (1)))::double precision * ("whole_opr")) as "p_p_opr_opr_whole_opr_opr_avg", avg((("p")::double precision * (-("p")::double precision + (1)))::double precision * ("shucked_opr")) as "p_p_opr_opr_shucked_opr_opr_avg", avg((("p")::double precision * (-("p")::double precision + (1)))::double precision * ("viscera_opr")) as "p_p_opr_opr_viscera_opr_opr_avg", avg((("p")::double precision * (-("p")::double precision + (1)))::double precision * ("shell_opr")) as "p_p_opr_opr_shell_opr_opr_avg", avg("length_opr") as "length_opr_avg", avg("diameter_opr") as "diameter_opr_avg", avg("height_opr") as "height_opr_avg", avg("whole_opr") as "whole_opr_avg", avg("shucked_opr") as "shucked_opr_avg", avg("viscera_opr") as "viscera_opr_avg", avg("shell_opr") as "shell_opr_avg", avg(("y")::integer) as "y_avg" from "pg_temp_2"."__madlib_temp_46498179_1385193537_36746346__"