[![Apply Terraform manifest](https://github.com/andre177/desafio-devops-letscode/actions/workflows/tf-apply.yml/badge.svg)](https://github.com/andre177/desafio-devops-letscode/actions/workflows/tf-apply.yml)
[![Apply Terraform manifest for k8s private resources](https://github.com/andre177/desafio-devops-letscode/actions/workflows/tf-apply-private.yml/badge.svg)](https://github.com/andre177/desafio-devops-letscode/actions/workflows/tf-apply-private.yml)
[![Build backend app and deploy](https://github.com/andre177/desafio-devops-letscode/actions/workflows/backend-ci.yml/badge.svg)](https://github.com/andre177/desafio-devops-letscode/actions/workflows/backend-ci.yml)
[![Build frontend app and deploy](https://github.com/andre177/desafio-devops-letscode/actions/workflows/frontend-ci.yml/badge.svg)](https://github.com/andre177/desafio-devops-letscode/actions/workflows/frontend-ci.yml)

# Desafio DevOps Let's Code by Ada

### Como executar o projeto via GitHub Actions (recomendado):
1. Criar os seguintes secrets do GitHub Actions no seu repositório com sua credencial da AWS com permissão AdministratorAccess (ou semelhante) e Personal Access Token do GitHub com permissão para manipular os secrets do repo:
   - AWS_ACCESS_KEY_ID: `sua-access-key-id-da-aws`
   - AWS_SECRET_ACCESS_KEY: `sua-secret-access-key-da-aws`
   - GH_TOKEN: `seu-personal-access-token-do-github`
2. Executar o workflow `Apply Terraform manifest`. Ao término da execução, aguarde 5 minutos e o cluster já deverá estar acessível. Os seguintes recursos serão criados:
   - VPC e seus demais recursos;
   - Banco de dados RDS;
   - Cluster do K8s e seus respectivos EC2;
   - Bastion host;
   - Vários secrets do AWS Secrets Manager com informações sensíveis que serão utilizadas posteriormente;
3. Adicionar seu usuário na tabela usuários do banco de dados. As credenciais estarão no Secrets Manager;
4. Executar o workflow `Apply Terraform manifest for k8s private resources`. Ele criará o namespace, configmaps, deployments e services via Bastion Host (o cluster é totalmente privado com os EC2 em subnets internas);
5. Alterar o arquivo [environment.ts](frontend/app/src/environments/environment.ts) com a URL do Load Balancer criado pelo service backend-app que sairá como output do Terraform no passo anterior. Também é possível pegar a URL via console;
6. Executar os workflows `Build backend app and deploy` e `Build frontend app and deploy`. Após o término da execução, ambas aplicações estarão disponíveis. Acesse o frontend pela url do Load Balancer do service frontend-app;

#### Observações:
- Para acessar o cluster via kubectl ou Lens, recomendo tunelar seu tráfego usando [sshuttle](https://github.com/sshuttle/sshuttle) (essa private key também acesssa os nodes do cluster). A private key estará no Secrets Manager:
  - `sshuttle -r ubuntu@<ip-bastion-host> 10.10.0.0/24 -vv --ssh-cmd 'ssh -i <path-da-chave>'`
- Para executar o projeto fora do GitHub Actions, execute primeiro o que está na pasta `iac/` e depois na pasta `private-iac/`;
- O cluster será provisionado com 2 workers pois usei o free-tier da AWS e a instância disponível é a *t2.micro*. Ela não suporta as duas aplicações juntas no mesmo node. Eu recomendo fortemente o uso de instâncias maiores;
- Não usei certificado no Load Balancer nem domínio customizado pois usei uma conta apenas com free-tier. A AWS bloqueou meu cartão por alguma razão do destino; :face_exhaling:

#### Pontos de melhoria
1. Colocaria um Chart Museum no cluster e controlaria o versionamento das aplicações com HELM;
2. Configuraria os nodes via Ansible (apesar de ter funcionado muito bem via user-data);
3. Adicionaria certificados no Load Balancer (via ACM) e usaria um domínio customizado para poder habilitar CORS no Spring;


##### Espero que gostem. Um abraço!
###### André Ferreira
