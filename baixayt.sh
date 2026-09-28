#!/usr/bin/env bash
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
# 2026_09_27_19_22_07

# Obtém o conteúdo da área de transferência.
# As aspas preservam caracteres especiais, como &, ?, = e #.
URL="$(xclip -selection clipboard -o | tr -d '\r\n')"

# Remove espaços no início e no final.
URL="${URL#"${URL%%[![:space:]]*}"}"
URL="${URL%"${URL##*[![:space:]]}"}"

# Verifica se o conteúdo parece ser uma URL válida
# ou uma ID de vídeo com 11 caracteres.
if [[ ! "$URL" =~ ^https?://[^[:space:]]+$ &&
      ! "$URL" =~ ^[A-Za-z0-9_-]{11}$ ]]; then

    echo "Erro: o clipboard não contém uma URL ou ID válida."
    echo "Conteúdo encontrado: $URL"
    exit 1
fi

# Se o clipboard contiver somente uma ID, transforma em URL do YouTube.
if [[ "$URL" =~ ^[A-Za-z0-9_-]{11}$ ]]; then
    URL="https://www.youtube.com/watch?v=$URL"
fi

# Menu de opções
echo
echo "URL/ID detectada:"
echo "$URL"
echo
echo "Escolha o tipo de download:"
echo
echo "1) MP4 compatível com WhatsApp — até 720p"
echo "2) Live desde o início — MKV"
echo "3) MP4 original — sem conversão completa"
echo "4) Melhor qualidade disponível — MKV"
echo "5) MP4 compatível — sem limite de resolução"
echo "6) MP4 compatível — usando o título do vídeo"
echo "0) Cancelar"
echo

read -rp "Digite uma opção [0-6]: " OPCAO

case "$OPCAO" in

    1)
        # MP4 compatível com WhatsApp:
        # até 720p, H.264, AAC e tamanho reduzido.
        yt-dlp \
            -f "bv*[height<=720][vcodec^=avc1][ext=mp4]+ba[acodec^=mp4a][ext=m4a]/b[height<=720][ext=mp4]" \
            --merge-output-format mp4 \
            --recode-video mp4 \
            --postprocessor-args "VideoConvertor:-c:v libx264 -preset veryfast -crf 25 -c:a aac -b:a 128k -pix_fmt yuv420p -movflags +faststart" \
            "$URL"
        ;;


    2)
        # Live desde o início, salvando no contêiner MKV.
        yt-dlp \
            -f "bv*+ba/b" \
            --live-from-start \
            --merge-output-format mkv \
            "$URL"
        ;;

    3)
        # MP4 original, sem conversão completa.
        yt-dlp \
            -f "bv*[ext=mp4]+ba[ext=m4a]/b[ext=mp4]" \
            --merge-output-format mp4 \
            "$URL"
        ;;



    4)
        # Melhor qualidade disponível, sem limite de resolução.
        # Salva no contêiner MKV.
        yt-dlp \
            -f "bv*+ba/b" \
            --merge-output-format mkv \
            "$URL"
        ;;

    5)
        # MP4 compatível, sem limite de resolução.
        # Converte para H.264 + AAC.
        yt-dlp \
            -f "bv*[vcodec^=avc1][ext=mp4]+ba[acodec^=mp4a][ext=m4a]/b[ext=mp4]" \
            --merge-output-format mp4 \
            --recode-video mp4 \
            --postprocessor-args "VideoConvertor:-c:v libx264 -c:a aac -pix_fmt yuv420p -movflags +faststart" \
            "$URL"
        ;;

    6)
        # MP4 compatível usando o título do vídeo.
        yt-dlp \
            -f "bv*[vcodec^=avc1][ext=mp4]+ba[acodec^=mp4a][ext=m4a]/b[ext=mp4]" \
            --merge-output-format mp4 \
            --recode-video mp4 \
            --postprocessor-args "VideoConvertor:-c:v libx264 -c:a aac -pix_fmt yuv420p -movflags +faststart" \
            -o "%(title)s.%(ext)s" \
            "$URL"
        ;;

    0)
        echo "Operação cancelada."
        exit 0
        ;;

    *)
        echo "Erro: opção inválida."
        exit 1
        ;;

esac
