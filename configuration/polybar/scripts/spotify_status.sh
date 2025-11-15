#!/bin/bash

# Intervalo de atualização em segundos
intervalo=0.5

# Loop infinito
while true; do
    # Verifica o status do Spotify
    status=$(playerctl --player=spotify status 2>/dev/null)

    # Se o Spotify não estiver ativo (fechado)
    if [ -z "$status" ] || [ "$status" == "No players found" ]; then
        echo "󰪏"  # Apenas o ícone do Spotify
        exit 0
    fi

    # Define o número máximo de caracteres
    max_length=10

    # Se o Spotify estiver tocando ou pausado
    if [ "$status" == "Playing" ] || [ "$status" == "Paused" ]; then
        # Pega o nome da música e do artista
        text=$(playerctl --player=spotify metadata --format "{{ artist }} - {{ title }}" 2>/dev/null)
        
        # Define o ícone dependendo do status
        if [ "$status" == "Playing" ]; then
            play_icon="󰏤"  # Ícone de Pause
        elif [ "$status" == "Paused" ]; then
            play_icon="󰐊"  # Ícone de Play
        fi
    fi

    # Limita o número de caracteres do texto
    if [ ${#text} -gt $max_length ]; then
        text="${text:0:$((max_length - 3))}..."  # Adiciona '...' se o texto for muito longo
    fi

    # Exibe com ícones de controle
    echo "%{A:playerctl --player=spotify previous:}󰒮%{A} %{A:playerctl --player=spotify play-pause:}$play_icon%{A} %{A:playerctl --player=spotify next:}󰒭%{A} $text"

    # Espera o intervalo definido antes de rodar novamente
    sleep $intervalo
done
