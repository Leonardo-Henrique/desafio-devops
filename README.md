### Visão geral do objetivo

O desafio consiste em lançar, em produção, uma aplicação dockerizada.

### Abordagem inicial

Como relatado em nossa reunião, não havia trabalhado, anteriormente, com Docker e nem outra ferramenta de integração contínua, como o Jenkins. Entretanto, acredito que nossa evolução ocorre justamente nos pontos de ruptura e de quebra com o status quo – ou seja, somente nos tornamos pessoas e profissionais melhores quando nos permitimos à novos horizontes.

Desta forma, minha abordagem inicial fora realizar uma varredura de todas as tecnologias que integrariam o desafio, para então buscar me inserir no contexto de tais aplicações com a finalidade de prosseguir o desenvolvimento do desafio. 

Meu primeiro passo, então, foi realizar um clone do repositório disponibilizado pelo desafio. Em primeira vista, identifiquei a utilização do Docker (o arquivo dockerfile já estava criado) para conteinerizar uma aplicação web em Python.

Neste momento, meus esforços se concentraram em adquirir o máximo de conhecimento sobre Docker no tempo que eu tinha disponível. Consultei o site oficial da aplicação em https://www.docker.com/ e comecei a estudar sobre os passos iniciais, tais como os conceitos importantes como imagens, contêineres e layers. Assim que soube do Docker Desktop, realizei download e instalei na minha máquina. A partir deste ponto, testei uma série de comandos essenciais como 

`Docker pull <nome da imagem> `para baixar uma imagem do Dockerhub
Docker images para visualizar as imagens já baixadas
`Docker rmi <nome da imagem>` para remover uma imagem
`Docker run <nome da imagem>` para inicializar uma imagem, que nesse caso, se transforma em um container 
`Docker ps e` `docker ps -a `para visualizar as imagens ativas (e recentes)
`Docker stop <nome ou id do container>` para parar a execução de um container
`Docker start <nome ou id do container>` para iniciar  a execução de um container

Após essa contextualização inicial, meu foco se concentrou em fazer a aplicação rodar em minha máquina. Na raiz do projeto no Github, possuía as indicações de como inicializar aquela aplicação, decidir seguí-los.

`docker build -t python-web-app . `era o step inicial, porém obtive diversos erros no log referente à versão do Python que eu estaria utilizando para executar a imagem. Tentei, então atualizá-lo, entretanto, não obtive sucesso. Pesquisando, observei que o alpine possuía versão mais atual, então indiquei para fazer o download da versão mais recente, porém, novamente, não tive êxito. Pesquisando mais, vi que muitas pessoas apontavam a versão 3.7 como sendo estável e perfeita para uso, resolvi testar e a imagem foi construída com sucesso.

Logo após, rodei docker `run -it -p 5000:5000 python-web-app` e a aplicação estava executando no localhost:5000. 




### Ambientação com Jenkins

Meu objetivo agora era criar um ambiente local de automação de deploy, escolhi o Jenkins como ferramenta de CI/CD. Após ler sobre os pontos principais da aplicação, baixei o arquivo .war do Jenkins, criei um bat para executá-lo na porta 8000. Segui a instalação convencional e comecei a construção da automação. 

Criei um job em modo free-style, que baixa o código da aplicação do repositório, e roda os comandos necessários para construção da imagem e execução dela (Docker build e Docker run). 

[![Job iniciando](https://i.imgur.com/9hO1jhX.jpg "Job iniciando")](https://i.imgur.com/9hO1jhX.jpg "Job iniciando")

[![](https://i.imgur.com/XuSfT6k.jpg)](https://i.imgur.com/XuSfT6k.jpg)

[![](https://i.imgur.com/hILWE8m.jpg)](https://i.imgur.com/hILWE8m.jpg)

[![](https://i.imgur.com/6HTUvFA.jpg)](https://i.imgur.com/6HTUvFA.jpg)

[![](https://i.imgur.com/THJruxB.jpg)](https://i.imgur.com/THJruxB.jpg)

Executando este job, visualizou-se pelos logs que a operação foi completada com sucesso, sendo possível acessar a aplicação na porta 5000 no localhost.

### Servidor remoto

Uma vez validada toda a execução da aplicação à nível local, iniciei o processo de replicação em um servidor remoto. Como tenho conhecimento básico em alguns serviços Amazon Web Services tais como EC2 e S3, optei por utilizar os serviços dessa cloud provider. Entretanto, devido à ausência de experiência com Docker e servidores AWS enfrentei alguns percalços na configuração de um ambiente adequado para deploy de uma aplicação dockerizada.

Minha ideia inicial era replicar a estrutura Jenkins e Docker que criei em minha máquina local. Para tanto, utilizei uma t3.medium como servidor e instalei git, Jenkins e Java. Meu primeiro percalço tange quanto ao suporte do Windows Server com Docker Desktop, aplicação que eu estava utilizando localmente para gerenciar as imagens e contêineres Docker. Em minhas pesquisas observei que não há suporte adequado para ele e que a forma mais adequada é instalar os módulos do Docker através do PowerShell.  

`Install-Module -Name DockerMsftProvider -Repository PSGallery -Force`
`Install-Package -Name docker -ProviderName DockerMsftProvider`
`Start-Service Docker`

Além disso, instalei manualmente os componentes do Hyper-V, necessários para virtualização na máquina.

`Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V -All`
`Add-WindowsFeature Hyper-V-Tools`
`Add-WindowsFeature Hyper-V-PowerShell `

Com o Docker instalado na EC2, configurei o Jenkins para realizar o clone do repositório e posteriormente o deploy na porta 5000. Ao rodar o job, me deparei com o erro do tipo`“no matching manifest for windows/amd64 in the manifest list entries”`. Esse erro é comumente quando estamos tentando executar uma imagem baseada em uma arquitetura de sistema operacional diferente do sistema operacional principal. Para resolver este problema foi necessário configurar a arquitetura de execução para Linux (o que poderia ser facilmente feito através do Docker Desktop), através do download do pacote de contêineres para Linux na pasta Linux Containers em Program Files:

`curl -OutFile release.zip https://github.com/linuxkit/lcow/releases/download/v4.14.35-v0.3.9/release.zip`
`Expand-Archive -DestinationPath . .\release.zip`
`rm release.zip`

(Basicamente, baixei o .zip, extraí os arquivos e excluí o .zip)

Entretanto, continuei recebendo o mesmo erro na execução do Job. Pesquisando sobre os possíveis motivos, observei que há relação direta com a virtualização aninhada (nested virtualization) da máquina, que na instância utilizada, estava desativada. Até o momento, somente máquinas do tipo Bare Metal nativas AWS possuem essa função ativada.

Além disso, verifiquei outros serviços AWS como Elastic Beanstalk, CodePipeline e CodeBuild que considero serem mais adequados para a realização da orquestração, build e deploy de uma aplicação contenireizada. Como meu tempo foi curto esta semana, não consegui aprofundar nestas ferramentas, mas estas seriam as próximas aplicações a que eu recorreria para poder concluir o desafio.

Apesar de não ter conseguido executar a aplicação em um servidor remoto, considero de extremo proveito todo o conhecimento que angariei ao longo do desafio, principalmente por sair do total 0 com relação à Jenkins e Docker e chegar a um nível de compreensão dos conceitos fundamentais bem como arquitetura de Windows Server (também tentei utilizar Jenkinsfile e docker-compose, mas depois de alguns testes, julguei que não era de extrema necessidade para o desafio). Espero que as informações dispostas aqui sejam úteis na tomada de decisão de vocês. Além disso, os erros que foram acontecendo ao longo do caminho me ajudaram a ter uma visão mais geral sobre essas aplicações. Aguardo ansiosamente pelo retorno e agradeço a oportunidade!


