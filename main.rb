require_relative './amanda'

# TODOS
# 0) Generalizar o analisador
# 1) Rodar analisador apenas sobre arquivos modificados no commit
# 2) Criar branch novo com alterações
# 3) Criar pull-request e realizar push
# 3.5) Identificar se o pull request foi aceito ou não
# 4) Criar comentários amigáveis no pull-request
# 5) Criar uma gema com o projeto
# 6) Criar api para automatizar o processo de correção
# 7) Expandir para outras linguagens

Amanda.new("rodriggochaves/literate-lamp", "-R")