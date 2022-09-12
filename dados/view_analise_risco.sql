create or replace view   dados_analise_risco as
select
ids.person_id id_solic
, dados_mutuarios.person_age idade_solic
, dados_mutuarios.person_income salario_anual_solic

, IFNULL(ELT(FIELD(dados_mutuarios.person_home_ownership,
       'Rent', 'Own', 'Mortgage', 'Other'),'Alugada','Própria','Hipotecada','Outros'),
       'Outros') situacao_prop_solic

, dados_mutuarios.person_emp_length anos_trab_solic
, IFNULL(ELT(FIELD(emprestimos.loan_intent,
       'Venture', 'Personal', 'Medical', 'Homeimprovement', 'Education', 'Debtconsolidation'),'Empreendimento','Pessoal','Médico','Melhora do lar','Educativo','Pagamento de débitos'),
       'Outros') motivo_emprestimo
, emprestimos.loan_amnt valor_ttl_emprestimo
, emprestimos.loan_grade pontuacao_emprestimo
, emprestimos.loan_int_rate tx_juros
, emprestimos.loan_percent_income renda_percentual
, IFNULL(ELT(FIELD(emprestimos.loan_status,
       1, 0),'Sim','Não'),
       null) possibilidade_inad

, historicos_banco.cb_person_cred_hist_length anos_credito 
, IFNULL(ELT(FIELD(historicos_banco.cb_person_default_on_file,
       'Y', 'N', 'YES', 'NO'),'Sim','Não','Sim','Não'),
       null) ja_inadimplente
       
from ids, dados_mutuarios, emprestimos, historicos_banco
where ids.person_id = dados_mutuarios.person_id
and ids.loan_id = emprestimos.loan_id
and ids.cb_id = historicos_banco.cb_id
order by ids.person_id;


SELECT * FROM dados_analise_risco
INTO OUTFILE '\dados_analise_risco.csv'
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n';
