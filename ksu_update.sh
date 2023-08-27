#!/bin/bash

# -----------------------------
#   By Akari Nyan - © 2023
# ----------------------------- 

# Define a opção padrão
tag="stable"

# Define a opção padrão
# para remover o aviso KPROBES
remove_kprobes_warning="y"

# Processa os argumentos de linha de comando
while getopts "t:k:h" opt; do
  case $opt in
    t)
      tag="$OPTARG"
      ;;
    k)
      remove_kprobes_warning="$OPTARG"
      ;;
    h)
      echo "Uso: ./ksu_update.sh [-t <tag>] [-k <remover aviso KPROBES>] [-h]"
      echo ""
      echo "Opções:"
      echo "  -t <tag> Seleciona a tag do KernelSU. Opções: stable (padrão), dev (instável)"

      echo "  -k <remover aviso KPROBES> Se deve ser removido. Opções: y, n (padrão)"

      echo "  -h, --help Exibe esta mensagem de ajuda"
      exit 0
      ;;
    \?)
      echo "Opção inválida: -$OPTARG" >&2
      exit 1
      ;;
  esac
done

# Define o comando a ser executado com base na tag selecionada
if [ "$tag" = "stable" ]; then
  rm -rf KernelSU
  cmd="bash -"
elif [ "$tag" = "dev" ]; then
  rm -rf KernelSU
  cmd="bash -s main"
else
  echo "Tag inválida: $tag" >&2
  exit 1
fi

# Executa o comando curl para baixar e executar o script
# Tag Padrão: stable
curl -LSs "https://raw.githubusercontent.com/tiann/KernelSU/main/kernel/setup.sh" | $cmd

# Remove o aviso de dependência KPROBES se a opção estiver definida como "y"
# Padrão: Sim
if [ "$remove_kprobes_warning" = "y" ]; then
  sed -i '59,60d' KernelSU/kernel/ksu.c
fi
