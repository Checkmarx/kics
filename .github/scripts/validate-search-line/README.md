# SearchLine Validation

Esta GitHub Action valida automaticamente que o campo `searchLine` em resultados de queries está correctamente configurado.

## 📋 O que valida?

Para cada query modificada num PR, a ação:

1. **Detecta queries modificadas** - Procura por ficheiros `query.rego` alterados em `assets/queries/`
2. **Valida searchLine** - Verifica que:
   - `searchLine` NÃO é -1 (deve estar definida)
   - Se `searchLine` não é -1, deve ser igual ao valor de `line`

## 📁 Estrutura de uma Query

```
assets/queries/<platform>/<category>/<query-name>/
├── metadata.json        # Metadados da query
├── query.rego          # Implementação da query
└── test/
    ├── positive*.tf    # Testes positivos (devem ser detectados)
    ├── positive*.json  # Resultados esperados
    └── negative*       # Testes negativos (não devem ser detectados)
```

## 🔧 Duas Versões Disponíveis

### 1. **validate-search-line.yaml** (Completa)
- Compila KICS a partir do código fonte
- Executa as queries contra os ficheiros de teste
- Valida os resultados reais gerados

**Triggers:**
```yaml
paths:
  - "assets/queries/**/query.rego"
```

**Vantagens:** Teste mais rigoroso e realista
**Desvantagens:** Mais tempo de execução (compilação do Go)

### 2. **validate-search-line-lite.yaml** (Rápida)
- Análise estática dos ficheiros Rego e JSON
- Sem compilação ou execução de queries
- Mais rápida, ideal para CI/CD rápido

**Triggers:**
```yaml
paths:
  - "assets/queries/**/query.rego"
  - "assets/queries/**/test/*expected_result*.json"
```

**Vantagens:** Executa prontamente, feedback rápido
**Desvantagens:** Não valida comportamento real

### 📌 Recomendação

Use a versão **lite** para feedback rápido, e a versão **completa** para validação robusta antes de merge.

## ✍️ Exemplos de searchLine

### ❌ Evite a hardcoded -1

```rego
result := {
    "searchLine": -1,  // ❌ ERRADO! Causa erro de validação
    ...
}
```

### ✅ Use build_search_line()

```rego
result := {
    "documentId": input.document[i].id,
    "searchKey": sprintf("run={{%s}}", [run]),
    "issueType": "IncorrectValue",
    "searchLine": common_lib.build_search_line(["jobs", j, "steps", k, "run"],[]),
    ...
}
```

## 📊 Valores Especiais

- `searchLine: -1` → ❌ Causa erro (deve estar definida)
- `searchLine: <número>` → ✅ Deve ser igual a `line`

## 🐛 Como Corrigir Erros

### Erro: "searchLine é -1"
- Revise a chamada a `build_search_line()` na query
- Certifique-se que os índices do path estão correctos
- O path deve levar à linha exacta do recurso

### Erro: "searchLine != line"
- O caminho passado a `build_search_line()` não está determinando a linha correcta
- Revise os índices do path da query
- Adicione debug mantendo os prints da query

### Exemplo de Debug

```rego
// Na query, imprima os índices para compreender a estrutura
print_debug := {
    "doc_index": i,
    "jobs_index": j,
    "steps_index": k,
}
```

## 💻 Executar Localmente

### Versão Lite
```bash
cd .github/scripts/validate-search-line/
pip3 install requests
KICS_PR_NUMBER=123 KICS_GITHUB_TOKEN=your_token python3 validate-search-line-lite.py
```

### Versão Completa
```bash
cd .github/scripts/validate-search-line/
pip3 install -r requirements.txt
make build  # Compilar KICS
KICS_PR_NUMBER=123 KICS_GITHUB_TOKEN=your_token python3 validate-search-line.py
```

## 📚 Referências

- [Rego Language Docs](https://www.openpolicyagent.org/docs/latest/policy-language/)
- [KICS Queries](https://docs.kics.io/latest/queries/)
- [Common Lib Functions](../../../assets/libraries/common.rego)
