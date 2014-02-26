--
-- Greenplum Database database dump
--

SET statement_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = off;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET escape_string_warning = off;

SET default_with_oids = false;

--
-- Name: GPDUMPGUC; Type: INTERNAL GUC; Schema: -; Owner:
--

SET gp_called_by_pgdump = true;


SET search_path = madlibtestdata, pg_catalog;

SET default_tablespace = '';

--
-- Name: kyphosis; Type: TABLE; Schema: madlibtestdata; Owner: qianh1; Tablespace:
--

CREATE TABLE kyphosis (
    kyphosis text,
    age integer,
    number integer,
    start integer,
    id integer NOT NULL
)
WITH (appendonly=true) DISTRIBUTED RANDOMLY;



--
-- Name: kyphosis_id_seq; Type: SEQUENCE; Schema: madlibtestdata; Owner: qianh1
--

CREATE SEQUENCE kyphosis_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE madlibtestdata.kyphosis_id_seq OWNER TO qianh1;

--
-- Name: kyphosis_id_seq; Type: SEQUENCE OWNED BY; Schema: madlibtestdata; Owner: qianh1
--

ALTER SEQUENCE kyphosis_id_seq OWNED BY kyphosis.id;


--
-- Name: kyphosis_id_seq; Type: SEQUENCE SET; Schema: madlibtestdata; Owner: qianh1
--

SELECT pg_catalog.setval('kyphosis_id_seq', 81, true);


--
-- Name: id; Type: DEFAULT; Schema: madlibtestdata; Owner: qianh1
--

ALTER TABLE kyphosis ALTER COLUMN id SET DEFAULT nextval('kyphosis_id_seq'::regclass);


--
-- Data for Name: kyphosis; Type: TABLE DATA; Schema: madlibtestdata; Owner: qianh1
--

COPY kyphosis (kyphosis, age, number, start, id) FROM stdin;
absent	158	3	14	1
present	128	4	5	21
absent	2	5	1	22
absent	71	3	5	61
absent	1	2	16	2
absent	61	2	17	23
absent	37	3	16	24
absent	1	4	15	62
present	59	6	12	3
present	82	5	14	25
absent	148	3	16	26
absent	113	2	16	63
absent	1	4	12	4
absent	168	3	18	27
absent	1	3	16	28
absent	18	5	2	64
absent	175	5	13	5
absent	80	5	16	29
absent	27	4	9	30
absent	78	6	15	65
present	105	6	5	6
present	96	3	12	31
absent	131	2	3	32
absent	22	2	16	66
absent	9	5	13	7
absent	8	3	6	33
absent	100	3	14	34
present	15	7	2	67
absent	151	2	16	8
absent	31	3	16	35
absent	125	2	11	36
absent	4	3	16	68
absent	112	3	16	9
absent	140	5	11	37
absent	93	3	16	38
absent	130	5	13	69
present	52	5	6	10
absent	20	6	9	39
present	91	5	12	40
absent	1	3	9	70
absent	35	3	13	11
absent	143	9	3	41
absent	61	4	1	42
present	73	5	1	71
present	139	3	10	12
absent	136	4	15	43
absent	131	5	13	44
absent	97	3	16	72
absent	177	2	14	13
absent	68	5	10	45
absent	9	2	17	46
present	121	3	3	73
absent	2	2	17	14
absent	140	4	15	47
absent	72	5	15	48
present	139	10	6	74
present	120	5	8	15
absent	51	7	9	49
absent	102	3	13	50
absent	2	3	13	75
present	114	7	8	16
absent	81	4	1	51
absent	118	3	16	52
present	130	4	1	76
absent	17	4	10	17
absent	195	2	17	53
absent	159	4	13	54
absent	118	4	16	77
absent	15	5	16	18
absent	158	5	14	55
absent	127	4	12	56
absent	18	4	11	78
absent	206	4	10	19
absent	11	3	15	57
absent	178	4	15	58
absent	87	4	16	79
absent	26	7	13	20
absent	120	2	13	59
present	42	7	6	60
present	157	3	13	80
absent	36	4	13	81
\.


--
-- Greenplum Database database dump complete
--

