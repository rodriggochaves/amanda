require_relative './billy_bot'

# TODOS
# 1) Rodar analisador apenas sobre arquivos modificados no commit
# 2) Criar branch novo com alterações
# 3) Criar pull-request e realizar push
# 4) Criar comentários amigáveis no pull-request
# 5) Criar uma gema com o projeto
# 6) Criar api para automatizar o processo de correção
# 7) Expandir para outras linguagens

BillyBot.new("rodriggochaves/literate-lamp", "-R")