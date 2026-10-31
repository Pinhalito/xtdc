#!/usr/bin/env bash

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

echo
echo "MENU"
echo "OPÇÃO 1: criar C = A - B"
echo "OPÇÃO 2: criar C = B - A"
echo "OPÇÃO 3: criar C = A + B (entradas únicas)"
read -r -p "Escolha uma opção: " opcao

arquivo_c="C.txt"

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
        cat "$arquivo_a" "$arquivo_b" | awk '!v[$0]++' > "$arquivo_c"
        ;;
    *)
        echo "Opção inválida."
        exit 1
        ;;
esac

echo "Resultado salvo em: $arquivo_c"
