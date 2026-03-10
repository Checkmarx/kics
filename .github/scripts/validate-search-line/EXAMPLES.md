"""
Exemplos de como usar searchLine corretamente em queries KICS
"""

# ===== EXEMPLO 1: Query com build_search_line =====
# arquivo: assets/queries/cicd/example_query/query.rego

"""
package Cx

import data.generic.common as common_lib

CxPolicy[result] {
    # Procura um campo específico na configuração
    config := input.document[i].jobs[j].steps[k].run
    
    # Verifica se contém padrão malicioso
    contains(config, "dangerous")
    
    result := {
        "documentId": input.document[i].id,
        "searchKey": sprintf("run={{%s}}", [config]),
        "issueType": "IncorrectValue",
        "keyExpectedValue": "Run block is safe",
        "keyActualValue": "Run block contains dangerous code",
        # NÃO use -1! Use build_search_line com o path correto
        "searchLine": common_lib.build_search_line(["jobs", j, "steps", k, "run"],[]),
        "searchValue": config
    }
}
"""

# ===== EXEMPLO 2: Query sem build_search_line =====
# (Menos recomendado, mas possível)

"""
package Cx

CxPolicy[result] {
    # Se a structure é fixa e você quer retornar uma linha específica
    resource := input.document[i].resources[name]
    line := resource.line  # Obtém a linha do campo
    
    result := {
        "documentId": input.document[i].id,
        "searchKey": sprintf("resource.%s", [name]),
        "issueType": "IncorrectValue",
        # Se você tem acesso à linha, pode usá-la directamente
        "searchLine": line,  # ✅ VÁLIDO se line é a linha correcta
        ...
    }
}
"""

# ===== EXEMPLO 3: Ficheiro de teste esperado =====
# arquivo: assets/queries/cicd/example_query/test/positive_expected_result.json

"""
[
  {
    "queryName": "Example Query Name",
    "severity": "HIGH",
    "line": 5,
    "searchLine": 5  # Opcional em expected_result.json, mas se presente, deve==line
  }
]
"""

# ===== EXEMPLO 4: build_search_line internamente =====

"""
A função common_lib.build_search_line() faz:

1. Recebe um path: ["jobs", 0, "steps", 1, "run"]
2. Navega na estrutura JSON/YAML do documento
3. Encontra a linha (linha_do_arquivo) onde aquele field está
4. Retorna essa linha

Exemplo com YAML:
jobs:           # linha 1
  test:         # linha 2
    steps:      # linha 3
      - name: test  # linha 4
        run: npm test  # linha 5  ← searchLine retornará 5
        
build_search_line(["jobs", "test", "steps", 0, "run"], [])
                  → linha 5
"""

# ===== COMPARAÇÃO FINAL =====

"""
✅ CORRETO:
result := {
    "line": 10,
    "searchLine": 10,  # Igual ao line
    ...
}

✅ TAMBÉM CORRETO:
result := {
    "line": 10,
    # Nenhum searchLine = será calculado automaticamente
    ...
}

❌ ERRADO:
result := {
    "line": 10,
    "searchLine": -1,  # Não pode ser -1!
    ...
}

❌ ERRADO:
result := {
    "line": 10,
    "searchLine": 5,  # Não corresponde a line!
    ...
}
"""
