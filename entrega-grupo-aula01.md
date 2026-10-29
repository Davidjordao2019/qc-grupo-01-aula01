# Entrega Aula <01> — Grupo <01>

**Disciplina:** Cloud & Cognitive Environments — FIAP MBA AI Engineering & Multi-Agents
**Turma:** <6AIER>
**Data de entrega:** <28/10/2026>

## Grupo

| # | Nome completo | GitHub | E-mail FIAP |
|---|---------------|--------|-------------|
| 1 | David Jordao | https://github.com/Davidjordao2019/qc-grupo-01-aula01 | rm379349@fiap.com.br |
| 2 | | | |
| 3 | | | |
| 4 | | | |
| 5 | | | |

## Distribuição do trabalho

| Membro | Nível assumido | Item específico |
|--------|----------------|-----------------|
| David Jordao | 🟢 N1 | Exercícios 1.1, 1.2, 1.3 |
| David Jordao | 🟡 N2 | Exercício 2.1 — Arquitetura QC |
| David Jordao | 🟡 N2 | Exercício 2.2 — Comparativo |
| David Jordao | 🔴 N3 (bônus) | Exercício 3.1 — IaC avançado |
| David Jordao | 🟢 N1 (apoio) | Revisão das respostas N1 |

> Regra: cada membro deve ter pelo menos uma contribuição. O **rodízio entre aulas** (quem fez N1 antes faz N2 depois) é incentivado e vale o ponto do Critério 4 (ver [rubrica.md](rubrica.md)).

---

## 🟢 Nível 1 — Respostas

Para cada serviço, identifique se é IaaS, PaaS, SaaS ou FaaS. Justifique em uma frase.

| Serviço | Modelo (IaaS/PaaS/SaaS/FaaS) | Justificativa |
|---------|------------------------------|---------------|
| Gmail | SaaS | Usuário só utiliza o Serviços |
| Azure Virtual Machines | IaaS | Cliente gerencia SO, Middleware, Runtime, Data, Applications |
| Azure App Service (hospedar uma API) | PaaS | Cliente gerencia Data, Applications |
| AWS Lambda | FaaS | Cliente gerencia funções |
| Azure SQL Database | PaaS | Cliente gerencia SO, Middleware, Runtime, Data, Applications |
| Salesforce CRM | SaaS | Usuário só utiliza o Serviços |
| Google Kubernetes Engine (GKE) | PaaS/IaaS | Cliente gerencia pods, Data, Applications |
| Azure Blob Storage | PaaS | Cliente gerencia Data, Applications |
| Azure OpenAI Service | SaaS | Usuário só utiliza o Serviços  |


---

## 🟡 Nível 2 — Respostas + Implementação

### Exercício 2.1 — Arquitetura de alto nível: Quantum Commerce

**Contexto:** A Quantum Commerce é um gigante do e-commerce com 12 países, 5M de SKUs, e quer transformar a experiência de compra com IA conversacional.

**Sua tarefa (em grupo):** Proponha uma arquitetura de alto nível em cloud para a QC. Identifique:

1. **Camadas da arquitetura** — quantas e o que cada uma faz (ex: frontend, API, dados, AI/ML, observabilidade)
2. **Provedor principal** — qual escolheria (Azure, AWS, GCP) e por quê
3. **Serviços por categoria** — preencha a tabela:

| Categoria | Serviço Azure | Alternativa AWS | Alternativa GCP |
|-----------|--------------|-----------------|-----------------|
| Compute (backend) | | | |
| Storage (catálogo, imagens) | | | |
| Banco relacional | | | |
| Banco NoSQL | | | |
| Vector Database | | | |
| Serviços de IA cognitivos | | | |
| CDN | | | |
| Mensageria/Filas | | | |
| Observabilidade (logs/métricas) | | | |

4. **Diagrama** — feito no Excalidraw (excalidraw.com), draw.io (diagrams.net) ou à mão fotografado. **Tudo sem instalação.**

> **Entrega:** O grupo commita o esboço (`respostas-aula01.md` + imagem do diagrama) no fork até 1 dia antes da Aula 2. O professor dá feedback escrito durante a semana. O diagrama evolui a cada aula até a entrega final na Aula 6.

---

---

## 🔴 Nível 3 — Bônus (se aplicável)

(Respostas + scripts/links)

---

## Reflexão coletiva

3-5 parágrafos respondendo:

1. O que o grupo aprendeu de mais importante nesta aula?
2. Como isso se conecta com a arquitetura cloud de uma plataforma agentic?
3. Que decisão arquitetural vocês fariam diferente se começassem o projeto QC hoje?

---

## Artefatos do ZIP

- Diagrama: `diagramas/arquitetura-qc-aulaXX.png`
- Código IaC: `terraform/`
- Scripts: `scripts/`
- Endpoint ativo (se houver): URL pública sem credenciais — apenas para demonstração durante a janela de correção
