# #!/usr/bin/env bash
#
#######################
#    ^...^  `^...^´   #
#   /_o,o_\ /_O,O_\   #
#   |):::(| |):::(|   #
# ====" "=====" "==== #
#         TdC         #
#      1998-2026      #
#######################
#
# Toca das Corujas
# Códigos Binários,
# Funções de Onda e
# Teoria do Orbital Molecular Inc.
# Unidade Barão Geraldo CX
#
read -r -p "Localização de A.txt: " arquivo_a
read -r -p "Localização de B.txt: " arquivo_b

if [[ ! -f "$arquivo_a" ]]; then
    echo "Erro: arquivo A não encontrado: $arquivo_a"
    exit 1
fi

if [[ ! -f "$arquivo_b" ]]; then
    echo "Erro: arquivo B não encontrado: $arquivo_b"
    exit 1
fi

arquivo_c="C.txt"

# Evita que a saída sobrescreva um dos arquivos de entrada.
if [[ -e "$arquivo_c" ]] &&
   { [[ "$arquivo_a" -ef "$arquivo_c" ]] || [[ "$arquivo_b" -ef "$arquivo_c" ]]; }; then
    echo "Erro: $arquivo_c é um dos arquivos de entrada."
    exit 1
fi

echo
echo "MENU"
echo "OPÇÃO 1: criar C = A - B"
echo "OPÇÃO 2: criar C = B - A"
echo "OPÇÃO 3: criar C = A + B (entradas únicas)"
echo "OPÇÃO 4: criar C = A ∩ B (linhas em comum)"
echo "OPÇÃO 5: comparar pacotes em comum e suas versões"

read -r -p "Escolha uma opção: " opcao

case "$opcao" in
    1)
        # Linhas que estão em A, mas não em B.
        grep -F -x -v -f "$arquivo_b" "$arquivo_a" > "$arquivo_c"
        ;;
    2)
        # Linhas que estão em B, mas não em A.
        grep -F -x -v -f "$arquivo_a" "$arquivo_b" > "$arquivo_c"
        ;;
    3)
        # Junta A e B, remove linhas repetidas e mantém a primeira ocorrência.
        awk '!v[$0]++' "$arquivo_a" "$arquivo_b" > "$arquivo_c"
        ;;
    4)
        # Linhas que aparecem nos dois arquivos; remove duplicatas no resultado.
        grep -F -x -f "$arquivo_a" "$arquivo_b" | awk '!v[$0]++' > "$arquivo_c"
        ;;
    5)
        {
            printf "pacote\tversão em A\tversão em B\n"

            # Evita a comparação incorreta quando A está vazio.
            if [[ -s "$arquivo_a" ]]; then
                awk '
                    FILENAME == ARGV[1] {
                        if (NF >= 2 && !($1 in versao_a)) {
                            versao_a[$1] = $2
                        }
                        next
                    }
                    NF >= 2 && ($1 in versao_a) && !($1 in vistos_b) {
                        print $1 "\t" versao_a[$1] "\t" $2
                        vistos_b[$1] = 1
                    }
                ' "$arquivo_a" "$arquivo_b"
            fi
        } > "$arquivo_c"
        ;;
    *)
        echo "Opção inválida."
        exit 1
        ;;
esac

echo "Resultado salvo em: $arquivo_c"
