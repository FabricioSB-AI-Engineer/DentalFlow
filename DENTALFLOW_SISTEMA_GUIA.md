# DentalFlow — guia do ambiente local

## Ponto de retomada

O projeto contém a interface React/Vite em `dentalflow-app`, a API Express em `dentalflow-backend` e os repositórios de referência A360 em `a360-repos`. A continuação de 6 de novembro de 2026 preserva as telas existentes e torna verificáveis as ações de cadastro, confirmação, funil e simulação de recall.

Esta é uma aplicação local de demonstração. A base inicial contém exemplos. WhatsApp, Twilio, Meta e Simples Dental não estão conectados; não há envio de mensagens, ligações, publicações ou sincronização com essas plataformas. O Copilot responde por regras e consulta os registros locais; não usa um modelo de IA externo.

## Iniciar

Requer Node.js compatível com as dependências instaladas (22.12 ou superior).

1. Se necessário, execute `npm install` dentro de `dentalflow-backend` e de `dentalflow-app`.
2. Abra `iniciar-sistema.bat` na raiz.
3. Espere a mensagem de verificação e abra **http://127.0.0.1:5173**.
4. Mantenha o terminal aberto. Use **Ctrl+C** para encerrar os dois serviços.

O inicializador verifica as portas 3001 e 5173, inicia os dois processos e consulta a API diretamente e pelo proxy da interface. Uma porta ocupada ou falha de inicialização produz um erro explícito. Ele não encerra processos preexistentes.

Também é possível executar `node scripts/start-system.cjs`. Para verificar a inicialização e encerrar automaticamente, use `node scripts/start-system.cjs --check`.

## Fluxos disponíveis

- **Dashboard:** visão dos dados locais. Elementos históricos ilustrativos são identificados como exemplos; não representam faturamento real ou resultados comprovados de agentes.
- **Anti No-Show:** confirmação manual persistida de consultas. A confirmação só aparece como salva após resposta da API.
- **Venda de Casos:** avanço das etapas do funil. Um caso aceito não volta ao início automaticamente.
- **Recall:** registra uma simulação local, sem anunciar uma mensagem como enviada a um paciente.
- **Esquadrão A360:** consulta do estado local, histórico de ações, Copilot por regras e simulação de mensagem recebida.
- **Prontuários CRM:** busca e cadastro de pacientes. Falhas preservam os dados preenchidos para correção ou nova tentativa.

Quando a API está indisponível, a interface informa a falha e permite tentar novamente. Não cria confirmações ou cadastros fictícios como alternativa a uma gravação que falhou.

## Dados e configuração

O arquivo persistente é `dentalflow-backend/data.json`. Faça uma cópia antes de intervenções manuais. O arquivo não deve ser versionado com dados reais. A gravação usa substituição de arquivo temporário; um JSON inválido produz erro em vez de ser silenciosamente substituído pela base de exemplo.

Variáveis do backend:

| Variável | Uso |
| --- | --- |
| `PORT` | Porta da API ao iniciar separadamente (padrão 3001). |
| `HOST` | Endereço de escuta (padrão loopback `127.0.0.1`). |
| `DENTALFLOW_DB_FILE` | Caminho de uma base alternativa, útil para testes isolados. |
| `CRM_INGEST_TOKEN` | Segredo do webhook de entrada. Sem esta variável, o webhook retorna 503; o simulador local continua disponível. |

O inicializador integrado utiliza as portas 3001 e 5173. A interface usa `/api` pelo proxy do Vite. `VITE_API_URL` permite definir outra URL da API na configuração do frontend. Variáveis `VITE_*` são públicas no navegador: nunca coloque segredos nelas.

O arquivo JSON atende um único processo local. Esta versão não possui autenticação de usuários, isolamento entre clínicas nem infraestrutura de produção; não a exponha como serviço público.

## Simulação de mensagens

A interface usa `POST /api/crm/simulate`, com `phone`, `name` opcional e `messageText`. A simulação pode alterar uma consulta local correspondente e grava um log identificado como simulação.

O reconhecimento utiliza o telefone normalizado. Não usa nomes vazios para escolher a primeira consulta; telefones desconhecidos, correspondências ambíguas e mensagens negativas não devem confirmar uma consulta indevidamente. O endpoint com token, `POST /api/crm/ingest/:token`, é separado do simulador e requer configuração no backend. Isso não conecta um provedor de WhatsApp automaticamente.

## Verificação

No diretório `dentalflow-backend`, execute `npm test`. A suíte usa bases temporárias, sem alterar `data.json`.

No diretório `dentalflow-app`, execute `npm run build` para verificar TypeScript e gerar o frontend.

Na raiz, execute `node scripts/start-system.cjs --check` para verificar a inicialização e a conexão entre frontend e backend.

Validação realizada nesta continuação: 11 testes de API aprovados, build TypeScript/Vite aprovado e fluxos verificados no Chrome com uma base isolada: busca, erro de cadastro com preservação do formulário, reconexão, cadastro com origem Instagram, recarga dos registros persistidos, confirmação manual, avanço de caso, recall simulado, mensagem simulada, Copilot e recuperação após falha de rede. A comparação do arquivo original antes e depois confirmou que esses testes não o alteraram. O inicializador também foi verificado com base temporária.

## Próxima etapa

Para evoluir além da demonstração local: escolher uma integração real, configurar credenciais apenas no servidor, implementar autenticação e testar o fluxo com dados autorizados. O nome dos agentes e os repositórios A360 são referências de projeto; não comprovam a execução de serviços externos.
